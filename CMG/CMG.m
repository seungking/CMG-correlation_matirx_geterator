function varargout = CMG(varargin)
% CMG MATLAB code for CMG.fig
%      CMG, by itself, creates a new CMG or raises the existing
%      singleton*.
%
%      H = CMG returns the handle to a new CMG or the handle to
%      the existing singleton*.
%
%      CMG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CMG.M with the given input arguments.
%
%      CMG('Property','Value',...) creates a new CMG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CMG_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CMG_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CMG

% Last Modified by GUIDE v2.5 22-Aug-2019 17:05:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CMG_OpeningFcn, ...
                   'gui_OutputFcn',  @CMG_OutputFcn, ...
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


% --- Executes just before CMG is made visible.
function CMG_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CMG (see VARARGIN)

% Choose default command line output for CMG
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CMG wait for user response (see UIRESUME)
% uiwait(handles.figure1);
%% Plot no-data matrix on figure
X = (0:42);
Y = (0:42);
for n = 1 : 43
     correlation_r(n,n) = 0;
     correlation_r(n,n) = 0;
end
pcolor(X,Y,correlation_r);
pbaspect([1 1 1]);
    
title('Correlation Matrix');
colorbar;
caxis([-0.5 1]);

xlabel('UNIT#');
ylabel('UNIT#');
colormap jet;
legend('off');

set(gca,'Xtick',[0, round(42*(1/4)) , round(42*(2/4)), round(42*(3/4)), 42])
set(gca,'Ytick',[0, round(42*(1/4)) , round(42*(2/4)), round(42*(3/4)), 42])
set(gca,'YDir','rev');


% --- Outputs from this function are returned to the command line.
function varargout = CMG_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in tab1.
function tab1_Callback(hObject, eventdata, handles)
% hObject    handle to tab1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.page2,'visible','off')
set(handles.k_w_check,'visible','on')
 
% --- Executes on button press in tab2.
function tab2_Callback(hObject, eventdata, handles)
% hObject    handle to tab2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 set(handles.page2,'visible','on')
 set(handles.k_w_check,'visible','off')
 
% --- Executes on button press in Startbutton.
function Startbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Startbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

method = 0;

% STTC OR K_W_correlation
if (get(handles.sttc_check,'Value')==0 && get(handles.k_w_check,'Value')==0)
    disp('Did not select method');
else if get(handles.sttc_check,'Value') == 1
    method = 1;%STTC
    else if get(handles.k_w_check, 'Value') == 1
            method = 2;%K_W
        end
    end
end

% Type of cell
on_bt = get(handles.on_bt,'Value');
on_bs = get(handles.on_bs,'Value');
off_bt = get(handles.off_bt,'Value');
off_bs = get(handles.off_bs,'Value');

%Response Type and conditions to find out mat file with spike train
if (get(handles.light_response_check,'Value')==0 && get(handles.electric_response_check,'Value')==0)
    disp('Did not select the response type');
else if get(handles.light_response_check,'Value')==1
    response_type = 1;% LIGHT
    pp1 = cellstr(get(handles.light_p1,'String'))% get conditions list as a string array
    pp2 = cellstr(get(handles.light_p2,'String'))
    pp3 = cellstr(get(handles.light_p3,'String'))
    p1 = get(handles.light_p1,'Value')% get location value in the array
    p2 = get(handles.light_p2,'Value')
    p3 = get(handles.light_p3,'Value')
    p1 = pp1(p1)
    p2 = pp2(p2)
    p3 = pp3(p3)
    else if get(handles.electric_response_check, 'Value')==1
    response_type = 2;% ELECTRIC
    pp1 = cellstr(get(handles.electric_p1,'String'))% get conditions list as a string array
    pp2 = cellstr(get(handles.electric_p2,'String'))
    pp3 = cellstr(get(handles.electric_p3,'String'))
    p1 = get(handles.electric_p1,'Value');% get location value in the array
    p2 = get(handles.electric_p2,'Value');
    p3 = get(handles.electric_p3,'Value');
    p1 = pp1(p1)
    p2 = pp2(p2)
    p3 = pp3(p3)    
        end
    end
end

%Create_image
if get(handles.create_image,'Value') == 1
    create_image = 1;
else
    create_image = 0;
end

%range of caparison
range1 = str2double(get(handles.time1_1,'String'));
range2 = str2double(get(handles.time2_1,'String'));
%window size
dt =  str2double(get(handles.window_size, 'String'));
if isnan(dt)
    dt = 50;
