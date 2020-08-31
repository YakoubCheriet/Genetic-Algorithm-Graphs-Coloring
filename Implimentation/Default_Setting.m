function Default_Setting()

handles = guihandles(gcbo);

set(handles.Max_Gen,'String','100');
set(handles.Pop_size,'String','100');
set(handles.Proba_Croiss,'String','0.8');
set(handles.Proba_Mut,'String','0.1');
set(handles.Max_Col,'String','5');

set(handles.Begin_Calcul,'enable', 'off')
set(handles.Select_G,'enable', 'on');
set(handles.Create_G,'enable', 'on');
set(handles.Close_All,'enable', 'on')

set(handles.Elapsed_Time,'String', 'Elapsed Time ( 0 sec )');
set(handles.Best_Pop_value,'String', '---');
set(handles.Best_Pop_value,'ForegroundColor','b');
set(handles.Conflit_nbr,'String', '---');
set(handles.Color_Value,'String', '---');
set(handles.Fitness_Value,'String', 'Fitness Value');

end

