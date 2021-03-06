function Dprep = CSG_preprocessing(cfg)

% load parameters
filename    = cfg.filename;
preproname  = cfg.preproname;
D           = spm_eeg_load(filename);
filtpar     = cfg.filtpar;
win.L       = cfg.Lwin;
win.S       = cfg.Swin;
interpol.L  = cfg.Linterpo;
interpol.S  = cfg.Sinterpo;
incoh       = cfg.incoh;
ref         = cfg.ref; %  still to be done

% parameters loaded from the file
fs          =   fsample(D);
nspl        =   nsamples(D);
channels    =   meegchannels(D);
Nchan       =   numel(channels);

% defaults values
def         =   csg_get_defaults;
feeg        =   def.one.filtEEG;
forder      =   def.one.forder;


%% Copy data ---------
Dnew        =   copy(D,char(preproname));

% -----------
%% Filtering 
% -----------
if ~isempty(filtpar.eegblw) 
    h = waitbar(0,'EEG channels filtering'); 
    for ichan = 1 : numel(channels)
        waitbar((ichan/numel(channels)),h,sprintf('%d/%d filtered EEG channels', ichan, numel(channels)));
        Dnew(channels(ichan),:) = filterlowhigh(D(channels(ichan),:),[filtpar.eegblw filtpar.eegabv],fs,3);
    end
    eogchan = eogchannels(D);
    if ~isempty(eogchan) 
        for ichan = 1 : numel(eogchan)
            waitbar((ichan/numel(eogchan)),h,sprintf('%d/%d filtered EOG channels', ichan, numel(eogchan)));
            Dnew(eogchan(ichan),:) = filterlowhigh(D(eogchan(ichan),:),[filtpar.eogblw filtpar.eogabv],fs,3);
        end
    end
    emgchan = emgchannels(D);
    if ~isempty(emgchan) 
        for ichan = 1 : numel(emgchan)
            waitbar((ichan/numel(emgchan)),h,sprintf('%d/%d filtered EMG channels', ichan, numel(emgchan)));
            Dnew(emgchan(ichan),:) = filterlowhigh(D(emgchan(ichan),:),[filtpar.emgblw filtpar.emgabv],fs,3);
        end
    end
    otherchan = setdiff(1:size(D,1),[channels eogchan emgchan]);
    if ~isempty(otherchan) 
        for ichan = 1 : numel(otherchan)
            waitbar((ichan/numel(otherchan)),h,sprintf('%d/%d filtered OTHER channels', ichan, numel(otherchan)));
            Dnew(otherchan(ichan),:) = filterlowhigh(D(otherchan(ichan),:),[filtpar.eegblw filtpar.eegabv],fs,3);
        end
    end
    close(h);
    save(Dnew);
end


%% BAD CHANNELS over large fix time-windows
% -----------------------------------------
cfg             =   [];
cfg.dataset     =   Dnew;
cfg.winsize     =   win.L;
cfg.channels    =   channels;

% put the signal in �V
scl = units(D);
scale = ones(1,size(D,1));
if ~strcmp(scl,'�V')
    if strcmp(scl,'V')
        scale = scale*1e6;
    elseif strcmp(scl,'mV')
        scale = scale*1e3;
    end   
end

