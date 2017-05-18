function [D cleaned] = csg_interpol(cfg)

% csg_interpol interpolate bad channels detected over fix time windows when less than 50% of all channels considered are bad.
% The new file with interpolated channels is renamed by simply adding a 'I' as prefix.
%
% cfg is is a struct containing:
% ° .dataset     : meeg object for the data to interpolate
% ° .method      : 'spline' or 'average' interpolation method
% ° .lambda      : smoothing (?)
% ° .order       : m-constant for the spline interpolation
% ° .channels    : channels considered for the interpolation of bad
% channels (by default: all meegchannels)
% ° .badchannels : bad channels to interpolate
% ° .winsize     : duration of fix time-windows
%
%  This code needs functions from the fieldtrip toolbox (i.e. ft_channelrepair) available in SPM12
%  To interpolate bad channels, the following subfunctions are needed:
%   ° ft_prepare_layout, ft_prepare_neighbours(configuration of these subfunctions has to be reviewed)
%  Configuration chosen is saved in the data structure: D.CSG.interpolation.cfg


%% load data
if ~isempty(cfg)
    D           = cfg.dataset;
    Lw          = cfg.winsize;
    channels    = cfg.channels;
    badchannels = cfg.badchannels;
else 
    error('Minimum of configuration is required !!!!!!!!!! \n')
end

% parameters from the data file loaded
fs          =   fsample(D);             % sampling frequency
nspl        =   nsamples(D);            % number of samples
Lwin        =   fs*Lw;
NofW        =   ceil(nspl/Lwin);     % number of fix time window
Nchan       =   numel(channels);
data.label  =   chanlabels(D,channels);

data        =   spm2fieldtrip(D);   % transform meeg object from spm into a raw data of fieldtrip
coord       =   coor2D(D)';

% interpolation: configuration (to be checked, still in progess)
elec.chanpos    =   [coord zeros(numel(channels),1)];
elec.elecpos    =   [coord zeros(numel(channels),1)];
elec.label      =   chanlabels(D,channels); 
cfglayout.elec  =	elec;
cfglayout.layout=   'circular';
lay             =   ft_prepare_layout(cfglayout, data);

cfgneigh.elec   =   elec;
cfgneigh.method	=   'distance';      % or 'template','triangulation' (default = 'distance')
cfgneigh.layout	=   lay;
cfg.neighbours  =   ft_prepare_neighbours(cfgneigh, data);

cfg.elec    =   elec; % channels position and labels given from the elec_EGI256.mat file according to the fieldtrip toolbox
cfg.method  =   ft_getopt(cfg, 'method','spline');
cfg.lambda  =   ft_getopt(cfg, 'lambda',[]);    % subfunction will handle this
cfg.order   =   ft_getopt(cfg, 'order',[]);     % subfunction will handle this

D.CSG.preprocessing.info.interpolation  =   cfg;

data.label	=   chanlabels(D,channels);

% loop to search bad channels in each fiw time-window and interpolate bad
% channels from the method chosen
cleaned = zeros(Nchan,NofW);
for iw = 1 : NofW
    fprintf(1,' \n');
    tempo   =   max(1,(iw-1)*Lw*fs):min(nspl,iw*fs*Lw);
    if any(badchannels(:,iw))
        if numel(find(badchannels(:,iw)))<0.7*Nchan 
            cfg.badchannel      =   chanlabels(D,channels(badchannels(:,iw)));  % bad channel to interpolate
            data.trial{1}       =   D(channels,tempo);
            data.time{1}        =   data.time{1}(:,tempo);       
            inter               =   ft_channelrepair(cfg,data);
            D(channels,tempo)   =   inter.trial{1};
            cleaned(badchannels(:,iw),iw) = 1;
        end
    end
end
fprintf(1,' Interpolation done  \n ============================= \n ');
save(D);

