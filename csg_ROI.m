function varargout = csg_ROI(varargin)
% CSG_ROI MATLAB code for csg_ROI.fig
%      CSG_ROI, by itself, creates a new CSG_ROI or raises the existing
%      singleton*.
%
%      H = CSG_ROI returns the handle to a new CSG_ROI or the handle to
%      the existing singleton*.
%
%      CSG_ROI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CSG_ROI.M with the given input arguments.
%
%      CSG_ROI('Property','Value',...) creates a new CSG_ROI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before csg_ROI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to csg_ROI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help csg_ROI

% Last Modified by GUIDE v2.5 19-May-2017 15:16:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @csg_ROI_OpeningFcn, ...
                   'gui_OutputFcn',  @csg_ROI_OutputFcn, ...
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


% --- Executes just before csg_ROI is made visible.
function csg_ROI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to csg_ROI (see VARARGIN)

% Choose default command line output for csg_ROI
handles.output = hObject;
set(0,'CurrentFigure',handles.figure1);

load CSG_electrodes.mat;
handles.names     = names;
handles.pos       = pos';
handles.crc_types = crc_types;

% Filter for vhdr, mat and edf files
prefile = spm_select(1, 'any', 'Select imported EEG file','' ...
    ,pwd,'\.[mMvVeErR][dDhHaA][fFDdTtwW]');
for i=1:size(prefile,1)
    D{i} = crc_eeg_load(deblank(prefile(i,:)));
    file = fullfile(D{i}.path,D{i}.fname);
    handles.file{i} = file;
    handles.chan{i} = upper(chanlabels(D{i}));
    handles.Dmeg{i} = D{i};
    handles.Struct(i) = struct(D{i});
end
% color
handles.color(1,:) = get(handles.roi1,'ForegroundColor');
handles.color(2,:) = get(handles.roi2,'ForegroundColor');
handles.color(3,:) = get(handles.roi3,'ForegroundColor');
handles.color(4,:) = get(handles.roi4,'ForegroundColor');
handles.color(5,:) = get(handles.roi5,'ForegroundColor');
handles.color(6,:) = get(handles.roi6,'ForegroundColor');
handles.color(7,:) = get(handles.roi7,'ForegroundColor');
handles.color(8,:) = get(handles.roi8,'ForegroundColor');
handles.color(9,:) = get(handles.roi9,'ForegroundColor');
handles.color(10,:) = get(handles.roi10,'ForegroundColor');

% graph
[dumb1,dumb2,index]=intersect(upper(chanlabels(handles.Dmeg{1})),upper(handles.names));

idxblue =   index(handles.crc_types(index)>-2);

xblu    =   handles.pos(1,idxblue);
yblu    =   handles.pos(2,idxblue);

cleargraph(handles)
hold on
plot(xblu,yblu,'+','color',[0.8 0.8 0.8])
hold off

xlim([0 1])
ylim([0 1])
box('on')

set(handles.axes1,'XTick',[]);
set(handles.axes1,'YTick',[]);

handles.index = idxblue;

% list available
handles.chanav = upper(chanlabels(handles.Dmeg{1}));
set(handles.available,'String',handles.chanav,'Enable','off');

% initialization 
handles.inroi1 = {};
handles.inroi2 = {};
handles.inroi3 = {};
handles.inroi4 = {};
handles.inroi5 = {};
handles.inroi6 = {};
handles.inroi7 = {};
handles.inroi8 = {};
handles.inroi9 = {};
handles.inroi10 = {};

% setup axes
% set(handles.axes1,'HitTest','off')
% set(gcf,'WindowButtonDownFcn',@click_Callback)
%set(handles.axes1,'ButtonDownFcn',@click)
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes csg_ROI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = csg_ROI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
 
handles.NROI = str2double(get(hObject,'String'));
if isnan(handles.NROI)
    % if error, put a value by default
    set(handles.edit1,'String',4)    
end

x    =   handles.pos(1,handles.index);
y    =   handles.pos(2,handles.index);

cleargraph(handles)
hold on
plot(xblu,yblu,'b+')
hold off

xlim([0 1])
ylim([0 1])
box('on')

set(handles.axes1,'XTick',[]);
set(handles.axes1,'YTick',[]);


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


% --- Executes on button press in roi1.
function roi1_Callback(hObject, eventdata, handles)
% hObject    handle to roi1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of roi1
if get(hObject,'Value')
    set(handles.roi2,'Value',0);
    set(handles.roi3,'Value',0);
    set(handles.roi4,'Value',0);
    set(handles.roi5,'Value',0);
    set(handles.roi6,'Value',0);
    set(handles.roi7,'Value',0);
    set(handles.roi8,'Value',0);
    set(handles.roi9,'Value',0);
    set(handles.roi10,'Value',0);
    set(handles.available,'enable','on');
    set(handles.listroi,'String',handles.inroi1);
    set(handles.inroi,'String','ROI 1');
    set(handles.available,'enable','on');
