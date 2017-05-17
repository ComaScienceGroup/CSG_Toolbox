function varargout = csg_dis_main(varargin)
% CSG_DIS_MAIN M-file for csg_dis_main.fig
% CSG_DIS_MAIN, by itself, creates a new CSG_DIS_MAIN or raises the 
% existing singleton*.
%
%      H = CRC_DIS_MAIN returns the handle to a new CSG_DIS_MAIN or the handle to
%      the existing singleton*.
%
%      CSG_DIS_MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CSG_DIS_MAIN.M with the given input arguments.
%
%      CRC_DIS_MAIN('Property','Value',...) creates a new CSG_DIS_MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dis_main_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to crc_dis_main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
%__________________________________________________________________
% Copyright (C) 2017 Coma Science Group
% Inspired by Y. Leclercq & C. Phillips, 2008.
% and adapted for the Coma Science Group by D. Coppieters, 2017
% Coma Science Group
% $Id:$

% Last Modified by GUIDE v2.5 14-Jan-2011 17:09:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @csg_dis_main_OpeningFcn, ...
    'gui_OutputFcn',  @csg_dis_main_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before crc_dis_main is made visible.
function csg_dis_main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to crc_dis_main (see VARARGIN)

crcdef  =   crc_get_defaults('one');       %   default values from fasst toolbox
set(0,'CurrentFigure',handles.figure1);
warning('off')

% Choose default command line output for crc_dis_main
handles.output  =   hObject;
handles.file    =   varargin{1}.file;
handles.Dmeg    =   varargin{1}.Dmeg;

handles.figz    =   0;
handles.winsize =   20;
handles.export  =   0;

for i=1:numel(handles.Dmeg)
    handles.Dmeg{i} =   meeg(handles.Dmeg{i});
end
D = handles.Dmeg{1};
handles.index   =   varargin{1}.index;
handles.indexMEEG   =   fliplr(intersect(meegchannels(handles.Dmeg{1}),handles.index))';
handles.indnomeeg   =   setdiff(handles.index, handles.indexMEEG)';
if size(handles.indnomeeg,1)>1
    handles.indnomeeg = handles.indnomeeg';
end 
if size(handles.indexMEEG,1)>1
    handles.indexMEEG = handles.indexMEEG';
end 
handles.inddis = [handles.indnomeeg handles.indexMEEG];
handles.indeeg = [meegchannels(D,'EEG') meegchannels(D,'LFP')];

% Default values
handles.scale       =   crcdef.scale;
handles.eegscale    =   [];
handles.eogscale    =   [];
handles.emgscale    =   [];
handles.ecgscale    =   [];
handles.otherscale  =   [];
handles.lfpscale    =   [];
handles.chan        =   [];

% diplay of artefacts detected with the CSG method developed by coppieters in 2016 FOR egi 256
% CHANNELS
handles.badepoch = [];
if isfield(D,'CSG') && isfield(D.CSG,'preprocessing')
    if isfield(D.CSG.preprocessing,'artefact')
        handles.badepoch = D.CSG.preprocessing.artefact;
    end
end
handles.chanlab = meegchannels(D);
if isempty(handles.chanlab)
    handles.chanlab = find(or(or(strncmp(chanlabels(D),'F',1),strncmp(chanlabels(D),'C',1)),or(strncmp(chanlabels(D),'O',1),strncmp(chanlabels(D),'P',1))));
end

%Spike detection
%---------------
handles.move = 0;
if  isfield(varargin{1},'type') % We come back from the "Event_menu"
    handles.type = varargin{1}.type;
else       % It's the begining
    D      = handles.Dmeg{1};
    handles.type = {};
end

%--------------------------------------------
%coming back from "detection" or "Event_menu"
%-------------------------------------------
if isfield(varargin{1},'base')
    handles.base     =   varargin{1}.base; 
else
    handles.base     =   {};
end

%---------------------------------------------
%if only one file to display
handles.multcomp=0;
set(handles.axes5,'visible','on');
set(handles.axes4,'visible','on');

%handles date and hour and slider
if isfield(handles.Dmeg{1},'info')
    if isfield(handles.Dmeg{1}.info,'hour')
        handles.offset = handles.Dmeg{1}.info.hour(1) * 60^2 + ...
        handles.Dmeg{1}.info.hour(2)*60 + ...
        handles.Dmeg{1}.info.hour(3);
    end
end
set(handles.slider1,...
    'Max', nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1})-handles.winsize/2,...
    'Value',0,...
    'Min',0)
try
    set(handles.slider1,'SliderStep',[(handles.winsize)/(nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1})-handles.winsize/2) 0.1])
end
set(handles.totaltime,'String',['/ ' ...
    num2str(round(nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1})))]);
set(handles.currenttime,'String',num2str(round(handles.winsize/2)));
%new index for page
set(handles.totalpage,'String',['/ ' ...
    num2str(ceil((nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1}))/handles.winsize))]);
set(handles.currentpage,'String',num2str(1));
% Number of channels displayed
Nchdisp     =   str2double(get(handles.NbreChan,'String'));
set(handles.NbreChan,'String', num2str(min(Nchdisp, length(handles.indexMEEG) + length(handles.indnomeeg))))

popupmenustring     =   chanlabels(handles.Dmeg{1}) ;
if sum(strcmp(chanlabels(handles.Dmeg{1}),'REF2'))
    popupmenustring =   [popupmenustring 'MEAN OF REF'];
end
if and(sum(strcmp(chanlabels(handles.Dmeg{1}),'M1')), ...
        sum(strcmp(chanlabels(handles.Dmeg{1}),'M2')))
    popupmenustring =   [popupmenustring 'M1-M2'];
end
set(handles.figure1,'name',handles.file{1})

% Define filter according to the smallest sampling frequency
handles.filter.other    =   crcdef.filtEEG;
filt=zeros(size(handles.Dmeg,2),1);
for i=1:size(handles.Dmeg,2)
    filt(i)     =   fsample(handles.Dmeg{i})/2;
end
[filt,posf] = max(filt);
% Adjust filter order to sampling rate, low at 5kHz (EEG-fMRI data)
if filt>2000
    forder = 1;
else
    forder = 3;
end
handles.minsamp     =   posf;
handles.filter.EMG  =   [crcdef.filtEMG(1) ...
    min(crcdef.filtEMG(2),filt/2)];
handles.filter.EOG = crcdef.filtEOG;
[B,A] = butter(forder,[handles.filter.EOG(1)/(fsample(handles.Dmeg{posf})/2),...
    handles.filter.EOG(2)/(fsample(handles.Dmeg{posf})/2)],'pass');
handles.filter.coeffEOG=[B;A];
[B,A] = butter(forder,[handles.filter.EMG(1)/(fsample(handles.Dmeg{posf})/2),...
    handles.filter.EMG(2)/(fsample(handles.Dmeg{posf})/2)],'pass');
handles.filter.coeffEMG=[B;A];
[B,A] = butter(forder,[handles.filter.other(1)/(fsample(handles.Dmeg{posf})/2),...
    handles.filter.other(2)/(fsample(handles.Dmeg{posf})/2)],'pass');
handles.filter.coeffother=[B;A];
set(handles.frqabv,'String',num2str(handles.filter.other(2)));
set(handles.upemg,'String',num2str(handles.filter.EMG(2)));

% popupmenu setting
popupmenustring	=   [popupmenustring 'REF1'];
set(handles.EEGpopmenu,...
    'String',popupmenustring,...
    'Value',length(popupmenustring))
set(handles.otherpopmenu,...
    'String',popupmenustring,...
    'Value',length(popupmenustring))
popupmenustring = [popupmenustring 'BIPOLAR'];
set(handles.EOGpopmenu,...
    'String',popupmenustring,...
    'Value',length(popupmenustring))
set(handles.EMGpopmenu,...
    'String',popupmenustring,...
    'Value',length(popupmenustring))

% Menu to display FFT for each window according to the channel selected
popmenustring   =   upper(chanlabels(handles.Dmeg{1}, handles.inddis));
set(handles.channels,'String', popmenustring,'Value', 1,'Visible','on')

load('CSG_electrodes.mat');
handles.names       =   names;
handles.crc_types   =   crc_types;
handles.pos         =   pos';
handles.Dchan       =   Dchan;

%events display,
handles.displevt    =   0;
pmstring    =   [{'All'}];
evt         =   events(handles.Dmeg{1});
evt = evt(:);
if iscell(evt)
    evt     =   cell2mat(evt);
    disp(['Warning: data not continuous (trials of 1s), only first epoch showed'])
end
if ~isempty(evt)
    for i = 1:max(size(evt,2),size(evt,1))
        if ~isempty(evt(i)) && ~any(strcmpi(evt(i).type, pmstring)) &&...
                 ~isempty(evt(i).time)
            pmstring    =   [pmstring, {evt(i).type}];
        end
    end
