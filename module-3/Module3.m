function varargout = Module3(varargin)

% MODULE3 MATLAB code for Module3.fig
%      MODULE3, by itself, creates a new MODULE3 or raises the existing
%      singleton*.
%
%      H = MODULE3 returns the handle to a new MODULE3 or the handle to
%      the existing singleton*.
%
%      MODULE3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MODULE3.M with the given input arguments.
%
%      MODULE3('Property','Value',...) creates a new MODULE3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Module3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Module3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Module3

% Last Modified by GUIDE v2.5 20-Apr-2016 17:14:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Module3_OpeningFcn, ...
                   'gui_OutputFcn',  @Module3_OutputFcn, ...
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


% --- Executes just before Module3 is made visible.
function Module3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Module3 (see VARARGIN)

% Choose default command line output for Module3
handles.output = hObject;
handles.mode = -1;
handles.dataset = -1;

handles.endpoint = -1;
handles.algorithm = -1;
handles.k = -1;
handles.nrTopFeatures = -1;
handles.imageIdx = -1;

% Update handles structure
guidata(hObject, handles);

set(handles.pumAlgorithm, 'Enable', 'Off');
set(handles.pumEndpoint, 'Enable', 'Off');
set(handles.editkNN, 'Enable', 'Off');
set(handles.editImageIdx, 'Enable', 'Off');
set(handles.editnrFeatures, 'Enable', 'Off');

set(handles.btSConfirm, 'Enable', 'Off');
set(handles.btSClear, 'Enable', 'Off');
set(handles.btSStart, 'Enable', 'Off');

addpath .\kNN
addpath .\ANN1
addpath .\ANN2
addpath .\ANN3
addpath .\DTree


% UIWAIT makes Module3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Module3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in pumMode.
function pumMode_Callback(hObject, eventdata, handles)
% hObject    handle to pumMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pumMode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pumMode


% --- Executes during object creation, after setting all properties.
function pumMode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pumMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pumDS.
function pumDS_Callback(hObject, eventdata, handles)
% hObject    handle to pumDS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pumDS contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pumDS


% --- Executes during object creation, after setting all properties.
function pumDS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pumDS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btCPConfirm.
function btCPConfirm_Callback(hObject, eventdata, handles)
% hObject    handle to btCPConfirm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.btCPConfirm, 'Enable', 'Off');
set(handles.btCPClear, 'Enable', 'On');

set(handles.btSConfirm, 'Enable', 'On');
set(handles.btSClear, 'Enable', 'On');
set(handles.btSStart, 'Enable', 'Off');

set(handles.pumMode, 'Enable', 'Off');
set(handles.pumDS, 'Enable', 'Off');

set(handles.pumAlgorithm, 'Enable', 'On');
set(handles.pumEndpoint, 'Enable', 'On');
set(handles.editkNN, 'Enable', 'On');
set(handles.editImageIdx, 'Enable', 'On');
set(handles.editnrFeatures, 'Enable', 'On');

mode = get(handles.pumMode, 'Value');
modeStr = get(handles.pumMode, 'String');
set(handles.editResultMode, 'String', modeStr{mode, 1});

dataset = get(handles.pumDS, 'Value');
set(handles.editResultDataset, 'String', num2str(dataset));

if dataset == 1
    tempStr = ['Necrosis vs Tumor          ';
               'Tumor vs Stroma            ';
               'Stroma vs Necrosis         ';
               'Necrosis vs Stroma vs Tumor'];
else
    tempStr = ['Binary Grade   ';
               'Binary Survival'];
end
C = cellstr(tempStr);
set(handles.pumEndpoint, 'String', C);

handles.mode = mode;
handles.dataset = dataset;
guidata(hObject, handles);


% --- Executes on button press in btCPClear.
function btCPClear_Callback(hObject, eventdata, handles)
% hObject    handle to btCPClear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.btCPConfirm, 'Enable', 'On');

set(handles.btSConfirm, 'Enable', 'Off');
set(handles.btSClear, 'Enable', 'Off');
set(handles.btSStart, 'Enable', 'Off');

set(handles.pumMode, 'Enable', 'On');
set(handles.pumDS, 'Enable', 'On');

set(handles.pumAlgorithm, 'Enable', 'Off');
set(handles.pumEndpoint, 'Enable', 'Off');
set(handles.editkNN, 'Enable', 'Off');
set(handles.editImageIdx, 'Enable', 'Off');
set(handles.editnrFeatures, 'Enable', 'Off');

