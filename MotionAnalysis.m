function varargout = MotionAnalysis(varargin)
% MOTIONANALYSIS MATLAB code for MotionAnalysis.fig
%      MOTIONANALYSIS, by itself, creates a new MOTIONANALYSIS or raises the existing
%      singleton*.
%
%      H = MOTIONANALYSIS returns the handle to a new MOTIONANALYSIS or the handle to
%      the existing singleton*.
%
%      MOTIONANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MOTIONANALYSIS.M with the given input arguments.
%
%      MOTIONANALYSIS('Property','Value',...) creates a new MOTIONANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MotionAnalysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MotionAnalysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MotionAnalysis

% Last Modified by GUIDE v2.5 30-Sep-2014 10:04:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MotionAnalysis_OpeningFcn, ...
                   'gui_OutputFcn',  @MotionAnalysis_OutputFcn, ...
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


% --- Executes just before MotionAnalysis is made visible.
function MotionAnalysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MotionAnalysis (see VARARGIN)

% Choose default command line output for MotionAnalysis
handles.output = hObject;

logo = imread('UWPlogo.png');   % Cover Art
axes(handles.axes2); 
imshow(logo);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MotionAnalysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MotionAnalysis_OutputFcn(hObject, eventdata, handles) 
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
handles.vidHeight = xyloObj.Height;
handles.vidWidth = xyloObj.Width;
set(handles.slider1,'Max',nFrames)

% Key in frame rate
 temp_str = inputdlg('Key in Frame Rate of the video =',...
             'Video Frame Rate', [1 40]);
        FrameRate=str2num(char(temp_str))
handles.FrameRate=FrameRate;

% prelocate 
%mov(1:nFrames) = ...
%    struct('cdata',zeros(vidHeight,vidWidth, 3,'uint8'),'colormap',[]);

% impoart frame 1 to check size of image volume ad allocate space    
[xrow,ycol] = size(rgb2gray(read(xyloObj,1)));

% allocate memory to image_vol
image_vol=zeros(xrow,ycol,nFrames);
h = waitbar(0,'Uploading and converting image to gray scale image..');
for fn = 1 : nFrames
    % computations take place here
    waitbar(fn / nFrames);
    image_vol(:,:,fn) = rgb2gray(read(xyloObj,fn));
end
delete(h)
handles.image_vol=image_vol;  % store image fraems into handles
handles.sframe=1;
handles.eframe=nFrames;
handles.minframe=1;
handles.maxframe=nFrames;
handles.PointDefCheck=0;
handles.pointON_BT_CHECK=0;
handles.vectorON_BT_CHECK=0;
handles.fName=fName;
handles.PathName=PathName;

ColorVec=['b','r','y','c','m','g','w'];
handles.ColorVec=ColorVec;

axes(handles.axes2); 
imshow(image_vol(:,:,1)/256); % /256 is a small trick for showing gray image 

%hold
% WARNING plot and getpts coordinate is flipped from other image coordinate
%[x0, y0] = getpts
%plot(x0,y0,'r o'); 

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
delete xyloObj
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
image_vol=handles.image_vol;  % store image fraems into handles
axes(handles.axes2); 
image_info_check=handles.pointON_BT_CHECK+handles.vectorON_BT_CHECK;
xaxis=[10,handles.vidHeight-10
       50,handles.vidHeight-10]; 
yaxis=[10,handles.vidHeight-10
       10,handles.vidHeight-50]; 
   