end
%data directroy path
dir_name = get(handles.print_directory,'String');

if method == 1
    sttc_correlation(dir_name,method,dt,response_type,on_bt,on_bs,off_bt,off_bs,p1,p2,p3,create_image,range1,range2);
else if method == 2
        k_w_correlation(dir_name,method,dt,response_type,on_bt,on_bs,off_bt,off_bs,p1,p2,p3,create_image,range1,range2);
    end
end

% --- Executes on button press in load_data.
function load_data_Callback(hObject, eventdata, handles)
% hObject    handle to load_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.show_data,'value', 1);

method = 0;
% STTC OR K_W_correlation
if (get(handles.sttc_check,'Value')==0 && get(handles.k_w_check,'Value')==0)
    disp('Did not select method');
else if get(handles.sttc_check,'Value') == 1
    method = 1;%STTC
    else if get(handles.k_w_check, 'Value') == 1
            method = 2;%K_W
        end
    end
end

%cell_number and type of cell
cell_number = str2double(get(handles.input_cell_number,'String'));
on_bt2 = get(handles.on_bt2,'Value');
on_bs2 = get(handles.on_bs2,'Value');
off_bt2 = get(handles.off_bt2,'Value');
off_bs2 = get(handles.off_bs2,'Value');

%response type
if (get(handles.light_response_check2,'Value')==1)
    response_type = 1;%LIGHT
    spike_path = '0_Light_Responses\5_Spike_And_Artifact_Onsets';  
end
if (get(handles.electric_response_check2,'Value')==1)
    response_type = 2;%ELECTRIC
    spike_path = '3_Long\5_Spike_And_Artifact_Onsets';
end

%data directory file
dir_name = get(handles.print_directory,'String');

%get list of mat file with spike train
data_dir_path = dir_name;
cell_list_path = 'Journal of Physiology 2015 paper summary of cells.xlsx';
if on_bt2 == 1
    [~,~,cell_path] = xlsread(fullfile(data_dir_path,cell_list_path),1,'D2:D20');
end
if on_bs2 == 1
    [~,~,cell_path] = xlsread(fullfile(data_dir_path,cell_list_path),1,'D23:D45');
end
if off_bt2 == 1
    [~,~,cell_path] = xlsread(fullfile(data_dir_path,cell_list_path),1,'D51:D75');
end
if off_bs2 == 1
    [~,~,cell_path] = xlsread(fullfile(data_dir_path,cell_list_path),1,'D84:D100');
end
cell_path(any(cellfun(@(x) any(isnan(x)),cell_path),2),:) = [];

set(handles.cell_address,'String',fullfile(data_dir_path,cell_path{cell_number}(22:length(cell_path{cell_number})),spike_path));
Files = struct2cell(dir(fullfile(data_dir_path,cell_path{cell_number}(22:length(cell_path{cell_number})),spike_path)))';
Files = Files(:,1);
set(handles.show_data,'String',Files(3:length(Files)));

set(handles.show_data,'Max',30,'Min',0);

% --- Executes on button press in apply_data.
function apply_data_Callback(hObject, eventdata, handles)
% hObject    handle to apply_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.select_list,'value',1);

%data directroy path
dir_name = get(handles.print_directory,'String');
data_dir_path = dir_name;

%cell_number and type of cell
cell_number = str2double(get(handles.input_cell_number,'String'));
on_bt2 = get(handles.on_bt2,'Value');
on_bs2 = get(handles.on_bs2,'Value');
off_bt2 = get(handles.off_bt2,'Value');
off_bs2 = get(handles.off_bs2,'Value');
 
dir_name = get(handles.print_directory,'String');

%get list of mat file with spike train
data_dir_path = dir_name;
cell_list_path = 'Journal of Physiology 2015 paper summary of cells.xlsx';
if on_bt2 == 1
    [~,~,cell_path] = xlsread(fullfile(data_dir_path,cell_list_path),1,'D2:D20');
end
if on_bs2 == 1
    [~,~,cell_path] = xlsread(fullfile(data_dir_path,cell_list_path),1,'D23:D45');
end
if off_bt2 == 1
    [~,~,cell_path] = xlsread(fullfile(data_dir_path,cell_list_path),1,'D51:D75');
end
if off_bs2 == 1
    [~,~,cell_path] = xlsread(fullfile(data_dir_path,cell_list_path),1,'D84:D100');