set(handles.editResultMode, 'String', '');
set(handles.editResultDataset, 'String', '');

handles.mode = -1;
handles.dataset = -1;
guidata(hObject, handles);


% --- Executes on selection change in pumAlgorithm.
function pumAlgorithm_Callback(hObject, eventdata, handles)
% hObject    handle to pumAlgorithm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pumAlgorithm contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pumAlgorithm


% --- Executes during object creation, after setting all properties.
function pumAlgorithm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pumAlgorithm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pumEndpoint.
function pumEndpoint_Callback(hObject, eventdata, handles)
% hObject    handle to pumEndpoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pumEndpoint contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pumEndpoint


% --- Executes during object creation, after setting all properties.
function pumEndpoint_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pumEndpoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
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



function editnrFeatures_Callback(hObject, eventdata, handles)
% hObject    handle to editnrFeatures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editnrFeatures as text
%        str2double(get(hObject,'String')) returns contents of editnrFeatures as a double


% --- Executes during object creation, after setting all properties.
function editnrFeatures_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editnrFeatures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btSConfirm.
function btSConfirm_Callback(hObject, eventdata, handles)
% hObject    handle to btSConfirm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.btSConfirm, 'Enable', 'Off');
set(handles.btSStart, 'Enable', 'On');

set(handles.pumAlgorithm, 'Enable', 'Off');
set(handles.pumEndpoint, 'Enable', 'Off');
set(handles.editkNN, 'Enable', 'Off');
set(handles.editImageIdx, 'Enable', 'Off');
set(handles.editnrFeatures, 'Enable', 'Off');

algorithm = get(handles.pumAlgorithm, 'Value');
algorithmStr = get(handles.pumAlgorithm, 'String');
set(handles.editResultAlgorithm, 'String', algorithmStr{algorithm, 1});

endPoint = get(handles.pumEndpoint, 'Value');
endPointStr = get(handles.pumEndpoint, 'String');
set(handles.editResultEndpoint, 'String', endPointStr{endPoint, 1});

if handles.mode == 2
    switch handles.dataset
        case 1
            idx = str2num(get(handles.editImageIdx, 'String'));
            temp = load('.\dataset1\testing\correspondence.mat');
            imageDir = temp.imageDir;
            set(handles.editResultImageIdx, 'String', imageDir(idx).name(1:end-4));
            if strcmp(imageDir(idx).name(1), 'N')
                tempStr = 'Necrosis';
            elseif strcmp(imageDir(idx).name(1), 'S')
                tempStr = 'Stroma';
            else
                tempStr = 'Tumor';
            end
            set(handles.editResultLabel, 'String', tempStr);
        case 2
            idx = str2num(get(handles.editImageIdx, 'String'));
            temp = load('.\dataset2\testing\correspondence.mat');
            imageDir = temp.imageDir;
            set(handles.editResultImageIdx, 'String', imageDir(16*(idx-1)+1).name(1:12));
            labels = xlsread('.\ANN2\test_labels.xlsx');
            set(handles.editResultLabel, 'String', num2str(labels(idx, 3-endPoint)));
        case 3
            idx = str2num(get(handles.editImageIdx, 'String'));
            temp = load('.\dataset3\testing\correspondence.mat');
            imageDir = temp.imageDir;
            set(handles.editResultImageIdx, 'String', imageDir(16*(idx-1)+1).name(1:12));
            labels = xlsread('.\ANN3\testing.xlsx');
            set(handles.editResultLabel, 'String', num2str(labels(idx, 3-endPoint)));
    end
end

handles.algorithm = algorithm;
handles.endpoint = endPoint;
handles.k = str2num(get(handles.editkNN, 'String'));
handles.nrTopFeatures = str2num(get(handles.editnrFeatures, 'String'));
handles.imageIdx = str2num(get(handles.editImageIdx, 'String'));
guidata(hObject, handles);


% --- Executes on button press in btSClear.
function btSClear_Callback(hObject, eventdata, handles)
% hObject    handle to btSClear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.btSConfirm, 'Enable', 'On');
set(handles.btSStart, 'Enable', 'Off');

set(handles.pumAlgorithm, 'Enable', 'On');
set(handles.pumEndpoint, 'Enable', 'On');
set(handles.editkNN, 'Enable', 'On');
set(handles.editImageIdx, 'Enable', 'On');
set(handles.editnrFeatures, 'Enable', 'On');

