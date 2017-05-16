function csg_defaults
% Sets the defaults which are used by CSG Toolbox.
%
% FORMAT csg_defaults
%_______________________________________________________________________
%
% This file can be customised to any the site/person own setup.
% Individual users can make copies which can be stored on their own
% matlab path. Make sure your 'crc_defaults' is the first one found in the
% path. See matlab documentation for details on setting path.
%
% Care must be taken when modifying this file!
%
% The structure and content of this file are largely inspired by SPM.
%_______________________________________________________________________
% Copyright (C) 2009 Cyclotron Research Centre
% Copyright (C) 2017 Coma Science Group

% Written by Y. Leclercq & C. Phillips, 2008.
% Cyclotron Research Centre, University of Liege, Belgium
% Then modified for use with the CSG toolbox by Dorothée Coppieters 
% $Id$



%% __________________________________________________________
%
%  Default values for functions created from Fasst
% ----------------------------------------------
% _____________________________________________________________
%  Note : could be reduced as most of Fasst functions have been removed


%% NEED to include the scaling of ECG/EMG/EOG

%%
global csg_def

%%% FMRI : probably for Giorgos !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

%% %%%%%%%%%%%%%%%%% Artefact Rejection Parameters %%%%%%%%%%%%%%%%%%%%%%%

% Parameters for the gradient artefact rejection, csg_gar.m
%-----------------------------------------------
csg_def.gar.prefix         = 'cga_';
csg_def.gar.output_fs      = 500 ;     % Frequency sampling of the output file
csg_def.gar.Nsc_aver       = 30 ;      % Average computed on ... scans
csg_def.gar.Nsc_skipped_be = 3 ;       % Number of scans skipped before correction
csg_def.gar.UseScanMrk     = 1 ;       % Using volume marker from the scanner (1), or not (0)

% If UseScanMrk = 1;
csg_def.gar.ScanMrk1       = 128 ;     % Marker number coming from the scanner
csg_def.gar.ScanMrk2       = 1002 ;    % Secondary scanner marker.
csg_def.gar.MrkStep        = 1 ;      % Number of marker between 2 successive volumes
% If you have a scanner marker every slice,
% use the number of slices !

% If UseScanMrk = 0;
csg_def.gar.TR             = 2.46; % in sec
csg_def.gar.AutoChk        = 1;    % Autodetection of beginning & end
% If csg_def.gar.AutoChk = 1
csg_def.gar.Threshold      = 350;
csg_def.gar.DetStep        = 1 ;   % Step use for detection (in sec)
csg_def.gar.DetChan        = 1 ;   % Channel use for detection
% If csg_def.gar.AutoChk = 0
csg_def.gar.beg            = 1 ;       % in sec
csg_def.gar.nd             = 2500;     % in sec

% Parameters for cICA pulse artefact calculation,
%-----------------------------------------------
% used in csg_bcgremoval_rt.m

% Filename convention.
csg_def.par.cicapref  = 'cICA_'; %filename prefix added after using cICA
csg_def.par.pcapref   = 'cpca_'; %filename prefix added after using PCA
csg_def.par.aaspref   = 'caas_'; %filename prefix added after using AAS
csg_def.par.iicapref  = 'ciica_'; %filename prefix added after using iICA
csg_def.par.pcaaspref = 'cpcaas_'; %filename prefix added after using PCA/AAS

% Parameters for pulse artefact rejection
%----------------------------------------
csg_def.par.bcgrem.size        = 90 ; % in sec (60 is the minimum)
csg_def.par.bcgrem.step        = 60 ; % about 2/3 size
csg_def.par.bcgrem.scSNR       = 3 ; % nr of signal std to consider signal as noise: abs(signal)>scSNR*max(std)
% Channels used to build the constrain vector.
% They're taken from around the head
csg_def.par.Refnames = ...
    {'AF3' 'AF4' 'FPZ' 'FP1' 'FP2' 'O1' 'O2' 'F1' 'F2' 'C1' 'C2' 'PZ' 'OZ' 'F5' ...
    'F6' 'C5' 'C6' 'P5' 'P6'};