end
cell_path(any(cellfun(@(x) any(isnan(x)),cell_path),2),:) = [];

%list_order : fullfile path of cell selected by user
list_order = get(handles.list_order, 'String');
cellstr(fullfile(data_dir_path,cell_path{cell_number}(22:length(cell_path{cell_number}))))
list_order = [list_order',cellstr(fullfile(data_dir_path,cell_path{cell_number}(22:length(cell_path{cell_number}))))]
set(handles.list_order, 'String', list_order)

%spike_list : save the order of cells selected by user simply
%sipike_counter : save the number of cells selected by user orderly 
spike_list = get(handles.tosave, 'String');
spike_counter = get(handles.spike_counter,'String');

list = get(handles.show_data,'String');
select = get(handles.show_data,'Value');
new_spikes = fullfile(get(handles.cell_address,'String'),list(select))

spike_list = vertcat(spike_list,new_spikes);
spike_counter = vertcat(spike_counter,cellstr(num2str(length(new_spikes))));
set(handles.tosave, 'String', spike_list);
set(handles.spike_counter, 'String', spike_counter);

% cell name
if (get(handles.light_response_check2,'Value'))
    type = '[L]';
end
if (get(handles.electric_response_check2,'Value'))
    type = '[E]';
end

if get(handles.on_bt2,'Value')
   cell = 'ON-BT'; 
end
if get(handles.on_bs2,'Value')
   cell = 'ON-BS'; 
end
if get(handles.off_bt2,'Value')
   cell = 'OFF-BT'; 
end
if get(handles.off_bs2,'Value')
   cell = 'OFF-BS'; 
end

%cell list
select_list = get(handles.select_list,'String');
select_cell = sprintf('%s%s%s%s%s', type,'(', get(handles.input_cell_number,'String'),')',cell);
while(length(select_cell)~=15)
    select_cell = [select_cell,' '];
end
select_list = vertcat(select_list,select_cell);
set(handles.select_list,'String',select_list);

total_number = str2double(get(handles.total_counter,'String'));
if isnan(total_number)
    total_number = 0;
end
total_number = total_number + 1;
set(handles.total_counter,'String',total_number);

% --- Executes on button press in start_button2.
function start_button2_Callback(hObject, eventdata, handles)
% hObject    handle to start_button2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

method = 0;
% STTC OR K_W_correlation
if (get(handles.sttc_check,'Value')==0 && get(handles.k_w_check,'Value')==0)
    disp('Did not select method');
else if get(handles.sttc_check,'Value') == 1
    method = 1;%STTC
    else if get(handles.k_w_check, 'Value') == 1
            method = 2;%K_W
        end
    end
end

%Response Type and conditions to find out mat file with spike train
if (get(handles.light_response_check,'Value')==0 && get(handles.electric_response_check,'Value')==0)
    disp('Did not select the response type');
else if get(handles.light_response_check,'Value')==1
    response_type = 1;% LIGHT
    else if get(handles.electric_response_check, 'Value')==1
    response_type = 2;% ELECTRIC
    end
    end
end

%Create_image
if get(handles.create_image,'Value') == 1
    create_image = 1;
else
    create_image = 0;
end
%window size
dt =  str2double(get(handles.window_size2, 'String'));
if isnan(dt)
    dt = 50;
end
dir_name = get(handles.print_directory,'String');
spike_list = get(handles.tosave,'String');
list_order = get(handles.list_order,'String');
spike_counter = get(handles.spike_counter,'String');
range1 = str2double(get(handles.time1_2,'String'));
range2 = str2double(get(handles.time2_2,'String'));
select_list = get(handles.select_list,'String');
sttc_correlation_create_new(dir_name,method,dt,response_type,list_order,spike_counter,spike_list,range1,range2,select_list);


% --- Executes on button press in data_dir.
function data_dir_Callback(hObject, eventdata, handles)
% hObject    handle to data_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dir_name = uigetdir('C:\');
set(handles.data_directory,'String',dir_name);

% --- Executes on button press in on_bt.
function on_bt_Callback(hObject, eventdata, handles)
% hObject    handle to on_bt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of on_bt


% --- Executes on button press in on_bs.
function on_bs_Callback(hObject, eventdata, handles)
% hObject    handle to on_bs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of on_bs

% --- Executes during object creation, after setting all properties.
function text5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function text6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function text7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over Startbutton.
function Startbutton_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Startbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in sttc_check.
function sttc_check_Callback(hObject, eventdata, handles)
% hObject    handle to sttc_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sttc_check



function window_size_Callback(hObject, eventdata, handles)
% hObject    handle to window_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of window_size as text
%        str2double(get(hObject,'String')) returns contents of window_size as a double


% --- Executes during object creation, after setting all properties.
function window_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to window_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in light_response_check.
function light_response_check_Callback(hObject, eventdata, handles)
% hObject    handle to light_response_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of light_response_check


% --- Executes on button press in electric_response_check.
function electric_response_check_Callback(hObject, eventdata, handles)
% hObject    handle to electric_response_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of electric_response_check


% --- Executes on selection change in light_p1.
function light_p1_Callback(hObject, eventdata, handles)
% hObject    handle to light_p1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns light_p1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from light_p1


% --- Executes during object creation, after setting all properties.
function light_p1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to light_p1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in light_p2.
function light_p2_Callback(hObject, eventdata, handles)
% hObject    handle to light_p2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns light_p2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from light_p2


% --- Executes during object creation, after setting all properties.
function light_p2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to light_p2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in light_p3.
function light_p3_Callback(hObject, eventdata, handles)
% hObject    handle to light_p3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns light_p3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from light_p3


% --- Executes during object creation, after setting all properties.
function light_p3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to light_p3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in electric_p1.
function electric_p1_Callback(hObject, eventdata, handles)
% hObject    handle to electric_p1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns electric_p1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from electric_p1


% --- Executes during object creation, after setting all properties.
function electric_p1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to electric_p1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in electric_p2.
function electric_p2_Callback(hObject, eventdata, handles)
% hObject    handle to electric_p2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns electric_p2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from electric_p2


% --- Executes during object creation, after setting all properties.
function electric_p2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to electric_p2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in electric_p3.
function electric_p3_Callback(hObject, eventdata, handles)
% hObject    handle to electric_p3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns electric_p3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from electric_p3


% --- Executes during object creation, after setting all properties.
function electric_p3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to electric_p3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function data_directory_CreateFcn(hObject, eventdata, handles)
% hObject    handle to data_directory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

function page1_CreateFcn(hObject, eventdata, handles)


% --- Executes on button press in create_image.
function create_image_Callback(hObject, eventdata, handles)
% hObject    handle to create_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of create_image


% --- Executes during object creation, after setting all properties.
function uipanel2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function page2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to page2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



% --- Executes on button press in off_bs.
function checkbox11_Callback(hObject, eventdata, handles)
% hObject    handle to off_bs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of off_bs


% --- Executes on button press in data_directory2.
function data_directory2_Callback(hObject, eventdata, handles)
% hObject    handle to data_directory2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dir_name = uigetdir('C:\');
set(handles.print_directory2,'String',dir_name);

function print_directory2_Callback(hObject, eventdata, handles)
% hObject    handle to print_directory2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of print_directory2 as text
%        str2double(get(hObject,'String')) returns contents of print_directory2 as a double


% --- Executes during object creation, after setting all properties.
function print_directory2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to print_directory2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in data_directory.
function data_directory_Callback(hObject, eventdata, handles)
% hObject    handle to data_directory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dir_name = uigetdir('C:\');
set(handles.print_directory,'String',dir_name);

function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to print_directory2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of print_directory2 as text
%        str2double(get(hObject,'String')) returns contents of print_directory2 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to print_directory2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_cell_number_Callback(hObject, eventdata, handles)
% hObject    handle to input_cell_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_cell_number as text
%        str2double(get(hObject,'String')) returns contents of input_cell_number as a double


% --- Executes during object creation, after setting all properties.
function input_cell_number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_cell_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in show_data.
function show_data_Callback(hObject, eventdata, handles)
% hObject    handle to show_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns show_data contents as cell array
%        contents{get(hObject,'Value')} returns selected item from show_data


% --- Executes during object creation, after setting all properties.
function show_data_CreateFcn(hObject, eventdata, handles)
% hObject    handle to show_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
% set(handles.show_data,'value',1) ;
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cell_address_Callback(hObject, eventdata, handles)
% hObject    handle to cell_address (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cell_address as text
%        str2double(get(hObject,'String')) returns contents of cell_address as a double


% --- Executes during object creation, after setting all properties.
function cell_address_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cell_address (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function total_counter_Callback(hObject, eventdata, handles)
% hObject    handle to total_counter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of total_counter as text
%        str2double(get(hObject,'String')) returns contents of total_counter as a double


% --- Executes during object creation, after setting all properties.
function total_counter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to total_counter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function window_size2_Callback(hObject, eventdata, handles)
% hObject    handle to window_size2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of window_size2 as text
%        str2double(get(hObject,'String')) returns contents of window_size2 as a double


% --- Executes during object creation, after setting all properties.
function window_size2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to window_size2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function time_range2_Callback(hObject, eventdata, handles)
% hObject    handle to time_range2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of time_range2 as text
%        str2double(get(hObject,'String')) returns contents of time_range2 as a double


% --- Executes during object creation, after setting all properties.
function time_range2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time_range2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function time_range_Callback(hObject, eventdata, handles)
% hObject    handle to time_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of time_range as text
%        str2double(get(hObject,'String')) returns contents of time_range as a double


% --- Executes during object creation, after setting all properties.
function time_range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axes11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes11


% --- Executes on button press in Reset.
function Reset_Callback(hObject, eventdata, handles)
% hObject    handle to Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Reset
empty_array = [];
set(handles.total_counter,'String', '0')
set(handles.tosave,'String', empty_array);
set(handles.select_list, 'String', empty_array);
set(handles.spike_counter,'String', empty_array);
set(handles.list_order, 'String', empty_array);
set(handles.show_data, 'String', empty_array);
set(handles.show_data,'value',1) ;

function print_directory_CreateFcn(hObject, eventdata, handles)
function print_data_directory_CreateFcn(hObject, eventdata, handles)
function off_bt_Callback(hObject, eventdata, handles)
function off_bs_Callback(hObject, eventdata, handles)

% --- Executes on button press in create_image2.
function create_image2_Callback(hObject, eventdata, handles)
% hObject    handle to create_image2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of create_image2


% --- Executes on selection change in select_list.
function select_list_Callback(hObject, eventdata, handles)
% hObject    handle to select_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns select_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from select_list


% --- Executes during object creation, after setting all properties.
function select_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to select_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function start_button2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to start_button2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function apply_data_CreateFcn(hObject, eventdata, handles)
% hObject    handle to apply_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function tosave_Callback(hObject, eventdata, handles)
% hObject    handle to tosave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tosave as text
%        str2double(get(hObject,'String')) returns contents of tosave as a double


% --- Executes during object creation, after setting all properties.
function tosave_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tosave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tosave2_Callback(hObject, eventdata, handles)
% hObject    handle to tosave2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tosave2 as text
%        str2double(get(hObject,'String')) returns contents of tosave2 as a double


% --- Executes during object creation, after setting all properties.
function tosave2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tosave2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function list_order_Callback(hObject, eventdata, handles)
% hObject    handle to list_order (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of list_order as text
%        str2double(get(hObject,'String')) returns contents of list_order as a double


% --- Executes during object creation, after setting all properties.
function list_order_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_order (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function spike_counter_Callback(hObject, eventdata, handles)
% hObject    handle to spike_counter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of spike_counter as text
%        str2double(get(hObject,'String')) returns contents of spike_counter as a double


% --- Executes during object creation, after setting all properties.
function spike_counter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spike_counter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function time1_2_Callback(hObject, eventdata, handles)
% hObject    handle to time1_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of time1_2 as text
%        str2double(get(hObject,'String')) returns contents of time1_2 as a double


% --- Executes during object creation, after setting all properties.
function time1_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time1_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function time2_2_Callback(hObject, eventdata, handles)
% hObject    handle to time2_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of time2_2 as text
%        str2double(get(hObject,'String')) returns contents of time2_2 as a double


% --- Executes during object creation, after setting all properties.
function time2_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time2_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function time1_1_Callback(hObject, eventdata, handles)
% hObject    handle to time1_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of time1_1 as text
%        str2double(get(hObject,'String')) returns contents of time1_1 as a double


% --- Executes during object creation, after setting all properties.
function time1_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time1_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function time2_1_Callback(hObject, eventdata, handles)
% hObject    handle to time2_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of time2_1 as text
%        str2double(get(hObject,'String')) returns contents of time2_1 as a double


% --- Executes during object creation, after setting all properties.
function time2_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time2_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in shading.
function shading_Callback(hObject, eventdata, handles)
% hObject    handle to shading (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of shading