set(handles.editResultAlgorithm, 'String', '');
set(handles.editResultEndpoint, 'String', '');
set(handles.editResultImageIdx, 'String', '');
set(handles.editResultTopFeatures, 'String', '');

set(handles.editAUC, 'String', '');
set(handles.editMCC, 'String', '');
set(handles.editACC, 'String', '');
set(handles.editF, 'String', '');
set(handles.editCVLoss, 'String', '');
set(handles.editResultTopFeatures, 'String', '');
set(handles.editResultLabel, 'String', '');
set(handles.editPrediction, 'String', '');

handles.algorithm = -1;
handles.endpoint = -1;
handles.k = -1;
handles.nrTopFeatures = -1;
handles.imageIdx = -1;
guidata(hObject, handles);

% --- Executes on button press in btSStart.
function btSStart_Callback(hObject, eventdata, handles)
% hObject    handle to btSStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
endPointStr = get(handles.pumEndpoint, 'String');
if handles.mode == 1    % Algorithm Evaluation
    switch handles.dataset
        case 1  % dataset 1    
            if handles.algorithm == 1   % ANN
                [eval1, eval2, eval3, MCC1, MCC2, MCC3, p1, p2, p3, pp, ~, ~, ~, ~] = nn('trainlm', handles.nrTopFeatures);
                if handles.endpoint == 1
                    ACC = num2str(1 - p3);
                    F = num2str(eval3(6));
                    MCC = num2str(MCC3);
                    AUC = '-';
                elseif handles.endpoint == 2
                    ACC = num2str(1 - p2);
                    F = num2str(eval2(6));
                    MCC = num2str(MCC2);
                    AUC = '-';
                elseif handles.endpoint == 3
                    ACC = num2str(1 - p1);
                    F = num2str(eval1(6));
                    MCC = num2str(MCC1);
                    AUC = '-';
                else
                    ACC = num2str(1 - pp);
                    F = '-';
                    MCC = '-';
                    AUC = '-';
                end
                temp = load('.\ANN1\goodFeatureIdx.mat');
                topFeatures = temp.goodFeatureIdx(1:7, 1);
                
                set(handles.editACC, 'String', ACC);
                set(handles.editMCC, 'String', MCC);
                set(handles.editF, 'String', F);
                set(handles.editAUC, 'String', AUC);
                set(handles.editCVLoss, 'String', '-');
                set(handles.editResultTopFeatures, 'String', num2str(topFeatures'));
                
            elseif handles.algorithm == 2   % kNN
                [ACC1, ~, MCC1, F1, AUC1, CVLoss1, ~, topFeatures1] = KNN_dataset1('Necrosis', 'Stroma', handles.nrTopFeatures, handles.k);
                [ACC2, ~, MCC2, F2, AUC2, CVLoss2, ~, topFeatures2] = KNN_dataset1('Necrosis', 'Tumor', handles.nrTopFeatures, handles.k);
                [ACC3, ~, MCC3, F3, AUC3, CVLoss3, ~, topFeatures3] = KNN_dataset1('Tumor', 'Stroma', handles.nrTopFeatures, handles.k);
                if handles.endpoint == 1
                    ACC = ACC1;
                    F = F1;
                    MCC = MCC1;
                    AUC = AUC1;
                    CVLoss = CVLoss1;
                    topFeatures = topFeatures1;
                elseif handles.endpoint == 2
                    ACC = ACC3;
                    F = F3;
                    MCC = MCC3;
                    AUC = AUC3;
                    CVLoss = CVLoss3;
                    topFeatures = topFeatures3;
                elseif handles.endpoint == 3
                    ACC = ACC2;
                    F = F2;
                    MCC = MCC2;
                    AUC = AUC2;
                    CVLoss = CVLoss2;
                    topFeatures = topFeatures2;
                else
                    ACC = (ACC1 + ACC2 + ACC3) / 3;
                    F = (F1 + F2 + F3) / 3;
                    MCC = (MCC1 + MCC2 + MCC3) / 3;
                    AUC = (AUC1 + AUC2 + AUC3) / 3;
                    CVLoss = (CVLoss1 + CVLoss2 + CVLoss3) / 3;
                    topFeatures = intersect(intersect(topFeatures1, topFeatures2), topFeatures3);
                end
                
                set(handles.editACC, 'String', num2str(ACC/100));
                set(handles.editMCC, 'String', num2str(MCC));
                set(handles.editF, 'String', num2str(F));
                set(handles.editAUC, 'String', num2str(AUC));
                set(handles.editCVLoss, 'String', num2str(CVLoss));
                len = length(topFeatures);
                topFeatures = topFeatures(1:min(7, len));
                set(handles.editResultTopFeatures, 'String', num2str(topFeatures'));
                
            elseif handles.algorithm == 3   % DTree
                [ACC1, ~, MCC1, F1, AUC1, CVLoss1, ~, topFeatures1] = Decision_Tree_dataset1('Necrosis', 'Stroma', handles.nrTopFeatures);
                [ACC2, ~, MCC2, F2, AUC2, CVLoss2, ~, topFeatures2] = Decision_Tree_dataset1('Necrosis', 'Tumor', handles.nrTopFeatures);
                [ACC3, ~, MCC3, F3, AUC3, CVLoss3, ~, topFeatures3] = Decision_Tree_dataset1('Tumor', 'Stroma', handles.nrTopFeatures);
                if handles.endpoint == 1
                    ACC = ACC1;
                    F = F1;
                    MCC = MCC1;
                    AUC = AUC1;
                    CVLoss = CVLoss1;
                    topFeatures = topFeatures1;
                elseif handles.endpoint == 2
                    ACC = ACC3;
                    F = F3;
                    MCC = MCC3;
                    AUC = AUC3;
                    CVLoss = CVLoss3;
                    topFeatures = topFeatures3;
                elseif handles.endpoint == 3
                    ACC = ACC2;
                    F = F2;
                    MCC = MCC2;
                    AUC = AUC2;
                    CVLoss = CVLoss2;
                    topFeatures = topFeatures2;
                else
                    ACC = (ACC1 + ACC2 + ACC3) / 3;
                    F = (F1 + F2 + F3) / 3;
                    MCC = (MCC1 + MCC2 + MCC3) / 3;
                    AUC = (AUC1 + AUC2 + AUC3) / 3;
                    CVLoss = (CVLoss1 + CVLoss2 + CVLoss3) / 3;
                    topFeatures = intersect(intersect(topFeatures1, topFeatures2), topFeatures3);
                end
                
                set(handles.editACC, 'String', num2str(ACC/100));
                set(handles.editMCC, 'String', num2str(MCC));
                set(handles.editF, 'String', num2str(F));
                set(handles.editAUC, 'String', num2str(AUC));
                set(handles.editCVLoss, 'String', num2str(CVLoss));
                len = length(topFeatures);
                topFeatures = topFeatures(1:min(7, len));
                set(handles.editResultTopFeatures, 'String', num2str(topFeatures));
            end
            
        case 2  % dataset 2
            if handles.algorithm == 1
                if handles.endpoint == 1
                    [eval, MCCC, p, ~] = nn2bg_batch('trainlm', handles.nrTopFeatures);
                    temp = load('.\ANN2\goodFeatureIdx_BG.mat');
                    topFeatures = temp.goodFeatureIdx(1:7, 1);
                else
                    [eval, MCCC, p, ~] = nn2bs_batch('trainlm', handles.nrTopFeatures);
                    temp = load('.\ANN2\goodFeatureIdx_BS.mat');
                    topFeatures = temp.goodFeatureIdx(1:7, 1);
                end
                ACC = num2str(1 - p);
                F = num2str(eval(6));
                MCC = num2str(MCCC);
                AUC = '-';
                
                set(handles.editACC, 'String', ACC);
                set(handles.editMCC, 'String', MCC);
                set(handles.editF, 'String', F);
                set(handles.editAUC, 'String', AUC);
                set(handles.editCVLoss, 'String', '-');
                set(handles.editResultTopFeatures, 'String', num2str(topFeatures'));
                
            elseif handles.algorithm == 2
                [ACC, ~, MCC, F, AUC, CVLoss, ~, topFeatures] = KNN_dataset2(endPointStr{handles.endpoint, 1}, handles.nrTopFeatures, handles.k);
                set(handles.editACC, 'String', num2str(ACC/100));
                set(handles.editMCC, 'String', num2str(MCC));
                set(handles.editF, 'String', num2str(F));
                set(handles.editAUC, 'String', num2str(AUC));
                set(handles.editCVLoss, 'String', num2str(CVLoss));
                len = length(topFeatures);
                topFeatures = topFeatures(1:min(7, len));
                set(handles.editResultTopFeatures, 'String', num2str(topFeatures'));
            elseif handles.algorithm == 3
                [ACC, ~, MCC, F, AUC, CVLoss, ~, topFeatures] = Decision_Tree_dataset2(endPointStr{handles.endpoint, 1}, handles.nrTopFeatures);
                set(handles.editACC, 'String', num2str(ACC/100));
                set(handles.editMCC, 'String', num2str(MCC));
                set(handles.editF, 'String', num2str(F));
                set(handles.editAUC, 'String', num2str(AUC));
                set(handles.editCVLoss, 'String', num2str(CVLoss));
                len = length(topFeatures);
                topFeatures = topFeatures(1:min(7, len));
                set(handles.editResultTopFeatures, 'String', num2str(topFeatures));
            end
        case 3  % dataset 3
            if handles.algorithm == 1
                if handles.endpoint == 1
                    [eval, MCCC, p, ~] = nn3bg_batch('trainlm', handles.nrTopFeatures);
                    temp = load('.\ANN3\goodFeatureIdx_BG.mat');
                    topFeatures = temp.goodFeatureIdx(1:7, 1);
                else
                    [eval, MCCC, p, ~] = nn3bs_batch('trainlm', handles.nrTopFeatures);
                    temp = load('.\ANN3\goodFeatureIdx_BS.mat');
                    topFeatures = temp.goodFeatureIdx(1:7, 1);
                end
                ACC = num2str(1 - p);
                F = num2str(eval(6));
                MCC = num2str(MCCC);
                AUC = '-';
                set(handles.editACC, 'String', ACC);
                set(handles.editMCC, 'String', MCC);
                set(handles.editF, 'String', F);
                set(handles.editAUC, 'String', AUC);
                set(handles.editCVLoss, 'String', '-');
                set(handles.editResultTopFeatures, 'String', num2str(topFeatures'));
                
            elseif handles.algorithm == 2
                [ACC, ~, MCC, F, AUC, CVLoss, ~, topFeatures] = KNN_dataset3(endPointStr{handles.endpoint, 1}, handles.nrTopFeatures, handles.k);
                set(handles.editACC, 'String', num2str(ACC/100));
                set(handles.editMCC, 'String', num2str(MCC));
                set(handles.editF, 'String', num2str(F));
                set(handles.editAUC, 'String', num2str(AUC));
                set(handles.editCVLoss, 'String', num2str(CVLoss));
                len = length(topFeatures);
                topFeatures = topFeatures(1:min(7, len));
                set(handles.editResultTopFeatures, 'String', num2str(topFeatures'));
            elseif handles.algorithm == 3
                [ACC, ~, MCC, F, AUC, CVLoss, ~, topFeatures] = Decision_Tree_dataset3(endPointStr{handles.endpoint, 1}, handles.nrTopFeatures);
                set(handles.editACC, 'String', num2str(ACC/100));
                set(handles.editMCC, 'String', num2str(MCC));
                set(handles.editF, 'String', num2str(F));
                set(handles.editAUC, 'String', num2str(AUC));
                set(handles.editCVLoss, 'String', num2str(CVLoss));
                len = length(topFeatures);
                topFeatures = topFeatures(1:min(7, len));
                set(handles.editResultTopFeatures, 'String', num2str(topFeatures));
            end
    end
    
elseif handles.mode == 2
    switch handles.dataset
        case 1
            temp1 = load('.\dataset1\testing\testing.mat');
            idx = str2num(get(handles.editImageIdx, 'String'));
            C = temp1.features;
            C3 = C(idx, :);
            if handles.algorithm == 2
                [label, ~, ~ ] = Global_KNN_classifier(handles.nrTopFeatures, handles.k, C3);
            elseif handles.algorithm == 3
                [label, ~, ~ ] = Global_Tree_classifier(handles.nrTopFeatures, C3);
            end
            tempStr = ['Necrosis ';
                       'Stroma   ';
                       'Tumor    '];
            nameStr = cellstr(tempStr);
            set(handles.editPrediction, 'String', nameStr{label, 1});
            if strcmp(get(handles.editResultLabel, 'String'), nameStr{label, 1});
                set(handles.editACC, 'String', '100%');
            else
                set(handles.editACC, 'String', '0%');
            end
            
        case 2
            if handles.algorithm == 1
                temp1 = load('.\dataset2\testing\testing.mat');
                idx = str2num(get(handles.editImageIdx, 'String'));
                if handles.endpoint == 1
                    [p, ~] = nn2bg(idx, 'trainlm', handles.nrTopFeatures);
                else
                    [~, ~, p, ~] = nn2bs(idx, 'trainlm', handles.nrTopFeatures);
                end
                if p > 0.5
                    set(handles.editACC, 'String', '100%');
                else
                    set(handles.editACC, 'String', '0%');
                end
                
                
            elseif handles.algorithm == 2
                [~, ~, ~, ~, ~, ~, knnModel, topFeatures] = KNN_dataset2(endPointStr{handles.endpoint, 1}, handles.nrTopFeatures, handles.k);
                temp2 = load('.\dataset2\testing\testing.mat');
                idx = str2num(get(handles.editImageIdx, 'String'));
                temp = temp2.features;
                testing = temp((16*(idx-1)) + 1:16*idx, topFeatures);
                [Y, ~] = predict(knnModel, testing);
                nrPY = length(find(Y == 1));
                if nrPY < 8
                    label = -1;
                elseif nrPY > 8
                    label = 1;
                else
                    label = 0;
                end
                set(handles.editPrediction, 'String', num2str(label));
                if label == str2num(get(handles.editResultLabel, 'String'));
                    set(handles.editACC, 'String', '100%');
                else
                    set(handles.editACC, 'String', '0%');
                end
                
            elseif handles.algorithm == 3
                [~, ~, ~, ~, ~, ~, tree, topFeatures] = Decision_Tree_dataset2(endPointStr{handles.endpoint, 1}, handles.nrTopFeatures);
                temp2 = load('.\dataset2\testing\testing.mat');
                idx = str2num(get(handles.editImageIdx, 'String'));
                temp = temp2.features;
                testing = temp((16*(idx-1)) + 1:16*idx, topFeatures);
                [Y, ~] = predict(tree, testing);
                nrPY = length(find(Y == 1));
                if nrPY < 8
                    label = -1;
                elseif nrPY > 8
                    label = 1;
                else
                    label = 0;
                end
                set(handles.editPrediction, 'String', num2str(label));
                if label == str2num(get(handles.editResultLabel, 'String'));
                    set(handles.editACC, 'String', '100%');
                else
                    set(handles.editACC, 'String', '0%');
                end
            end        
           
        case 3
            if handles.algorithm == 1
                temp1 = load('.\dataset3\testing\testing.mat');
                idx = str2num(get(handles.editImageIdx, 'String'));
                if handles.endpoint == 1
                    [~, ~, p, ~] = nn3bg(idx, 'trainlm', handles.nrTopFeatures);
                else
                    [~, ~, p, ~] = nn3bs(idx, 'trainlm', handles.nrTopFeatures);
                end
                if p > 0.5
                    set(handles.editACC, 'String', '100%');
                else
                    set(handles.editACC, 'String', '0%');
                end
                
                
            elseif handles.algorithm == 2
                [~, ~, ~, ~, ~, ~, knnModel, topFeatures] = KNN_dataset3(endPointStr{handles.endpoint, 1}, handles.nrTopFeatures, handles.k);
                temp2 = load('.\dataset3\testing\testing.mat');
                idx = str2num(get(handles.editImageIdx, 'String'));
                temp = temp2.features;
                testing = temp((16*(idx-1)) + 1:16*idx, topFeatures);
                [Y, ~] = predict(knnModel, testing);
                nrPY = length(find(Y == 1));
                if nrPY < 8
                    label = -1;
                elseif nrPY > 8
                    label = 1;
                else
                    label = 0;
                end
                set(handles.editPrediction, 'String', num2str(label));
                if label == str2num(get(handles.editResultLabel, 'String'));
                    set(handles.editACC, 'String', '100%');
                else
                    set(handles.editACC, 'String', '0%');
                end
                
            elseif handles.algorithm == 3
                [~, ~, ~, ~, ~, ~, tree, topFeatures] = Decision_Tree_dataset3(endPointStr{handles.endpoint, 1}, handles.nrTopFeatures);
                temp2 = load('.\dataset3\testing\testing.mat');
                idx = str2num(get(handles.editImageIdx, 'String'));
                temp = temp2.features;
                testing = temp((16*(idx-1)) + 1:16*idx, topFeatures);
                [Y, ~] = predict(tree, testing);
                nrPY = length(find(Y == 1));
                if nrPY < 8
                    label = -1;
                elseif nrPY > 8
                    label = 1;
                else
                    label = 0;
                end
                set(handles.editPrediction, 'String', num2str(label));
                if label == str2num(get(handles.editResultLabel, 'String'));
                    set(handles.editACC, 'String', '100%');
                else
                    set(handles.editACC, 'String', '0%');
                end
            end                    
    end
    
else
    
end


function editImageIdx_Callback(hObject, eventdata, handles)
% hObject    handle to editImageIdx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editImageIdx as text
%        str2double(get(hObject,'String')) returns contents of editImageIdx as a double


% --- Executes during object creation, after setting all properties.
function editImageIdx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editImageIdx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editResultMode_Callback(hObject, eventdata, handles)
% hObject    handle to editResultMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editResultMode as text
%        str2double(get(hObject,'String')) returns contents of editResultMode as a double


% --- Executes during object creation, after setting all properties.
function editResultMode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editResultMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editResultDataset_Callback(hObject, eventdata, handles)
% hObject    handle to editResultDataset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editResultDataset as text
%        str2double(get(hObject,'String')) returns contents of editResultDataset as a double


% --- Executes during object creation, after setting all properties.
function editResultDataset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editResultDataset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editResultAlgorithm_Callback(hObject, eventdata, handles)
% hObject    handle to editResultAlgorithm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editResultAlgorithm as text
%        str2double(get(hObject,'String')) returns contents of editResultAlgorithm as a double


% --- Executes during object creation, after setting all properties.
function editResultAlgorithm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editResultAlgorithm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editResultImageIdx_Callback(hObject, eventdata, handles)
% hObject    handle to editResultImageIdx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editResultImageIdx as text
%        str2double(get(hObject,'String')) returns contents of editResultImageIdx as a double


% --- Executes during object creation, after setting all properties.
function editResultImageIdx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editResultImageIdx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editResultEndpoint_Callback(hObject, eventdata, handles)
% hObject    handle to editResultEndpoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editResultEndpoint as text
%        str2double(get(hObject,'String')) returns contents of editResultEndpoint as a double


% --- Executes during object creation, after setting all properties.
function editResultEndpoint_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editResultEndpoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editResultTopFeatures_Callback(hObject, eventdata, handles)
% hObject    handle to editResultTopFeatures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editResultTopFeatures as text
%        str2double(get(hObject,'String')) returns contents of editResultTopFeatures as a double


% --- Executes during object creation, after setting all properties.
function editResultTopFeatures_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editResultTopFeatures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editAUC_Callback(hObject, eventdata, handles)
% hObject    handle to editAUC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editAUC as text
%        str2double(get(hObject,'String')) returns contents of editAUC as a double


% --- Executes during object creation, after setting all properties.
function editAUC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editAUC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editMCC_Callback(hObject, eventdata, handles)
% hObject    handle to editMCC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMCC as text
%        str2double(get(hObject,'String')) returns contents of editMCC as a double


% --- Executes during object creation, after setting all properties.
function editMCC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMCC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editACC_Callback(hObject, eventdata, handles)
% hObject    handle to editACC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editACC as text
%        str2double(get(hObject,'String')) returns contents of editACC as a double


% --- Executes during object creation, after setting all properties.
function editACC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editACC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editF_Callback(hObject, eventdata, handles)
% hObject    handle to editF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editF as text
%        str2double(get(hObject,'String')) returns contents of editF as a double


% --- Executes during object creation, after setting all properties.
function editF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editResultLabel_Callback(hObject, eventdata, handles)
% hObject    handle to editResultLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editResultLabel as text
%        str2double(get(hObject,'String')) returns contents of editResultLabel as a double


% --- Executes during object creation, after setting all properties.
function editResultLabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editResultLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editCVLoss_Callback(hObject, eventdata, handles)
% hObject    handle to editCVLoss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editCVLoss as text
%        str2double(get(hObject,'String')) returns contents of editCVLoss as a double


% --- Executes during object creation, after setting all properties.
function editCVLoss_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editCVLoss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editPrediction_Callback(hObject, eventdata, handles)
% hObject    handle to editPrediction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editPrediction as text
%        str2double(get(hObject,'String')) returns contents of editPrediction as a double


% --- Executes during object creation, after setting all properties.
function editPrediction_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editPrediction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