else 
    set(handles.inroi,'String','in ROI');
    set(handles.listroi,'String',{});
    set(handles.available,'enable','off');
end

% --- Executes on button press in roi2.
function roi2_Callback(hObject, eventdata, handles)
% hObject    handle to roi2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of roi2
if get(hObject,'Value')
    set(handles.roi1,'Value',0);
    set(handles.roi3,'Value',0);
    set(handles.roi4,'Value',0);
    set(handles.roi5,'Value',0);
    set(handles.roi6,'Value',0);
    set(handles.roi7,'Value',0);
    set(handles.roi8,'Value',0);
    set(handles.roi9,'Value',0);
    set(handles.roi10,'Value',0);
    set(handles.available,'enable','on');
    set(handles.listroi,'String',handles.inroi2);
    set(handles.inroi,'String','ROI 2');
    set(handles.available,'enable','on');
else 
    set(handles.inroi,'String','in ROI');
    set(handles.listroi,'String',{});
    set(handles.available,'enable','off');
end

% --- Executes on button press in roi3.
function roi3_Callback(hObject, eventdata, handles)
% hObject    handle to roi3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of roi3
if get(hObject,'Value')
    set(handles.roi1,'Value',0);
    set(handles.roi2,'Value',0);
    set(handles.roi4,'Value',0);
    set(handles.roi5,'Value',0);
    set(handles.roi6,'Value',0);
    set(handles.roi7,'Value',0);
    set(handles.roi8,'Value',0);
    set(handles.roi9,'Value',0);
    set(handles.roi10,'Value',0);
    set(handles.available,'enable','on');
    set(handles.listroi,'String',handles.inroi3);
    set(handles.inroi,'String','ROI 3');
    set(handles.available,'enable','on');
else 
    set(handles.inroi,'String','in ROI');
    set(handles.listroi,'String',{});
    set(handles.available,'enable','off');
end

% --- Executes on button press in roi4.
function roi4_Callback(hObject, eventdata, handles)
% hObject    handle to roi4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of roi4
if get(hObject,'Value')
    set(handles.roi1,'Value',0);
    set(handles.roi2,'Value',0);
    set(handles.roi3,'Value',0);
    set(handles.roi5,'Value',0);
    set(handles.roi6,'Value',0);
    set(handles.roi7,'Value',0);
    set(handles.roi8,'Value',0);
    set(handles.roi9,'Value',0);
    set(handles.roi10,'Value',0);
    set(handles.available,'enable','on');
    set(handles.listroi,'String',handles.inroi4);
    set(handles.inroi,'String','ROI 4');
    set(handles.available,'enable','on');
else 
    set(handles.inroi,'String','in ROI');
    set(handles.listroi,'String',{});
    set(handles.available,'enable','off');
end

% --- Executes on button press in roi5.
function roi5_Callback(hObject, eventdata, handles)
% hObject    handle to roi5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of roi5
if get(hObject,'Value')
    set(handles.roi1,'Value',0);
    set(handles.roi2,'Value',0);
    set(handles.roi3,'Value',0);
    set(handles.roi4,'Value',0);
    set(handles.roi6,'Value',0);
    set(handles.roi7,'Value',0);
    set(handles.roi8,'Value',0);
    set(handles.roi9,'Value',0);    
    set(handles.roi10,'Value',0);
    set(handles.available,'enable','on');
    set(handles.listroi,'String',handles.inroi5);
    set(handles.inroi,'String','ROI 5');
    set(handles.available,'enable','on');
else 
    set(handles.inroi,'String','in ROI');
    set(handles.listroi,'String',{});
    set(handles.available,'enable','off');
end

% --- Executes on button press in roi6.
function roi6_Callback(hObject, eventdata, handles)
% hObject    handle to roi6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of roi6
if get(hObject,'Value')
    set(handles.roi1,'Value',0);
    set(handles.roi2,'Value',0);
    set(handles.roi3,'Value',0);
    set(handles.roi4,'Value',0);
    set(handles.roi5,'Value',0);
    set(handles.roi7,'Value',0);
    set(handles.roi8,'Value',0);
    set(handles.roi9,'Value',0);    
    set(handles.roi10,'Value',0);
    set(handles.available,'enable','on');
    set(handles.listroi,'String',handles.inroi6);
    set(handles.inroi,'String','ROI 6');
    set(handles.available,'enable','on');
else 
    set(handles.inroi,'String','in ROI');
    set(handles.available,'enable','off');
    set(handles.listroi,'String',{});
