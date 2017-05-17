
function varargout = csg_badchannels(varargin)

% FORMAT DC_badchannels(args)
% Bad channels detection for whole sleep recordings. 
% Bad channels are detected by fiw time window and are either:
%       * Noisy
%      or
%       * Flat
% Badchannels are saved in: 
% * C.CSG.artefact.badchannels.chan_defaillant = flat channels saved in a matrix.
%                           Row correspond to fixed time windows and columns
%                           to EEG channel number.
% * C.CSG.artefact.badchannels.chan_incoherent = noisy channels saved in a matrix.
%                           Row correspond to fixed time windows and columns
%                           to EEG channel number.
% the thresholds are available in csg_get_default('bc')    
%
% INPUT
%       .file   - data file (.mat files)
%__________________________________________________________________
% Copyright (C) 2014 Cyclotron Research Centre
% Copyright (C) 2017 Coma Science Group

% Written by D. Coppieters 't Wallant, 2014.
% Cyclotron Research Centre, University of Liege, Belgium
% $Id$

% *************************************************************************
%                         Loading and parameters values 
% *************************************************************************
clear global csg_def;
defilt  =   csg_get_defaults('one');
feeg    =   defilt.filtEEG;   % by default [.1 20]Hz
forder  =   defilt.forder;
% *************************************************************************
%                                 Threshold 
% *************************************************************************
def = crc_get_defaults('qc.bc');
% Obvious channels --------------------------------------------
def_n  = def.n;  % noisy channel threshold
def_f1 = def.f1; % 1st threshold of flat channel
% Noisy channels ----------------------------------------------
def_r  = def.r; % ratio of deviation
% Flat channels -----------------------------------------------
def_f2 = def.f2; % 2nd threshold of flat channel
def_tf = def.tf; % duration of flat channel
def_ampl = def.ampl; % amplitude depending on standard deviation

%%% Load data
if nargin == 1
    D           =   varargin{1}.dataset;
    winsize     =   varargin{1}.winsize;
    channels    =   varargin{1}.channels;
    signals     =   varargin{1}.signals;
   
    fs          =   fsample(D);   
    nspl        =   nsamples(D); 
    Time        =   nspl/fs;
    NofW        =   ceil(Time / winsize);
else 
    D           =   spm_eeg_load;
    fs          =   fsample(D);   
    nspl        =   nsamples(D);
    winsize     =   defilt.winsize;
    channels    =   meegchannels(D);
    Time        =   nspl/fs;
    NofW        =   ceil(Time / winsize);
    Lwin        =   winsize*fs;
    % scale according to units
    % put the signal in µV
    scl = units(D);
    scale = ones(1,size(D,1));
    if ~strcmp(scl,'µV')
        if strcmp(scl,'V')
            scale = scale*1e6;
        elseif strcmp(scl,'mV')
            scale = scale*1e3;
        end   
    end
    % filtering $
    fD = D(channels,:);
    for ic = 1 : Nchan
        fD(ic,:) = filterlowhigh(D(channels(ic),:),feeg,fs,forder)/scale(channels(ic));
    end

    % reshape the data by epoch 
    signals = csg_reshape(fD,Nchan,NofW,Lwin,nspl); % signals = Nchan x Nepo x Lepo
end

% initialization
chan_def    =   zeros(numel(channels),NofW);
chan_incoh  =   zeros(numel(channels),NofW);

% *************************************************************************
%                    Obviously bad channels detection
% *************************************************************************
h = waitbar(0,'badchannels detection');  

fprintf(1,'Bad Channels detection over large %d sec-epochs \n', winsize);
for w = 1 : NofW
   % --- obvious noisy channel
   eeg_an    =   std(signals(:,w,:),[],3); 
   if any(eeg_an >= def_n)
       chan_incoh(eeg_an >= def_n,w) = 1;
   % --- obvious flat channel
   elseif any(eeg_an <= def_f1) 
       chan_def(eeg_an <= def_f1,w) = 1;
   end
    String  =  ['Progress of bad channels detection 1/2 : ' num2str(w/NofW*100) ' %'];
    waitbar((w/NofW),h,String);
end
% *************************************************************************
%                Finer detection for noisy and flat channels
% *************************************************************************

for w = 1 : NofW
    good_chan   =   ~or(chan_incoh(:,w),chan_def(:,w));
    window      =	signals(good_chan,w,:);
    if ~isempty(window)
        st_5epo	=	std(window,[],3); % standard deviation over time for each not obvious bad channels
        ich     =   find(good_chan);
        test1	=	st_5epo<def_f2;
        for ic = 1:size(window,1)
% ***** flat channel ***** (Devuyst)
            if test1(ic)
                v = find(abs(window(ic,:)) <= def_ampl*st_5epo(ic)); 
                diff_def = diff(v);
                fin = unique([find(diff_def~=1) length(diff_def)]);
                deb = [1 fin(1:end-1)+1];
                duration_def = (fin - deb)/fs;
                if duration_def >= def_tf                   
                    chan_def(ich(ic),w) = 1;  %artefact de défaillance des électrodes
                end  
            end
% ***** noisy channels *****
            other     =     good_chan; %all good channels except the one we are analyzing
            other(ic) =     0;
            eeg_oth   =  	mean(signals(other,w,:));
            eeg_an    =     window(ic,:); 
            intera_std =    abs(std(eeg_an)/std(eeg_oth)); 
            if (intera_std >= def_r)
               chan_incoh(ich(ic),w) = 1;  %artefact de défaillance des électrodes
            end
       end
    end
    String  =  ['Progress of bad channels detection 2/2: ' num2str(w/NofW*100) ' %'];
    waitbar((w/NofW),h,String);
end
close(h);
D.CSG.preprocessing.badchannels.chan_flat  = chan_def;
D.CSG.preprocessing.badchannels.chan_noisy = chan_incoh;
save(D);
varargout{1} = D;
fprintf(1,'---Bad channels detection DONE---\n')


function xf = filterlowhigh(x,frqcut,fs,forder)

flc = frqcut(1)/(fs/2);
fhc = frqcut(2)/(fs/2);
[B,A] = butter(forder,flc,'high');
xf = filtfilt(B,A,x);
[B,A] = butter(forder,fhc,'low');
xf = filtfilt(B,A,xf);

return