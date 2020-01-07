function varargout = VirtualLab(varargin)
% VIRTUALLAB MATLAB code for VirtualLab.fig
%      VIRTUALLAB, by itself, creates a new VIRTUALLAB or raises the existing
%      singleton*.
%
%      H = VIRTUALLAB returns the handle to a new VIRTUALLAB or the handle to
%      the existing singleton*.
%
%      VIRTUALLAB('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIRTUALLAB.M with the given input arguments.
%
%      VIRTUALLAB('Property','Value',...) creates a new VIRTUALLAB or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VirtualLab_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VirtualLab_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VirtualLab

% Last Modified by GUIDE v2.5 30-Sep-2014 13:09:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VirtualLab_OpeningFcn, ...
                   'gui_OutputFcn',  @VirtualLab_OutputFcn, ...
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


% --- Executes just before VirtualLab is made visible.
function VirtualLab_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VirtualLab (see VARARGIN)

% Choose default command line output for VirtualLab
handles.output = hObject;

logo = imread('uwp_logo_g.png');   % Cover Art
axes(handles.axes1); 
imshow(logo);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VirtualLab wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = VirtualLab_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in VideoEditBT.
function VideoEditBT_Callback(hObject, eventdata, handles)
% hObject    handle to VideoEditBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
MovieEdit()

% --- Executes on button press in MotionAnalysisBT.
function MotionAnalysisBT_Callback(hObject, eventdata, handles)
% hObject    handle to MotionAnalysisBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
MotionAnalysis()

% --- Executes on button press in AnalysisBT.
function AnalysisBT_Callback(hObject, eventdata, handles)
% hObject    handle to AnalysisBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
errordlg('Under Construction! COMING SOON ','Program Error');