end

% --- Executes on button press in roi7.
function roi7_Callback(hObject, eventdata, handles)
% hObject    handle to roi7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of roi7
if get(hObject,'Value')
    set(handles.roi1,'Value',0);
    set(handles.roi2,'Value',0);
    set(handles.roi3,'Value',0);
    set(handles.roi4,'Value',0);
    set(handles.roi5,'Value',0);
    set(handles.roi6,'Value',0);
    set(handles.roi8,'Value',0);
    set(handles.roi9,'Value',0);    
    set(handles.roi10,'Value',0);
    set(handles.available,'enable','on');
    set(handles.listroi,'String',handles.inroi7);
    set(handles.inroi,'String','ROI 7');
    set(handles.available,'enable','on');
else 
    set(handles.inroi,'String','in ROI');
    set(handles.listroi,'String',{});
    set(handles.available,'enable','off');
end

% --- Executes on button press in roi8.
function roi8_Callback(hObject, eventdata, handles)
% hObject    handle to roi8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of roi8
if get(hObject,'Value')
    set(handles.roi1,'Value',0);
    set(handles.roi2,'Value',0);
    set(handles.roi3,'Value',0);
    set(handles.roi4,'Value',0);
    set(handles.roi5,'Value',0);
    set(handles.roi6,'Value',0);
    set(handles.roi7,'Value',0);
    set(handles.roi9,'Value',0);
    set(handles.roi10,'Value',0);
    set(handles.available,'enable','on');
    set(handles.listroi,'String',handles.inroi8);
    set(handles.inroi,'String','ROI 8');
    set(handles.available,'enable','on');
else 
    set(handles.inroi,'String','in ROI');
    set(handles.listroi,'String',{});
    set(handles.available,'enable','off');
end

% --- Executes on button press in roi9.
function roi9_Callback(hObject, eventdata, handles)
% hObject    handle to roi9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of roi9
if get(hObject,'Value')
    set(handles.roi1,'Value',0);
    set(handles.roi2,'Value',0);
    set(handles.roi3,'Value',0);
    set(handles.roi4,'Value',0);
    set(handles.roi5,'Value',0);
    set(handles.roi6,'Value',0);
    set(handles.roi7,'Value',0);
    set(handles.roi8,'Value',0);
    set(handles.roi10,'Value',0);
    set(handles.available,'enable','on');
    set(handles.listroi,'String',handles.inroi9);
    set(handles.inroi,'String','ROI 9');
    set(handles.available,'enable','on');
else 
    set(handles.inroi,'String','in ROI');
    set(handles.listroi,'String',{});
    set(handles.available,'enable','off');
end

% --- Executes on button press in roi10.
function roi10_Callback(hObject, eventdata, handles)
% hObject    handle to roi10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of roi10
if get(hObject,'Value')
    set(handles.roi1,'Value',0);
    set(handles.roi2,'Value',0);
    set(handles.roi3,'Value',0);
    set(handles.roi4,'Value',0);
    set(handles.roi5,'Value',0);
    set(handles.roi6,'Value',0);
    set(handles.roi7,'Value',0);
    set(handles.roi8,'Value',0);
    set(handles.roi9,'Value',0);
    set(handles.available,'enable','on');
    set(handles.listroi,'String',handles.inroi10);
    set(handles.inroi,'String','ROI 10');
    set(handles.available,'enable','on');
else 
    set(handles.inroi,'String','in ROI');
    set(handles.listroi,'String',{});
    set(handles.available,'enable','off');
end

