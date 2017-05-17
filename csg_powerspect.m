function varargout = csg_powerspect(varargin)

if nargin < 1
    D = spm_eeg_load;
    eegchan = meegchannels(D);
    epoch = 4;
    flag = 1;
elseif nargin == 1    
    if isfield(varargin{1},'Dmeg')
        D = varargin{1}.Dmeg{1};
    end        
    if isfield(varargin{1},'powchan')
        eegchan = varargin{1}.powchan;
    else
        eegchan = meegchannels(D);
    end
    if isfield(varargin{1},'epoch')
        epoch = varargin{1}.epoch;
    else
        epoch = 4;
    end
    if isfield(varargin{1},'plot')
        flag = varargin{1}.plot;
    else 
        flag = 0;
    end
end

fprintf(1,'SPECTROGRAM IS BEING COMPUTED \n');


% load parameters
fs = fsample(D);
pow2 = nextpow2(epoch*fs);
nfft = (2^(pow2-1));
forder = 3;
    
% remove bad channels detected from the averaged signal
S = cell(size(eegchan));
fD = D(eegchan,:);
for ic = 1 : numel(eegchan)
    fD(ic,:) = filterlowhigh(D(eegchan(ic),:),[0.1 30],fs,forder);
end

[S{1} F T P] = spectrogram(fD(1,:),epoch*fs,[],0.1:fs/nfft:30,fs);
h = waitbar(0,'PSD is computing');
for i = 2 : numel(eegchan)
   S{i} = spectrogram(fD(i,:),epoch*fs,[],0.1:fs/nfft:30,fs);
   String  =  ['Progress : ' num2str(i/numel(eegchan)*100) ' %'];
   waitbar((i/numel(eegchan)),h,String);
end
close(h);
% power by 2 sec epochs (by default)
avg_S  = meancell(S);
args = {F,T,10*log10(abs(avg_S'))};

if flag
    figure;
    xlbl = 'Frequency (Hz)';
    ylbl = 'Time (sec)';
    surf(args{:},'EdgeColor','none');

    axis xy; axis tight;
    colormap(jet);
    view(90,270);

    ylabel(ylbl);
    xlabel(xlbl);
end

% save power spectrum in the data structure 
D.CSG.spectrogram.info.channels = eegchan;
D.CSG.spectrogram.info.epoch = epoch;

D.CSG.spectrogram.tempo = args{2};
D.CSG.spectrogram.frequency = args{1};
D.CSG.spectrogram.power = args{3};

save(D);
varargout{1} = D;

function xf = filterlowhigh(x,frqcut,fs,forder)

flc = frqcut(1)/(fs/2);
fhc = frqcut(2)/(fs/2);
[B,A] = butter(forder,flc,'high');
xf = filtfilt(B,A,x);
[B,A] = butter(forder,fhc,'low');
xf = filtfilt(B,A,xf);

return