end
set(handles.popupmenu10,...
    'String',pmstring,...
    'Value',length(pmstring))
pmstring=[{'All'}, {'Number of event'}];
if ~isempty(evt)
    for i = 1:max(size(evt,2),size(evt,1))
        if ~isempty(evt(i)) && isnumeric(evt(i).value)
            evt(i).value    =   num2str(evt(i).value);
        end
        if ~isempty(evt(i)) && ~any(strcmpi(evt(i).value, pmstring)) &&...
                ~isempty(evt(i).time)
            pmstring    =   [pmstring, {evt(i).value}];
        end
    end
end
set(handles.popupmenu11,...
    'String',pmstring,...
    'Value',length(pmstring))
handles.evt     =   evt;
handles.chostype    =   1:max(size(evt,2),size(evt,1));
handles.chosevt     =   1:max(size(evt,2),size(evt,1));
set(handles.figure1,'MenuBar','figure')
D   =   handles.Dmeg{1};
if ~isfield(D,'info')
    D.info  =   [];     %in case field other empty set info to allow
end                        %further dot name structure assignments
if ~isfield (D,'CSG')
    D.CSG   =   [];
end

% initalize the field 'goodevents' in D.CRC and, if spindle or slow wave
% detection was performed, retrieve which events were marked as bad.
aevt = events(D);
D.CSG.goodevents    =   ones(1,numel(aevt));
if iscell(aevt)
    aevt   =   cell2mat(aevt);
end

% display spectrogram if there is one in type structure of data
if isfield(handles.Dmeg{1},'CSG') && isfield(handles.Dmeg{1}.CSG,'spectrogram')
    set(handles.figure1,'CurrentAxes',handles.axes4)
    handles.pow = handles.Dmeg{1}.CSG.spectrogram;
    handles.powinfo = handles.Dmeg{1}.CSG.spectrogram.info;
    totime = ceil(nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1}));
    xtick =sort((totime):-(totime/10):0);
%     set(handles.axes4,'Xtick',sort((totime):-(totime/10):0));
    if isfield(handles.Dmeg{1},'info') &&  isfield(handles.Dmeg{1}.info,'hour')
            xtick = mod(xtick + handles.offset,24*60^2);
    elseif isfield(handles,'offset')
        xtick = mod(xtick + handles.offset,24*60^2);
    end
    
    [dumb, times] = crc_time_converts(xtick);
    hold on,
    set(handles.axes4,'YTick',[0:10:floor(handles.pow.frequency(end))], ...
        'YTickLabel', [0:10:floor(handles.pow.frequency(end))],...
        'Xtick',xtick,...
        'XTickLabel',times, ...
        'Fontsize',8);
    surf(handles.pow.tempo+handles.powinfo.epoch/2 + xtick(1),handles.pow.frequency,handles.pow.power','EdgeColor','none')
    colormap(jet);
    xlim([xtick(1) xtick(end)])
    set(handles.figure1,'CurrentAxes',handles.axes1)
else 
    handles.pow = []; 
    handles.powinfo = [];
end

handles.Dmeg{1}     =   D;
save(D);
guidata(hObject, handles);
% to display the main plot
channels_Callback(hObject,[],handles)
% Update handles structure


% UIWAIT makes crc_dis_main wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = csg_dis_main_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on slider movement (through time)
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.displevt=0;
%%%%%%%%%%%%%%%%%
mainplot(handles)
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%Editing the window size
function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

if handles.multcomp
    handles.winsize = min(str2double(get(hObject,'String')),handles.maxx);
    maxiwin         = handles.maxx-handles.winsize;
    miniwin         = 1/handles.winsize;
else
    handles.winsize = min(str2double(get(hObject,'String')), ...
        round(nsamples(handles.Dmeg{1})/(2*fsample(handles.Dmeg{1}))));
    maxiwin         = nsamples(handles.Dmeg{1})/ ...
        fsample(handles.Dmeg{1})-handles.winsize;
    miniwin         = 1/fsample(handles.Dmeg{1});
end
set(handles.edit1,'String',num2str(handles.winsize));
set(handles.slider1,'Max',maxiwin)
set(handles.slider1,'Min',miniwin)
set(handles.slider1,'SliderStep',[handles.winsize/maxiwin 0.1])
set(handles.totalpage,'String',['/ ' ...
        num2str(ceil((nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1}))/handles.winsize))]);
mainplot(handles)

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% editing the scale
function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double

if not(str2double(get(hObject,'String'))>0)&& not(str2double(get(hObject,'String'))<0)
    set(handles.edit2,'String',num2str(handles.scale));
else
    handles.scale=str2double(get(hObject,'String'));
end

% Update handles structure
guidata(hObject, handles);

mainplot(handles)

if handles.multcomp
    i   =   length(handles.Dmeg);
else
    NbreChandisp    =   str2double(get(handles.NbreChan,'String'));
    i   =   min(length(handles.indexMEEG) + length(handles.indnomeeg),NbreChandisp); 
end
ylim([0 handles.scale*(i+1)]);
set(handles.axes1,'YTick',[handles.scale/2:handles.scale/2:i*handles.scale+handles.scale/2]);
ylabels=[num2str(round(handles.scale/2))];
for j=1:i
    if handles.multcomp
        ylabels=[ylabels {num2str(j)}];
    else
        ylabels=[ylabels chanlabels(handles.Dmeg{1},handles.index(j))];
    end
    ylabels=[ylabels num2str(round(handles.scale/2))];
end
set(handles.axes1,'YTickLabel',ylabels);

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Push the 'back to channel selection' button
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

flags.index	=   handles.index;
flags.Dmeg  =   handles.Dmeg;
flags.file  =   handles.file;
csg_dis_selchan(flags);

delete(handles.figure1);
try
    close(handles.figz)
end

%Editing the 'current time' field
function currenttime_Callback(hObject, eventdata, handles)
% hObject    handle to currenttime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of currenttime as text
%        str2double(get(hObject,'String')) returns contents of currenttime as a double

i=handles.minsamp;
slidval = str2double(get(hObject,'String')); % str2double is faster than str2num
slidval = max(slidval - handles.winsize/2,1/fsample(handles.Dmeg{i}));

if handles.multcomp
    maxiwin=handles.maxx-handles.winsize;
else
    maxiwin=nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1})-handles.winsize;
end
slidval = min(slidval,maxiwin);
set(handles.slider1,'Value',slidval)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mainplot(handles)

% --- Executes during object creation, after setting all properties.
function currenttime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currenttime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Editing the 'current time' field
function currentpage_Callback(hObject, eventdata, handles)
% hObject    handle to currenttime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of currenttime as text
%        str2double(get(hObject,'String')) returns contents of currenttime as a double

i=handles.minsamp;
pageval = floor(str2double(get(hObject,'String'))); % str2double is faster than str2num
pageval = max(pageval,1);

if handles.multcomp
    maxiwin=floor((handles.maxx-handles.winsize)/handles.winsize);
else
    maxiwin=ceil((nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1}))/handles.winsize);
end
pageval = min(pageval,maxiwin);
slidval = max((pageval-1)*handles.winsize,handles.winsize/2);
set(handles.slider1,'Value',slidval)
mainplot(handles)


% To view another file
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

csg_dis_selchan;
delete(handles.figure1);
try
    close(handles.figz)
end

%--------------------------------------------------------------------------
%Filters for the EEG, EOG or EMG signals-----------------------------------
%--------------------------------------------------------------------------

% Edit the lowpass filter cutoff of EEG
function frqabv_Callback(hObject, eventdata, handles)
% hObject    handle to frqabv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frqabv as text
%        str2double(get(hObject,'String')) returns contents of frqabv as a double

frbe = str2double(get(hObject,'String'));
i = handles.minsamp;
if not(isnan(frbe)) && length(frbe)==1

    if frbe>fsample(handles.Dmeg{i})/2*.99
        handles.filter.other(2) = fsample(handles.Dmeg{i})/2*.99;
        set(hObject,'String',num2str(fsample(handles.Dmeg{i})/2));
    else
        handles.filter.other(2) = frbe;
    end

else
    beep
    set(hObject,'String',num2str(handles.filter.other(2)))
    return
end
if fsample(handles.Dmeg{i})>1500
    forder = 1;
else
    forder = 3;
end
[B,A] = butter(forder,[handles.filter.other(1)/(fsample(handles.Dmeg{i})/2),...
    handles.filter.other(2)/(fsample(handles.Dmeg{i})/2)],'pass');
handles.filter.coeffother=[B;A];

% Plot 
mainplot(handles)

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function frqabv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frqabv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%Edit the highpass filter cutoff
function frqblw_Callback(hObject, eventdata, handles)
% hObject    handle to frqblw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frqblw as text
%        str2double(get(hObject,'String')) returns contents of frqblw as a double