switch image_info_check

    case 0 % play movie without any overlay  OK
        for fn=handles.sframe:handles.eframe
            set(handles.frameNumber,'String',num2str(fn))
            set(handles.slider1,'Value',fn)
            imshow(image_vol(:,:,fn)/256)
            text(10,10,['Frame# =',num2str(fn)],'Color','r')
            text(60,handles.vidHeight-10,'x','Color','w')
            text(10,handles.vidHeight-60,'y','Color','w')
            % adding refrence axis 10/01
            hold
            plot(xaxis(:,1),xaxis(:,2),'w')
            plot(yaxis(:,1),yaxis(:,2),'w')
            hold off
            drawnow
        end
        
    case 1 % point ON  OK
        for fn=handles.sframe:handles.eframe
            set(handles.frameNumber,'String',num2str(fn))
            set(handles.slider1,'Value',fn)
            imshow(image_vol(:,:,fn)/256)
            text(10,10,['Frame# =',num2str(fn)],'Color','r')
            text(60,handles.vidHeight-10,'x','Color','w')
            text(10,handles.vidHeight-60,'y','Color','w')
            hold
            % plot points
            %point_plot_func(handles,fn)
            point_plot2_func(handles,fn,handles.blocksize)
            plot(xaxis(:,1),xaxis(:,2),'w')
            plot(yaxis(:,1),yaxis(:,2),'w')
            hold off
            drawnow
        end

    case 2 % vector ON OK
        for fn=handles.sframe:handles.eframe
            set(handles.frameNumber,'String',num2str(fn))
            set(handles.slider1,'Value',fn)
            imshow(image_vol(:,:,fn)/256)
            text(10,10,['Frame# =',num2str(fn)],'Color','r')
            text(60,handles.vidHeight-10,'x','Color','w')
            text(10,handles.vidHeight-60,'y','Color','w')
            
            hold
           % plot vectors
            vector_plot_func(handles,fn)
            plot(xaxis(:,1),xaxis(:,2),'w')
            plot(yaxis(:,1),yaxis(:,2),'w')
            hold off
            drawnow
        end

    case 3 % Both point and vector ON
        for fn=handles.sframe:handles.eframe
            set(handles.frameNumber,'String',num2str(fn))
            set(handles.slider1,'Value',fn)
            imshow(image_vol(:,:,fn)/256)
            text(10,10,['Frame# =',num2str(fn)],'Color','r')
            text(60,handles.vidHeight-10,'x','Color','w')
            text(10,handles.vidHeight-60,'y','Color','w')
            
            hold   
            % plot points and vectors
            %point_plot_func(handles,fn)
            point_plot2_func(handles,fn,handles.blocksize)
            vector_plot_func(handles,fn)
            plot(xaxis(:,1),xaxis(:,2),'w')
            plot(yaxis(:,1),yaxis(:,2),'w')
            
            hold off
            drawnow
        end
        
end

guidata(hObject, handles);


% --- Executes on button press in saveButton.
function saveButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image_vol=handles.image_vol;  % store image fraems into handles
PathName_in=handles.PathName;
axes(handles.axes2); 
%mov=handles.M;
[FileName,PathName] = uiputfile('*.avi','Save the Editted movie',PathName_in);
fName=[PathName,FileName];
writerObj = VideoWriter(fName,'Uncompressed AVI');
open(writerObj);
%++++++++++++
image_info_check=handles.pointON_BT_CHECK+handles.vectorON_BT_CHECK;
xaxis=[10,handles.vidHeight-10
       50,handles.vidHeight-10]; 
yaxis=[10,handles.vidHeight-10
       10,handles.vidHeight-50]; 

switch image_info_check

    case 0 % play movie without any overlay  OK
        for fn=handles.sframe:handles.eframe
            set(handles.frameNumber,'String',num2str(fn))
            set(handles.slider1,'Value',fn)
            imshow(image_vol(:,:,fn)/256)
            text(10,10,['Frame# =',num2str(fn)],'Color','r')
            text(60,handles.vidHeight-10,'x','Color','w')
            text(10,handles.vidHeight-60,'y','Color','w')
            % adding refrence axis 10/01
            hold
            plot(xaxis(:,1),xaxis(:,2),'w')
            plot(yaxis(:,1),yaxis(:,2),'w')
            hold off

            drawnow
            frame = getframe;
            writeVideo(writerObj,frame);

        end
        
    case 1 % point ON  OK
        for fn=handles.sframe:handles.eframe
            set(handles.frameNumber,'String',num2str(fn))
            set(handles.slider1,'Value',fn)
            imshow(image_vol(:,:,fn)/256)
            text(10,10,['Frame# =',num2str(fn)],'Color','r')
            text(60,handles.vidHeight-10,'x','Color','w')
            text(10,handles.vidHeight-60,'y','Color','w')
            
            hold
            % plot points
            %point_plot_func(handles,fn)
            point_plot2_func(handles,fn,handles.blocksize)
            plot(xaxis(:,1),xaxis(:,2),'w')
            plot(yaxis(:,1),yaxis(:,2),'w')

            hold off
            drawnow
            frame = getframe;
            writeVideo(writerObj,frame);

        end

    case 2 % vector ON OK
        for fn=handles.sframe:handles.eframe
            set(handles.frameNumber,'String',num2str(fn))
            set(handles.slider1,'Value',fn)
            imshow(image_vol(:,:,fn)/256)
            text(10,10,['Frame# =',num2str(fn)],'Color','r')
            text(60,handles.vidHeight-10,'x','Color','w')
            text(10,handles.vidHeight-60,'y','Color','w')

            hold
           % plot vectors
            vector_plot_func(handles,fn)
            plot(xaxis(:,1),xaxis(:,2),'w')
            plot(yaxis(:,1),yaxis(:,2),'w')

            hold off
            drawnow
            frame = getframe;
            writeVideo(writerObj,frame);
        end

    case 3 % Both point and vector ON
        for fn=handles.sframe:handles.eframe
            set(handles.frameNumber,'String',num2str(fn))
            set(handles.slider1,'Value',fn)
            imshow(image_vol(:,:,fn)/256)
            text(10,10,['Frame# =',num2str(fn)],'Color','r')
            text(60,handles.vidHeight-10,'x','Color','w')
            text(10,handles.vidHeight-60,'y','Color','w')

            hold
            
            % plot points and vectors
            %point_plot_func(handles,fn)
            point_plot2_func(handles,fn,handles.blocksize)
            vector_plot_func(handles,fn)
            plot(xaxis(:,1),xaxis(:,2),'w')
            plot(yaxis(:,1),yaxis(:,2),'w')
            
            hold off
            drawnow
            frame = getframe;
            writeVideo(writerObj,frame);
        end
        
