function [min_color,Best_pop,Conflit_nbr ] = Genetic_Algorithm( graph,probabilite_croisement,probabilite_mutation,...
                                                                       Max_itera,Max_Pop,Max_colors )
%% Variables Globales
%--- non
%% Initialisation
warning('off','all');
% warning;

Conflit_nbr = size(graph,2);
pop_size = Max_Pop;


population = zeros(pop_size,size(graph,2));
Conflit = zeros(pop_size,1);

% initialize the population
pop_iter = 1;

while(pop_iter <= pop_size)
    
    interval_color = [1 Max_colors];
    Chrom = randint(1,1,interval_color); %generate random population based on colors given
    
    for i = 1: size(graph,2)         
         population(pop_iter,i) = Chrom; % fill the generated pop
    end
    
    pop_iter = pop_iter+1;
end
%% Evaluation Initial

for i = 1 : pop_iter - 1
    Conflit(i) = Evaluation(population,i,graph);
end
%% initialisation des Fils
child = zeros( Max_itera,size(graph,2) );
iter = 1;
%% Initialisation Generation | Colors
min_color_array = zeros(Max_itera,1);
min_Conflit = zeros(Max_itera,1);

%% Generation / iteration
% Proceed = true;
while( iter <= Max_itera )  %&& Proceed )
    
    num_child = 1;
    
%% Parents Selection  :
    while( num_child < pop_size )

        Random_Chrom = randint(2,1,interval_color);
        if( Conflit(Random_Chrom(1)) < Conflit(Random_Chrom(2)))
            parent1=population(Random_Chrom(1),:);
        else
            parent1=population(Random_Chrom(2),:);
        end

        interval_color=[1 Max_colors]; % regenerate randomly again to not get same result probabilities
        Random_Chrom = randint(2,1,interval_color);
        if( Conflit(Random_Chrom(1)) < Conflit(Random_Chrom(2)) )
            parent2=population(Random_Chrom(1),:);
        else
            parent2=population(Random_Chrom(2),:);
        end

%% Crossover :
        child1 = zeros(1,size(graph,2));
        child2 = zeros(1,size(graph,2));
        random = rand;
        if(random < probabilite_croisement)
            % Crossover at a point
            interval_color=[1 size(graph,2)-1];
            %[1]
            Random_Chrom = randint(1,1,interval_color);
            for i = 1 : Random_Chrom
                child1(i)=parent1(i);
                child2(i)=parent2(i);
            end
            %[2]
            for j = Random_Chrom +1 : size(graph,2)
                child1(j)=parent2(j);
                child2(j)=parent1(j);
            end
            %from [1] to [2] concatenate the two parts from both parent
        else
            % probability too weak, so no crossover
             child1=parent1;
             child2=parent2;
        end

%% Mutation
        % for child 1
        random = rand;
        if( random < probabilite_mutation )
            % generate randomly the location where the mutation will probably occur
            interval_location = [1 size(graph,2)];
            mutation_location = randint(1,1,interval_location);
            
            % append the mutation to the selected region
            interval_color = [1 Max_colors];
            mutation_Value = randint(1,1,interval_color);
            child1(mutation_location) = mutation_Value;
        end
        
        % for child 2
         random = rand;
        if( random < probabilite_mutation )
            % generate randomly the location where the mutation will probably occur
            interval_location=[1 size(graph,2)];
            mutation_location=randint(1,1,interval_location);
            
            % append the mutation to the selected region
            interval_color=[1 Max_colors];
            mutation_Value=randint(1,1,interval_color);
            child2(mutation_location)=mutation_Value;
        end

%% Make the changes after mutation/crossover
        child(num_child,:)=child1;
        child(num_child+1,:)=child2;
        num_child=num_child+2;
    end
    population=child;
%% Fitness Calculation
    Conflit = zeros( pop_iter - 1 , 1 );
    for k = 1: pop_iter -1
        uniqu_colors(k) = size(unique(population(k,:)),2);
        Conflit(k)=Evaluation(population,k,graph);
        
%% EVALUATION : Test for best population
        Min_f = unique (min (Conflit(k)));
        %% *** Check ligne [160 - 169] ***
    end

%% Save the different values needed for plotting

    mfit=mean(Conflit);
    
    % recover the minimum number of conflict
    min_Conflit(iter)=mfit;                 %for Multip Display
    min_fitness_nbr (iter)= min (mfit);     %for Singulair Display
    
    %Add the new required min color number
    min_color_array(iter)=min(uniqu_colors);
    
%% PLot Display
    plot(min_Conflit,'Color', 'k'); %     color string = 'kbgry';
    xlim([1 Max_itera])
    pause(.05)
    xlabel('Generations')
    ylabel('Conflit | Colors')
    grid
    title(sprintf('GRAPH : Conflit & Colors / Generation'));
    
    handles = guihandles(gcbo);
    set(handles.uipanel_Color,'BackgroundColor','b');
    set(handles.uipanel_Fitness,'BackgroundColor','k');
    set(handles.Fitness_Value,'String',Min_f)
    
    %% Test for best result if so (cnflit = 0) then STOP the whole process
    if Min_f == 0
        Best_pop = population;      % keep that best selected pop for conflit = 0
        Conflit_nbr = 0;
%         Proceed = false;
    else
        if ( (Min_f >= 1) && (Conflit_nbr ~= 0) )
            Best_pop = population;  % keep that best selected pop for best conflit found
            Conflit_nbr = Min_f;
        end
    end
    
    % Next gen please
    iter = iter+1;
end

%% The Returned Result(s)
Best_pop;
Conflit_nbr;
min_color = ( min_color_array(1:Max_itera) );
end