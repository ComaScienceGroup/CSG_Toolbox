function varargout = csg_dis_selchan(varargin)
% CSG_DIS_SELCHAN M-file for csg_dis_selchan.fig
%      CSG_DIS_SELCHAN, by itself, creates a new CSG_DIS_SELCHAN or raises the existing
%      singleton*.
%
%      H = CSG_DIS_SELCHAN returns the handle to a new CSG_DIS_SELCHAN or the handle to
%      the existing singleton*.
%
%      CSG_DIS_SELCHAN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CSG_DIS_SELCHAN.M with the given input arguments.
%
%      CSG_DIS_SELCHAN('Property','Value',...) creates a new CSG_DIS_SELCHAN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dis_selchan_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to csg_dis_selchan_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
%__________________________________________________________________
% Copyright (C) 

% Written by 
% $Id$

% Edit the above text to modify the response to help csg_dis_selchan

% Last Modified by GUIDE v2.5 10-May-2017 10:02:39

% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @csg_dis_selchan_OpeningFcn, ...
    'gui_OutputFcn',  @csg_dis_selchan_OutputFcn, ...
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


% --- Executes just before csg_dis_selchan is made visible.
function csg_dis_selchan_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to csg_dis_selchan (see VARARGIN)
% Choose default command line output for csg_dis_selchan
set(0,'CurrentFigure',handles.figure1);
handles.output = hObject;

load CSG_electrodes.mat;
handles.names     = names;
handles.pos       = pos';
handles.crc_types = crc_types;

if isempty(varargin) || ~isfield(varargin{1},'file')
    % Filter for vhdr, mat and edf files
    prefile = spm_select(1, 'any', 'Select imported EEG file','' ...
        ,pwd,'\.[mMvVeErR][dDhHaA][fFDdTtwW]');
    for i=1:size(prefile,1)
        D{i} = crc_eeg_load(deblank(prefile(i,:)));
        file = fullfile(D{i}.path,D{i}.fname);
        handles.file{i} = file;
        handles.chan{i} = upper(chanlabels(D{i}));
        if isfield(D{i}, 'info')
            try
                D{i}.info.date;
            catch
                D{i}.info.date = [1 1 1];
            end
            try
                D{i}.info.hour;
            catch
                D{i}.info.hour = [0 0 0];
            end
        else
            D{i}.info = struct('date',[1 1 1],'hour',[0 0 0]);
        end
        handles.Dmeg{i} = D{i};
        handles.Struct(i) = struct(D{i});
        handles.date{i} = zeros(1,2);
        handles.date{i}(1) = datenum([D{i}.info.date D{i}.info.hour]);
        handles.date{i}(2) = handles.date{i}(1) + ...
                        datenum([ 0 0 0 crc_time_converts(nsamples(D{i})/ ...
                                                            fsample(D{i}))] );
        handles.dates(i,:) = handles.date{i}(:);
    end
    cleargraph(handles)
else
    handles.file = varargin{1}.file;
    index = varargin{1}.index;
    for i=1:size(varargin{1}.Dmeg,2)
%         handles.Dmeg{i} = crc_eeg_load([path(varargin{1}.Dmeg{i}),filesep,fname(varargin{1}.Dmeg{i})]);
        handles.Dmeg{i} = varargin{1}.Dmeg{i};
    end
    if isempty(index)
        index=1:nchannels(handles.Dmeg{1});
    end
    set(handles.list_selected,'String',upper(chanlabels(handles.Dmeg{1},varargin{1}.index)));
    diff = setdiff(upper(chanlabels(handles.Dmeg{1})),upper(chanlabels(handles.Dmeg{1},varargin{1}.index)));
    set(handles.list_available,'String',diff);
    [dumb1,dumb2,index2]=intersect(upper(chanlabels(handles.Dmeg{1},varargin{1}.index)),upper(handles.names));

    idxred=index2(find(handles.crc_types(index2)<-1));
    idxblue=index2(find(handles.crc_types(index2)>-2));

    xred=handles.pos(1,idxred);
    yred=handles.pos(2,idxred);

    xblu=handles.pos(1,idxblue);
    yblu=handles.pos(2,idxblue);

    cleargraph(handles)
    hold on
    plot(xred,yred,'r+'), plot(xblu,yblu,'b+')
    hold off
    if and(length(xblu)==0,length(xred)==0)
        cleargraph(handles)
    end

    xlim([0 1])
    ylim([0 1])
    handles.chan{1}=get(handles.list_selected,'String');
end

if ~isempty(varargin) && isfield(varargin{1},'delmap')
    handles.delmap=varargin{1}.delmap;
end

