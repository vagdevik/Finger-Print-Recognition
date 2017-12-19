function varargout = a(varargin)
% A MATLAB code for a.fig
%      A, by itself, creates a new A or raises the existing
%      singleton*.
%
%      H = A returns the handle to a new A or the handle to
%      the existing singleton*.
%
%      A('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in A.M with the given input arguments.
%
%      A('Property','Value',...) creates a new A or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before a_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to a_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help a

% Last Modified by GUIDE v2.5 12-Nov-2016 11:56:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @a_OpeningFcn, ...
                   'gui_OutputFcn',  @a_OutputFcn, ...
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


% --- Executes just before a is made visible.
function a_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to a (see VARARGIN)

% Choose default command line output for a
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes a wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = a_OutputFcn(hObject, eventdata, handles) 
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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



addpath(genpath(pwd));
%% BUILD FINGERPRINT TEMPLATE DATABASE
% build_db(9,8);        %THIS WILL TAKE ABOUT 30 MINUTES
load('db.mat');

%% EXTRACT FEATURES FROM AN ARBITRARY FINGERPRINT
val=char(get(handles.edit1,'String'));
try
filename=strcat('C:\Users\G. ADITYA\Desktop\Code\FVC2002\DB1_B\',val,'.tif');
img = imread(filename);
axes(handles.axes1);
imshow(img);

if ndims(img) == 3; 
  img = rgb2gray(img); 
end  % Color Images
disp(['Extracting features from ' filename ' ...']);
ffnew=ext_finger(img,1);

%% FOR EACH FINGERPRINT TEMPLATE, CALCULATE MATCHING SCORE IN COMPARISION WITH FIRST ONE
S=zeros(72,1);
m=[];
for i=1:72
    second=['10' num2str(fix((i-1)/8)+1) '_' num2str(mod(i-1,8)+1)];
    filename1=strcat('C:\Users\G. ADITYA\Desktop\Code\FVC2002\DB1_B\',second,'.tif');
    img1 = imread(filename1);
axes(handles.axes2);
imshow(img1);
    fprintf(['Computing similarity between ' filename ' and ' second ' from FVC2002 : ']);
    S(i)=match(ffnew,ff{i});
    m='Matched';
    nm='Not Matched';
 if S(i)>0.48
     set(handles.edit6,'string',m);
 else
     set(handles.edit6,'string',nm); 
 end
    fprintf([num2str(S(i)) '\n']);
    drawnow
end
%% OFFER MATCHED FINGERPRINTS
Matched_FigerPrints=num2str(find(S>0.48));


 set(handles.listbox2,'string',Matched_FigerPrints); 
catch
    warning('Data base is not present');
end
 

% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2




% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