csg_def.par.NitKmeans = 150;

% Parameters for pulse artefact matrix quality assessment
%--------------------------------------------------------
csg_def.par.useinitseg = 1; % Use initial segment to assess the quality of the correction matrix.
csg_def.par.additioseg = 10; % Number of additional random segments.
% Note that if both of these value equals 0, the software use the
% 1st segment anyway.
csg_def.par.length = 60; % Length of each segment in seconds.

% Parameters for PAR Batch (giopia)
%-------------------------
csg_def.par.qrsmethod  = 1;  % QRS detection method, only one so far...
csg_def.par.bcgmethod  = 'acica';  % pulse artefact rejection method
csg_def.par.peaksave   = 1;  % save detected QRS peaks (1) or (0)
csg_def.par.fqrsdet    = 0;  % force QRS detection (1) or not (0), even if peaks already available
csg_def.par.nit        = 50; % #iterations for the "iterative ICA" method
csg_def.par.ecgchan    = 0;  % default ECG channel = first one with name ECG/EKG
csg_def.par.badchan    = []; % e.g. 32 for BrainProducts caps with 64ch setup as at the CRC

%% %%%%%%%%%%%%%%%%% Display parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Parameters for display one file,
%-----------------------------------------------
% used in csg_dis_main.m
csg_def.one.winsize    = 20; % in sec
csg_def.one.scale      = 150; % in µV
csg_def.one.filtEEG    = [.1 20]; % in Hz
csg_def.one.filtEMG    = [10 125]; % max is adapted to true sampling rate
csg_def.one.filtEOG    = [.1 4]; % in Hz
csg_def.one.forder     = 3;     %order of the butterworth filter used with filtfilt
% Parameters for scale handling,
%-----------------------------------------------
% used in csg_dis_main.m, csg_SP_detect.m, csg_SW_detect
csg_def.scales.eeg   = 10^-6; % in V
csg_def.scales.eog   = 10^-6; % in V
csg_def.scales.ecg   = 3*10^-5; % in V
csg_def.scales.emg   = 10^-6; % in V
csg_def.scales.other   = 1; % in µV
csg_def.scales.lfp   = 10^-5; % in V
csg_def.scales.megmag   = 5*10^-14; % in µV
csg_def.scales.megplan   = 5*10^-13; % in µV

% Parameters for display power spectrum
%-----------------------------------------------
csg_def.disfrq.scale       = [200 0.3 5]; % Absolute Value / Relative Value / Mongrain Value
csg_def.disfrq.subsmpl     = 0; %subsampling factor computed automatically. The user can set a value instead (enter value)
csg_def.disfrq.maxpix      = 1600;
csg_def.disfrq.window      = 0;

%% %%%%%%%%%%%%%%%%% Processing parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Parameters for computing spectrogram or power spectrum, csg_spectcompute.m
%-----------------------------------------------
csg_def.cps.uplimit        = 25 ;  % upper frequency \_ bound (Hz)
csg_def.cps.downlimit      = .5 ;  % lower frequency /
csg_def.cps.duration       = 4 ;   % Window size in sec
csg_def.cps.step           = 2 ;   % sliding step
csg_def.cps.scorer         = 1 ;   % index of scorer
csg_def.cps.reference      = 1 ;   % index of reference
csg_def.cps.maxmemload     = 50 * 1024^2; % i.e. 50Mb

% Parameters for downsampling
%-----------------------------------------------
csg_def.ds.stepse  = 60; % sec
csg_def.ds.fs      = 250; % Hz
csg_def.ds.prefix  = 'ds_';

