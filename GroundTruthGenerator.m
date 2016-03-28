function varargout = GroundTruthGenerator(varargin)
% GROUNDTRUTHGENERATOR MATLAB code for GroundTruthGenerator.fig
%      GROUNDTRUTHGENERATOR, by itself, creates a new GROUNDTRUTHGENERATOR or raises the existing
%      singleton*.
%
%      H = GROUNDTRUTHGENERATOR returns the handle to a new GROUNDTRUTHGENERATOR or the handle to
%      the existing singleton*.
%
%      GROUNDTRUTHGENERATOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GROUNDTRUTHGENERATOR.M with the given input arguments.
%
%      GROUNDTRUTHGENERATOR('Property','Value',...) creates a new GROUNDTRUTHGENERATOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GroundTruthGenerator_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GroundTruthGenerator_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GroundTruthGenerator

% Last Modified by GUIDE v2.5 09-Mar-2016 20:30:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GroundTruthGenerator_OpeningFcn, ...
                   'gui_OutputFcn',  @GroundTruthGenerator_OutputFcn, ...
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


% --- Executes just before GroundTruthGenerator is made visible.
function GroundTruthGenerator_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GroundTruthGenerator (see VARARGIN)

% Choose default command line output for GroundTruthGenerator
handles.output = hObject;

% Update handles structure
handles.rgbImage = [];
handles.colors = [];
handles.filename = [];
handles.idxMap = [];
handles.allcolors = [];
handles.inc = 0;
handles.newfilename=[];
handles.Necrosis_images=cell(1,100);
handles.Stroma_images=cell(1,100);
handles.Tumor_images=cell(1,100);

% Update handles structure
guidata(hObject, handles);

% diable some buttons
set(handles.btSelectPixels, 'Enable', 'Off');
set(handles.btStart, 'Enable', 'Off');
set(handles.btClear, 'Enable', 'Off');
set(handles.btReset, 'Enable', 'Off');
set(handles.btSave, 'Enable', 'Off');



% UIWAIT makes GroundTruthGenerator wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GroundTruthGenerator_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btSelectImage.
function btSelectImage_Callback(hObject, eventdata, handles)
% hObject    handle to btSelectImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% open an image file
[FileName, PathName] = uigetfile('*.png', 'Select an image');

% pass the filename and path name of the selected image
rgbImage = im2double(imread([PathName FileName]));
axes(handles.axes1);
imshow(rgbImage);

% Update handles structure
handles.rgbImage = rgbImage;
handles.filename = FileName;

% update handles
guidata(hObject, handles);

set(handles.btSelectImage, 'Enable', 'Off');
set(handles.btSelectPixels, 'Enable', 'On');
set(handles.btClear, 'Enable', 'On');
set(handles.btReset, 'Enable', 'On');


% --- Executes on button press in btSave.
function btSave_Callback(hObject, eventdata, handles)
% hObject    handle to btSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% [file, path] = uiputfile(handles.filename, 'Save ground truth');
% imwrite(handles.idxMap, [path file]);
idxMap = handles.idxMap;
newfilename=handles.newfilename;
GTmat = fullfile(newfilename);
save(GTmat, 'idxMap');



% --- Executes on button press in btReset.
function btReset_Callback(hObject, eventdata, handles)
% hObject    handle to btReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Update handles structure
handles.rgbImage = [];
handles.colors = [];
handles.idxMap = [];
handles.filename = [];
guidata(hObject, handles);

cla(handles.axes2);
cla(handles.axes1);

% diable some buttons
set(handles.btSelectPixels, 'Enable', 'Off');
set(handles.btStart, 'Enable', 'Off');
set(handles.btClear, 'Enable', 'Off');
set(handles.btReset, 'Enable', 'Off');
set(handles.btSave, 'Enable', 'Off');
set(handles.btSelectImage, 'Enable', 'On');

set(handles.sliderWN, 'Enable', 'Off');
set(handles.sliderWC, 'Enable', 'Off');
set(handles.sliderWB, 'Enable', 'Off');


% --- Executes on button press in btClear.
function btClear_Callback(hObject, eventdata, handles)
% hObject    handle to btClear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla(handles.axes2);
cla(handles.axes1);
axes(handles.axes1);
imshow(handles.rgbImage);

% update handles
handles.colors = [];
handles.idxMap = [];
guidata(hObject, handles);

set(handles.btSelectPixels, 'Enable', 'On');
set(handles.btStart, 'Enable', 'Off');
set(handles.btSave, 'Enable', 'Off');

set(handles.sliderWN, 'Enable', 'Off');
set(handles.sliderWC, 'Enable', 'Off');
set(handles.sliderWB, 'Enable', 'Off');


% --- Executes on button press in btSelectPixels.
function btSelectPixels_Callback(hObject, eventdata, handles)
% hObject    handle to btSelectPixels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% select three reference pixels
[cn, rn] = ginput(1); % nuclei
cn = floor(cn);
rn = floor(rn);
colorN = reshape(handles.rgbImage(floor(rn), cn, :), [3, 1]);
hold on 
scatter(cn, rn, '*', 'r');

[cc, rc] = ginput(1); % cytoplasma
cc = floor(cc);
rc = floor(rc);
colorC = reshape(handles.rgbImage(rc, cc, :), [3, 1]);
hold on 
scatter(cc, rc, '*', 'b');

