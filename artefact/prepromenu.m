function varargout = prepromenu(varargin)
% PREPROMENU MATLAB code for prepromenu.fig
%      PREPROMENU, by itself, creates a new PREPROMENU or raises the existing
%      singleton*.
%
%      H = PREPROMENU returns the handle to a new PREPROMENU or the handle to
%      the existing singleton*.
%
%      PREPROMENU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PREPROMENU.M with the given input arguments.
%
%      PREPROMENU('Property','Value',...) creates a new PREPROMENU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before prepromenu_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to prepromenu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help prepromenu

% Last Modified by GUIDE v2.5 10-May-2017 12:28:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @prepromenu_OpeningFcn, ...
                   'gui_OutputFcn',  @prepromenu_OutputFcn, ...
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


% --- Executes just before prepromenu is made visible.
function prepromenu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to prepromenu (see VARARGIN)

% Choose default command line output for prepromenu
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes prepromenu wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = prepromenu_OutputFcn(hObject, eventdata, handles) 
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
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double


% --- Executes during object creation, after setting all properties.
function Explanations_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
    set(hObject,'String', 'Bad channels are detected by large time windows (by default 20s) and can be interpolated. Then, smaller artifacts are detected over smaller time window (by default 4s) over each channel by using correlation analysis over closed derivations.')
end


% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6



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
