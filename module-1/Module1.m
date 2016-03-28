function varargout = Module1(varargin)
% MODULE1 MATLAB code for Module1.fig
%      MODULE1, by itself, creates a new MODULE1 or raises the existing
%      singleton*.
%
%      H = MODULE1 returns the handle to a new MODULE1 or the handle to
%      the existing singleton*.
%
%      MODULE1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MODULE1.M with the given input arguments.
%
%      MODULE1('Property','Value',...) creates a new MODULE1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Module1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Module1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Module1

% Last Modified by GUIDE v2.5 05-Mar-2016 20:20:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Module1_OpeningFcn, ...
                   'gui_OutputFcn',  @Module1_OutputFcn, ...
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


% --- Executes just before Module1 is made visible.
function Module1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Module1 (see VARARGIN)

% Choose default command line output for Module1
handles.output = hObject;

% define some variables
handles.filename = []; % filename of the image
handles.name = [];

% Update handles structure
guidata(hObject, handles);

% GUI initialization
set(handles.AxesRGBImage, 'Visible', 'Off');
set(handles.AxesOutGrayImage, 'Visible', 'Off');
set(handles.AxesOutPColorImage, 'Visible', 'Off');
set(handles.AxesEvaluation, 'Visible', 'Off');

% disable start button
set(handles.btStart, 'Enable', 'Off');
set(handles.editEvaluation, 'Enable', 'Off');


% UIWAIT makes Module1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Module1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% Maximize the window via undocumented Java call.
% Reference: http://undocumentedmatlab.com/blog/minimize-maximize-figure-window
 MaximizeFigureWindow; 


