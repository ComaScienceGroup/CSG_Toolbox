function varargout = csg_eegmenu(varargin)
% CSG_EEGMENU MATLAB code for csg_eegmenu.fig
%      CSG_EEGMENU, by itself, creates a new CSG_EEGMENU or raises the existing
%      singleton*.
%
%      H = CSG_EEGMENU returns the handle to a new CSG_EEGMENU or the handle to
%      the existing singleton*.
%
%      CSG_EEGMENU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CSG_EEGMENU.M with the given input arguments.
%
%      CSG_EEGMENU('Property','Value',...) creates a new CSG_EEGMENU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before csg_eegmenu_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to csg_eegmenu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help csg_eegmenu

% Last Modified by GUIDE v2.5 18-May-2017 14:43:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @csg_eegmenu_OpeningFcn, ...
                   'gui_OutputFcn',  @csg_eegmenu_OutputFcn, ...
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


% --- Executes just before csg_eegmenu is made visible.
function csg_eegmenu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to csg_eegmenu (see VARARGIN)

% Choose default command line output for csg_eegmenu
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes csg_eegmenu wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = csg_eegmenu_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in displayeeg.
function displayeeg_Callback(hObject, eventdata, handles)
% hObject    handle to displayeeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
csg_dis_selchan;

% --- Executes on button press in csg_mainprepro.
function csg_mainprepro_Callback(hObject, eventdata, handles)
% hObject    handle to csg_mainprepro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
csg_prepload;

% --- Executes on button press in spectanalysis.
function spectanalysis_Callback(hObject, eventdata, handles)
% hObject    handle to spectanalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
csg_ROI;

% --- Executes on button press in statanalysis.
function statanalysis_Callback(hObject, eventdata, handles)
% hObject    handle to statanalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in connectivity.
function connectivity_Callback(hObject, eventdata, handles)
% hObject    handle to connectivity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in microstates.
function microstates_Callback(hObject, eventdata, handles)
% hObject    handle to microstates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in sourcerec.
function sourcerec_Callback(hObject, eventdata, handles)
% hObject    handle to sourcerec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in backmain.
function backmain_Callback(hObject, eventdata, handles)
% hObject    handle to backmain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.figure1)
csg_menu


% --- Executes on button press in chunkbutton.
function chunkbutton_Callback(hObject, eventdata, handles)
% hObject    handle to chunkbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
csg_chunks;
