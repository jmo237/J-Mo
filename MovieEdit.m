function varargout = MovieEdit(varargin)
% MOVIEEDIT MATLAB code for MovieEdit.fig
%      MOVIEEDIT, by itself, creates a new MOVIEEDIT or raises the existing
%      singleton*.
%
%      H = MOVIEEDIT returns the handle to a new MOVIEEDIT or the handle to
%      the existing singleton*.
%
%      MOVIEEDIT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MOVIEEDIT.M with the given input arguments.
%
%      MOVIEEDIT('Property','Value',...) creates a new MOVIEEDIT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MovieEdit_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MovieEdit_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MovieEdit

% Last Modified by GUIDE v2.5 05-Aug-2014 16:01:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MovieEdit_OpeningFcn, ...
                   'gui_OutputFcn',  @MovieEdit_OutputFcn, ...
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


% --- Executes just before MovieEdit is made visible.
function MovieEdit_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MovieEdit (see VARARGIN)

% Choose default command line output for MovieEdit
handles.output = hObject;

logo = imread('UWPlogo.png');   % Cover Art
axes(handles.axes2); 
imshow(logo);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MovieEdit wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MovieEdit_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in fileImport.
function fileImport_Callback(hObject, eventdata, handles)
% hObject    handle to fileImport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[FileName,PathName,FilterIndex] = uigetfile('*.avi')
fName=[PathName,FileName];
set(handles.fileName,'String',fName)
xyloObj = VideoReader(fName);
nFrames = xyloObj.NumberOfFrames;
vidHeight = xyloObj.Height;
vidWidth = xyloObj.Width;
set(handles.slider1,'Max',nFrames)

% prelocate 
mov(1:nFrames) = ...
    struct('cdata',zeros(vidHeight,vidWidth, 3,'uint8'),'colormap',[]);
% impoart image     
for k = 1 : nFrames
    mov(k).cdata = read(xyloObj,k);
end
handles.M=mov;  % store image fraems into handles
handles.sframe=1;
handles.eframe=nFrames;
handles.minframe=1;
handles.maxframe=nFrames;
handles.PathName=PathName;

axes(handles.axes2); 
imshow(mov(1).cdata)
%ax2=handles.axes2;
%hf=figure;
%set(hf, 'position', [150 150 vidWidth vidHeight])
%movie(mov, 1, xyloObj.FrameRate);
%{
for fn=1:nFrames
set(handles.frameNumber,'String',num2str(fn))
set(handles.slider1,'Value',fn)
imshow(mov(fn).cdata)
drawnow
end
%}
guidata(hObject, handles);


function fileName_Callback(hObject, eventdata, handles)
% hObject    handle to fileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fileName as text
%        str2double(get(hObject,'String')) returns contents of fileName as a double


% --- Executes during object creation, after setting all properties.
function fileName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function frameNumber_Callback(hObject, eventdata, handles)
% hObject    handle to frameNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frameNumber as text
%        str2double(get(hObject,'String')) returns contents of frameNumber as a double


% --- Executes during object creation, after setting all properties.
function frameNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frameNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
fn=round(get(handles.slider1,'Value'));
set(handles.frameNumber,'String',num2str(fn))
axes(handles.axes2);
imshow(handles.M(fn).cdata)

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in playButton.
function playButton_Callback(hObject, eventdata, handles)
% hObject    handle to playButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mov=handles.M;  % store image fraems into handles
%sframe=handles.sframe;
%eframe=handles.endFrame;
axes(handles.axes2); 

for fn=handles.sframe:handles.eframe
set(handles.frameNumber,'String',num2str(fn))
set(handles.slider1,'Value',fn)
imshow(mov(fn).cdata)
text(10,10,['Frame# =',num2str(fn)],'Color','r')
drawnow
end
%}
guidata(hObject, handles);


% --- Executes on button press in saveButton.
function saveButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes2); 
PathName_in=handles.PathName;
mov=handles.M;
[FileName,PathName] = uiputfile('*.avi','Save the Editted movie',PathName_in);
fName=[PathName,FileName];
writerObj = VideoWriter(fName, ...
                        'Uncompressed AVI');
open(writerObj);
for fn = handles.sframe:handles.eframe
   %img = read(readerObj,k);
   %writeVideo(writerObj,mov(fn).cdata);
   set(handles.frameNumber,'String',num2str(fn))
   set(handles.slider1,'Value',fn)
   imshow(mov(fn).cdata)
   text(10,10,['Frame# =',num2str(fn)],'Color','r')
   frame = getframe;
   writeVideo(writerObj,frame);
end

close(writerObj);



function startFrame_Callback(hObject, eventdata, handles)
% hObject    handle to startFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of startFrame as text
%        str2double(get(hObject,'String')) returns contents of startFrame as a double
handles.sframe=str2num(get(handles.startFrame,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function startFrame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to startFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function endFrame_Callback(hObject, eventdata, handles)
% hObject    handle to endFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of endFrame as text
%        str2double(get(hObject,'String')) returns contents of endFrame as a double
handles.eframe=str2num(get(handles.endFrame,'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function endFrame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to endFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in acceptBT.
function acceptBT_Callback(hObject, eventdata, handles)
% hObject    handle to acceptBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in resetBT.
function resetBT_Callback(hObject, eventdata, handles)
% hObject    handle to resetBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.startFrame,'String',num2str(0));
set(handles.endFrame,'String',num2str(0));
handles.sframe=handles.minframe;
handles.eframe=handles.maxframe;
guidata(hObject, handles);