% Parameters for chunking: does not exist anymore but could be
% interesting!!!
%-----------------------------------------------
csg_def.chk.overwr   = 0; % No overwriting by def
csg_def.chk.numchunk = 1; % Start index at 1
csg_def.chk.prefix   = 'chk';
csg_def.chk.clockt   = 0; % Don't worry about clocktime

% Parameters for concatenating
%-----------------------------------------------
csg_def.cat.prefix1   = 'cc_'; % standard concatenation
csg_def.cat.prefix2   = 'cr_'; % concatenation at reading (raw EGI)


% Parameters for memory handling
%-----------------------------------------------
csg_def.mem.cps_maxmemload = 50  * 1024^2; % i.e. 50Mb
csg_def.mem.maxmemload     = 100 * 1024^2; % i.e. 100Mb
csg_def.mem.sp_maxmemload  = 200 * 1024^2; % i.e. 200Mb

% Parameters for Spindle detection
%--------------------------------------------
csg_def.sp.highfc          = 8;
csg_def.sp.lowfc           = 20;
csg_def.sp.elecoi          = {'Fz' 'Cz' 'Pz'};
csg_def.sp.stagesp         = [2 3 4];% stages to extract from original scored file
csg_def.sp.prcthresh       = 95; %percentile used to perform detection of spindles
csg_def.sp.stagethresh     = 2;% stage to compute threshold of detection
csg_def.sp.threshold       = 0;% user chosing the threshold of detection
csg_def.sp.lengthsp        = 0.4;% spindles of 400 ms duration minimum (in s)
csg_def.sp.succsp          = 1;% 1000ms between 2 successive sp (in s)
csg_def.sp.type            = 'EEG';% type of channels to detect spindles
csg_def.sp.usetheor        = 0;% do not use theoretical positions if localisation file available (1 for always use theoretical positions).

% ------------------------------------------------
% Parameters for Quality Control detection (qc)
%--------------------------------------------

% ------------------- bad channel (bd) -------------------------
% 0/ bad channels (bc) length
csg_def.qc.bc.Lwin          = 20;   % bad channels are initially detected by 20s time windows
csg_def.qc.bc.Swin          = 4;   % then a finer detection is used for high density eeg and bad channels are removed by 4s time windows
% 1/ bad channels (bc) in  EEG
csg_def.qc.bc.tf           = 0.8;   % duration of flat channel (s)
csg_def.qc.bc.n            = 6e3;   % noisy channel threshold (µV)
csg_def.qc.bc.f1           = 1;     % 1st flat channel threshold (µV)
csg_def.qc.bc.ampl         = 0.1;   % threshold for amplitude of flat channel depending on standard deviation
csg_def.qc.bc.r            = 5;     % ratio of deviation
csg_def.qc.bc.f2           = 10;    % 2nd flat channel threshold (µV)
% 2/ bad channels (bc) in  EMG
csg_def.qc.bc.fm           = 1;     % flat channel threshold
csg_def.qc.bc.sm           = 1.5;   % ratio of deviation
% 3/ for incoherent channels detected by small epoch 
csg_def.qc.bc.epo           = 4;    % epoch of 4s are analyzed with coherence values 
csg_def.qc.bc.spt           = 0.2;  % coherence is analyzed around 0.2 in normalized space

% ------------------ bad epochs (be) -------------------------
% -- rapid transition (popping)
csg_def.qc.be.pr    = 5e4;    % variation rate in MAS channel (µV²/sec)
csg_def.qc.be.pe    = 1e5;  % variation rate in EEG channel (µV²/sec)
csg_def.qc.be.pt    = 0.05;   % peak to peak interval (sec)
% -- movement and arousal
csg_def.qc.be.mvt_t = 0.15;     % minimal time to consider movement in nREM(sec)
csg_def.qc.be.ainf  = 3;        % minimal time to consider arousal in nREM (sec)
csg_def.qc.be.asup  = 14;       % macimal time to consider arousal in nREM (sec)


return