if ~isempty(win.L)
    Lepo        =   win.L*fs;
    Nepo        =   ceil(nspl/Lepo);
    % filtering for the artefact detection process
    fD = D(channels,:);
    for ic = 1 : Nchan
        fD(ic,:) =  filterlowhigh(D(channels(ic),:),feeg,fs,forder)/scale(channels(ic));
    end

    % reshape the data by epoch of winL
    signals     =   csg_reshape(fD,Nchan,Nepo,Lepo,nspl); % signals = Nchan x Nepo x Lepo
    cfg.signals	=   signals;

    % bad channels detection
    Dnew            =   csg_badchannels(cfg);
    cfg.dataset     =   Dnew;
    %% Interpolation of bad channels detected
    % ---------------------------------------
    if interpol.L
        cfg.badchannels     =   or(Dnew.CSG.preprocessing.badchannels.chan_flat,Dnew.CSG.preprocessing.badchannels.chan_noisy);
        [Dnew cleaned]      =   csg_interpol(cfg);
        % keep in memory channels repaired and remove them from badchannels
        Dnew.CSG.preprocessing.interpolated.large       = cleaned;
        Dnew.CSG.preprocessing.badchannels.chan_flat    = and(Dnew.CSG.preprocessing.badchannels.chan_flat,~Dnew.CSG.preprocessing.badchannels.interpolated.large);
        Dnew.CSG.preprocessing.badchannels.chan_noisy   = and(Dnew.CSG.preprocessing.badchannels.chan_noisy,~Dnew.CSG.preprocessing.badchannels.interpolated.large);
        save(Dnew);
        cfg.dataset  =  Dnew;
    end

    %% BAD CHANNELS detection over small epochs
    % -----------------------------------------
    Dnew.CSG.preprocessing.badchannels.incoherent = [];
    if incoh
        cfg.epoch       =   win.S;
        NofE            =   ceil(nspl/(fs*win.S));  % number of small epochs in the whole recording
        cfg.badchannels =   or(Dnew.CSG.preprocessing.badchannels.chan_flat,Dnew.CSG.preprocessing.badchannels.chan_noisy);
        Dnew            =   CSG_artefact(cfg);    
        cfg.dataset     =   Dnew;
        if interpol.S     
            cfg.badchannels =   cfg.dataset.CSG.preprocessing.badchannels.incoherent;
            cfg.winsize     =   win.S;
            %% interpolation of bad channels detected over small epochs
            [Dnew cleaned]  = csg_interpol(cfg);  
            % keep in memory channels repaired and remove them from badchannels
            Dnew.CSG.preprocessing.interpolated.small = cleaned;
            for ibc = 1 : NofE
                Dnew.CSG.preprocessing.badchannels.incoherent = and(Dnew.CSG.preprocessing.badchannels.incoherent,~Dnew.CSG.preprocessing.interpolated.small);
            end
        end
    end
    % Pull together all artefacts detected by one second epoch
    allbad = splitwin(or(Dnew.CSG.preprocessing.badchannels.chan_flat,Dnew.CSG.preprocessing.badchannels.chan_noisy),win.L);
    if isempty(Dnew.CSG.preprocessing.badchannels.incoherent)
        Dnew.CSG.preprocessing.artefact = allbad;
    else
        allbad2 = splitwin(Dnew.CSG.preprocessing.badchannels.incoherent,win.S);
        Dnew.CSG.preprocessing.artefact = allbad + allbad2;
    end
    Dnew.CSG.preprocessing.info.Lwin = win.L;
    Dnew.CSG.preprocessing.info.Swin = win.S;
    Dnew.CSG.preprocessing.info.ILwin = interpol.L;
    Dnew.CSG.preprocessing.info.ISwin = interpol.S;

    save(Dnew);
end
%rerefencing
if strcmp(ref,'Average of all channels')
    refchosen = mean(Dnew(channels,:));
else
    [dum refnumber dum] = intersect(chanlabels(Dnew),ref);
    refchosen = Dnew(refnumber,:);                 
end
Dnew(channels,:) = Dnew(channels,:)-ones(numel(channels),1)*refchosen(:)';   
save(Dnew)
% make a report on paper and save it on the mat file
fprintf('To obtain information about the artefact detection method used, tape ''csg_read(''artefact'')'' and load the preprocessed file obtained.');

%%%%%%%%%%%%%%%%%%%%
function xf = filterlowhigh(x,frqcut,fs,forder)

flc = frqcut(1)/(fs/2);
fhc = frqcut(2)/(fs/2);
[B,A] = butter(forder,flc,'high');
xf = filtfilt(B,A,x);
[B,A] = butter(forder,fhc,'low');
xf = filtfilt(B,A,xf);

return

