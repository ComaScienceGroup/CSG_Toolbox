function varargout = csg_prepromenu(varargin)
% CSG_PREPROMENU MATLAB code for csg_prepromenu.fig
%      CSG_PREPROMENU, by itself, creates a new CSG_PREPROMENU or raises the existing
%      singleton*.
%
%      H = CSG_PREPROMENU returns the handle to a new CSG_PREPROMENU or the handle to
%      the existing singleton*.
%
%      CSG_PREPROMENU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CSG_PREPROMENU.M with the given input arguments.
%
%      CSG_PREPROMENU('Property','Value',...) creates a new CSG_PREPROMENU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before csg_prepromenu_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to csg_prepromenu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help csg_prepromenu

% Last Modified by GUIDE v2.5 10-May-2017 13:02:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @csg_prepromenu_OpeningFcn, ...
                   'gui_OutputFcn',  @csg_prepromenu_OutputFcn, ...
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


% --- Executes just before csg_prepromenu is made visible.
function csg_prepromenu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to csg_prepromenu (see VARARGIN)


% Choose default command line output for csg_prepromenu
handles.output = hObject;
handles.Dmeg = varargin{1}.Dmeg;
handles.Nfiles = varargin{1}.Nfiles;

% initialization of the rereferencing list
if handles.Nfiles>1
    chanlabels1 = chanlabels(handles.Dmeg{1});
    chanlabels2 = chanlabels(handles.Dmeg{2});
    i = 3;
    while i<=handles.Nfiles && numel(chanlabels1) == numel(chanlabels2) && all(strcmp(chanlabels1,chanlabels2))
        chanlabels2 = chanlabels(handles.Dmeg{i});
        i = i+1;
    end
    if i>handles.Nfiles
        % channels are the same in all files 
        reflist = [chanlabels1 'Average of all channels'];
        set(handles.reflist,'String',reflist);      
    else 
        set(handles.reflist,'String','Average of all channels');    
    end
else 
    reflist = [chanlabels(handles.Dmeg{1}) 'Average of all channels'];
    set(handles.reflist,'String',reflist);      
end

set(handles.Explanations,'String', 'Bad channels are detected over large and small time windows (by default 20s and 4s respectively). Over smaller time windows, the AADM uses coherence values so only high density EEG should add this particular detection. For both detections, you can also interpolate bad epochs detected.')
set(handles.Explanationreref,'String','The rereferencing is processed after the AADM. Bad channels are removed from the averaged signal used as reference but interpolated signals are kept.')
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes csg_prepromenu wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = csg_prepromenu_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in filtopt.
function filtopt_Callback(hObject, eventdata, handles)
% hObject    handle to filtopt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of filtopt

if get(hObject,'Value')
    handles.filtering.eegblw = get(handles.eegblw,'String');
end


function eegblw_Callback(hObject, eventdata, handles)
% hObject    handle to eegblw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eegblw as text
%        str2double(get(hObject,'String')) returns contents of eegblw as a double


% --- Executes during object creation, after setting all properties.
function eegblw_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eegblw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function eegabv_Callback(hObject, eventdata, handles)
% hObject    handle to eegabv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eegabv as text
%        str2double(get(hObject,'String')) returns contents of eegabv as a double


% --- Executes during object creation, after setting all properties.
function eegabv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eegabv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function eogblw_Callback(hObject, eventdata, handles)
% hObject    handle to eogblw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eogblw as text
%        str2double(get(hObject,'String')) returns contents of eogblw as a double


% --- Executes during object creation, after setting all properties.
function eogblw_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eogblw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function eogabv_Callback(hObject, eventdata, handles)
% hObject    handle to eogabv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eogabv as text
%        str2double(get(hObject,'String')) returns contents of eogabv as a double


% --- Executes during object creation, after setting all properties.
function eogabv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eogabv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ecgblw_Callback(hObject, eventdata, handles)
% hObject    handle to ecgblw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ecgblw as text
%        str2double(get(hObject,'String')) returns contents of ecgblw as a double


% --- Executes during object creation, after setting all properties.
function ecgblw_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ecgblw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ecgabv_Callback(hObject, eventdata, handles)
% hObject    handle to ecgabv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ecgabv as text
%        str2double(get(hObject,'String')) returns contents of ecgabv as a double