% --- Executes on selection change in popMenuMethods.
function popMenuMethods_Callback(hObject, eventdata, handles)
% hObject    handle to popMenuMethods (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popMenuMethods contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popMenuMethods


% --- Executes during object creation, after setting all properties.
function popMenuMethods_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popMenuMethods (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popMenuEvaluation.
function popMenuEvaluation_Callback(hObject, eventdata, handles)
% hObject    handle to popMenuEvaluation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popMenuEvaluation contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popMenuEvaluation


% --- Executes during object creation, after setting all properties.
function popMenuEvaluation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popMenuEvaluation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btStart.
function btStart_Callback(hObject, eventdata, handles)
% hObject    handle to btStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% check whether everything is ready
status = get(handles.popMenuMethods, 'Enable');
if (strcmp(status, 'On'))
    warndlg(sprintf('Please confirm the inputs first!'), 'Runtime Error');
else
    % disable the three buttons
    set(handles.btClear, 'Enable', 'Off');
    set(handles.btReset, 'Enable', 'Off');
    
    % read current selected method
    strList = get(handles.popMenuMethods, 'String');
    strVal = get(handles.popMenuMethods, 'Value');
    method = strList{strVal};
    
    % parse color space
    cList = get(handles.popMenuColorSpace, 'String');
    cVal = get(handles.popMenuColorSpace, 'Value');
    colorSpace = cList{cVal};
    
    % define colormap
    mapGray = [0 0 0; 0.5 0.5 0.5; 1 1 1];
    mapColor = [0, 0, 255;204, 0, 0; 255 255 255] / 255;
    
    if strcmp(method, 'GMMs-EM') 
        % parse initial means
        A = get(handles.editInitMeans, 'String');
        B = strrep(A, ';', ' ');
        C = char(strsplit(B));
        D = reshape(str2num(C), [], 3)';
        if strcmp(colorSpace, 'RGB')
            D = D / 255;
        end
        if strcmp(colorSpace, 'HSV')
            D = [0.75177 0.51648 0.35686; 0.93791 0.3088 0.86; 0.1666 0.012 0.97];
        end
        
        if strcmp(colorSpace, 'Lab')
            D = [27 24 -20; 60 30 -2; 94 0 0];
        end
        
        
        % GMMs-EM
        t0 = cputime;
        [outputImage, image] = GMMSegmentationFast(handles.filename, D, colorSpace);
        t1 = cputime;
        gmmsTime = t1 - t0;
        
        % visualize results
        axes(handles.AxesRGBImage);
        imshow(image);
        
        axes(handles.AxesOutGrayImage);
        imshow(outputImage, []), colormap(handles.AxesOutGrayImage, mapGray);
        
        axes(handles.AxesOutPColorImage);
        imshow(outputImage, []), colormap(handles.AxesOutPColorImage, mapColor);
        
        gtName = [handles.filename '.GTfile.mat'];
        gt = load(gtName);
        gt = gt.idxMap;
        axes(handles.AxesEvaluation);
        imshow(outputImage - gt, []);
        
        % evaluate results
        [pri, gce, acc] = evaluate(gt, outputImage);
        evaString = sprintf('Accuracy: %f Time: %fs PRI: %f GCE: %f', acc, gmmsTime, pri, gce);
%         str = {'Time: '; 'PRI: '; 'GCE:'};
%         M = [gmmsTime; pri; gce];
%         B = cat(2, cellstr(str), num2cell(M))';
% 
%         evaString = sprintf(1, '%s %4.2f\n', B{:});
        set(handles.editEvaluation, 'String', evaString); 
        
    else
        % read the ground truth matrix
        strList = get(handles.popMenukNN, 'String');
        strVal = get(handles.popMenukNN, 'Value');
        mode = strList{strVal};
        GT = [];              
        image = im2double(imread(handles.filename));
        if strcmp(colorSpace, 'RGB')
            I=image;
            if strcmp(mode, '450')
                A = open('RGB_GT1.mat');
                GT = A.GTmat;
            else
                A = open('RGB_GT2.mat');
                GT = A.GTmatrix;
            end   
        elseif strcmp(colorSpace, 'Lab')
            I=rgb2lab(image);
            if strcmp(mode, '450')
                A = open('Lab_GT1.mat');
                GT = A.LabGT1;
            else
                A = open('Lab_GT2.mat');
                GT = A.LabGT2;
            end 
        else
            I=rgb2hsv(image);
            if strcmp(mode, '450')
                A = open('HSV_GT1.mat');
                GT = A.HSV_GT1;
            else
                A = open('HSV_GT2.mat');
                GT = A.HSV_GT2;
            end 
        end
        
        % parse the number of neighborhood
        nrNN = str2num(get(handles.editkNN, 'String'));
        
        % apply kNN here
        
        t0 = cputime;
%         model = train_knn(GT, nrNN);
%         segmented = segment_knn(model, I);
        S =  segmentColor(nrNN, GT, I);
        t1 = cputime;
        timekNN = t1 - t0;
        
%         S = reshape(segmented, [size(I, 1), size(I, 2)]);
        
        % visualize results
        axes(handles.AxesRGBImage);
        imshow(image);
        
        axes(handles.AxesOutGrayImage);
        imshow(S, []), colormap(handles.AxesOutGrayImage, mapGray);
        
        axes(handles.AxesOutPColorImage);
        imshow(S, []), colormap(handles.AxesOutPColorImage, mapColor);
        
        gtName = [handles.filename '.GTfile.mat'];
        gt = load(gtName);
        gt = gt.idxMap;
        axes(handles.AxesEvaluation);
        imshow(S - gt, []);
        
        % evaluate
        [pri, gce, acc] = evaluate(gt, S);
        evaString = sprintf('Accuracy: %f Time: %fs PRI: %f GCE: %f', acc, timekNN, pri, gce);
%         str = {'Time: '; 'PRI: '; 'GCE:'};
%         M = [timekNN; pri; gce];
%         B = cat(2, cellstr(str), num2cell(M))';
% 
%         evaString = sprintf(1, '%s %4.2f\n', B{:});
        set(handles.editEvaluation, 'String', evaString);
        
    end
    
    % enable the three buttons
    set(handles.btClear, 'Enable', 'On');
    set(handles.btReset, 'Enable', 'On');
    
end


% --- Executes on button press in btReset.
function btReset_Callback(hObject, eventdata, handles)
% hObject    handle to btReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% define some variables
handles.filename = []; % filename of the image
handles.name = [];

% Update handles structure
guidata(hObject, handles);

% clear axes
cla(handles.AxesRGBImage);
cla(handles.AxesOutGrayImage);
cla(handles.AxesOutPColorImage);
cla(handles.AxesEvaluation);

% reset button status
set(handles.btStart, 'Enable', 'Off');
set(handles.btConfirm, 'Enable', 'On');
set(handles.btSelect, 'Enable', 'On');

% reset others
set(handles.editInitMeans, 'Enable', 'On');
set(handles.popMenuColorSpace, 'Enable', 'On');
set(handles.popMenuMethods, 'Enable', 'On');

set(handles.text7, 'String', '');


% --- Executes on button press in btConfirm.
function btConfirm_Callback(hObject, eventdata, handles)
% hObject    handle to btConfirm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% if no image is selected, show a warning dialog
if isempty(handles.filename)
    warndlg(sprintf('Please select an image!'), 'Runtime Error');
else   
    % disable all pop menus and  text edits
    set(handles.popMenuMethods, 'Enable', 'Off');
    set(handles.popMenuColorSpace, 'Enable', 'Off');
    set(handles.editInitMeans, 'Enable', 'Off');

    % disable the button for selecting the image
    set(handles.btSelect, 'Enable', 'Off');

    % enable the start button
    set(handles.btStart, 'Enable', 'On');
    
    % disable itself
    set(handles.btConfirm, 'Enable', 'Off');
    
end

% --- Executes on button press in btClear.
function btClear_Callback(hObject, eventdata, handles)
% hObject    handle to btClear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% enable all pop menus, text edits and button for selecting the image
set(handles.btSelect, 'Enable', 'On');
set(handles.popMenuMethods, 'Enable', 'On');
set(handles.popMenuColorSpace, 'Enable', 'On');
set(handles.editInitMeans, 'Enable', 'On');

% disable the start button
set(handles.btStart, 'Enable', 'Off');
set(handles.btConfirm, 'Enable', 'On');


% --- Executes on button press in btSelect.
function btSelect_Callback(hObject, eventdata, handles)
% hObject    handle to btSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% load the filename and path name of a selected image
[FileName, PathName] = uigetfile('*.png', 'Select an image');

% check whether the image exists and wether the image is PNG
extentionIdx = strfind(FileName, '.');
if ~exist([PathName FileName], 'file')
    warndlg(sprintf('The image does not exist!'), 'Runtime Error');
elseif ~strcmp(FileName(extentionIdx:end), '.png')
    warndlg(sprintf('The image type is not PNG!'), 'Runtime Error');
else
    % display the infomation of the selected image
    index = strfind(PathName, 'Dataset');
    imageInfo = [PathName(index:end) FileName];
    position = get(handles.text7, 'Position');
    set(handles.text7, 'Position', [position(1) position(2) length(imageInfo)+8 position(4)]);
    set(handles.text7, 'String', imageInfo);

    % pass the filename and path name of the selected image
    handles.filename = [PathName FileName];
    handles.name = FileName;
    guidata(hObject, handles);
    
    set(handles.btConfirm, 'Enable', 'On');
end

function editInitMeans_Callback(hObject, eventdata, handles)
% hObject    handle to editInitMeans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editInitMeans as text
%        str2double(get(hObject,'String')) returns contents of editInitMeans as a double


% --- Executes during object creation, after setting all properties.
function editInitMeans_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editInitMeans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popMenuColorSpace.
function popMenuColorSpace_Callback(hObject, eventdata, handles)
% hObject    handle to popMenuColorSpace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popMenuColorSpace contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popMenuColorSpace


% --- Executes during object creation, after setting all properties.
function popMenuColorSpace_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popMenuColorSpace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editEvaluation_Callback(hObject, eventdata, handles)
% hObject    handle to editEvaluation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editEvaluation as text
%        str2double(get(hObject,'String')) returns contents of editEvaluation as a double


% --- Executes during object creation, after setting all properties.
function editEvaluation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editEvaluation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editkNN_Callback(hObject, eventdata, handles)
% hObject    handle to editkNN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editkNN as text
%        str2double(get(hObject,'String')) returns contents of editkNN as a double


% --- Executes during object creation, after setting all properties.
function editkNN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editkNN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popMenukNN.
function popMenukNN_Callback(hObject, eventdata, handles)
% hObject    handle to popMenukNN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popMenukNN contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popMenukNN


% --- Executes during object creation, after setting all properties.
function popMenukNN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popMenukNN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
