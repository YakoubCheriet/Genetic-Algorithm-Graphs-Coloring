function Min_fit = Evaluation(Pop_Select,iter,Graph)

    Nbr_Conflit = 0;
    for j=1:size(Graph,2)
        for k=1:size(Graph,2)
            if(Graph(j,k)==1 && Pop_Select(iter,j)==Pop_Select(iter,k))
               Nbr_Conflit = Nbr_Conflit + 1;
            end
        end
    end

    Min_fit = Nbr_Conflit;
end