end

%{
++++++++++++++
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
%}
close(writerObj);


% --- Executes on button press in acceptBT.
function acceptBT_Callback(hObject, eventdata, handles)
% hObject    handle to acceptBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in PointDef.
function PointDef_Callback(hObject, eventdata, handles)
% hObject    handle to PointDef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fn=round(get(handles.PointDef,'Value'))

if fn >= 0
clear x0
clear y0
clear x1
clear y1
clear maxValueHistory

image_vol=handles.image_vol;  % store image fraems into handles
sframe=handles.sframe;
nFrames=handles.eframe;
minframe=handles.minframe;
maxframe=handles.maxframe;
blocksize=str2num(get(handles.BlockSize,'String'))
axes(handles.axes2); 
imshow(image_vol(:,:,1)/256); % /256 is a small trick for showing gray image 
hold
% WARNING plot and getpts coordinate is flipped from other image coordinate
[x0, y0] = getpts
plot(x0,y0,'y o'); 
hold off;

InitPoint(:,1)=x0;
InitPoint(:,2)=y0;

InitPoint_s=InitPoint(1,:);
image_vol_s=image_vol(:,:,1:2);

% initialize coordinate frame matrix 
totalPointNumber=size(x0,1);
totalFrameNumber=nFrames;
psize=round(blocksize/2);  % one-szie pach size.  Totoal matrix will be psize x 2 + 1

%x1=zeros(totalPointNumber,totalFrameNumber);
%y1=zeros(totalPointNumber,totalFrameNumber);
%maxValueHistory=zeros(totalPointNumber,totalFrameNumber-1);

% x,y flip to correct information
%x1(:,1)=round(y0);
%y1(:,1)=round(x0);
end

% trial track to estimate the total time
%totalFrameNumber=2;
%totalPointNumber=1;
IN.RAD = psize;
IN.mag=3;
IN.BUF = 30;
IN.SPC = 10;
totalFrameNumber_s=2;
totalPointNumber_s=1;

tic;
%[x1,y1]=f2ftrack_func(image_vol,x1,y1,psize,,2,maxValueHistory);
%[x1,y1]=f2ftrack_func(image_vol,x1,y1,psize,totalFrameNumber,totalPointNumber,maxValueHistory)
[x1,y1,NCC_vol,SNR_vol]=f2ftrack_func100(image_vol_s,InitPoint_s,IN,totalFrameNumber_s,totalPointNumber_s)

time_per_point=toc;

%totalPointNumber=size(x0,1)
%totalFrameNumber=nFrames;
%x1=zeros(totalPointNumber,totalFrameNumber);
%y1=zeros(totalPointNumber,totalFrameNumber);
%maxValueHistory=zeros(totalPointNumber,totalFrameNumber-1);

% x,y flip to correct information
%x1(:,1)=y0;
%y1(:,1)=x0;

%handles.x1=x1;
%handles.y1=y1;
%handles.maxValueHistory=maxValueHistory;
handles.blocksize=blocksize;
handles.totalPointNumber=totalPointNumber;
handles.totalFrameNumber=totalFrameNumber;
handles.PointDefCheck=1;
handles.IN=IN;
handles.InitPoint=InitPoint;

total_time=time_per_point*totalFrameNumber*totalPointNumber;
time_message=['! Check ! Estimated Total tracking = ',num2str(total_time)];
warndlg(time_message,'If you need to change setting, DO IT NOW')