frbe    =   str2double(get(hObject,'String'));
i       =   handles.minsamp;
if not(isnan(frbe)) && length(frbe)==1
    if frbe<0.0001
        handles.filter.other(1)=0.0001;
        set(hObject,'String',num2str(0.0001));
    else
        handles.filter.other(1) = frbe;
    end
else
    beep
    set(hObject,'String',num2str(handles.frqbelow))
    return
end
if fsample(handles.Dmeg{i})>1500
    forder = 1;
else
    forder = 3;
end
[B,A] = butter(forder,[handles.filter.other(1)/(fsample(handles.Dmeg{i})/2),...
    handles.filter.other(2)/(fsample(handles.Dmeg{i})/2)],'pass');
handles.filter.coeffother=[B;A];
guidata(hObject, handles);

mainplot(handles)

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function frqblw_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frqblw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function upemg_Callback(hObject, eventdata, handles)
% hObject    handle to upemg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of upemg as text
%        str2double(get(hObject,'String')) returns contents of upemg as a double

frbe	=   str2double(get(hObject,'String'));
i   =   handles.minsamp;
if not(isnan(frbe)) && length(frbe)==1
    if frbe>fsample(handles.Dmeg{i})/2*.99
        handles.filter.EMG(2)=fsample(handles.Dmeg{i})/2*.99;
        set(hObject,'String',num2str(fsample(handles.Dmeg{i})/2));
    else
        handles.filter.EMG(2) = frbe;
    end
else
    beep
    set(hObject,'String',num2str(handles.filter.EMG(2)))
    return
end
if fsample(handles.Dmeg{i})>1500
    forder = 1;
else
    forder = 3;
end
[B,A] = butter(forder,[handles.filter.EMG(1)/(fsample(handles.Dmeg{i})/2),...
    handles.filter.EMG(2)/(fsample(handles.Dmeg{i})/2)],'pass');
handles.filter.coeffEMG=[B;A];

guidata(hObject, handles);

% Main plot  
mainplot(handles)
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function upemg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to upemg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function downemg_Callback(hObject, eventdata, handles)
% hObject    handle to downemg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of downemg as text
%        str2double(get(hObject,'String')) returns contents of downemg as a double
frbe=str2double(get(hObject,'String'));
i=handles.minsamp;
if not(isnan(frbe)) && length(frbe)==1
    if frbe<0.0001
        handles.filter.EMG(1)=0.0001;
        set(hObject,'String',num2str(0.0001));
    else
        handles.filter.EMG(1) = frbe;
    end
else
    beep
    set(hObject,'String',num2str(handles.filter.EMG(1)))
    return
end
if fsample(handles.Dmeg{i})>1500
    forder = 1;
else
    forder = 3;
end
[B,A] = butter(forder,[handles.filter.EMG(1)/(fsample(handles.Dmeg{i})/2),...
    handles.filter.EMG(2)/(fsample(handles.Dmeg{i})/2)],'pass');
handles.filter.coeffEMG=[B;A];

guidata(hObject, handles);

mainplot(handles)

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function downemg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to downemg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Edit the highpass cutoff frequency for EOG signal
function downeog_Callback(hObject, eventdata, handles)
% hObject    handle to downeog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of downeog as text
%        str2double(get(hObject,'String')) returns contents of downeog as a double

frbe=str2double(get(hObject,'String'));
i=handles.minsamp;
if not(isnan(frbe)) && length(frbe)==1
    if frbe<0.0001
        handles.filter.EOG(1)=0.0001;
        set(hObject,'String',num2str(0.0001));
    else
        handles.filter.EOG(1) = frbe;
    end
else
    beep
    set(hObject,'String',num2str(handles.filter.EOG(1)))
    return
end
if fsample(handles.Dmeg{i})>1500
    forder = 1;
else
    forder = 3;
end
[B,A] = butter(forder,[handles.filter.EOG(1)/(fsample(handles.Dmeg{i})/2),...
    handles.filter.EOG(2)/(fsample(handles.Dmeg{i})/2)],'pass');
handles.filter.coeffEOG=[B;A];
guidata(hObject, handles);

mainplot(handles)

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function downeog_CreateFcn(hObject, eventdata, handles)
% hObject    handle to downeog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Edit the lowpass cutoff frequency for EOG signal
function upeog_Callback(hObject, eventdata, handles)
% hObject    handle to upeog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of upeog as text
%        str2double(get(hObject,'String')) returns contents of upeog as a double
frbe = str2double(get(hObject,'String'));
i = handles.minsamp;
if not(isnan(frbe)) && length(frbe)==1
    if frbe>fsample(handles.Dmeg{i})/2*.99
        handles.filter.EOG(2) = fsample(handles.Dmeg{i})/2*.99;
        set(hObject,'String',num2str(fsample(handles.Dmeg{i})/2));
    else
        handles.filter.EOG(2) = frbe;
    end
else
    beep
    set(hObject,'String',num2str(handles.filter.EOG(2)))
    return
end
if fsample(handles.Dmeg{i})>1500
    forder = 1;
else
    forder = 3;
end
[B,A] = butter(forder,[handles.filter.EOG(1)/(fsample(handles.Dmeg{i})/2),...
    handles.filter.EOG(2)/(fsample(handles.Dmeg{i})/2)],'pass');
handles.filter.coeffEOG=[B;A];
guidata(hObject, handles);

mainplot(handles)

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function upeog_CreateFcn(hObject, eventdata, handles)
% hObject    handle to upeog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%--------------------------------------------------------------------------
%Menus to change the reference in either EEG, EMG or EEG
%--------------------------------------------------------------------------

% --- Executes on selection change in EOGpopmenu.
function EOGpopmenu_Callback(hObject, eventdata, handles)
% hObject    handle to EOGpopmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns EOGpopmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from EOGpopmenu

mainplot(handles)

% --- Executes during object creation, after setting all properties.
function EOGpopmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EOGpopmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in EMGpopmenu.
function EMGpopmenu_Callback(hObject, eventdata, handles)
% hObject    handle to EMGpopmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns EMGpopmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from EMGpopmenu

mainplot(handles)

% --- Executes during object creation, after setting all properties.
function EMGpopmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EMGpopmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in EEGpopmenu.
function EEGpopmenu_Callback(hObject, eventdata, handles)
% hObject    handle to EEGpopmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns EEGpopmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from EEGpopmenu
mainplot(handles)

% --- Executes during object creation, after setting all properties.
function EEGpopmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EEGpopmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in otherpopmenu.
function otherpopmenu_Callback(hObject, eventdata, handles)
% hObject    handle to otherpopmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns otherpopmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from otherpopmenu
mainplot(handles)

% --- Executes during object creation, after setting all properties.
function otherpopmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to otherpopmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%--------------------------------------------------------------------------
% Export in a matlab figure------------------------------------------------
%--------------------------------------------------------------------------
function Export_Callback(hObject, eventdata, handles)

% hObject    handle to Export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.export=1;
z=figure;
axs=axes;
set(z,'CurrentAxes',axs)
handles.currentfigure=z;
mainplot(handles)
ha=get(handles.currentfigure,'CurrentAxes');
%display y-labels
index           =   handles.inddis;
li   =   length(index);

ylim([0 handles.scale*(li+1)])
set(ha,'YTick',[handles.scale/2:handles.scale/2:li*handles.scale+handles.scale/2]);
ylabels     =   [num2str(round(handles.scale/2))];
for j=1:li
    ylabels=[ylabels chanlabels(handles.Dmeg{1},index(j))];
    ylabels=[ylabels num2str(round(handles.scale/2))];
end
set(ha,'YTickLabel',ylabels);

%display x-labels
slidval=str2num(get(handles.currenttime,'String'));
xlim([slidval-handles.winsize/2 slidval+handles.winsize/2])
xtick = get(handles.axes1,'XTick');
if isfield(handles,'offset')
    xtick = mod(xtick + handles.offset,24*60^2);
end
[time string] = crc_time_converts(xtick);
set(ha,'XTickLabel',string)

handles.figz=z;
handles.export=0;

% Update handles structure
guidata(hObject, handles);

return

%--------------------------------------------------------------------------
%Management of number of channels and slider-------------------------------
%--------------------------------------------------------------------------

%Slider for the channels when only one file
% --- Executes on slider movement.
function Chanslider_Callback(hObject, eventdata, handles)
% hObject    handle to Chanslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