% --- Executes on selection change in available.
function available_Callback(hObject, eventdata, handles)
% hObject    handle to available (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns available contents as cell array
%        contents{get(hObject,'Value')} returns selected item from available

contents = cellstr(get(hObject,'String'));
sel = contents{get(hObject,'Value')};
available = get(handles.available,'String');
idx = ~strcmp(available,sel);
set(handles.available,'String',available(idx),'Value',min(find(~idx),numel(available)-1))
if get(handles.roi1,'Value')
    [dum goodorder dum] = intersect(handles.chanav,union(handles.inroi1,sel));
    handles.inroi1      = handles.chanav(sort(goodorder));
    set(handles.listroi,'String',handles.inroi1,'Value',numel(handles.inroi1));
elseif get(handles.roi2,'Value')
    [dum goodorder dum] = intersect(handles.chanav,union(handles.inroi2,sel));
    handles.inroi2      = handles.chanav(sort(goodorder));
    set(handles.listroi,'String',handles.inroi2,'Value',numel(handles.inroi2));
elseif get(handles.roi3,'Value')
    [dum goodorder dum] = intersect(handles.chanav,union(handles.inroi3,sel));
    handles.inroi3      = handles.chanav(sort(goodorder));
    set(handles.listroi,'String',handles.inroi3,'Value',numel(handles.inroi3));
elseif get(handles.roi4,'Value')
    [dum goodorder dum] = intersect(handles.chanav,union(handles.inroi4,sel));
    handles.inroi4      = handles.chanav(sort(goodorder));
    set(handles.listroi,'String',handles.inroi4,'Value',numel(handles.inroi4));
elseif get(handles.roi5,'Value')
    [dum goodorder dum] = intersect(handles.chanav,union(handles.inroi5,sel));
    handles.inroi5      = handles.chanav(sort(goodorder));
    set(handles.listroi,'String',handles.inroi5,'Value',numel(handles.inroi5));
elseif get(handles.roi6,'Value')
    [dum goodorder dum] = intersect(handles.chanav,union(handles.inroi6,sel));
    handles.inroi6      = handles.chanav(sort(goodorder));
    set(handles.listroi,'String',handles.inroi6,'Value',numel(handles.inroi6));
elseif get(handles.roi7,'Value')
    [dum goodorder dum] = intersect(handles.chanav,union(handles.inroi7,sel));
    handles.inroi7      = handles.chanav(sort(goodorder));
    set(handles.listroi,'String',handles.inroi7,'Value',numel(handles.inroi7));
elseif get(handles.roi8,'Value')
    [dum goodorder dum] = intersect(handles.chanav,union(handles.inroi8,sel));
    handles.inroi8      = handles.chanav(sort(goodorder));
    set(handles.listroi,'String',handles.inroi8,'Value',numel(handles.inroi8));
elseif get(handles.roi9,'Value')
    [dum goodorder dum] = intersect(handles.chanav,union(handles.inroi9,sel));
    handles.inroi9      = handles.chanav(sort(goodorder));
    set(handles.listroi,'String',handles.inroi9,'Value',numel(handles.inroi9));
elseif get(handles.roi10,'Value')
    [dum goodorder dum] = intersect(handles.chanav,union(handles.inroi10,sel));
    handles.inroi10      = handles.chanav(sort(goodorder));
    set(handles.listroi,'String',handles.inroi10,'Value',numel(handles.inroi10));
end
graph(handles)
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function available_CreateFcn(hObject, eventdata, handles)
% hObject    handle to available (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listroi.
function listroi_Callback(hObject, eventdata, handles)
% hObject    handle to listroi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listroi contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listroi

contents    = cellstr(get(hObject,'String'));
sel         = contents{get(hObject,'Value')}; 
[dum goodorder dum] = intersect(handles.chanav, setdiff(contents,sel));
newcontent  = handles.chanav(sort(goodorder));
available   = get(handles.available,'String');
[dum goodorder dum]  = intersect(handles.chanav,union(available,sel));
newavail = handles.chanav(sort(goodorder));
Name = get(handles.inroi,'String');
switch Name
    case 'ROI 1'
        handles.inroi1  =  newcontent;
    case 'ROI 2'
        handles.inroi2  =  newcontent;
    case 'ROI 3'
        handles.inroi3  =  newcontent;
    case 'ROI 4'
        handles.inroi4  =  newcontent;
    case 'ROI 5'
        handles.inroi5  =  newcontent;
    case 'ROI 6'
        handles.inroi6  =  newcontent;
    case 'ROI 7'
        handles.inroi7  =  newcontent;
    case 'ROI 8'
        handles.inroi8  =  newcontent;
    case 'ROI 9'
        handles.inroi9  =  newcontent;
    case 'ROI 10'
        handles.inroi10  =  newcontent;
end
set(handles.listroi,'String',newcontent,'Value',min(numel(newcontent),get(hObject,'Value')));
set(handles.available,'String',newavail,'Value',numel(newavail));
graph(handles)
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function listroi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listroi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% subfunction 

%%%%%%%%%%%%%%%

function graph(handles)

% roi 1
[dump1 dump2 indexroi1] = intersect(handles.inroi1,upper(handles.names));
[dump1 dump2 indexroi2] = intersect(handles.inroi2,upper(handles.names));
[dump1 dump2 indexroi3] = intersect(handles.inroi3,upper(handles.names));
[dump1 dump2 indexroi4] = intersect(handles.inroi4,upper(handles.names));
[dump1 dump2 indexroi5] = intersect(handles.inroi5,upper(handles.names));
[dump1 dump2 indexroi6] = intersect(handles.inroi6,upper(handles.names));
[dump1 dump2 indexroi7] = intersect(handles.inroi7,upper(handles.names));
[dump1 dump2 indexroi8] = intersect(handles.inroi8,upper(handles.names));
[dump1 dump2 indexroi9] = intersect(handles.inroi9,upper(handles.names));
[dump1 dump2 indexroi10] = intersect(handles.inroi10,upper(handles.names));

x{1}    =   handles.pos(1,indexroi1);
y{1}    =   handles.pos(2,indexroi1);
x{2}    =   handles.pos(1,indexroi2);
y{2}    =   handles.pos(2,indexroi2);
x{3}    =   handles.pos(1,indexroi3);
y{3}    =   handles.pos(2,indexroi3);
x{4}    =   handles.pos(1,indexroi4);
y{4}    =   handles.pos(2,indexroi4);
x{5}    =   handles.pos(1,indexroi5);
y{5}    =   handles.pos(2,indexroi5);
x{6}    =   handles.pos(1,indexroi6);
y{6}    =   handles.pos(2,indexroi6);
x{7}    =   handles.pos(1,indexroi7);
y{7}    =   handles.pos(2,indexroi7);
x{8}    =   handles.pos(1,indexroi8);
y{8}    =   handles.pos(2,indexroi8);
x{9}    =   handles.pos(1,indexroi9);
y{9}    =   handles.pos(2,indexroi9);
x{10}   =   handles.pos(1,indexroi10);
y{10}   =   handles.pos(2,indexroi10);

cleargraph(handles)
x{11}    =   handles.pos(1,handles.index);
y{11}    =   handles.pos(2,handles.index);

hold on
plot(x{11},y{11},'+','color',[0.8 0.8 0.8])
for i = 1 : 10
    plot(x{i},y{i},'+','color',handles.color(i,:),'Markersize',8,'LineWidth',2), 
end
hold off

xlim([0 1])
ylim([0 1])
box('on')

set(handles.axes1,'XTick',[]);
set(handles.axes1,'YTick',[]);


function cleargraph(handles)

A=get(handles.figure1,'Children');
idx=find(strcmp(get(A,'Type'),'axes')==1);
try
    delete(get(A(idx),'Children'))
end

% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currentpath = pwd;
cd (path(handles.Dmeg{1}));
ROIname = ls(['ROI_*' fname(handles.Dmeg{1})]);
if isempty(ROIname)
    Namefile = fullfile(path(handles.Dmeg{1}),['ROI_1_' fname(handles.Dmeg{1})]);
else 
    num = ROIname(:,5);
    i=1;
    while any(str2num(num)==i)
        i=i+1;
    end
    Namefile = fullfile(path(handles.Dmeg{1}),['ROI_',num2str(i),'_', fname(handles.Dmeg{1})]);
end

roi1 = handles.inroi1;
roi2 = handles.inroi2;
roi3 = handles.inroi3;
roi4 = handles.inroi4;
roi5 = handles.inroi5;
roi6 = handles.inroi6;
roi7 = handles.inroi7;
roi8 = handles.inroi8;
roi9 = handles.inroi9;
roi10 = handles.inroi10;
save(Namefile,'roi1','roi2','roi3','roi4','roi5','roi6','roi7','roi8','roi9','roi10');
cd (currentpath)
% --- Executes on button press in load.
function load_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

file = spm_select(1,'mat','Select a ''ROI'' file to load Regions of Interest',[],[],'ROI*');
ROI = load(file);
handles.inroi1 = intersect(handles.chanav,ROI.roi1);
handles.inroi2 = intersect(handles.chanav,ROI.roi2);
handles.inroi3 = intersect(handles.chanav,ROI.roi3);
handles.inroi4 = intersect(handles.chanav,ROI.roi4);
handles.inroi5 = intersect(handles.chanav,ROI.roi5);
handles.inroi6 = intersect(handles.chanav,ROI.roi6);
handles.inroi7 = intersect(handles.chanav,ROI.roi7);
handles.inroi8 = intersect(handles.chanav,ROI.roi8);
handles.inroi9 = intersect(handles.chanav,ROI.roi9);
handles.inroi10 = intersect(handles.chanav,ROI.roi10);
available = setdiff(handles.chanav,[ROI.roi1(:);ROI.roi2(:);ROI.roi3(:);ROI.roi4(:);ROI.roi5(:);ROI.roi6(:);ROI.roi7(:);ROI.roi8(:);ROI.roi9(:);ROI.roi10(:)]);
set(handles.available,'String',available)
graph(handles)
guidata(hObject,handles);


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.available,'String',handles.chanav,'Enable','off');
set(handles.inroi,'String','in ROI')
set(handles.listroi,'String',{})
set(handles.roi1,'Value',0);
set(handles.roi2,'Value',0);
set(handles.roi3,'Value',0);
set(handles.roi4,'Value',0);
set(handles.roi5,'Value',0);
set(handles.roi6,'Value',0);
set(handles.roi7,'Value',0);
set(handles.roi8,'Value',0);
set(handles.roi9,'Value',0);
set(handles.roi10,'Value',0);
handles.inroi1 = {};
handles.inroi2 = {};
handles.inroi3 = {};
handles.inroi4 = {};
handles.inroi5 = {};
handles.inroi6 = {};
handles.inroi7 = {};
handles.inroi8 = {};
handles.inroi9 = {};
handles.inroi10 = {};
graph(handles);
guidata(hObject,handles);


% --- Executes on button press in back.
function back_Callback(hObject, eventdata, handles)
% hObject    handle to back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

csg_eegmenu;


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function click(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Mouse 	= get(handles.axes1,'CurrentPoint');
XMouse = Mouse(1,1);
YMouse = Mouse(1,2);

if XMouse > 0 && XMouse <1 && YMouse > 0 && YMouse <1
    dist	= sqrt((handles.pos(1,handles.index)-XMouse).^2 + (handles.pos(2,handles.index)-YMouse).^2);
    [mindist idx] = min(dist);
    if mindist<0.1
        Elec    = upper(handles.names(handles.index(idx)));

        chanavail = get(handles.available,'String');
        nRoi = get(handles.inroi,'String');
        newcontent = get(handles.listroi,'String');
        try
            switch nRoi
                case 'ROI 1'
                    if any(strcmp(handles.inroi1,Elec))
                        newcontent = setdiff(handles.inroi1,Elec);
                        chanavail  = union(chanavail,Elec); 
                    else
                        newcontent = union(Elec,handles.inroi1);
                        chanavail  = setdiff(chanavail,Elec);            
                    end
                    handles.inroi1  =  newcontent;
                    handles.inroi2  =  setdiff(handles.inroi2,Elec);
                    handles.inroi3  =  setdiff(handles.inroi3,Elec);
                    handles.inroi4  =  setdiff(handles.inroi4,Elec);
                    handles.inroi5  =  setdiff(handles.inroi5,Elec);
                    handles.inroi6  =  setdiff(handles.inroi6,Elec);
                    handles.inroi7  =  setdiff(handles.inroi7,Elec);
                    handles.inroi8  =  setdiff(handles.inroi8,Elec);
                    handles.inroi9  =  setdiff(handles.inroi9,Elec);
                    handles.inroi10 =  setdiff(handles.inroi10,Elec);
                case 'ROI 2'
                    if any(strcmp(handles.inroi2,Elec))
                        newcontent = setdiff(handles.inroi2,Elec);
                        chanavail  = union(chanavail,Elec); 
                    else
                        newcontent = union(Elec,handles.inroi2);
                        chanavail  = setdiff(chanavail,Elec);            
                    end
                    handles.inroi2  =  newcontent;
                    handles.inroi1  = setdiff(handles.inroi1,Elec);
                    handles.inroi3  = setdiff(handles.inroi3,Elec);
                    handles.inroi4  = setdiff(handles.inroi4,Elec);
                    handles.inroi5  = setdiff(handles.inroi5,Elec);
                    handles.inroi6  = setdiff(handles.inroi6,Elec);
                    handles.inroi7  = setdiff(handles.inroi7,Elec);
                    handles.inroi8  = setdiff(handles.inroi8,Elec);
                    handles.inroi9  = setdiff(handles.inroi9,Elec);
                    handles.inroi10  = setdiff(handles.inroi10,Elec);
                case 'ROI 3'
                    if any(strcmp(handles.inroi3,Elec))
                        newcontent = setdiff(handles.inroi3,Elec);
                        chanavail  = union(chanavail,Elec); 
                    else
                        newcontent = union(Elec,handles.inroi3);
                        chanavail  = setdiff(chanavail,Elec);            
                    end
                    handles.inroi3  =  newcontent;
                    handles.inroi2  = setdiff(handles.inroi2,Elec);
                    handles.inroi1  = setdiff(handles.inroi1,Elec);
                    handles.inroi4  = setdiff(handles.inroi4,Elec);
                    handles.inroi5  = setdiff(handles.inroi5,Elec);
                    handles.inroi6  = setdiff(handles.inroi6,Elec);
                    handles.inroi7  = setdiff(handles.inroi7,Elec);
                    handles.inroi8  = setdiff(handles.inroi8,Elec);
                    handles.inroi9  = setdiff(handles.inroi9,Elec);
                    handles.inroi10  = setdiff(handles.inroi10,Elec);
                case 'ROI 4'
                    if any(strcmp(handles.inroi4,Elec))
                        newcontent = setdiff(handles.inroi4,Elec);
                        chanavail  = union(chanavail,Elec); 
                    else
                        newcontent = union(Elec,handles.inroi4);
                        chanavail  = setdiff(chanavail,Elec);            
                    end
                    handles.inroi4  =  newcontent;
                    handles.inroi2  = setdiff(handles.inroi2,Elec);
                    handles.inroi3  = setdiff(handles.inroi3,Elec);
                    handles.inroi1  = setdiff(handles.inroi1,Elec);
                    handles.inroi5  = setdiff(handles.inroi5,Elec);
                    handles.inroi6  = setdiff(handles.inroi6,Elec);
                    handles.inroi7  = setdiff(handles.inroi7,Elec);
                    handles.inroi8  = setdiff(handles.inroi8,Elec);
                    handles.inroi9  = setdiff(handles.inroi9,Elec);
                    handles.inroi10  = setdiff(handles.inroi10,Elec);
                case 'ROI 5'
                    if any(strcmp(handles.inroi5,Elec))
                        newcontent = setdiff(handles.inroi5,Elec);
                        chanavail  = union(chanavail,Elec); 
                    else
                        newcontent = union(Elec,handles.inroi5);
                        chanavail  = setdiff(chanavail,Elec);            
                    end
                    handles.inroi5  =  newcontent;
                    handles.inroi2  = setdiff(handles.inroi2,Elec);
                    handles.inroi3  = setdiff(handles.inroi3,Elec);
                    handles.inroi4  = setdiff(handles.inroi4,Elec);
                    handles.inroi1  = setdiff(handles.inroi1,Elec);
                    handles.inroi6  = setdiff(handles.inroi6,Elec);
                    handles.inroi7  = setdiff(handles.inroi7,Elec);
                    handles.inroi8  = setdiff(handles.inroi8,Elec);
                    handles.inroi9  = setdiff(handles.inroi9,Elec);
                    handles.inroi10  = setdiff(handles.inroi10,Elec);
                case 'ROI 6'
                    if any(strcmp(handles.inroi6,Elec))
                        newcontent = setdiff(handles.inroi6,Elec);
                        chanavail  = union(chanavail,Elec); 
                    else
                        newcontent = union(Elec,handles.inroi6);
                        chanavail  = setdiff(chanavail,Elec);            
                    end  
                    handles.inroi6  =  newcontent;
                    handles.inroi2  = setdiff(handles.inroi2,Elec);
                    handles.inroi3  = setdiff(handles.inroi3,Elec);
                    handles.inroi4  = setdiff(handles.inroi4,Elec);
                    handles.inroi5  = setdiff(handles.inroi5,Elec);
                    handles.inroi1  = setdiff(handles.inroi1,Elec);
                    handles.inroi7  = setdiff(handles.inroi7,Elec);
                    handles.inroi8  = setdiff(handles.inroi8,Elec);
                    handles.inroi9  = setdiff(handles.inroi9,Elec);
                    handles.inroi10  = setdiff(handles.inroi10,Elec);
                case 'ROI 7'
                    if any(strcmp(handles.inroi7,Elec))
                        newcontent = setdiff(handles.inroi7,Elec);
                        chanavail  = union(chanavail,Elec); 
                    else
                        newcontent = union(Elec,handles.inroi7);
                        chanavail  = setdiff(chanavail,Elec);            
                    end  
                    handles.inroi7  =  newcontent;
                    handles.inroi2  = setdiff(handles.inroi2,Elec);
                    handles.inroi3  = setdiff(handles.inroi3,Elec);
                    handles.inroi4  = setdiff(handles.inroi4,Elec);
                    handles.inroi5  = setdiff(handles.inroi5,Elec);
                    handles.inroi6  = setdiff(handles.inroi6,Elec);
                    handles.inroi1  = setdiff(handles.inroi1,Elec);
                    handles.inroi8  = setdiff(handles.inroi8,Elec);
                    handles.inroi9  = setdiff(handles.inroi9,Elec);
                    handles.inroi10  = setdiff(handles.inroi10,Elec);
                case 'ROI 8'
                    if any(strcmp(handles.inroi8,Elec))
                        newcontent = setdiff(handles.inroi8,Elec);
                        chanavail  = union(chanavail,Elec); 
                    else
                        newcontent = union(Elec,handles.inroi8);
                        chanavail  = setdiff(chanavail,Elec);            
                    end 
                    handles.inroi8  =  newcontent;
                    handles.inroi2  = setdiff(handles.inroi2,Elec);
                    handles.inroi3  = setdiff(handles.inroi3,Elec);
                    handles.inroi4  = setdiff(handles.inroi4,Elec);
                    handles.inroi5  = setdiff(handles.inroi5,Elec);
                    handles.inroi6  = setdiff(handles.inroi6,Elec);
                    handles.inroi7  = setdiff(handles.inroi7,Elec);
                    handles.inroi1  = setdiff(handles.inroi1,Elec);
                    handles.inroi9  = setdiff(handles.inroi9,Elec);
                    handles.inroi10  = setdiff(handles.inroi10,Elec);
                case 'ROI 9'
                    if any(strcmp(handles.inroi9,Elec))
                        newcontent = setdiff(handles.inroi9,Elec);
                        chanavail  = union(chanavail,Elec); 
                    else
                        newcontent = union(Elec,handles.inroi9);
                        chanavail  = setdiff(chanavail,Elec);            
                    end  
                    handles.inroi9  =  newcontent;
                    handles.inroi2  = setdiff(handles.inroi2,Elec);
                    handles.inroi3  = setdiff(handles.inroi3,Elec);
                    handles.inroi4  = setdiff(handles.inroi4,Elec);
                    handles.inroi5  = setdiff(handles.inroi5,Elec);
                    handles.inroi6  = setdiff(handles.inroi6,Elec);
                    handles.inroi7  = setdiff(handles.inroi7,Elec);
                    handles.inroi8  = setdiff(handles.inroi8,Elec);
                    handles.inroi1  = setdiff(handles.inroi1,Elec);
                    handles.inroi10  = setdiff(handles.inroi10,Elec);
                case 'ROI 10'
                    if any(strcmp(handles.inroi10,Elec))
                        newcontent = setdiff(handles.inroi10,Elec);
                        chanavail  = union(chanavail,Elec); 
                    else
                        newcontent = union(Elec,handles.inroi10);
                        chanavail  = setdiff(chanavail,Elec);            
                    end 
                    handles.inroi10  =  newcontent;
                    handles.inroi2  = setdiff(handles.inroi2,Elec);
                    handles.inroi3  = setdiff(handles.inroi3,Elec);
                    handles.inroi4  = setdiff(handles.inroi4,Elec);
                    handles.inroi5  = setdiff(handles.inroi5,Elec);
                    handles.inroi6  = setdiff(handles.inroi6,Elec);
                    handles.inroi7  = setdiff(handles.inroi7,Elec);
                    handles.inroi8  = setdiff(handles.inroi8,Elec);
                    handles.inroi9  = setdiff(handles.inroi9,Elec);
                    handles.inroi1  = setdiff(handles.inroi1,Elec);
            end
            set(handles.available,'String',chanavail);
            set(handles.listroi,'String',newcontent);
            graph(handles);
            guidata(hObject,handles)
        end
    end
end


% --- Executes on button press in specanal.
function specanal_Callback(hObject, eventdata, handles)
% hObject    handle to specanal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% load parameters
fs = fsample(handles.Dmeg{1});
epoch = 4; % 4s could be a parameter to change 
pow2 = nextpow2(epoch*fs);
nfft = (2^(pow2-1));
forder = 3; % could also be a parameter
    
% remove bad channels detected from the averaged signal: to be
% done!!!!!!!!!!!!
fprintf('WARNIN and RECOMMENDATIONS!! \n')
fprintf('Signals are not filtered so use the preprocessing to filter data first!! \n')
fprintf('Artefact detected are not removed from the spectral computation: should be improved!! \n')
fprintf('the whole signal is used: used Chunk to isolate a time window or ask to add the possibility to select time window!! \n')

chanroi{1} = handles.inroi1;
chanroi{2} = handles.inroi2;
chanroi{3} = handles.inroi3;
chanroi{4} = handles.inroi4;
chanroi{5} = handles.inroi5;
chanroi{6} = handles.inroi6;
chanroi{7} = handles.inroi7;
chanroi{8} = handles.inroi8;
chanroi{9} = handles.inroi9;
chanroi{10} = handles.inroi10;
for iroi = 1 : 10
    [dum chanin dum] = intersect(handles.chanav,chanroi{iroi});
    D = handles.Dmeg{1}(chanin,:);
    [S{iroi}.chan{1} F T P] = spectrogram(D(1,:),epoch*fs,[],0.1:fs/nfft:30,fs);
    h = waitbar(0,['PSD is computing for ROI', num2str(iroi)]);
    for i = 2 : numel(chanroi{iroi})
       S{iroi}.chan{i} = spectrogram(D(i,:),epoch*fs,[],0.1:fs/nfft:30,fs);
       String  =  ['Progress : ' num2str(i/numel(chanroi{iroi})*100) ' %'];
       waitbar((i/numel(chanroi{iroi})),h,String);
    end
    close(h);
    % power by 2 sec epochs (by default)
    avg_S{iroi}  = meancell(S{iroi}.chan);
    args{iroi} = {F,T,10*log10(abs(avg_S{iroi}'))};
end


