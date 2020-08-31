function varargout = Main(varargin)
% Last Modified by GUIDE v2.5 25-Apr-2018 21:22:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Main_OpeningFcn, ...
                   'gui_OutputFcn',  @Main_OutputFcn, ...
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


% --- Executes just before Main is made visible.
function Main_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for Main
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%clear all objects
evalin( 'base', 'clearvars *' );
clc;
set(handles.Begin_Calcul,'enable', 'off');

% UIWAIT makes Main wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = Main_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in Select_G.
function Select_G_Callback(hObject, eventdata, handles)

global read_graph

set(handles.Create_G,'enable', 'off')
evalin( 'base', 'clearvars *' );  % clear all workspace & objet **New Start**
cla;

[file, path]=uigetfile('*.txt','Open graph');

Getfile=strcat (path , file); % to concatinate bouth the path and file nime together

if file==0          % Test if the file loaded EMTPY or NOT
    msgbox('Select input file with your graph please !','Error','Error');
    return
else
    msgbox('Graph loaded succefuly, please click on "Start" Button to continue !','info','Help');
    set(handles.Create_G,'enable', 'off');
end

if get(handles.radiobutton_adja,'Value') == 1
    Brute_File = fopen(Getfile);
    [ N,M,A,read_graph ] = Read_File (Brute_File);
else
    read_graph = importdata(Getfile);
end

display (read_graph);            % Display the loaded Graph
size_d = size(read_graph);       % Size of matrix AKA Graph



if size_d(1)~= size_d(2)
    errordlg('Matrix A is not square, Please try again !','Error','modal') % Display error message if A is not square
    return                                          % Stop program execution 
end

set(handles.Begin_Calcul,'enable', 'on');


% --- Executes on button press in Create_G.
function Create_G_Callback(hObject, eventdata, handles)

% global Graph_Matrix
% 
Draw_Graph();
% 
% Test_G = isempty (Graph_Matrix);
% 
% if Test_G == 0
    set(handles.Select_G,'enable', 'off');
    set(handles.Begin_Calcul,'enable', 'on');
    
% end


% --- Executes on button press in Clear_All.
function Clear_All_Callback(hObject, eventdata, handles)
global cnt
global Max_Gen
cnt = Max_Gen;

cla;
%-restore The Default Setting
Default_Setting();
evalin( 'base', 'clearvars *' );  % clear all workspace & objet **New Start**
clear all; clc;



% --- Executes on button press in Close_All.
function Close_All_Callback(hObject, eventdata, handles)
% clear all ; clc ; cla ;
evalin( 'base', 'clearvars *' );
clear all ; clc ;
close(gcbf)
% quit force % error % dbquit % global cnt % cnt=300; % exit
perl('quitproc.pl','gphoto2.exe');