slidval = get(handles.Chanslider,'Value');
set(handles.Chanslider,'Value',slidval-rem(slidval,1))
mainplot(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Chanslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Chanslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%Edit the number of channel to display
function NbreChan_Callback(hObject, eventdata, handles)

% hObject    handle to NbreChan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NbreChan as text
%        str2double(get(hObject,'String')) returns contents of NbreChan as a double

Nchdispmeeg = str2double(get(handles.NbreChan,'String'));
if ~isnan(Nchdispmeeg) && length(Nchdispmeeg)==1
    set(handles.NbreChan,'String', num2str(min(Nchdispmeeg, length(handles.indexMEEG) + length(handles.indnomeeg))));
else
    beep
    set(handles.NbreChan,'String', num2str(10))
end
channels_Callback(hObject,[],handles);
handles = guidata(hObject);
mainplot(handles);
guidata(hObject,handles);

%--------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%end to be checked%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
% --- Executes during object creation, after setting all properties.

function NbreChan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NbreChanEeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%--------------------------------------------------------------------------
%Management of the scales -------------------------------------------------
%--------------------------------------------------------------------------

%Menu of scales
% --- Executes on selection change in menu scales.
function scales_Callback(hObject, eventdata, handles)
% hObject    handle to scales (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%EEG scale
% --- Executes on selection change in menu scales.
function scale_eeg_Callback(hObject, eventdata, handles)
% hObject    handle to scale_eeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
eegsc=spm_input('EEG scale?',1,'s','1');
close gcf
try
    handles.eegscale=eval(eegsc);
catch
    if strcmpi(eegsc,'V')
        handles.eegscale=10^-6;
    elseif strcmpi(eegsc,'µV')
        handles.eegscale=1;
    else
        beep
        disp('Enter scale in 10^-x format or V or µV')
        handles.eegscale=[];
        return
    end
end
mainplot(handles)
guidata(hObject, handles);

%EOG scale
% --- Executes on selection change in menu scales.
function scale_eog_Callback(hObject, eventdata, handles)
% hObject    handle to scale_eeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
eogsc=spm_input('EOG scale?',1,'s','1');
close gcf
try
    handles.eogscale=eval(eogsc);
catch
    if strcmpi(eogsc,'V')
        handles.eogscale=10^-6;
    elseif strcmpi(eogsc,'µV')
        handles.eogscale=1;
    else
        beep
        disp('Enter scale in 10^-x format or V or µV')
        handles.eogscale=[];
        return
    end
end
mainplot(handles)
guidata(hObject, handles);

%EMG scale
% --- Executes on selection change in menu scales.
function scale_emg_Callback(hObject, eventdata, handles)
% hObject    handle to scale_eeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
emgsc=spm_input('EMG scale?',1,'s','1');
close gcf
try
    handles.emgscale=eval(emgsc);
catch
    if strcmpi(emgsc,'V')
        handles.emgscale=10^-6;
    elseif strcmpi(emgsc,'µV')
        handles.emgscale=1;
    else
        beep
        disp('Enter scale in 10^-x format or V or µV')
        handles.emgscale=[];
        return
    end
end
mainplot(handles)
guidata(hObject, handles);

%ECG scale
% --- Executes on selection change in menu scales.
function scale_ecg_Callback(hObject, eventdata, handles)
% hObject    handle to scale_eeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ecgsc=spm_input('ECG scale?',1,'s','1');
close gcf
try
    handles.ecgscale=eval(ecgsc);
catch
    if strcmpi(ecgsc,'V')
        handles.ecgscale=10^-6;
    elseif strcmpi(ecgsc,'µV')
        handles.ecgscale=1;
    else
        beep
        disp('Enter scale in 10^-x format or V or µV')
        handles.ecgscale=[];
        return
    end
end
mainplot(handles)
guidata(hObject, handles);

%LFP scale
% --- Executes on selection change in menu scales.
function scale_lfp_Callback(hObject, eventdata, handles)
% hObject    handle to scale_eeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ecgsc=spm_input('LFP scale?',1,'s','1');
close gcf
try
    handles.lfpscale=eval(ecgsc);
catch
    if strcmpi(ecgsc,'V')
        handles.lfpscale=10^-6;
    elseif strcmpi(ecgsc,'µV')
        handles.lfpscale=1;
    else
        beep
        disp('Enter scale in 10^-x format or V or µV')
        handles.lfpscale=[];
        return
    end
end
mainplot(handles)
guidata(hObject, handles);

%Other scale
% --- Executes on selection change in menu scales.
function scale_other_Callback(hObject, eventdata, handles)
% hObject    handle to scale_eeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ecgsc=spm_input('Other scale?',1,'s','1');
close gcf
try
    handles.otherscale=eval(ecgsc);
catch
    beep
    disp('Enter scale in 10^-x format')
    handles.otherscale=[];
    return
end
mainplot(handles)
guidata(hObject, handles);


%Menu of MEG scales
% --- Executes on selection change in menu scales.
function scale_meg_Callback(hObject, eventdata, handles)
% hObject    handle to scales (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%ECG scale
% --- Executes on selection change in menu scales.
function scale_megmag_Callback(hObject, eventdata, handles)
% hObject    handle to scale_eeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ecgsc=spm_input('Magnometers scale?',1,'s','1');
close gcf
try
    handles.megmagscale=eval(ecgsc);
catch
    if strcmpi(ecgsc,'T')
        handles.megmagscale=10^-12;
    elseif strcmpi(ecgsc,'fT')
        handles.megmagscale=1;
    else
        beep
        disp('Enter scale in 10^-x format or T or fT')
        handles.megmagscale=[];
        return
    end
end
mainplot(handles)
guidata(hObject, handles);

%ECG scale
%--------------------------------------------------------------------------
%Display of events and travel in the data using types of events------------
%--------------------------------------------------------------------------

%Select the type of event
% --- Executes on selection change in popupmenu10.
function popupmenu10_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu10 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu10

evtype = get(handles.popupmenu10,'String');
evnum  = get(handles.popupmenu10,'Value');

if evnum==1
    evnum = 2 : size(evtype,1);
end

chos=[];

for i=1:max(size(handles.evt,2),size(handles.evt,1)) 
    if any(strcmpi(handles.evt(i).type,evtype(evnum)))
        chos=[chos, i];
    end
end

handles.chostype=chos;
pmstring=[{'All'},{'Scan number'}];
for i=1:size(chos,2)
    if ~any(strcmpi(handles.evt(chos(i)).value, pmstring))
        pmstring = [pmstring, {handles.evt(chos(i)).value}];
    end
end

handles.chosevt     = handles.chostype;
handles.displevt    = 0;

set(handles.popupmenu11,...
    'String',pmstring,...
    'Value',1) %pmstring in old version... to be checked

guidata(hObject, handles);
radiobutton1_Callback(hObject, [], handles)

% --- Executes during object creation, after setting all properties.
function popupmenu10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Goes to the previous event
% --- Executes on button press in previous event.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.displevt
    ind = find(handles.displevt==handles.chosevt);
    if ind-1>0
        handles.displevt=handles.chosevt(ind-1);
    else
        handles.displevt=handles.chosevt(ind);
    end
else
    difdur=zeros(1,size(handles.chosevt,2));
    slidval = get(handles.slider1,'Value');
    for i=1:size(handles.chosevt,2)
        difdur(i)=handles.evt(handles.chosevt(i)).time-slidval;
    end
    difdur(difdur>=0)=0;
    difdur(difdur<0)=1;
    diffdur=diff(difdur);
    todisp=find(diffdur==-1);
    if ~isempty(todisp)
        handles.displevt=handles.chosevt(todisp-1);
    elseif sum(difdur)==0
        handles.displevt=handles.chosevt(1);
    else
        handles.displevt=handles.chosevt(end);
    end
end

slidval=handles.evt(handles.displevt).time-handles.winsize/2;
if slidval<=1
    slidval=handles.evt(handles.displevt).time-2; %default value if first event is at the boundary of the file
end
set(handles.slider1,'Value',slidval)

mainplot(handles);
guidata(hObject, handles);



%Goes to next event
% --- Executes on button press in next event.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.displevt
    ind=find(handles.displevt==handles.chosevt);
    if ind+1<=size(handles.chosevt,2)
        handles.displevt=handles.chosevt(ind+1);
        if handles.evt(handles.chosevt(ind+1)).time>= nsamples(handles.Dmeg{1})...
                /fsample(handles.Dmeg{1})
            handles.displevt=handles.chosevt(ind);
        end
    else
        handles.displevt=handles.chosevt(ind);
    end
else
    difdur=zeros(1,size(handles.chosevt,2));
    slidval = get(handles.slider1,'Value');
    for i=1:size(handles.chosevt,2)
        difdur(i)=handles.evt(handles.chosevt(i)).time-slidval;
    end
    difdur(difdur>=0)=0;
    difdur(difdur<0)=1;
    diffdur=diff(difdur);
    todisp=find(diffdur==-1);
    if ~isempty(todisp)&& todisp+1<size(handles.evt,2)
        handles.displevt=handles.chosevt(todisp+1);
    elseif sum(difdur)==0
        handles.displevt=handles.chosevt(1);
    else
        handles.displevt=handles.chosevt(end);
    end
end

slidval=handles.evt(handles.displevt).time-handles.winsize/2;
if slidval<=0
    slidval=handles.evt(handles.displevt).time-2; %default value if first event is at the boundary of the file
end
set(handles.slider1,'Value',slidval)

mainplot(handles);
guidata(hObject, handles);


% %Goes to the previous event
% --- Executes when the button 'Spectogram' is pushed.
function push_ps_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

str = chanlabels(handles.Dmeg{1},meegchannels(handles.Dmeg{1}));
[handles.powchan,v] = listdlg('PromptString','Select EEG channels for the spectrogram computation',...
                'SelectionMode','inf',...
                'ListString',str);
D = csg_powerspect(handles);
handles.pow = D.CSG.spectrogram;
handles.powinfo = D.CSG.spectrogram.info;
% handles.powchan = 
csg_powplot(handles.axes4,handles);
guidata(hObject, handles);

%Check to say if event is good (1) or bad (0)
% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1
handles.plotevt =   get(handles.radiobutton1,'Value');
set(handles.figure1,'CurrentAxes',handles.axes4);
a = get(handles.axes4,'Children');
for ia = 1 : numel(a)
    if strcmp(get(a(ia),'tag'),'evt')
        delete(a(ia));
    end
end
if handles.plotevt   
    height = get(handles.axes4,'YTick');
    hold on, 
    for ievt = 1 : numel(handles.chosevt)
        xpos = handles.evt(handles.chosevt(ievt)).time;
        plot(xpos*ones(1,2),[0 height(end)],'k','tag','evt')
    end
    hold off
end
    
guidata(hObject,handles)


%Menu to chose the value of the event within a selected type
% --- Executes on selection change in popupmenu11.
function popupmenu11_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu11 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu11
evval   =   get(handles.popupmenu11,'String');
evnu    =   get(handles.popupmenu11,'Value');
if evnu == 1 || evnu == 2
    evnu = 3:size(evval,1);
end 

chos=[];
for i=1:size(handles.chostype,2)
    if any(strcmpi(handles.evt(handles.chostype(i)).value,evval(evnu)))
        chos=[chos, handles.chostype(i)];
    end
end
handles.chosevt = chos;

handles.displevt = 0;
guidata(hObject, handles);
radiobutton1_Callback(hObject, [], handles)

% --- Executes during object creation, after setting all properties.
function popupmenu11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%--------------------------------------------------------------------------
%Save the position of the slider in the data-------------------------------
%--------------------------------------------------------------------------
% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

slidval=get(handles.slider1,'Value');
D=handles.Dmeg{1};
if isfield(handles.Dmeg{1},'CRC')
    D.CRC.lastdisp=slidval;
else
    D.CRC=struct('lastdisp',[]);
    D.CRC.lastdisp=slidval;
end
handles.Dmeg{1}=D;
save(D);


%--------------------------------------------------------------------------
% menu on right click
%--------------------------------------------------------------------------

% --------------------------------------------------------------------
function CleanMenu_Callback(hObject, eventdata, handles)
% hObject    handle to CleanMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --------------------------------------------------------------------
handles.Mouse = get(handles.axes1,'CurrentPoint');
guidata(hObject,handles)

function clean_epoch_onechan_Callback(hObject, eventdata, handles)
% hObject    handle to clean_epoch_onechan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

chan = ceil((handles.Mouse(1,2)-handles.scale/2)/handles.scale);
time = ceil(handles.Mouse(1,1));
channel     =   handles.inddis(chan);
handles.badepoch(channel,time) = 0;
handles.Dmeg{1}.CSG.preprocessing.artefact = handles.badepoch;
save(handles.Dmeg{1});
% Update handles structure
guidata(hObject, handles);
mainplot(handles)

function clean_epoch_allchan_Callback(hObject, eventdata, handles)
% hObject    handle to clean_epoch_allchan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
time = ceil(handles.Mouse(1,1));
handles.badepoch(:,time) = [];
handles.Dmeg{1}.CSG.preprocessing.artefact = handles.badepoch;
save(handles.Dmeg{1});
% Update handles structure
guidata(hObject, handles);
mainplot(handles)


function remove_epoch_onechan_Callback(hObject, eventdata, handles)
% hObject    handle to remove_epoch_onechan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
chan = ceil((handles.Mouse(1,2)-handles.scale/2)/handles.scale);
time = ceil(handles.Mouse(1,1));
channel     =   handles.inddis(chan);
handles.badepoch(channel,time) = 1;
handles.Dmeg{1}.CSG.preprocessing.artefact = handles.badepoch;
save(handles.Dmeg{1});
% Update handles structure
guidata(hObject, handles);
mainplot(handles)

function remove_epoch_allchan_Callback(hObject, eventdata, handles)
% hObject    handle to remove_epoch_allchan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
time = ceil(handles.Mouse(1,1));
handles.badepoch(handles.indeeg,time) = 1;
handles.Dmeg{1}.CSG.preprocessing.artefact = handles.badepoch;
save(handles.Dmeg{1});
% Update handles structure
guidata(hObject, handles);
mainplot(handles)


% ----------------------------------------------------------------------
% For channel selection 
% ----------------------------------------------------------------------

% Click on channels displayed on the right to recenter the main display
% -----------------------------------------------------------------------

function click(hObject, eventdata, handles)

% Mouse on the spectrogram
Mouse = get(handles.axes4,'CurrentPoint');
xlim1 = get(handles.axes4,'xlim');
% Mouse on the mainplot
Mouse2 = get(handles.axes1,'CurrentPoint');
xlim2 = get(handles.axes1,'xlim');
% Mouse on the localizer
Mouse3 = get(handles.axes5,'CurrentPoint');

if  Mouse(1,1) > 0 && Mouse(1,2) > 0 && Mouse(1)<xlim1(end) %Even without score sleep, possibility to access from axes4 where we want on main screen
    slidval = Mouse(1);
    slidval = floor(slidval/handles.winsize)*handles.winsize;
    slidval = max(slidval,1/fsample(handles.Dmeg{1}));
    xtick = get(handles.axes4,'Xtick');
    slidval = slidval - xtick(1);
    set(handles.slider1,'Value',slidval)
    set(handles.figure1,'CurrentAxes',handles.axes4)
    a=get(handles.axes4,'Children');
    for i=1:size(a,1)
        if strcmpi(get(a(i),'tag'),'cursor')
            delete(a(i))
        end
    end
    hold on
    handles.cursor = plot(slidval+handles.winsize/2,0,'^','Color',[0.2 0.2 0.2],'LineWidth',2.5,'tag','cursor');
    guidata(hObject, handles);
    mainplot(handles)
end  
    
if Mouse2(1,1)>0 && Mouse2(1,2)>0 && Mouse2(1)<xlim2(end)
    Y = get(handles.axes1,'YTick');
    C = Mouse2(1,2);

    [gum index] = min(abs(C-Y(2:2:end)));
    [gum gum index2] = intersect(upper(chanlabels(handles.Dmeg{1},handles.inddis(index))),upper(handles.names));
    xpos = handles.pos(1,index2);
    ypos = handles.pos(2,index2);

    set(handles.figure1,'CurrentAxes',handles.axes5)
    a=get(handles.axes5,'Children');
    for i=1:size(a,1)
        if strcmpi(get(a(i),'tag'),'position')
            delete(a(i))
        end
    end
    hold on
    plot(xpos,ypos,'o','Markersize',10,'tag','position')
    hold off
    xlim([0 1])
    ylim([0 1])
    guidata(hObject, handles);
end

if Mouse3(1,1)>0 && Mouse3(1,2)>0 && ~any(abs(Mouse3(1,1:2))>1)
    chanavailable = chanlabels(handles.Dmeg{1},handles.index);
    [gum gum index] = intersect(upper(chanavailable),upper(handles.names));
    dist = sqrt(sum((Mouse3(1,1:2)'*ones(1,numel(index))-handles.pos(:,index)).^2));
    [gum mindist] = min(dist);
    
    handles.chansel = upper(handles.names(index(mindist)));
    [gum index gum] = intersect(get(handles.channels,'String'),handles.chansel);
    set(handles.channels,'Value',index);
    channels_Callback(hObject,[],handles)
end
% 



% --- Executes when the channel selected in the popupmenu is changed.
function channels_Callback(hObject, eventdata, handles)
% hObject    handle to channels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns channels contents as cell array
%        contents{get(hObject,'Value')} returns selected item from channels

contents            = cellstr(get(handles.channels,'String'));
handles.chansel     = contents{get(handles.channels,'Value')};
chanavailable       = upper(chanlabels(handles.Dmeg{1},handles.index));
[gum gum index]     = intersect(upper(handles.chansel),upper(handles.names));
[gum gum index2]    = intersect(upper(chanavailable),upper(handles.names));
NbreChandisp        = str2double(get(handles.NbreChan,'String'));
if isempty(index)
    count = 1;
    while isempty(index) && get(handles.channels,'Value')+count < numel(contents)
        handles.chansel = contents{get(handles.channels,'Value')+count};
        [gum gum index] = intersect(upper(handles.chansel),upper(handles.names));
        count = count + 1;
    end 
end
[gum idxsorted] = sort(handles.Dchan(index,index2));

handles.chantodisp  = upper(handles.names(index2(idxsorted(1:NbreChandisp))));
[gum gum handles.inddis] = intersect(handles.chantodisp,upper(chanlabels(handles.Dmeg{1})));
guidata(hObject,handles)
% 
set(handles.figure1,'CurrentAxes',handles.axes5)
[gum gum indexall] = intersect(upper(chanlabels(handles.Dmeg{1})),upper(handles.names));         
xblack = handles.pos(1,indexall);
yblack = handles.pos(2,indexall);
         
xblue = handles.pos(1,index2);
yblue = handles.pos(2,index2);

xred = handles.pos(1,index2(idxsorted(1:NbreChandisp)));
yred = handles.pos(2,index2(idxsorted(1:NbreChandisp)));

cla(handles.axes5)

hold on
plot(xblack,yblack,'k.','tag','localizer'), plot(xblue,yblue,'b+','tag','localizer'),plot(xred,yred,'r+','tag','localizer')
hold off
xlim([0 1])
ylim([0 1])

mainplot(handles)
guidata(hObject,handles)
return;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes during object creation, after setting all properties.
function channels_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ------------------------------------------------------------------
% Key Press Functions to navigate from one time window to the other
% ------------------------------------------------------------------
% --- Press 'F' for Forward to go to the next time window.
% --- Press 'B' for Backward to go to the previous time window

function keypress(hObject, eventdata, handles)

crcdef  =   crc_get_defaults('score');
currentwindow   =	floor(str2double(get(handles.currenttime,'String')) ...
                                /handles.winsize)+1;
if or(get(handles.figure1,'CurrentCharacter')=='B',get(handles.figure1,'CurrentCharacter')=='b')
    handles.move = 0;
    slidval = str2double(get(handles.currenttime,'String'));
    slidval = (floor(slidval/handles.winsize)-1)*handles.winsize;
    slidval = max(slidval,1/fsample(handles.Dmeg{1}));
    slidval = min(slidval, currentwindow*handles.winsize);

    set(handles.slider1,'Value',slidval);
    set(handles.figure1,'CurrentAxes',handles.axes4);
    if isfield(handles,'pow') && ~isempty(handles.pow)
        csg_powplot(handles.axes4, handles);
    end
    % Goes to next window
elseif or(get(handles.figure1,'CurrentCharacter')=='F',get(handles.figure1,'CurrentCharacter')=='f')
    handles.move = 0;
    slidval     =   str2double(get(handles.currenttime,'String'));
    slidval     =   (floor(slidval/handles.winsize)+1)*handles.winsize;
    slidval     =   max(slidval,1/fsample(handles.Dmeg{1}));

    if slidval>=nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1})
        slidval     =   currentwindow*handles.winsize;
    else
        slidval     =   min(slidval, currentwindow*handles.winsize);
    end
    set(handles.slider1,'Value',slidval);
    set(handles.figure1,'CurrentAxes',handles.axes4);
    if isfield(handles,'pow') && ~isempty(handles.pow)
        csg_powplot(handles.axes4, handles);
    end
else
    touch = int2str(get(handles.figure1,'CurrentCharacter'));
    if and(handles.move~=0,strcmpi(touch,'28'))
        ev = events(handles.Dmeg{1});
        ev(handles.move).time = ev(handles.move).time - 1/fsample(handles.Dmeg{1}); % On avance par échantillon
        handles.evt = ev;
        handles.Dmeg{1} = events(handles.Dmeg{1},1,ev);
        save(handles.Dmeg{1});
        fprintf(['The event ' char(handles.evt(handles.move).type) ' of ' char(handles.evt(handles.move).value) ' is moving on the left : ' num2str(handles.evt(handles.move).time) 'sec \n']) 
        mainplot(handles)
    elseif and(handles.move~=0,strcmpi(touch,'29'))
        ev = events(handles.Dmeg{1});
        ev(handles.move).time + 1/fsample(handles.Dmeg{1});
        ev(handles.move).time = ev(handles.move).time + 1/fsample(handles.Dmeg{1}); % On avance par échantillon
        handles.evt = ev;
        handles.Dmeg{1} = events(handles.Dmeg{1},1,ev);
        save(handles.Dmeg{1});
        fprintf(['The event ' char(handles.evt(handles.move).type) ' of ' char(handles.evt(handles.move).value) ' is moving on the right : ' num2str(handles.evt(handles.move).time) 'sec \n']) 
        mainplot(handles)
    else 
        beep;
        fprintf('Wrong key pressed! Please choose press a number between 0 and %d.\n',crcdef.nrStage-1)
        for ii = 1    :   crcdef.nrStage
            fprintf('%d : %s\n',ii-1,crcdef.stnames_L{ii})
        end
        fprintf('\n')   
    end
end 

set(handles.figure1,'CurrentAxes',handles.axes1);
mainplot(handles)
set(handles.figure1,'CurrentAxes',handles.axes1);

% Update handles structure
guidata(hObject, handles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%--------------------------------------------------------------------------
%------------------------------ MAIN PLOT FUNCTION ------------------------
%--------------------------------------------------------------------------

function mainplot(handles)

if handles.displevt
    handles.evt(handles.displevt).time;
    slidval=handles.evt(handles.displevt).time-handles.winsize/2;
    if slidval<=1
        slidval=max(handles.evt(handles.displevt).time-2,1/fsample(handles.Dmeg{1})); %default value if first event is at the boundary of the file
    elseif slidval>=(nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1})-handles.winsize/2)        
        slidval=min(handles.evt(handles.displevt).time-2,nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1})-handles.winsize/2); %default value if last event is at the boundary of the file
    end
else           
    slidval = floor((get(handles.slider1,'Value')/handles.winsize))*handles.winsize;  
    if slidval<1/fsample(handles.Dmeg{1})
        slidval=1/fsample(handles.Dmeg{1});
        set(handles.slider1,'Value',slidval);
    elseif slidval>nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1})-handles.winsize/2;
        slidval=nsamples(handles.Dmeg{1})/fsample(handles.Dmeg{1})-handles.winsize/2;
        aval=get(handles.slider1,'Max');
        set(handles.slider1,'Value',aval);
    end
