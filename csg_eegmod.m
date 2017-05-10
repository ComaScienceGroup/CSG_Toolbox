function varargout = csg_eegmod(varargin)
% CSG_EEGMOD MATLAB code for csg_eegmod.fig
%      CSG_EEGMOD, by itself, creates a new CSG_EEGMOD or raises the existing
%      singleton*.
%
%      H = CSG_EEGMOD returns the handle to a new CSG_EEGMOD or the handle to
%      the existing singleton*.
%
%      CSG_EEGMOD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CSG_EEGMOD.M with the given input arguments.
%
%      CSG_EEGMOD('Property','Value',...) creates a new CSG_EEGMOD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before csg_eegmod_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to csg_eegmod_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help csg_eegmod

% Last Modified by GUIDE v2.5 09-May-2017 13:53:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @csg_eegmod_OpeningFcn, ...
                   'gui_OutputFcn',  @csg_eegmod_OutputFcn, ...
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


% --- Executes just before csg_eegmod is made visible.
function csg_eegmod_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to csg_eegmod (see VARARGIN)

% Choose default command line output for csg_eegmod
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes csg_eegmod wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = csg_eegmod_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in dtieeg.
function dtieeg_Callback(hObject, eventdata, handles)
% hObject    handle to dtieeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in peteeg.
function peteeg_Callback(hObject, eventdata, handles)
% hObject    handle to peteeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in tmseeg.
function tmseeg_Callback(hObject, eventdata, handles)
% hObject    handle to tmseeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in mrieeg.
function mrieeg_Callback(hObject, eventdata, handles)
% hObject    handle to mrieeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in backmain.
function backmain_Callback(hObject, eventdata, handles)
% hObject    handle to backmain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

delete(handles.figure1)
csg_menu
