function []= headplot_psd(M_rest,M_task,band_name,chanlocs)

    %Medio e ottengo matrici 19x1x6
    M_rest=mean(M_rest,2);
    M_task=mean(M_task,2);
    
    for i=1:size(M_rest,3)
        MAX(i)=max([max(max(M_rest(:,1,i))),max(max(M_task(:,1,i)))]); 
        M_rest(:,1,i)=M_rest(:,1,i)./MAX(i);
        M_task(:,1,i)=M_task(:,1,i)./MAX(i);
    end 
    
    figure('Name',band_name)
    r=[1,3,5,7,9,11];
    t=[2,4,6,8,10,12];
    
    for i=1:size(M_rest,3)
        subplot(size(M_rest,3),2,r(i))
    
        topoplot(M_rest(:,1,i),chanlocs.chanlocs,'maplimits',([0,1]));
        colorbar
        if(i==1)
            title("REST",band_name)
        end
    
        subplot(size(M_rest,3),2,t(i))
        topoplot(M_task(:,1,i),chanlocs.chanlocs,'maplimits',([0,1]));
        colorbar 
        if(i==1)
            title("TASK",band_name)
        end
    end 
end
