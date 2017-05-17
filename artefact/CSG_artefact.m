function D = CSG_artefact(cfg)

% detection of artifacts (incoherence) over small epochs after a bad
% channels detection processed over larger time-windows.
% configuration is provided with the structure cfg. :
% °.dataset     : meeg structure 
% °.epoch;      : small time-window length
% °.winsize;    : large time-window length
% °.badchannels; : badchannels detected over large time-windows (after removing channels repaired with the
% interpolation)
% °.channels;   : channels to be analyzed


if ~isempty(cfg)
    D           =   cfg.dataset;
    epoch       =   cfg.epoch;
    winsize     =   cfg.winsize;
    badchannels =   cfg.badchannels;
    channels    =   cfg.channels; % numero de channels
    signals     =   cfg.signals;  % signals is a matrix Nchan x Nwin x Lwin, win, is the fix time window used in badchannel detection
else 
    error('Configuration missing !!!!!!!!!!! \n')
end

% Fix thresholds chosen
def     =   csg_get_defaults;
tr_spc  =   def.qc.bc.spt;     % threshold for spatial coherence: signals have to be coherent within a distance of tr_spc

% load montage
coord    =   coor2D(D,channels);
if size(coord,2)<numel(channels)
    error('coordinates for channels chosen missing !!!!!!!!! \n')
end
Dchan	=   DC_distance(coord');

% data parameters
fs      =   fsample(D);
nspl    =   nsamples(D);
Nchan   =   numel(channels);
Lepo    =   epoch*fs;
Nepo    =   ceil(nspl/Lepo);
L05     =   fs*0.5;
N05     =   ceil(Lepo/L05); 

% initialization
zMatrx      =   zeros(Nchan,Nepo);
zMatrx2     =   zeros(Nchan,Nepo);
Ampl        =   zeros(Nchan,Nepo);
badchan     =   zeros(Nchan,Nepo);

% reshape the data by epoch 
epochs  =   csg_reshape(signals,Nchan,Nepo,Lepo,nspl); % epochs = Nchan x Nepo x Lepo 

% initialize the std value
Tempo_std   =   mean(std(epochs,[],3),2);

fprintf(1,'Bad Channels detection over small %d sec-epochs \n', epoch);

for iw  =   2  :    Nepo
    % search if badchannel has previously been detected
    iwin    =   ceil(iw/(winsize/epoch));    
    if numel(find(badchannels(:,iwin)))  >   0.7*Nchan % if more than 70% of channels considered as bad, all channels are 'removed'
        badchan(:,iw) = 1;
    else 
        for ichan   =   1 : Nchan
        %%  incoherence: kinds of z score computed from small areas for each channel
            chan_around         =   and(Dchan(:,ichan)<tr_spc,~badchannels(:,iwin));
            chan_around(ichan)  =   0; 
            if numel(find(chan_around)) == 0
                error('The density of EEG is insufficient')
            end
            sig = epochs(ichan,iw,:);
            sigaround = epochs(chan_around,iw,:);
            if size(sigaround,1)>1
                Dmean = mean(sigaround);
            else 
                Dmean = Df;
            end
            SDan    =   std(sig);
            zsc     =   mean((sig-Dmean))/std(Dmean);
            zMatrx(ichan,iw)    =   zsc;
         %% kinds of zscore over small fix time windows on a same channel
            zMatrx2(ichan,iw)   =   SDan/Tempo_std(ichan);
            if and(abs(SDan/Tempo_std(ichan))<3, abs(SDan/Tempo_std(ichan))>1)
               Tempo_std(ichan)  =  SDan;
            end   
            chantoremove    =   or(abs(zMatrx(:,iw)>3),abs(zMatrx2(:,iw)>3));
            if numel(find(chantoremove))>0.5*Nchan
                badchan(:,iw) = 1;
            else 
                badchan(chantoremove,iw) = 1;
            end 
        end
        %% popping2: compute the maximal slope over small epoch for each channel
        shortsig   = csg_reshape(epochs(:,iw,:),Nchan,N05,L05,size(epochs,3));  
        slope   = zeros(Nchan,N05);
        for i05 = 1 : N05
            [Vmax imax] = max(shortsig(:,i05,:),[],3);  % max over time for each channel
            [Vmin imin] = min(shortsig(:,i05,:),[],3);  % min over time for each channel
            slope(:,i05) = (Vmax-Vmin)./(abs(imax-imin)/fs); 
        end
        Ampl(:,iw) = max(slope,[],2);
    end
end
% 
abn = cell(1,Nchan);
for ichan = 1 : Nchan
    speedchan   = Ampl(ichan,:);
    newabn      = find(abs(zscore(speedchan))>3);
    count = 0;
    while ~isempty(newabn) && count <= 3
        speedchan(abn{ichan}) = 0;
        newabn =  find(abs(zscore(speedchan))>3);
        abn{ichan} = [abn{ichan}(:); newabn(:)];
        count = count + 1;
    end
    inepoch = find(diff([0; sort(abn{ichan}(:))])==2);
    abn{ichan} = sort([abn{ichan}(:); inepoch(:)]);
    fprintf('.')
end
fprintf('.\n')
% regroup popping ('abn') with badchan...
for ichan = 1 : Nchan
    badepo = abn{ichan};
    for ibe = 1 : numel(badepo)
        badchan(ichan,badepo(ibe)) = 1;
    end
end
for iw = 1 : Nepo
    if numel(find(badchan(:,iw)))>0.5*Nchan
        badchan(:,iw) = 1;
    end
end

%% test 
fprintf(1,'---Bad epochs detection --- DONE---\n')
D.CSG.preprocessing.badchannels.incoherent = badchan;
save(D);

%%%%
function xf = filterlowhigh(x,frqcut,fs,forder)

flc = frqcut(1)/(fs/2);
fhc = frqcut(2)/(fs/2);
[B,A] = butter(forder,flc,'high');
xf = filtfilt(B,A,x);
[B,A] = butter(forder,fhc,'low');
xf = filtfilt(B,A,xf);

return