function []= errorbar_psd(M_rest,M_task,ft,band_name)
    
    %input 
    %M_rest: matrice electrodes X sample X subject
    %M_task: matrice electrodes X sample X subject
    
    figure()
    region={4:10,1:3,13:15,11:12,16:19};
    Name_region={'Canali Frontali', 'Canali Centrali','Canali Parietali','Canali Occipitali','Canali Temporali'};
    
    
    %Medio sui soggetti 
    
    M_rest_mean=mean(M_rest,3);
    M_task_mean=mean(M_task,3);
    
    for i=1:length(region)
    
        M_c_rest=M_rest_mean(region{i},:);
        M_c_task=M_task_mean(region{i},:);
        
        
        optionsr.handle = figure(i);
        optionsr.color_area = [243 169 114]./255;    % Orange theme
        optionsr.color_line = [236 112  22]./255;
        optionsr.alpha      = 0.5;
        optionsr.error = 'c95';
        optionsr.line_width = 2;
        optionsr.x_axis=ft;
        plot_areaerrorbar(M_c_rest,optionsr);
        hold on
        grid on 
        box  on 
        optionst.handle = figure(i);
        optionst.color_area = [128 193 219]./255; % Blue theme
        optionst.color_line = [ 52 148 186]./255;
        optionst.alpha      = 0.5;
        optionst.line_width = 2;
        optionst.x_axis=ft;
        optionst.error      = 'c95'; % 95 percent confidence interval
        plot_areaerrorbar(M_c_task,optionst);
        legend('','rest','','task');
        title([Name_region{i},band_name])
        
    end 
end 