function Max_Gen_Callback(hObject, eventdata, handles)
% hObject    handle to Max_Gen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function Max_Gen_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Proba_Croiss_Callback(hObject, eventdata, handles)
% hObject    handle to Proba_Croiss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function Proba_Croiss_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Proba_Mut_Callback(hObject, eventdata, handles)
% hObject    handle to Proba_Mut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function Proba_Mut_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Max_Col_Callback(hObject, eventdata, handles)
% hObject    handle to Max_Col (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function Max_Col_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Begin_Calcul.
function Begin_Calcul_Callback(hObject, eventdata, handles)

global Graph_Matrix
global read_graph

Max_itera = str2double(get(handles.Max_Gen,'String'));
Max_Pop = str2double(get(handles.Pop_size,'String'));
probabilite_croisement = str2double(get(handles.Proba_Croiss,'String'));
probabilite_mutation = str2double(get(handles.Proba_Mut,'String'));
Max_colors = str2num(get(handles.Max_Col,'String'));

set(handles.plot_result,'HandleVisibility','ON');

TF1 = isempty(read_graph);
TF2 = isempty(Graph_Matrix);

if get(handles.radiobutton_adja,'Value') == 0
    if (TF2 == 0)
        tic
        [min_color_array,Best_pop,Conflit_nbr]=Genetic_Algorithm( Graph_Matrix,probabilite_croisement,...
                                                    probabilite_mutation,Max_itera,Max_Pop,Max_colors );
        M = size ( Graph_Matrix,2 );
        Ag=zeros(M,M);

        for i=1 :M
            for j=1 : M
                if Graph_Matrix(j,i)==1
                    Ag(j,i)=1;
                    Ag(i,j)=0;
                end
            end
        end
        
        bg= biograph(Ag);
    elseif (TF1 == 0)
        tic
        [min_color_array,Best_pop,Conflit_nbr]=Genetic_Algorithm( read_graph,probabilite_croisement,...
                                                    probabilite_mutation,Max_itera,Max_Pop,Max_colors );
        M = size ( read_graph,2 );
        Ag=zeros(M,M);

        for i=1 :M
            for j=1 : M
                if read_graph(j,i)==1
                    Ag(j,i)=1;
                    Ag(i,j)=0;
                end
            end
        end
        
        bg= biograph(Ag);
    else
        errordlg('Ether the graph is empty or you did not select a graph yet, please Try again !','Error','modal')
    end
else
    if (TF1 == 0)
        tic
        [min_color_array,Best_pop,Conflit_nbr]=Genetic_Algorithm( read_graph,probabilite_croisement,...
                                                    probabilite_mutation,Max_itera,Max_Pop,Max_colors );
        bg= biograph(read_graph);
    else
        errordlg('Ether the graph is empty or you did not select a graph yet, please Try again !','Error','modal')
    end
end

elaps = toc ;


set(bg,'ShowArrows','Off');
h=view (bg);
set(h.Nodes,'shape','circle');
set(h.Nodes,'LineColor',[0 0 0]);
set(h.Edges,'LineColor',[0 0.75 1]);

Nods_Num = size (Best_pop(1,:));
Best_color=Best_pop(1,:);

Str_pop=num2str(Best_pop(1,:)); % convert th numbers in the array to strings

set(handles.Best_Pop_value,'String',Str_pop );
set(handles.Best_Pop_value,'ForegroundColor','r');

S=Nods_Num(2);

%-Generate automatique random colors and store them for later coloration
a = 0;
b = 1;
for k=1:Max_colors
    r1= (b-a).*rand(1, 'double');
    r2= (b-a).*rand(1, 'double');
    r3= (b-a).*rand(1, 'double');
    Mat1 (k) = r1;
    Mat2 (k) = r2;
    Mat3 (k) = r3;
end

%-Atribute to the Graph Nods the Specific Colors "Generated Previously"
%->accordingly to the best population found
for i=1:S
    for k=1:Max_colors
        if Best_color(i)== k
            set(h.nodes(i),'color',[Mat1(k) Mat2(k) Mat3(k)])
        end
    end
end

Color_nbr = max (min_color_array);

set(handles.Color_Value,'String',Color_nbr)
set(handles.Conflit_nbr,'String',Conflit_nbr)

%Display the passed time
set(handles.Elapsed_Time,'String',elaps);

%Save All Varibale to A file, 'just for record'
%% Note u can load all the variables saved (graph included) afterwards, just click on "Variables_Back_UP.mat"
filename = 'Variables_Back_UP.mat'; % save all the variable used
save(filename);

% --- Executes on button press in radiobutton_Binary.
function radiobutton_Binary_Callback(hObject, eventdata, handles)
set(hObject,'Value',1.0);
set(handles.radiobutton_adja,'Value',0.0);

% --- Executes on button press in radiobutton_adja.
function radiobutton_adja_Callback(hObject, eventdata, handles)
set(hObject,'Value',1.0);
set(handles.radiobutton_Binary,'Value',0.0);



function Pop_size_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function Pop_size_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