guidata(hObject, handles);


function BlockSize_Callback(hObject, eventdata, handles)
% hObject    handle to BlockSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BlockSize as text
%        str2double(get(hObject,'String')) returns contents of BlockSize as a double
handles.blocksize=str2num(get(handles.BlockSize,'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function BlockSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BlockSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PointTracking.
function PointTracking_Callback(hObject, eventdata, handles)
% hObject    handle to PointTracking (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fn=round(get(handles.PointTracking,'Value'))

if fn >= 0
image_vol=handles.image_vol;  % store image fraems into handles
sframe=handles.sframe;
nFrames=handles.eframe;
minframe=handles.minframe;
maxframe=handles.maxframe;
InitPoint=handles.InitPoint;
psize=round(handles.blocksize/2);
totalPointNumber=handles.totalPointNumber;
totalFrameNumber=nFrames;
IN=handles.IN;
%[x1,y1]=f2ftrack_func(image_vol,x1,y1,psize,totalFrameNumber,totalPointNumber,maxValueHistory);
[x1,y1,maxValueHistory]=f2ftrack_func100(image_vol,InitPoint,IN,totalFrameNumber,totalPointNumber)
end

handles.x1=x1; % information needs to be swapped due to coord change in MTX
handles.y1=y1;
handles.maxValueHistory=maxValueHistory;

guidata(hObject, handles);


% --- Executes on button press in VectorDef.
function VectorDef_Callback(hObject, eventdata, handles)
% hObject    handle to VectorDef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image_vol=handles.image_vol;  % store image fraems into handles
InitPoint=handles.InitPoint;

VectorDefCheck=round(get(handles.VectorDef,'Value'));
ColorVec=handles.ColorVec;
x1=handles.x1;
y1=handles.y1;

if VectorDefCheck >=0
   if handles.PointDefCheck~=1
       warndlg('More the 2 points Definition + Tracking need to be done first! ')
   else
      if handles.totalPointNumber < 2
       warndlg('Need More the 2 points to define one vectors! ');
      else
       % Vector can be defined
       temp_str = inputdlg('Input How Many Vectors to be deinfed =',...
             'Vector Defintion', [1 40]);
        totalVectorNumber=str2num(char(temp_str))
        handles.totalVectorNumber=totalVectorNumber;
        
         imshow(image_vol(:,:,1)/256);
           hold
         for nvec=1:totalVectorNumber
           %msg=['No.',num2str(nvec),'Vector be defined!'];
           %h=warndlg(msg);
           %imshow(image_vol(:,:,1)/256);
           %hold
           plot(InitPoint(:,1),InitPoint(:,2),'y o');
          
           [xLine, yLine] = getline
           [xLine, yLine,entryVec]=lineadjust_func(xLine,yLine,x1(:,1),y1(:,1))
           xLL(nvec,:)=entryVec(:);
           yLL(nvec,:)=entryVec(:);
           LinePattern=[ColorVec(nvec),'--']
           plot(xLine,yLine,LinePattern);
           EndPattern=[ColorVec(nvec),'x']
           plot(xLine(2),yLine(2),EndPattern)
           %hold off; 
         end
         hold off;
         
         % Enter reference line
         %h = msgbox('NOW Define Reference Line for vectors');
          %[xRef, yRef] = getline;
         
         handles.xLL=xLL; % xLL and yLL are redundant information! SAME!
         handles.yLL=yLL;
                 
         % Save coordinate of reference lines
         %handles.xRef=xRef;
         %handles.yRef=yRef;
      end
   end

end
guidata(hObject, handles);


% --- Executes on button press in SR_Analysis.
function SR_Analysis_Callback(hObject, eventdata, handles)
% hObject    handle to SR_Analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
SR_AnalysisCheck=round(get(handles.SR_Analysis,'Value'));
ColorVec=handles.ColorVec;
%x1=handles.x1;
%y1=handles.y1;

% coodinate conversion from image coord to x-y coord.
% all data are still in pixel unit!
xc=handles.x1;
yc=(handles.vidHeight-handles.y1)+1; 

xLL=handles.xLL;  % xLL(vec#,1) VEC start point# xLL(vec#,2) VEC end point#
totalPointNumber=handles.totalPointNumber;
totalFrameNumber=handles.eframe;
totalVectorNumber=handles.totalVectorNumber  % number of vectors

% settting up NULL matirx 
VecRotation=zeros(totalVectorNumber,totalFrameNumber);
%VecRotation2=VecRotation;
VecLength=zeros(totalVectorNumber,totalFrameNumber);

if SR_AnalysisCheck~=0
    h = waitbar(0,'Evaluating Length & Angle..');
   for nvec=1:totalVectorNumber
    waitbar(nvec / (totalVectorNumber));
     sPoint=xLL(nvec,1);  % xLL and yLL exactly the same
     ePoint=xLL(nvec,2);
     % manupilate coordinate here!  
     xs=xc(sPoint,:);
     xe=xc(ePoint,:);
     ys=yc(sPoint,:);
     ye=yc(ePoint,:);
 
     VecLength(nvec,:)=sqrt((xe-xs).^2+(ye-ys).^2);
     
     %%%%%%  updated ! 11/20/2014  %%%%%%%
     %VecRotation(nvec,:)=atan((ye-ys)./(xe-xs));
     for nf=1:totalFrameNumber
              xcrd10=xe(nf)-xs(nf); 
              ycrd10=ye(nf)-ys(nf);
              VecRotation(nvec,nf)=angle_eval_func(xcrd10,ycrd10);
     end
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   end
   delete(h)
end

handles.VecLength=VecLength;
handles.VecRotation=VecRotation;
guidata(hObject, handles);

% --- Executes on button press in dataSave_BT.
function dataSave_BT_Callback(hObject, eventdata, handles)
% hObject    handle to dataSave_BT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dataSave_BTCheck=round(get(handles.dataSave_BT,'Value'));
%x1=(handles.x1)';
%y1=(handles.y1)';

%Coordinate conversion from image coordinate to x-y cooridnate
% image cooridnate: start from Upper Left corner  (+x: right,+y down)
% x-y cooridnate: start from Lower Left corner  (+x: right,+y up)

xc=(handles.x1)';
yc=handles.vidHeight-(handles.y1)'+1;


sampleRate=1/handles.FrameRate;
totalFrameNumber=handles.eframe;
frameVector=[1:totalFrameNumber]';
timeVector=(frameVector-1)*sampleRate;
totalPointNumber=handles.totalPointNumber;
%handles.objectRatio;
%totalVectorNumber=handles.totalVectorNumber

% set up total data matix for tracked point
totalPointMTX=zeros(totalFrameNumber,totalPointNumber*2);
for np=1:totalPointNumber
  xcol=(np-1)*2+1;
  ycol=xcol+1;
  totalPointMTX(:,xcol)=xc(:,np);
  totalPointMTX(:,ycol)=yc(:,np);
end

% unit conversion from pixel to real dimention
convPointMTX=totalPointMTX*handles.objectRatio;

%if dataSave_BTCheck~=0

[pathName,fileName,fileExt]=fileparts(handles.fName);
    % mat file saving
    mat_fName=[pathName,'\',fileName,'.mat'];
    save([mat_fName], 'handles')
    % excel data saving
    xls_fName=[pathName,'\',fileName,'.xls'];
    
    % ColorVec=['b','r','y','c','m','g','w']; 7 data max
    
    %%%% STORING point data
    % sheet 1 point tracking result
    sheet1_header1={'Point','Tracking','Result','(ORIGINAL pixel data'};
    sheet1_header2={'Meter/Pixel Ratio ='};
    sheet1_header3={'Frame No.','Time(sec)','p1_x(Blue)','p1_y(Blue)',...
        'p2_x(Red)','p2_y(Red)','p3_x(Yellow)','p3_y(Yellow)',.......
        'p4_x(Cyan)','p4_y(Cyan)','p5_x(Magenta)','p5_y(Magenta)',....
        'p6_x(Green)','p6_y(Green)','p7_x(White)','p7_y(White)'};
    
    xlswrite([xls_fName],sheet1_header1,'Sheet1','A1');
    
    xlswrite([xls_fName],sheet1_header2,'Sheet1','A2');
    xlswrite([xls_fName],handles.objectRatio,'Sheet1','D2');
    
    xlswrite([xls_fName],sheet1_header3(1:2+2*totalPointNumber),'Sheet1','A3');
    xlswrite([xls_fName],frameVector,'Sheet1','A4');
    xlswrite([xls_fName],timeVector,'Sheet1','B4');
    xlswrite([xls_fName],totalPointMTX,'Sheet1','C4');
   
    %{
    sheet2_header1={'Point','Tracking','Result','(Data with meter unit'};
    xlswrite([xls_fName],sheet2_header1,'Sheet2','A1');
    xlswrite([xls_fName],sheet1_header2(1:2+2*totalPointNumber),'Sheet2','A2');
    xlswrite([xls_fName],frameVector,'Sheet2','A3');
    xlswrite([xls_fName],timeVector,'Sheet2','B3');
    xlswrite([xls_fName],convPointMTX,'Sheet2','C3');
    %}
    
    %%%%%%%%%%%%%%%%%%%%%%%
    
    %%%% STORING point data
    VecL=handles.VecLength';
    VecR=handles.VecRotation';
    totalVectorNumber=handles.totalVectorNumber;
    
    % set up total data matix for tracked vectors  
    totalVectorMTX=zeros(totalFrameNumber,totalVectorNumber*2);
    for nv=1:totalVectorNumber
        xcol=(nv-1)*2+1;
        ycol=xcol+1;
        totalVectorMTX(:,xcol)=VecL(:,nv);
        totalVectorMTX(:,ycol)=VecR(:,nv);
    end

   %%%% STORING vector data
    % sheet 2 
    sheet2_header1={'Vector','Tracking','Result','(ORIGINAL pixel data'};
    sheet2_header2={'Meter/Pixel Ratio ='};
    sheet2_header3={'Frame No.','Time(sec)','V1_Length(Blue)','V1_angle(Blue)',...
        'V2_Length(Red)','V2_angle(Red)','V3_Length(Yellow)','V3_angle(Yellow)',.......
        'V4_Length(Cyan)','V4_angle(Cyan)','V5_Length(Magenta)','V5_angle(Magenta)',....
        'V6_Length(Green)','V7_angle(Green)','V7_Length(White)','V7_angle(White)'};
    
    xlswrite([xls_fName],sheet2_header1,'Sheet2','A1');
    
    xlswrite([xls_fName],sheet2_header2,'Sheet2','A2');
    xlswrite([xls_fName],handles.objectRatio,'Sheet2','D2');
    
    xlswrite([xls_fName],sheet2_header3(1:2+2*totalVectorNumber),'Sheet2','A3');
    xlswrite([xls_fName],frameVector,'Sheet2','A4');
    xlswrite([xls_fName],timeVector,'Sheet2','B4');
    xlswrite([xls_fName],totalVectorMTX,'Sheet2','C4');
    
% end

guidata(hObject, handles);


% --- Executes on button press in pointON_BT.
function pointON_BT_Callback(hObject, eventdata, handles)
% hObject    handle to pointON_BT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pointON_BT
handles.pointON_BT_CHECK = get(handles.pointON_BT, 'Value')
guidata(hObject, handles);

% --- Executes on button press in vectorON_BT.
function vectorON_BT_Callback(hObject, eventdata, handles)
% hObject    handle to vectorON_BT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of vectorON_BT
handles.vectorON_BT_CHECK = 2*get(handles.vectorON_BT, 'Value')
guidata(hObject, handles);


% --- Executes on button press in objectMeasureBT.
function objectMeasureBT_Callback(hObject, eventdata, handles)
% hObject    handle to objectMeasureBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
objectMeasureCheck=round(get(handles.objectMeasureBT,'Value'));
ColorVec=handles.ColorVec;
totalMeasureNumber=3;
eLength=0
for nMeasure=1:totalMeasureNumber
    %msg=['No.',num2str(nvec),'Vector be defined!'];
    %h=warndlg(msg);
    
    [xLine, yLine] = getline % 10:53am 9/30
    element=sqrt((xLine(1)-xLine(2))^2+(yLine(1)-yLine(2))^2);
    eLength=eLength+element;
    %{
    [xLine, yLine,entryVec]=lineadjust_func(xLine,yLine,x1(:,1),y1(:,1))
    xLL(nvec,:)=entryVec(:);
    yLL(nvec,:)=entryVec(:);
    LinePattern=[ColorVec(nvec),'--']
    plot(xLine,yLine,LinePattern);
    EndPattern=[ColorVec(nvec),'x']
    plot(xLine(2),yLine(2),EndPattern)
    %}
end
handles.meanLength=eLength/totalMeasureNumber;
guidata(hObject, handles);


function ObjectSize_Callback(hObject, eventdata, handles)
% hObject    handle to ObjectSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ObjectSize as text
%        str2double(get(hObject,'String')) returns contents of ObjectSize as a double
handles.objectsize=str2num(get(handles.ObjectSize,'String'));
handles.objectRatio=handles.objectsize/handles.meanLength;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function ObjectSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ObjectSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