end
pwrstate = get(handles.axes4,'Visible');
if strcmp(pwrstate,'on')
    set(handles.figure1,'CurrentAxes',handles.axes4)
    a=get(handles.axes4,'Children');
    for i=1:size(a,1)
        if strcmpi(get(a(i),'tag'),'cursor')
            delete(a(i))
        end
    end
    hold on
    handles.cursor = plot(slidval+handles.winsize/2,0,'^','Color',[0.2 0.2 0.2],'LineWidth',2.5,'tag','cursor');
    set(handles.figure1,'CurrentAxes',handles.axes1)
end

cmap = hsv(length(handles.Dmeg));

if handles.export
    axs=get(handles.currentfigure,'CurrentAxes');
    h=axs;
else
    cleargraph(handles.figure1,'axes1');
    h=handles.axes1; 
end
axes(h);
maxi=1;                   

%one file
set(handles.currenttime,'String',num2str(round(slidval+handles.winsize/2)));
set(handles.edit1,'String',num2str(handles.winsize));
set(handles.currentpage,'String',num2str(ceil((slidval+handles.winsize/2)/handles.winsize)));
for i=1:maxi
    %timing
    tdeb = min(round(slidval*fsample(handles.Dmeg{i})),nsamples(handles.Dmeg{i})-10);
    %channels
    NbreChandisp    = str2double(get(handles.NbreChan,'String'));
    index   =   handles.inddis;
    maxj    =   length(index); %number of channels
    temps   =   tdeb:1:min(tdeb+(fsample(handles.Dmeg{i})*handles.winsize)-1, ...
                nsamples(handles.Dmeg{i}));
    toshow  =   temps;
    temps   =   temps/fsample(handles.Dmeg{i});
   
    for j=1:maxj
        hold on
        [dumb1,dumb2,index2] = ...
            intersect(upper(chanlabels(handles.Dmeg{i},index(j))),handles.names);
        %To be checked = old version contained : testcond = chanlabels(handles.Dmeg{i},index(j));
        if handles.multcomp
            factscale = handles.scale*i; %cycle on files if mult comp
        else
            factscale = handles.scale*j; %cycle on channels if one file    
        end
        if  any(index(j)==emgchannels(handles.Dmeg{i}))  %strfind(testcond{:},'EMG')
            contents = get(handles.EMGpopmenu,'String');
            selchan=upper(contents{get(handles.EMGpopmenu,'Value')});
            if isfield(handles,'emgscale') && ~isempty(handles.emgscale)
                scal=handles.emgscale;
            else
                unemg=units(handles.Dmeg{i},index(j));
                try
                    scal=eval(unemg{1});
                catch
                    if strcmpi(unemg{1},'V')
                        scal=10^-6;
                    else
                        scal=1;
                    end
                end
            end
            filtparam=handles.filter.coeffEMG;
        elseif any(index(j)==eogchannels(handles.Dmeg{i})) %strfind(testcond{:},'EOG')
            contents = get(handles.EOGpopmenu,'String');
            selchan=upper(contents{get(handles.EOGpopmenu,'Value')});
            if isfield(handles,'eogscale') && ~isempty(handles.eogscale)
                scal=handles.eogscale;
            else
                unemg=units(handles.Dmeg{i},index(j));
                try
                    scal=eval(unemg{1});
                catch
                    if strcmpi(unemg{1},'V')
                        scal=10^-6;
                    else
                        scal=1;
                    end
                end
            end
            filtparam=handles.filter.coeffEOG;
        elseif any(index(j)==ecgchannels(handles.Dmeg{i})) %strfind(testcond{:},'ECG'
            contents = get(handles.otherpopmenu,'String');
            selchan=upper(contents{get(handles.otherpopmenu,'Value')});
            if isfield(handles,'ecgscale') && ~isempty(handles.ecgscale)
                scal=handles.ecgscale;
            else
                unemg=units(handles.Dmeg{i},index(j));
                try
                    scal=eval(unemg{1});
                catch
                    if strcmpi(unemg{1},'V')
                        scal=3*10^-5;
                    else
                        scal=1;
                    end
                end
            end
            filtparam=handles.filter.coeffother;
        elseif any(index(j)==meegchannels(handles.Dmeg{i})) %'EEG'            
            contents = get(handles.EEGpopmenu,'String');
            selchan=upper(contents{get(handles.EEGpopmenu,'Value')});
            chtyp=chantype(handles.Dmeg{i},index(j));
            if strcmpi(chtyp,'EEG')
                if isfield(handles,'eegscale') && ~isempty(handles.eegscale)
                    scal=handles.eegscale;
                else
                    unemg=units(handles.Dmeg{i},index(j));
                    try
                        scal=eval(unemg{1});
                    catch
                        if strcmpi(unemg{1},'V')
                            scal=10^-6;
                        else
                            scal=1;
                        end
                    end
                end
            elseif strcmpi(chtyp,'MEGMAG')
                selchan = 'MEG';
                if isfield(handles,'megmagscale') && ~isempty(handles.megmagscale)
                    scal=handles.megmagscale;
                else
                    unemg=units(handles.Dmeg{i},index(j));
                    try
                        scal=eval(unemg{1});
                    catch
                        if strcmpi(unemg{1},'T')
                            scal=5*10^-14;
                        else
                            scal=1;
                        end
                    end
                end
            elseif strcmpi(chtyp,'MEGPLANAR')
                selchan = 'MEG';
                if isfield(handles,'megplanarscale') && ~isempty(handles.megplanarscale)
                    scal=handles.megplanarscale;
                else
                    unemg=units(handles.Dmeg{i},index(j));
                    try
                        scal=eval(unemg{1});
                    catch
                        if strcmpi(unemg{1},'T/m')
                            scal=5*10^-13;
                        else
                            scal=1;
                        end
                    end
                end
             elseif strcmpi(chtyp,'LFP')
                if isfield(handles,'lfpscale') && ~isempty(handles.lfpscale)
                    scal=handles.lfpscale;
                else
                    unemg=units(handles.Dmeg{i},index(j));
                    try
                        scal=eval(unemg{1});
                    catch
                        if strcmpi(unemg{1},'V')
                            scal=10^-5;
                        else
                            scal=10 ;
                        end
                    end
                end
            end
            filtparam=handles.filter.coeffother;
        else
            contents = get(handles.EEGpopmenu,'String');
            selchan=upper(contents{get(handles.EEGpopmenu,'Value')});
            chtyp=chantype(handles.Dmeg{i},index(j));
            if strcmpi(chtyp,'other') || strcmpi(chtyp,'unknown')
                if isfield(handles,'otherscale') && ~isempty(handles.otherscale)
                    scal=handles.otherscale;
                else
                    unemg=units(handles.Dmeg{i},index(j));
                    try
                        scal=eval(unemg{1});
                    catch
                        if strcmpi(unemg{1},'V')
                            scal=10^-6;
                        else
                            scal=1;
                        end

                    end
                end
            end
            filtparam=handles.filter.coeffother;
        end
       %Plot data   
        switch  selchan
            case 'MEG'
                % MEG data             
                chtyp = chantype(handles.Dmeg{i},index(j));
                if  strcmpi(chtyp,'MEGMAG') 
                    plt     =   plot(temps,factscale+(handles.Dmeg{i}(index(j),toshow))/scal,'Color',[0.25 0.25 0.25]);
                elseif  strcmpi(chtyp,'MEGPLANAR')
                        plt     =   plot(temps,factscale+(handles.Dmeg{i}(index(j),toshow))/scal,'Color',[0.5 0.5 0]);
                end
             case    'REF1'
                plt         = 	plot(temps,factscale + (handles.Dmeg{i}(index(j),toshow))/scal);             
             case    'MEAN OF REF'
                basedata    =   handles.Dmeg{i}(index(j),toshow);
                scnddata    =   basedata - handles.Dmeg{i}(strcmp(chanlabels(handles.Dmeg{i}),'REF2'),toshow);                         
                toplotdat   =   mean([basedata ; scnddata]);
                plt         =   plot(temps,factscale+(toplotdat)/scal);

            case    'M1-M2'
                basedata    =   handles.Dmeg{i}(index(j),toshow);
                M1idx       =   find(strcmp(chanlabels(handles.Dmeg{i}),'M1'));
                M2idx       =   find(strcmp(chanlabels(handles.Dmeg{i}),'M2'));
                meanM       =   mean([handles.Dmeg{i}(M1idx,toshow) ; ...
                                        handles.Dmeg{i}(M2idx,toshow)]);
                toplotdat   = 	basedata - meanM;
                plt         =   plot(temps,factscale+(toplotdat)/scal);

            case    'BIPOLAR'
                if handles.crc_types(index2)>0
                    [dumb1,index3] = ...
                        intersect(upper(chanlabels(handles.Dmeg{i})), ...
                        upper(handles.names(handles.crc_types(index2))));
                else
                    index3 = [];
                end
                if ~isempty(index3)
                    bipolar	=   handles.Dmeg{i}(index(j),toshow) - handles.Dmeg{i}(index3,toshow);
                    plt  	=   plot(temps,factscale+(bipolar)/scal,'Color','k');
                else
                    plt     =   plot(temps,factscale+(handles.Dmeg{i}(index(j),toshow))/scal,'Color','k');       
                end

            otherwise
                [dumb1,index3]  =   intersect(upper(chanlabels(handles.Dmeg{i})),selchan);       
                basedata        =   handles.Dmeg{i}(index(j),toshow);
                toplotdat       =   basedata - handles.Dmeg{i}(index3,toshow);
                plt  	=   plot(temps,factscale+(toplotdat)/scal);
        end
        filterlowhigh(plt,i,handles,filtparam,factscale)
        if plt~=0 && any(index(j)==ecgchannels(handles.Dmeg{i}))
            set(plt,'Color',[1 0.1 0.1])
        end
        if plt~=0 && handles.multcomp
            set(plt,'Color',cmap(i,:))
        end    

        %artefacts on single channel OVER handles.badchaninfo length
        if  any(handles.badepoch)
            ce = unique([ceil(temps(2)) : ceil(temps(end))]);
            for ice = 1 : numel(ce)
                badepoch = find(handles.badepoch(:,ce(ice)));                    
                if ~isempty(badepoch) && ~isempty(intersect(badepoch,index(j))) 
                    X   =   get(plt,'YData');
                    deb =  max(1,((ce(ice)-1) - temps(1))*fsample(handles.Dmeg{1})+1); %1=temps d'une époque artefactée
                    fin =  min(temps(end)*fsample(handles.Dmeg{1}),min(nsamples(handles.Dmeg{1}),ce(ice)*fsample(handles.Dmeg{1})))-temps(1)*fsample(handles.Dmeg{1});
                    time_epo = [deb : fin]./fsample(handles.Dmeg{1})+temps(1);
                    X   =   X(deb:fin);%fs est le nombre d'échantillons contenus dans une seconde
                    plot(time_epo,X,'color','r');
                end
            end
        end
        plt = 0;
    end
end

if strcmp(get(handles.axes4,'visible'),'on')
    set(handles.figure1,'CurrentAxes',handles.axes4);
    a   =   get(handles.axes4,'Children');
    for i   =   1   :   size(a,1)
        if strcmpi(get(a(i),'tag'),'cursor')
            delete(a(i));
        end
    end
    hold on
    handles.cursor  =    plot(slidval+handles.winsize/2,0,'^','Color','k','LineWidth',2.5,'tag','cursor');
    hold off
    set(handles.figure1,'CurrentAxes',handles.axes1);
end

if handles.displevt
    timevt=handles.evt(handles.displevt).time;
    szevt=handles.scale*size(index,2);
    hold on
    plot(timevt*ones(1,szevt+1),handles.scale/2:handles.scale/2+szevt,'-r','Linewidth',2)
end

%display the labels on the y-axis
li=length(index);
ylim([0 handles.scale*(li+1)])
set(handles.axes1,'YTick',[handles.scale/2 :handles.scale/2:li*handles.scale+handles.scale/2]);
ylabels=[num2str(round(handles.scale/2))];

for j = 1 : li
    ylabels = [ylabels chanlabels(handles.Dmeg{1},index(j))];
    ylabels = [ylabels num2str(round(handles.scale/2))];
end
set(handles.axes1,'YTickLabel',ylabels);

xlim([temps(1) temps(1)+handles.winsize])
xtick = get(handles.axes1,'XTick');
if isfield(handles,'offset')
    xtick = mod(xtick + handles.offset,24*60^2);
end
[time string] = crc_time_converts(xtick);
set(handles.axes1,'XTickLabel',string)


% Display trigger
ev = events(handles.Dmeg{1});

if iscell(ev)
    ev=cell2mat(ev);
end
if isempty(ev)
    ev=struct('time', -500,'value', -2000);
end
try
    [int indextoshow indextrig] = intersect(toshow,round([ev(:).time]*fsample(handles.Dmeg{1})));
catch
    [int indextoshow indextrig] = intersect(toshow,round([ev{:}.time]*fsample(handles.Dmeg{1})));
end
itrigger=[];
if ~isempty(handles.base) && ~isempty(intersect(handles.base(:,1),{ev(indextrig).type}))
    for tr = 1 : max(size(indextrig))
        itrigger = [itrigger find([ev(:).time] == ev(indextrig(tr)).time)];
    end
end

int = int/fsample(handles.Dmeg{1});
Nev_dis = length(int);
if Nev_dis % do all this if there are several triggers to be displayed !
    try
        tmp_val = ev(indextrig(1)).value;
    catch
        tmp_val = ev{indextrig(1)}.value;
    end
    if ischar(tmp_val)
        use_numv = 0;
    else
        use_numv = 1;
    end
    etype=cell(Nev_dis,1);
    for i=1:Nev_dis
        if use_numv
            etype{i}=num2str(ev(indextrig(i)).value);
        else
            etype{i}=ev(indextrig(i)).value;
        end
    end
    etpv = {ev(indextrig).type};
    plot(int,0.5*ones(1,length(int))*handles.scale/50*(NbreChandisp), ...
        'k^','LineWidth',2.5)
    if ~isempty(handles.type)
        [manev inte intm] = intersect(etpv,handles.type(:,1));
    else 
        manev = [];
    end
    nme = length(manev);
    for me = 1 : nme
        inte = find(strcmpi(etpv,manev(me)));
        col = char(handles.type(intm(me),2));
        incol = col(:,1);
        if ~handles.export 
            plot(int(inte),0.5*ones(1,length(int(inte)))*handles.scale/50*(NbreChandisp),'^','Color',incol,'UIContextMenu',handles.DeletEvents,...
                'LineWidth',2.5)
            for nse = 1 : length(inte)
                plot(ones(1,2).*int(inte(nse)),[handles.scale/2 handles.scale*(NbreChandisp)+handles.scale],'Color',incol,'UIContextMenu',handles.DeletEvents,...
                    'LineWidth',0.5)
            end
        else 
            plot(int(inte),0.5*ones(1,length(int(inte)))*handles.scale/50*(NbreChandisp),'^','Color',incol,...
                'LineWidth',2.5)
            for nse = 1 : length(inte)
                plot(ones(1,2).*int(inte(nse)),[handles.scale/2 handles.scale*(NbreChandisp)+handles.scale],'Color',incol,'LineWidth',0.5)
            end
        end                
    end
    %chose between the display of type or of value
    fmric=0;
    if ~(max(size(handles.evt))==max(size(handles.chosevt)))
        disc=1;
        evtp=get(handles.popupmenu11,'Value');
        if evtp==1
            evtch=get(handles.popupmenu10,'String');
            evtp=get(handles.popupmenu10,'Value');
            chostype=1;
            typevt=evtch(evtp);
        elseif evtp==2
            fmric=1;
            evtch=get(handles.popupmenu10,'String');
            evtp=get(handles.popupmenu10,'Value');
            chostype=1;
            typevt=evtch(evtp);
        else
            evtch=get(handles.popupmenu11,'String');
            chostype=0;
            typevt=evtch(evtp);
        end
    else
        disc=0;
        if get(handles.popupmenu11,'Value')==2
            fmric=1;
        end
    end
    for jj = 1:Nev_dis
        %if types or values are chosen by the user, only display their
        %names
         if isempty(handles.base) || isempty(intersect(handles.base(:,1),{ev(indextrig).type})) % pas de selection faite ou pas de trigger correspondant à la selection faite
            if disc && chostype && strcmpi(etpv{jj},typevt) && ~fmric
                msg = etpv{jj};
            elseif disc && chostype && strcmpi(etpv{jj},typevt) && fmric
                msg = etype{jj};                
            elseif disc && ~(strcmpi(etype{jj},typevt)) %(disc && chostype && strcmpi(etpv{jj},typevt)) || ...
                msg='';
            elseif disc && ~chostype && strcmpi(etype{jj},typevt) || fmric
                msg = etype{jj};
            elseif ~disc
                msg = num2str(etpv{jj});
            end
         else
            %msg must contain value in base 10 :
            m = find([ev(itrigger(:)).time]==ev(indextrig(jj)).time);      
            [evsel itri ibase]= intersect({ev(itrigger(m)).type},handles.base(:,1));
            if isempty(evsel)
                sumtrig = 0;
            else
                sumtrig = sum(2.^(ibase-1));
            end
            msg = num2str(sumtrig);
        end
        %Affichage
            if isempty(msg), msg = ''; end
            lgmsg = length(msg);
            if isfield(handles.Dmeg{1},'CRC') && ...
                    isfield(handles.Dmeg{1}.CRC,'goodevents') && ...
                        size(handles.Dmeg{1}.CRC.goodevents,2)>=indextrig(jj)&& ...
                            handles.Dmeg{1}.CRC.goodevents(indextrig(jj))==0
                b=[0.8 0.2 0.2];
            else
                b = 'k';
            end
            text(int(jj)-(0.4*lgmsg/(lgmsg+1))*handles.winsize/20, ...
                2.1*handles.scale/50*NbreChandisp,msg,'Color',b);
    end
end
return

%--------------------------------------------------------------------------
%-------------------------- SUBFUNCTIONS ----------------------------------
%--------------------------------------------------------------------------


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function filterlowhigh(plt,ii,handles,frqcut,scale)

if nargin<4
    flc = handles.filter.other(1)/(fsample(handles.Dmeg{ii})/2);
    fhc = handles.filter.other(2)/(fsample(handles.Dmeg{ii})/2);
    if fsample(handles.Dmeg{ii})>1500
        forder = 1;
    else
        forder = 3;
    end
    [B,A] = butter(forder,[flc,fhc],'pass');
else
    B = frqcut(1,:);
    A = frqcut(2,:);
end

X = get(plt,'YData');
% Apply Butterworth filter
Y = filtfilt(B,A,X);
set(plt,'YData',Y+scale - mean(Y))%,'Color',Col{ii})

return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Y = filterforspect(handles,X,frqcut,ii)
if fsample(handles.Dmeg{ii})>1500
    forder = 1;
else
    forder = 3;
end
[B,A] = butter(forder,[frqcut(1)/(fsample(handles.Dmeg{ii})/2),...
    frqcut(2)/(fsample(handles.Dmeg{ii})/2)],'pass');

% Apply Butterworth filter
Y = filtfilt(B,A,X);

return
%%%%%%%%%%%%%%%%%%%%%%%

function cleargraph(figure,axnum)

if nargin<2
    prop    =   'Type';
    compr   =   'axes';
else
    prop    =   'Tag';
    compr   =   axnum;
end

A       =   get(figure,'Children');
idx     =   find(strcmp(get(A,prop),compr)==1);
delete(get(A(idx),'Children'))