% --- Executes during object creation, after setting all properties.
function ecgabv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ecgabv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function emgblw_Callback(hObject, eventdata, handles)
% hObject    handle to emgblw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of emgblw as text
%        str2double(get(hObject,'String')) returns contents of emgblw as a double


% --- Executes during object creation, after setting all properties.
function emgblw_CreateFcn(hObject, eventdata, handles)
% hObject    handle to emgblw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function emgabv_Callback(hObject, eventdata, handles)
% hObject    handle to emgabv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of emgabv as text
%        str2double(get(hObject,'String')) returns contents of emgabv as a double


% --- Executes during object creation, after setting all properties.
function emgabv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to emgabv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in AADopt.
function AADopt_Callback(hObject, eventdata, handles)
% hObject    handle to AADopt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AADopt



function Explanations_Callback(hObject, eventdata, handles)
% hObject    handle to Explanations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Lwinopt as text
%        str2double(get(hObject,'String')) returns contents of Lwinopt as a double


% --- Executes during object creation, after setting all properties.
function Explanations_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Explanations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Explanationreref_Callback(hObject, eventdata, handles)
% hObject    handle to Explanations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Lwinopt as text
%        str2double(get(hObject,'String')) returns contents of Lwinopt as a double


% --- Executes during object creation, after setting all properties.
function Explanationreref_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Explanations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rerefopt.
function rerefopt_Callback(hObject, eventdata, handles)
% hObject    handle to rerefopt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rerefopt



function Swinopt_Callback(hObject, eventdata, handles)
% hObject    handle to Swinopt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Swinopt as text
%        str2double(get(hObject,'String')) returns contents of Swinopt as a double


% --- Executes during object creation, after setting all properties.
function Swinopt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Swinopt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in detcohopt.
function detcohopt_Callback(hObject, eventdata, handles)
% hObject    handle to detcohopt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of detcohopt


% --- Executes on button press in interpolsmall.
function interpolsmall_Callback(hObject, eventdata, handles)
% hObject    handle to interpolsmall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of interpolsmall


% --- Executes on button press in interpollarge.
function interpollarge_Callback(hObject, eventdata, handles)
% hObject    handle to interpollarge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of interpollarge



function Lwinopt_Callback(hObject, eventdata, handles)
% hObject    handle to Lwinopt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Lwinopt as text
%        str2double(get(hObject,'String')) returns contents of Lwinopt as a double


% --- Executes during object creation, after setting all properties.
function Lwinopt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Lwinopt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in backeegmenu.
function backeegmenu_Callback(hObject, eventdata, handles)
% hObject    handle to backeegmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.figure1)
csg_eegmenu;


% --- Executes on selection change in reflist.
function reflist_Callback(hObject, eventdata, handles)
% hObject    handle to reflist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns reflist contents as cell array
%        contents{get(hObject,'Value')} returns selected item from reflist


% --- Executes during object creation, after setting all properties.
function reflist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to reflist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in runpreproc.
function runpreproc_Callback(hObject, eventdata, handles)
% hObject    handle to runpreproc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(handles.filtopt,'Value')
    filtpar.eegblw = str2num(get(handles.eegblw,'String'));
    filtpar.eegabv = str2num(get(handles.eegabv,'String'));
    filtpar.ecgblw = str2num(get(handles.ecgblw,'String'));
    filtpar.ecgabv = str2num(get(handles.ecgabv,'String'));
    filtpar.emgblw = str2num(get(handles.emgblw,'String'));
    filtpar.emgabv = str2num(get(handles.emgabv,'String'));
    filtpar.eogblw = str2num(get(handles.eogblw,'String'));
    filtpar.eogabv = str2num(get(handles.eogabv,'String'));
end
if get(handles.AADopt,'Value')
    Lwin = str2num(get(handles.Lwinopt,'String'));
    Swin = str2num(get(handles.Swinopt,'String'));
    Linterpo = get(handles.interpollarge,'Value');
    Sinterpo = get(handles.interpolsmall,'Value');
end
if get(handles.rerefopt,'Value')
    ref = get(handles.reflist,'String');
end

function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
