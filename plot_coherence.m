function[]=plot_coherence(S_matrix_rest, S_matrix_task, chanlocs,C)

x=[];
y=[];
labels={};
    for i=1:19
        x= [x chanlocs.chanlocs(i).X];
        y= [y chanlocs.chanlocs(i).Y];  
        labels{i} = chanlocs.chanlocs(i).labels;
    end

figure,
for i=1:6
    subplot(2,3,i)
    
    plot(x,y,'.','Color','k')
    text(x,y,labels,'VerticalAlignment','top','HorizontalAlignment','right')
    title("Subject"+i)
    hold on
    grid on

    for j=1:length(S_matrix_rest(:,1))
        if S_matrix_rest(j,i)>=0.9
            el1=C(j,1);
            el2=C(j,2);

            k=0;
            s=0;
            while k==0
                s=s+1;
                k=strcmpi(chanlocs.chanlocs(s).labels,el1);  
            end

            k=0;
            t=0;
            while k==0
                t=t+1;
                k=strcmpi(chanlocs.chanlocs(t).labels,el2);  
            end

            ts = [chanlocs.chanlocs(s).X,chanlocs.chanlocs(t).X];
            ys = [chanlocs.chanlocs(s).Y,chanlocs.chanlocs(t).Y] ;
            tdis = linspace (min(ts) , max(ts) , 2);
            yICL = interp1 (ts,ys,tdis);

            p1 = plot(tdis,yICL,'r');
        end

        if S_matrix_task(j,i)>=0.9
            el1=C(j,1);
            el2=C(j,2);

            k=0;
            s=0;
            while k==0
                s=s+1;
                k=strcmpi(chanlocs.chanlocs(s).labels,el1);  
            end

            k=0;
            t=0;
            while k==0
                t=t+1;
                k=strcmpi(chanlocs.chanlocs(t).labels,el2);  
            end

            ts = [chanlocs.chanlocs(s).X,chanlocs.chanlocs(t).X];
            ys = [chanlocs.chanlocs(s).Y,chanlocs.chanlocs(t).Y] ;
            tdis = linspace (min(ts) , max(ts) , 2);
            yICL = interp1 (ts,ys,tdis);

            p2 = plot(tdis,yICL,['b']);
        end
    end
    legend([p1 p2],'rest','task','Location','northwest');
    
    end