[cb, rb] = ginput(1); % background
cb = floor(cb);
rb = floor(rb);
colorB = reshape(handles.rgbImage(rb, cb, :), [3, 1]);
hold on 
scatter(cb, rb, '*', 'k');

colors = [colorN colorC colorB];
handles.colors = colors;
guidata(hObject, handles);
handles.allcolors = [handles.allcolors ; [colorN' 1; colorC' 2; colorB' 3]];
guidata(hObject, handles);

set(handles.btSelectPixels, 'Enable', 'Off');
set(handles.btStart, 'Enable', 'On');

set(handles.sliderWN, 'Enable', 'On');
set(handles.sliderWC, 'Enable', 'On');
set(handles.sliderWB, 'Enable', 'On');



% --- Executes on slider movement.
function sliderWN_Callback(hObject, eventdata, handles)
% hObject    handle to sliderWN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function sliderWN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderWN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sliderWC_Callback(hObject, eventdata, handles)
% hObject    handle to sliderWC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function sliderWC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderWC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sliderWB_Callback(hObject, eventdata, handles)
% hObject    handle to sliderWB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function sliderWB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderWB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in btStart.
function btStart_Callback(hObject, eventdata, handles)
% hObject    handle to btStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% disable all buttons
set(handles.btSave, 'Enable', 'Off');
set(handles.btClear, 'Enable', 'Off');
set(handles.btReset, 'Enable', 'Off');

set(handles.sliderWN, 'Enable', 'Off');
set(handles.sliderWC, 'Enable', 'Off');
set(handles.sliderWB, 'Enable', 'Off');

% read weights from sliders
wN = get(handles.sliderWN, 'value');
wC = get(handles.sliderWC, 'value');
wB = get(handles.sliderWB, 'value');

w = [wN; wC; wB];

% calculate ground truth image
color = reshape(handles.rgbImage, [512*512, 3])';
ww = repmat(w, 1, 512 * 512);
table = zeros(3, 512*512);
for k = 1:3
    colorRef = repmat(handles.colors(:, k), 1, 512 * 512);
    table(k, :) = sum(ww .* (color - colorRef).^2, 1);
end
[~, minIdx] = min(table, [], 1);
idxMap = reshape(minIdx, [512, 512]);

% show ground truth image
axes(handles.axes2);
imshow(idxMap, []), axis image, colormap('jet');

% update data
handles.idxMap = idxMap;
guidata(hObject, handles);

% enable all buttons
set(handles.btSave, 'Enable', 'On');
set(handles.btClear, 'Enable', 'On');
set(handles.btReset, 'Enable', 'On');

set(handles.sliderWN, 'Enable', 'On');
set(handles.sliderWC, 'Enable', 'On');
set(handles.sliderWB, 'Enable', 'On');


function fctswitch(hObject, eventdata, handles)

    if handles.inc <= 50;
        rgbImage=im2double(handles.Necrosis_images{handles.inc});
        axes(handles.axes1);
        imshow(rgbImage)
        handles.ImgTitle=title(sprintf('Necrosis %d.png',handles.inc));
        handles.rgbImage = rgbImage;
        handles.newfilename = sprintf('Necrosis%d.GTfile.mat', handles.inc + 50);
        guidata(hObject, handles);
        
    elseif handles.inc <= 100
        k=handles.inc-50;
        rgbImage=im2double(handles.Stroma_images{k});
        axes(handles.axes1);
        imshow(rgbImage)
        handles.ImgTitle=title(sprintf('Stroma %d.png',k));
        handles.rgbImage = rgbImage;
        handles.newfilename = sprintf('Stroma%d.GTfile.mat', handles.inc );
        guidata(hObject, handles);
        
    elseif handles.inc <= 150
        k=handles.inc-100;
        rgbImage=im2double(handles.Tumor_images{k});
        axes(handles.axes1);
        imshow(rgbImage)
        handles.ImgTitle=title(sprintf('Tumor %d.png',k));
        handles.rgbImage = rgbImage;
        handles.newfilename = sprintf('Tumor%d.GTfile.mat', handles.inc - 50);        
        guidata(hObject, handles);
    end

% set(handles.btSelectImage, 'Enable', 'Off');
set(handles.btSelectPixels, 'Enable', 'On');
set(handles.btClear, 'Enable', 'On');
set(handles.btReset, 'Enable', 'On');


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.inc+1 <= 150;
    handles.inc=handles.inc+1;  % incrementing the counter
else 
    msgbox('Your Ground Truth matrix is ready !', 'Information Box')
end
guidata(hObject, handles);
fctswitch(hObject, eventdata, handles)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

guidata(hObject, handles);
for i=51:100
    handles.Necrosis_images{i-50}=imread(sprintf('Dataset1/Necrosis_%d.png',i));
    guidata(hObject, handles);
    handles.Stroma_images{i-50}=imread(sprintf('Dataset1/Stroma_%d.png',i));
    guidata(hObject, handles);
    handles.Tumor_images{i-50}=imread(sprintf('Dataset1/Tumor_%d.png',i));
    guidata(hObject, handles);
end

msgbox('Images are ready','Information Box');
