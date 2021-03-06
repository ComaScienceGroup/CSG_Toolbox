function varargout = csg_menu(varargin)
% CSG_MENU MATLAB code for csg_menu.fig
%      CSG_MENU, by itself, creates a new CSG_MENU or raises the existing
%      singleton*.
%
%      H = CSG_MENU returns the handle to a new CSG_MENU or the handle to
%      the existing singleton*.
%
%      CSG_MENU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CSG_MENU.M with the given input arguments.
%
%      CSG_MENU('Property','Value',...) creates a new CSG_MENU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before csg_menu_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to csg_menu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help csg_menu

% Last Modified by GUIDE v2.5 08-May-2017 15:43:38

% The ''Fasst 2 - CSG Toolbox'', is developed for the Coma Science Group.
% It is derived from the ''Fasst Toolbox'' developed by the Cyclotron Research Center.
% The version of this toolbox used as basis, was downloaded from Github on the 8th of May 2017.
%
% First Author of ''Fasst 2 - CSG Toolbox'': Coppieters Doroth�e, d.coppieters@ulg.ac.be
% Responsible in Liege of ''Fasst Toolbox'': Christophe Phillips, c.phillips@ulg.ac.be
%
% Display ASCII Welcome

disp('                           	');
disp('      __________  _____      	');
disp('     / _____/__/ / ___/      	');
disp('    / /   \__  \//  ____      ');
disp('   / /_______/ //__ /_/       ');
disp('  /______/___ /_____/         ');
disp('                              ');
disp(' Coma Science Group Toolbox,  ');
disp(' Based on the Fasst Toolbox: http://www.montefiore.ulg.ac.be/~phillips/FASST.html     ');
disp(' An SPM12-compatible toolbox.                                                         ');
fprintf('\n');

% Check if SPM is available
ok = check_installation;
if ~ok
    beep
    fprintf('INSTALLATION PROBLEM!');
    return
end

% Add the fieldtrip toolbox from SPM, if necessary
if ~exist('ft_defaults','file')
    addpath(fullfile(spm('Dir'),'external','fieldtrip'));
end
ft_defaults;

% Check for Signal Processing Toolbox
persistent flag_TBX
if isempty(flag_TBX)
    flag_TBX = license('checkout','signal_toolbox');
    if ~flag_TBX
        pth = fullfile(spm_str_manip(mfilename('fullpath'),'h'),'SPTfunctions');
        addpath(pth)
        disp(['warning: using freely distributed equivalent to filtering functions ', ...
          'as Signal Processing Toolbox is not available.']);
    end
end

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @csg_menu_OpeningFcn, ...
                   'gui_OutputFcn',  @csg_menu_OutputFcn, ...
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


% --- Executes just before csg_menu is made visible.
function csg_menu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to csg_menu (see VARARGIN)

[A] = imread('logo_CSG.jpg');
image(A)
axis off

% Choose default command line output for csg_menu
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes csg_menu wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = csg_menu_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in EEG.
function EEG_Callback(hObject, eventdata, handles)
% hObject    handle to EEG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.figure1)
csg_eegmenu

% --- Executes on button press in fMRI.
function fMRI_Callback(hObject, eventdata, handles)
% hObject    handle to fMRI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in DTI.
function DTI_Callback(hObject, eventdata, handles)
% hObject    handle to DTI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in TMS.
function TMS_Callback(hObject, eventdata, handles)
% hObject    handle to TMS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in PET.
function PET_Callback(hObject, eventdata, handles)
% hObject    handle to PET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in multmod.
function multmod_Callback(hObject, eventdata, handles)
% hObject    handle to multmod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

delete(handles.figure1)
csg_eegmod


%% SUBFUNCTION
% from the initial Fasst toolbox developed by the Cyclotron Research Center
% - Version downloaded on the 8th of May 2017
function ok = check_installation
% function to check installation state of toolbox,
% particullarly the SPM path setup

ok = true;

% Check SPM installation
if exist('spm.m','file')
    [SPMver, SPMrel] = spm('Ver');
    if ~(strcmpi(SPMver,'spm8') && str2double(SPMrel)>8.5) && ...
            ~strcmpi(SPMver,'spm12')
        beep
        fprintf('\nERROR:\n')
        fprintf('\tThe *latest* version of SPM8 or SPM12b should be installed on your computer,\n')
        fprintf('\tand be available on MATLABPATH!\n\n')
        ok = false;
    end
else
    beep
    fprintf('\nERROR:\n')
    fprintf('\tThe *latest* version of SPM8 should be installed on your computer,\n')
    fprintf('\tand be available on MATLABPATH!\n\n')
    ok = false;
end

return


