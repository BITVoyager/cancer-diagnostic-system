function varargout = ColorPicker(varargin)
% COLORPICKER MATLAB code for ColorPicker.fig
%      COLORPICKER, by itself, creates a new COLORPICKER or raises the existing
%      singleton*.
%
%      H = COLORPICKER returns the handle to a new COLORPICKER or the handle to
%      the existing singleton*.
%
%      COLORPICKER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COLORPICKER.M with the given input arguments.
%
%      COLORPICKER('Property','Value',...) creates a new COLORPICKER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ColorPicker_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ColorPicker_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ColorPicker

% Last Modified by GUIDE v2.5 27-Feb-2016 13:16:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ColorPicker_OpeningFcn, ...
                   'gui_OutputFcn',  @ColorPicker_OutputFcn, ...
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


% --- Executes just before ColorPicker is made visible.
function ColorPicker_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ColorPicker (see VARARGIN)

% Choose default command line output for ColorPicker
handles.output = hObject;
handles.rgbImage = [];
handles.hsvImage = [];

% Update handles structure
guidata(hObject, handles);

% diable some buttons
set(handles.btSelectPixel, 'Enable', 'Off');
set(handles.btClear, 'Enable', 'Off');
set(handles.btReset, 'Enable', 'Off');


% UIWAIT makes ColorPicker wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ColorPicker_OutputFcn(hObject, eventdata, handles) 
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
image = imread([PathName FileName]);
[rgbImage, ~, ~] = normalizeColor(image, 240);
imshow(rgbImage);

% Update handles structure
handles.rgbImage = rgbImage;

% convert the image to HSV
hsvImage = rgb2hsv(rgbImage);
handles.hsvImage = hsvImage;

% update handles
guidata(hObject, handles);

% enable some buttons
set(handles.btSelectPixel, 'Enable', 'On');
set(handles.btClear, 'Enable', 'On');
set(handles.btReset, 'Enable', 'On');

% disable itself
set(handles.btSelectImage, 'Enable', 'Off');

% --- Executes on button press in btSelectPixel.
function btSelectPixel_Callback(hObject, eventdata, handles)
% hObject    handle to btSelectPixel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[c, r] = ginput(1)

r = floor(r);
c = floor(c);
if r > size(handles.rgbImage, 1)
    r = 512;
end
if r < 1
    r = 1;
end

if c > size(handles.rgbImage, 2)
    c = 512;
end
if c < 1
    c = 1;
end


% show results
set(handles.editR, 'String', num2str(handles.rgbImage(r, c, 1)));
set(handles.editG, 'String', num2str(handles.rgbImage(r, c, 2)));
set(handles.editB, 'String', num2str(handles.rgbImage(r, c, 3)));

lab = rgb2lab(handles.rgbImage(r, c, :));
set(handles.editL, 'String', num2str(lab(1)));
set(handles.edita, 'String', num2str(lab(2)));
set(handles.editb, 'String', num2str(lab(3)));

set(handles.editH, 'String', num2str(handles.hsvImage(r, c, 1)));
set(handles.editS, 'String', num2str(handles.hsvImage(r, c, 2)));
set(handles.editV, 'String', num2str(handles.hsvImage(r, c, 3)));


% --- Executes on button press in btReset.
function btReset_Callback(hObject, eventdata, handles)
% hObject    handle to btReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% clear axes1
cla(handles.axes1);
handles.image = [];
guidata(hObject, handles);

% clear text edits
set(handles.editR, 'String', '');
set(handles.editG, 'String', '');
set(handles.editB, 'String', '');
set(handles.editL, 'String', '');
set(handles.edita, 'String', '');
set(handles.editb, 'String', '');
set(handles.editH, 'String', '');
set(handles.editS, 'String', '');
set(handles.editV, 'String', '');

% diable some buttons
set(handles.btSelectPixel, 'Enable', 'Off');
set(handles.btClear, 'Enable', 'Off');
set(handles.btReset, 'Enable', 'Off');

% enable button for image selecting
set(handles.btSelectImage, 'Enable', 'On');


% --- Executes on button press in btClear.
function btClear_Callback(hObject, eventdata, handles)
% hObject    handle to btClear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% clear axes1
cla(handles.axes1);

% clear text edits
set(handles.editR, 'String', '');
set(handles.editG, 'String', '');
set(handles.editB, 'String', '');
set(handles.editL, 'String', '');
set(handles.edita, 'String', '');
set(handles.editb, 'String', '');
set(handles.editH, 'String', '');
set(handles.editS, 'String', '');
set(handles.editV, 'String', '');

% show image again
imshow(handles.rgbImage);




function editR_Callback(hObject, eventdata, handles)
% hObject    handle to editR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editR as text
%        str2double(get(hObject,'String')) returns contents of editR as a double


% --- Executes during object creation, after setting all properties.
function editR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editG_Callback(hObject, eventdata, handles)
% hObject    handle to editG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editG as text
%        str2double(get(hObject,'String')) returns contents of editG as a double


% --- Executes during object creation, after setting all properties.
function editG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editB_Callback(hObject, eventdata, handles)
% hObject    handle to editB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editB as text
%        str2double(get(hObject,'String')) returns contents of editB as a double


% --- Executes during object creation, after setting all properties.
function editB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editL_Callback(hObject, eventdata, handles)
% hObject    handle to editL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editL as text
%        str2double(get(hObject,'String')) returns contents of editL as a double


% --- Executes during object creation, after setting all properties.
function editL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edita_Callback(hObject, eventdata, handles)
% hObject    handle to edita (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edita as text
%        str2double(get(hObject,'String')) returns contents of edita as a double


% --- Executes during object creation, after setting all properties.
function edita_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edita (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editb_Callback(hObject, eventdata, handles)
% hObject    handle to editb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editb as text
%        str2double(get(hObject,'String')) returns contents of editb as a double


% --- Executes during object creation, after setting all properties.
function editb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editH_Callback(hObject, eventdata, handles)
% hObject    handle to editH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editH as text
%        str2double(get(hObject,'String')) returns contents of editH as a double


% --- Executes during object creation, after setting all properties.
function editH_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editS_Callback(hObject, eventdata, handles)
% hObject    handle to editS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editS as text
%        str2double(get(hObject,'String')) returns contents of editS as a double


% --- Executes during object creation, after setting all properties.
function editS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editV_Callback(hObject, eventdata, handles)
% hObject    handle to editV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editV as text
%        str2double(get(hObject,'String')) returns contents of editV as a double


% --- Executes during object creation, after setting all properties.
function editV_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