if (~isempty(varargin) && isfield(varargin{1},'multcomp') && varargin{1}.multcomp) || ...
        isempty(varargin)
    chanset=handles.chan{1};
    set(handles.list_available,'String',chanset);
    handles.chan=chanset;
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes csg_dis_selchan wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = csg_dis_selchan_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in list_selected.
function list_selected_Callback(hObject, eventdata, handles)
% hObject    handle to list_selected (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns list_selected contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_selected
contents = get(hObject,'String');
if isempty(contents)
else
    %Remove the "activated" item from the list "Available Channels"
    [dumb1,dumb2,index]=intersect(contents{get(hObject,'Value')},contents);
    temp=[contents(1:index-1) ; contents(index+1:length(contents))];
    set(handles.list_selected,'String',temp);

    [dumb1,dumb2,index2]=intersect(upper(temp),upper(handles.names));

    idxred=index2(find(handles.crc_types(index2)<-1));
    idxblue=index2(find(handles.crc_types(index2)>-2));

    xred=handles.pos(1,idxred);
    yred=handles.pos(2,idxred);

    xblu=handles.pos(1,idxblue);
    yblu=handles.pos(2,idxblue);

    cleargraph(handles)
    hold on
    plot(xred,yred,'r+'), plot(xblu,yblu,'b+')
    hold off
    if and(length(xblu)==0,length(xred)==0)
        cleargraph(handles)
    end

    xlim([0 1])
    ylim([0 1])

    set(handles.Localizer,'XTick',[]);
    set(handles.Localizer,'YTick',[]);

    %Add the "activated" in the list "Selected Channels"
    if length(get(handles.list_available,'String'))==0
        temp={contents{get(hObject,'Value')}};
    else
        temp=[contents{get(hObject,'Value')} ; get(handles.list_available,'String')];
    end
    set(handles.list_available,'String',temp);

    %Prevent crashing if the first/last item of the list is selected.
    set(handles.list_selected,'Value',max(index-1,1));
    set(handles.list_available,'Value',1);

    %if multiple comparison, no more than one channel
    contents=get(handles.list_selected,'String');
    if isfield(handles,'multcomp') && (handles.multcomp && length(contents)>1 || isempty(contents))
        set(handles.PLOT,'enable','off');
        set(handles.PLOT,'ForegroundColor',[1 0 0]);
        beep
        disp('Select only one channel for multiple files comparison')
    elseif isfield(handles,'multcomp') && (handles.multcomp && length(contents)==1)
        set(handles.PLOT,'enable','on');
        set(handles.PLOT,'ForegroundColor',[0 0 0]);
    end
end
% Indicate this selection doesn't come from an selection uploaded
set(handles.Save,'Value',0);
set(handles.load,'Value',0);
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function list_selected_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_selected (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in list_available.
function list_available_Callback(hObject, eventdata, handles)
% hObject    handle to list_available (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

contents = get(hObject,'String');
if length(contents)==0
else
    %Remove the "activated" item from the list "Available Channels"
    [dumb1,dumb2,index]=intersect(contents{get(hObject,'Value')},contents);
    temp=[contents(1:index-1) ; contents(index+1:length(contents))];
    set(handles.list_available,'String',temp);

    %Add the "activated" in the list "Selected Channels"
    if length(get(handles.list_selected,'String'))==0
        temp={contents{get(hObject,'Value')}};
    else
        temp=[contents{get(hObject,'Value')} ; get(handles.list_selected,'String')];
    end
    set(handles.list_selected,'String',temp);

    %Prevent crashing if the first/last item of the list is selected.
    set(handles.list_available,'Value',max(index-1,1));
    set(handles.list_selected,'Value',1);

    [dumb1,dumb2,index]=intersect(upper(temp),upper(handles.names));

    idxred=index(find(handles.crc_types(index)<-1));
    idxblue=index(find(handles.crc_types(index)>-2));

    xred=handles.pos(1,idxred);
    yred=handles.pos(2,idxred);

    xblu=handles.pos(1,idxblue);
    yblu=handles.pos(2,idxblue);

    cleargraph(handles)
    hold on
    plot(xred,yred,'r+'), plot(xblu,yblu,'b+')
    hold off
    if and(length(xblu)==0,length(xred)==0)
        cleargraph(handles)
    end

    xlim([0 1])
    ylim([0 1])

    set(handles.Localizer,'XTick',[]);
    set(handles.Localizer,'YTick',[]);

    %if multiple comparison, no more than one channel
    contents=get(handles.list_selected,'String');
    if isfield(handles,'multcomp') && (handles.multcomp && length(contents)>1 || isempty(contents))
        set(handles.PLOT,'enable','off');
        set(handles.PLOT,'ForegroundColor',[1 0 0]);
        beep
        disp('Select only one channel for multiple files comparison')
    elseif isfield(handles,'multcomp') && (handles.multcomp && length(contents)==1)
        set(handles.PLOT,'enable','on');
        set(handles.PLOT,'ForegroundColor',[0 0 0]);
    end
end
% Indicate this selection doesn't come from an selection uploaded
set(handles.Save,'Value',0);
set(handles.load,'Value',0);
% Update handles structure
guidata(hObject, handles);

% Hints: contents = get(hObject,'String') returns list_available contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_available

% --- Executes during object creation, after setting all properties.
function list_available_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_available (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in Selectall.
function Selectall_Callback(hObject, eventdata, handles)
% hObject    handle to Selectall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.list_selected,'String',upper(chanlabels(handles.Dmeg{1})));
set(handles.list_available,'String',cell(0));

[dumb1,dumb2,index]=intersect(upper(chanlabels(handles.Dmeg{1})),upper(handles.names));

idxred=index(find(handles.crc_types(index)<-1));
idxblue=index(handles.crc_types(index)>-2);

xred=handles.pos(1,idxred);
yred=handles.pos(2,idxred);

xblu=handles.pos(1,idxblue);
yblu=handles.pos(2,idxblue);

cleargraph(handles)
hold on
plot(xred,yred,'r+'), plot(xblu,yblu,'b+')
hold off
if and(length(xblu)==0,length(xred)==0)
    cleargraph(handles)
end

xlim([0 1])
ylim([0 1])

set(handles.Localizer,'XTick',[]);
set(handles.Localizer,'YTick',[]);

% Indicate this selection doesn't come from an selection uploaded
set(handles.Save,'Value',0);
set(handles.load,'Value',0);
% Update handles structure
guidata(hObject, handles);


% Hint: get(hObject,'Value') returns toggle state of fctother
% --- Executes on button press in desall.
function desall_Callback(hObject, eventdata, handles)
% hObject    handle to desall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.list_available,'String',upper(chanlabels(handles.Dmeg{1})));
set(handles.list_selected,'String',cell(0));
cleargraph(handles)
xlim([0 1])
ylim([0 1])
set(handles.Localizer,'XTick',[]);
set(handles.Localizer,'YTick',[]);
% Indicate this selection doesn't come from an selection uploaded
set(handles.Save,'Value',0);
set(handles.load,'Value',0);
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in PLOT
function PLOT_Callback(hObject, eventdata, handles)
% hObject    handle to PLOT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

contents=get(handles.list_selected,'String');
   
if isfield(handles,'multcomp') && (handles.multcomp && length(contents)>1 || isempty(contents))%no more than one channel if multiple file comparison
    beep
    disp('Select only one channel for multiple files comparison')
    return
elseif ~isfield(handles,'multcomp') || ~handles.multcomp
    [dumb1,index]=intersect(upper(chanlabels(handles.Dmeg{1})),upper(get(handles.list_selected,'String')));
    try
        flags.index=sortch(handles.Dmeg{1},index);
    catch
        flags.index=fliplr(sort(index));
    end
else
    flags.dates=handles.dates;
    flags.chanset=handles.chan;
    [dumb1,index]=intersect(upper(handles.chan),upper(get(handles.list_selected,'String')));
    flags.index=index;
    flags.multcomp=1;
end
flags.Dmeg=handles.Dmeg;
flags.file=handles.file;
if isfield(handles,'delmap')
    flags.delmap=handles.delmap;
end
csg_dis_main(flags);
delete(handles.figure1)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% SORT CHANNEL FX
function idx=sortch(d,index)

% Find the EOG channels
EOGchan = eogchannels(d);
% A = strfind(upper(chanlabels(d,index)),'EOG');
% EOGchan = [];
% for i=1:length(A);
%     if A{i}>0
%         EOGchan=[EOGchan index(i)];
%     end
% end

% Find the ECG channels
ECGchan = ecgchannels(d);
% A=strfind(upper(chanlabels(d,index)),'ECG');
% ECGchan=[];
% for i=1:length(A);
%     if A{i}>0
%         ECGchan=[ECGchan index(i)];
%     end
% end

% Find the EMG channels
EMGchan = emgchannels(d);
% A=strfind(upper(chanlabels(d,index)),'EMG');
% EMGchan=[];
% for i=1:length(A);
%     if A{i}>0
%         EMGchan=[EMGchan index(i)];
%     end
% end

% Find the M/EEG channels
EEGchan = meegchannels(d);
% A=strfind(upper(chantype(d,index)),'EEG');
% EEGchan=[];
% for i=1:length(A);
%     if A{i}>0
%         EEGchan=[EEGchan index(i)];
%     end
% end

allbad = [EOGchan ECGchan EMGchan EEGchan];
other  = setdiff(index,allbad);

otherknown    = [];
othernotknown = [];
chanstr = chantype(d);
for ff = other
    if ~strcmpi(chanstr,'Other')
        othernotknown = [othernotknown ff];
    else
        otherknown = [otherknown ff];
    end
end
other = [otherknown othernotknown];

allbad = [EOGchan ECGchan EMGchan other];
eeg = setdiff(index,allbad);

AFrontal  = intersect(find(strncmp(chanlabels(d),'AF',2) ==1),eeg);
Frontal   = intersect(find(strncmp(chanlabels(d),'F',1) ==1),eeg);
Coronal   = intersect(find(strncmp(chanlabels(d),'C',1) ==1),eeg);
Temporal  = intersect(find(strncmp(chanlabels(d),'T',1) ==1),eeg);
Parietal  = intersect(find(strncmp(chanlabels(d),'P',1) ==1),eeg);
Occipital = intersect(find(strncmp(chanlabels(d),'O',1) ==1),eeg);

neweeg = [Occipital Parietal Temporal Coronal Frontal AFrontal];
eeg2 = setdiff(eeg,neweeg);

eeg = [eeg2 neweeg];

idx = [otherknown othernotknown ECGchan EMGchan EOGchan eeg];


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


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



% --- Executes on button press in Saveselection.
function Saveselection_Callback(hObject, eventdata, handles)
% hObject    handle to Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Saveselection
S = get(handles.Save,'Value');
[filename, pathname] = uiputfile('.txt','Save the Selection');
file = fopen(fullfile(pathname, filename), 'w');              % 'w' write
data = get(handles.list_selected,'String');
%write the data in file .txt
%data = {'bonjour' 'dorothe'}
for i = 1 : length(data)
    count = fwrite(file, [data{i} ' '],'char');
    if count ~= length(data{i})+1
        beep
        fprintf('There is an error, we can''t save this selection... Try again')
        i = length(data);
    end 
end
fprintf(['This selection is saved under the name:', char(filename)]);
fclose(file);

% --- Executes on button press in loadselection.
function loadselection_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of loadselection

[filename, pathname] = uigetfile('.txt','Open the Selection');
namefile = fullfile(pathname,filename);
fid = fopen (namefile,'r');
file = fread(fid,'uint8=>char')';
fclose(fid);
i = 1;
Selection = cell(0);
while i<length(file)
    init = i;
    while ~strcmpi(file(i),' ') && i<length(file)      
        i=i+1;
    end 
    Selection = [Selection file(init : i-1)];
    i=i+1;   
end
YET = get(handles.list_selected,'String');
if ~isempty(YET) 
    Sel = setdiff(YET,Selection);
    if ~isempty(Sel)
        Selection = [Sel'; Selection'];
    end
end
set(handles.list_selected,'String',Selection);
%list_selected all the channels there are in the file
contents = upper(chanlabels(handles.Dmeg{1}));
[dumb1,index,dumb2]=intersect(contents,Selection);

%Remove channels concerned by the Selection
DES = get(handles.list_available,'String');
temp = setdiff(DES,Selection);
set(handles.list_available,'String',temp);
%To avoid warning
set(handles.list_selected,'Value',1);
set(handles.list_available,'Value',1);
[dumb1,dumb2,index2]=intersect(upper(Selection),upper(handles.names));
%Indicate the placement of the electrodes selected
idxred=index2(find(handles.crc_types(index2)<-1));
idxblue=index2(find(handles.crc_types(index2)>-2));

xred=handles.pos(1,idxred);
yred=handles.pos(2,idxred);

xblu=handles.pos(1,idxblue);
yblu=handles.pos(2,idxblue);

cleargraph(handles)
hold on
plot(xred,yred,'r+'), plot(xblu,yblu,'b+')
hold off
if and(length(xblu)==0,length(xred)==0)
    cleargraph(handles)
end

xlim([0 1])
ylim([0 1])

set(handles.Localizer,'XTick',[]);
set(handles.Localizer,'YTick',[]);

set(handles.load,'Value',0)


% --- Executes on button press in backmain.
function backmain_Callback(hObject, eventdata, handles)
% hObject    handle to backmain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.figure1)
csg_menu


%%%%%%%%%%%%%%%
function cleargraph(handles)

A=get(handles.figure1,'Children');
idx=find(strcmp(get(A,'Type'),'axes')==1);
try
    delete(get(A(idx),'Children'))
end