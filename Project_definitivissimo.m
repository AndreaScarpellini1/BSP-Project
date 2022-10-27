clc 
clear all
close all
%% if you want to visualize VIZ =1
viz=1;
%% LOADING DATA
%Frequenza di Campionamento
fs_EEG=500; 
%Canali 
chanlocs=load("chanlocs.mat");
frequency_band={8:(1/fs_EEG):13, 13:(1/fs_EEG):30, 4:(1/fs_EEG):8};
sub=[1,2,3,7,8]; % non consideriamo soggetto 5 perchè outliers

for i=1:length(sub)
    Subjects_Rest{i}=load("Subject0"+sub(i)+"_1.mat");
    Subjects_Task{i}=load("Subject0"+sub(i)+"_2.mat");
end

ch_names=fieldnames(Subjects_Rest{1});

% già filtrati e già fatto detrend --> tolta la fq a 50 Hz
% dati già preprocessati

%% BANDE Theta
%parametri
wf=(8/(fs_EEG/2));
wl=(4/(fs_EEG/2));
filter_order=4;

[b1,a1] = butter(filter_order,wl,'high'); 
[b2,a2] = butter(filter_order,wf,'low');


for i=1:1:length(Subjects_Rest) %ogni sub 
    for s=1:1:length(ch_names)
        Subjects_rest_theta{i}.(ch_names{s}) = filtfilt(b1,a1,Subjects_Rest{i}.(ch_names{s})); 
        Subjects_rest_theta{i}.(ch_names{s}) = filtfilt(b2,a2,Subjects_rest_theta{i}.(ch_names{s}));

        Subjects_task_theta{i}.(ch_names{s}) = filtfilt(b1,a1,Subjects_Task{i}.(ch_names{s})); 
        Subjects_task_theta{i}.(ch_names{s}) = filtfilt(b2,a2,Subjects_task_theta{i}.(ch_names{s}));
        
        Subjects_rest_theta{i}.(ch_names{s})=detrend(Subjects_rest_theta{i}.(ch_names{s}));
        Subjects_task_theta{i}.(ch_names{s})=detrend(Subjects_task_theta{i}.(ch_names{s}));
    end 
end 

%% BANDE ALPHA
%parametri
wf=(13 /(fs_EEG/2));
wl=(8/(fs_EEG/2));
filter_order=4;

[b1,a1] = butter(filter_order,wl,'high'); 
[b2,a2] = butter(filter_order,wf,'low');


for i=1:1:length(Subjects_Rest) %ogni sub 
    for s=1:1:length(ch_names)
        Subjects_rest_alpha{i}.(ch_names{s}) = filtfilt(b1,a1,Subjects_Rest{i}.(ch_names{s})); 
        Subjects_rest_alpha{i}.(ch_names{s}) = filtfilt(b2,a2,Subjects_rest_alpha{i}.(ch_names{s}));

        Subjects_task_alpha{i}.(ch_names{s}) = filtfilt(b1,a1,Subjects_Task{i}.(ch_names{s})); 
        Subjects_task_alpha{i}.(ch_names{s}) = filtfilt(b2,a2,Subjects_task_alpha{i}.(ch_names{s}));
        
        Subjects_rest_alpha{i}.(ch_names{s})=detrend(Subjects_rest_alpha{i}.(ch_names{s}));
        Subjects_task_alpha{i}.(ch_names{s})=detrend(Subjects_task_alpha{i}.(ch_names{s}));
    end 
end 

% selezionamo i segnali delle due condizioni nella banda alpha

%% BANDE BETA 
%parametri
wf=(30/(fs_EEG/2));
wl=(13/(fs_EEG/2));
filter_order=4;

[b1,a1] = butter(filter_order,wl,'high'); 
[b2,a2] = butter(filter_order,wf,'low');


for i=1:1:length(Subjects_Rest) %ogni sub 
    for s=1:1:length(ch_names)
        Subjects_rest_beta{i}.(ch_names{s}) = filtfilt(b1,a1,Subjects_Rest{i}.(ch_names{s})); 
        Subjects_rest_beta{i}.(ch_names{s}) = filtfilt(b2,a2,Subjects_rest_beta{i}.(ch_names{s}));

        Subjects_task_beta{i}.(ch_names{s}) = filtfilt(b1,a1,Subjects_Task{i}.(ch_names{s})); 
        Subjects_task_beta{i}.(ch_names{s}) = filtfilt(b2,a2,Subjects_task_beta{i}.(ch_names{s}));
        
        Subjects_rest_beta{i}.(ch_names{s})=detrend(Subjects_rest_beta{i}.(ch_names{s}));
        Subjects_task_beta{i}.(ch_names{s})=detrend(Subjects_task_beta{i}.(ch_names{s}));
    end 
end

% selezionamo i segnali delle due condizioni nella banda beta

%% CALCOLO PSD REST theta

M_rest_theta=[];
for i=1:1:length(sub) 
    for s=1:1:length(ch_names)
        [M_rest_theta(s,:,i),fr_t] = pwelch(Subjects_rest_theta{i}.(ch_names{s})(38001:53000),hamming(1000),500,frequency_band{3},500);
    end
end 

%% CALCOLO PSD TASK Theta 
M_task_theta=[];
for i=1:1:length(sub) 
    for s=1:1:length(ch_names)
        [M_task_theta(s,:,i),ft_t] = pwelch(Subjects_task_theta{i}.(ch_names{s})(8001:23000),hamming(1000),500,frequency_band{3},500);
    end
end 

%% PLOTTO PSD theta mediato ch_names
if (viz==1)
    errorbar_psd(M_rest_theta,M_task_theta,ft_t,' THETA BAND');
end

%% PLOTTO HEAD PLOT DEI SOGGETTI 
if(viz==1)
headplot_psd(M_rest_theta,M_task_theta,' THETA BAND',chanlocs);
end

%% CALCOLO PSD REST ALPHA 
%INFO
% Lunghezza segnale: 30 s
% Lunghezzza finestra 5 s
% 6 finestre con Overlap 50%

M_rest_alpha=[];
for i=1:1:length(sub) 
    for s=1:1:length(ch_names)
        [M_rest_alpha(s,:,i),fr_a] = pwelch(Subjects_rest_alpha{i}.(ch_names{s})(38001:53000),hamming(1000),500,frequency_band{1},500);
    end
end 
%% CALCOLO PSD TASK ALPHA 

M_task_alpha=[];
for i=1:1:length(sub) 
    for s=1:1:length(ch_names)
        [M_task_alpha(s,:,i),ft_a] = pwelch(Subjects_task_alpha{i}.(ch_names{s})(8001:23000),hamming(1000),500,frequency_band{1},500);
    end
end 

% per PSD utilizziamo il metodo di welch con una finestra di Hamming
% ogni finestra ha 500*5 = 2500
% selezioniamo i 30 sec centrali di ogni segnale, per assicurarsi di
% raggiungere una condizione standard, evitando periodi di adattamento
% 3 min non sono necessari --> basta anche uno studio di 30 sec
% computazionalemtne più leggero
%% PLOTTO PSD ALPHA mediato ch_names
if (viz==1)
    errorbar_psd(M_rest_alpha,M_task_alpha,ft_a,' ALPHA BAND');
end 
%% PLOTTO HEAD PLOT DEI SOGGETTI 
if (viz==1)
    headplot_psd(M_rest_alpha,M_task_alpha,' ALPHA BAND',chanlocs);
end 
%% CALCOLO PSD REST BETA 

M_rest_beta=[];
for i=1:1:length(sub) 
    for s=1:1:length(ch_names)
        [M_rest_beta(s,:,i),fr_b] = pwelch(Subjects_rest_beta{i}.(ch_names{s})(38001:53000),hamming(1000),500,frequency_band{2},500);
    end
end 

%% CALCOLO PSD TASK BETA 
M_task_beta=[];
for i=1:1:length(sub) 
    for s=1:1:length(ch_names)
        [M_task_beta(s,:,i),ft_b] = pwelch(Subjects_task_beta{i}.(ch_names{s})(8001:23000),hamming(1000),500,frequency_band{2},500);
    end
end 

%% PLOTTO PSD BETA mediato ch_names
if (viz==1)
    errorbar_psd(M_rest_beta,M_task_beta,ft_b,' BETA BAND');
end

%% PLOTTO HEAD PLOT DEI SOGGETTI 
if(viz==1)
    headplot_psd(M_rest_beta,M_task_beta,' BETA BAND',chanlocs);
end 
%% ANALISI BOXPLOT THETA 
max_theta_rest=[];
max_theta_task=[];

for i=1:1:length(sub) 
    for s=1:1:length(ch_names)
        max_theta_rest(i,s) = max(M_rest_theta(s,find(fr_t==4):find(fr_t==8),i));
        max_theta_task(i,s) = max(M_task_theta(s,find(ft_t==4):find(ft_t==8),i));
    end
end 

avg_max_rest=[];
avg_max_rest=[avg_max_rest mean(max_theta_rest(1:length(sub),1:3),2) mean(max_theta_rest(1:length(sub),4:10),2) mean(max_theta_rest(1:length(sub),11:12),2) mean(max_theta_rest(1:length(sub),13:15),2) mean(max_theta_rest(1:length(sub),16:19),2)];
avg_max_task=[];
avg_max_task=[avg_max_task mean(max_theta_task(1:length(sub),1:3),2) mean(max_theta_task(1:length(sub),4:10),2) mean(max_theta_task(1:length(sub),11:12),2) mean(max_theta_task(1:length(sub),13:15),2) mean(max_theta_task(1:length(sub),16:19),2)];

max_all=max(max(avg_max_task));


title_box={'Central','Frontal','Occipital','Parietal','Temporal'};
if(viz==1)
    figure('Name','Theta Band')
    for i=1:5
    
        subplot(1,5,i)
        boxplot([avg_max_rest(:,i);avg_max_task(:,i)],[repelem("Rest",length(sub)),repelem("Task",length(sub))],'Color',['r','b']);
        ylim([0,max_all]);
        title(title_box{i})
        grid on 

        color=[0 0 1; 1 0 0];
        h = findobj(gca,'Tag','Box');
        for j=1:length(h)
            patch(get(h(j),'XData'),get(h(j),'YData'),color(j,:),'FaceAlpha',.5);
        end
    end
end

%% ANALISI BOXPLOT ALPHA 
max_alpha_rest=[];
max_alpha_task=[];

for i=1:1:length(sub) 
    for s=1:1:length(ch_names)
        max_alpha_rest(i,s) = max(M_rest_alpha(s,find(fr_a==8):find(fr_a==13),i));
        max_alpha_task(i,s) = max(M_task_alpha(s,find(ft_a==8):find(ft_a==13),i));
    end
end 

avg_max_rest=[];
avg_max_rest=[avg_max_rest mean(max_alpha_rest(1:length(sub),1:3),2) mean(max_alpha_rest(1:length(sub),4:10),2) mean(max_alpha_rest(1:length(sub),11:12),2) mean(max_alpha_rest(1:length(sub),13:15),2) mean(max_alpha_rest(1:length(sub),16:19),2)];
avg_max_task=[];
avg_max_task=[avg_max_task mean(max_alpha_task(1:length(sub),1:3),2) mean(max_alpha_task(1:length(sub),4:10),2) mean(max_alpha_task(1:length(sub),11:12),2) mean(max_alpha_task(1:length(sub),13:15),2) mean(max_alpha_task(1:length(sub),16:19),2)];

max_all=max(max(avg_max_rest));
title_box={'Central','Frontal','Occipital','Parietal','Temporal'};

if (viz==1)
    figure('Name','Alpha Band')
    for i=1:5
        subplot(1,5,i)
        boxplot([avg_max_rest(:,i);avg_max_task(:,i)],[repelem("Rest",length(sub)),repelem("Task",length(sub))],'Color',['r','b']);
        ylim([0,max_all]);
        title(title_box{i})
        grid on 
    
        color=[0 0 1; 1 0 0];
        h = findobj(gca,'Tag','Box');
        for j=1:length(h)
            patch(get(h(j),'XData'),get(h(j),'YData'),color(j,:),'FaceAlpha',.5);
        end

        
    end
    

end 

figure(10)
subplot(1,2,1)
boxplot([avg_max_rest(:,3);avg_max_task(:,3)],[repelem("Rest",length(sub)),repelem("Task",length(sub))],'Color',['r','b']);
ylim([0,max_all]);
title(title_box{3})
grid on 
    
color=[0 0 1; 1 0 0];
h = findobj(gca,'Tag','Box');
     for j=1:length(h)
          patch(get(h(j),'XData'),get(h(j),'YData'),color(j,:),'FaceAlpha',.5);
     end
subplot(1,2,2)
boxplot([avg_max_rest(:,4);avg_max_task(:,4)],[repelem("Rest",length(sub)),repelem("Task",length(sub))],'Color',['r','b']);
ylim([0,max_all]);
title(title_box{4})
grid on 
    for j=1:length(h)
          patch(get(h(j),'XData'),get(h(j),'YData'),color(j,:),'FaceAlpha',.5);
    end
    
           %% ANALISI BOXPLOT BETA 
max_beta_rest=[];
max_beta_task=[];

for i=1:1:length(sub) 
    for s=1:1:length(ch_names)
        max_beta_rest(i,s) = max(M_rest_beta(s,find(fr_b==13):find(fr_b==30),i));
        max_beta_task(i,s) = max(M_task_beta(s,find(ft_b==13):find(ft_b==30),i));
    end
end 

avg_max_rest=[];
avg_max_rest=[avg_max_rest mean(max_beta_rest(1:length(sub),1:3),2) mean(max_beta_rest(1:length(sub),4:10),2) mean(max_beta_rest(1:length(sub),11:12),2) mean(max_beta_rest(1:length(sub),13:15),2) mean(max_beta_rest(1:length(sub),16:19),2)];
avg_max_task=[];
avg_max_task=[avg_max_task mean(max_beta_task(1:length(sub),1:3),2) mean(max_beta_task(1:length(sub),4:10),2) mean(max_beta_task(1:length(sub),11:12),2) mean(max_beta_task(1:length(sub),13:15),2) mean(max_beta_task(1:length(sub),16:19),2)];

max_all=max(max(avg_max_task));


title_box={'Central','Frontal','Occipital','Parietal','Temporal'};
if(viz==1)
    figure('Name','Beta Band')
    for i=1:5
    
        subplot(1,2,i)
        boxplot([avg_max_rest(:,i);avg_max_task(:,i)],[repelem("Rest",length(sub)),repelem("Task",length(sub))],'Color',['r','b']);
        ylim([0,max_all]);
        title(title_box{i})
        grid on 
    
        color=[0 0 1; 1 0 0];
        h = findobj(gca,'Tag','Box');
        for j=1:length(h)
            patch(get(h(j),'XData'),get(h(j),'YData'),color(j,:),'FaceAlpha',.5);
        end
    end
end 



%% ANALISI INDICE DI COERENZA ALPHA
%Trovo le combinazioni 
C = nchoosek(ch_names,2);
for i=1:length(C(:,1))
    lg{i}=strcat(C{i,:});
end 
S_matrix_rest_alpha=zeros(length(C),length(Subjects_Rest));
S_matrix_task_alpha=zeros(length(C),length(Subjects_Task));
for i=1:length(Subjects_Task) %Giro i soggetti
    M_rest=[];
    M_task=[];
    for j=1:1:length(C(:,1))        %Giro le combinazioni di canali 
        [cxy_rest,ft]= mscohere(Subjects_Rest{i}.(C{j,1})(7251:22250),Subjects_Rest{i}.(C{j,2})(7251:22250),...
                       hamming(2500),1250,frequency_band{1},500);
        [cxy_task,ft]= mscohere(Subjects_Task{i}.(C{j,1})(7251:22250),Subjects_Task{i}.(C{j,2})(7251:22250),...
                       hamming(2500),1250,frequency_band{1},500);
        M_rest(j)=max(cxy_rest);
        M_task(j)=max(cxy_task);
    end    
    S_matrix_rest_alpha(:,i)=M_rest; 
    S_matrix_task_alpha(:,i)=M_task;
end 
fprintf("\n ALPHA BAND\n")
for i=1:length(Subjects_Rest)
    [M,I] = max (S_matrix_rest_alpha(:,i));
    fprintf("REST sub;%d,Electrodes:%s, Value:%f\n",i,lg{I},M);
end
disp("#############################")
for i=1:length(Subjects_Task)
    [M,I] = max (S_matrix_task_alpha(:,i));
    fprintf("TASK sub:%d, Electrodes:%s, Value:%f\n",i,lg{I},M);
end

%%
% ANALISI INDICE COERENZA BETA 
S_matrix_rest_beta=zeros(length(C),length(Subjects_Rest));
S_matrix_task_beta=zeros(length(C),length(Subjects_Task));

for i=1:length(Subjects_Rest) %Giro i soggetti
    M_rest=[];
    M_task=[];
    for j=1:1:length(C(:,1))        %Giro le combinazioni di canali 
        [cxy_rest,ft]= mscohere(Subjects_Rest{i}.(C{j,1})(7251:22250),Subjects_Rest{i}.(C{j,2})(7251:22250),...
                       hamming(2500),1250,frequency_band{2},500);
        [cxy_task,ft]= mscohere(Subjects_Task{i}.(C{j,1})(7251:22250),Subjects_Task{i}.(C{j,2})(7251:22250),...
                       hamming(2500),1250,frequency_band{2},500);
        M_rest(j)=max(cxy_rest);
        M_task(j)=max(cxy_task);
    end    
    S_matrix_rest_beta(:,i)=M_rest; 
    S_matrix_task_beta(:,i)=M_task;
end 
fprintf("\n BETA BAND\n")
for i=1:length(Subjects_Rest)
    [M,I] = max (S_matrix_rest_beta(:,i));
    fprintf("REST sub;%d,Electrodes:%s, Value:%f\n",i,lg{I},M);
end

disp("#############################")
for i=1:length(Subjects_Task)
    [M,I] = max (S_matrix_task_beta(:,i));
    fprintf("TASK sub:%d, Electrodes:%s, Value:%f\n",i,lg{I},M);
end
%%
plot_coherence(S_matrix_rest_beta,S_matrix_task_beta, chanlocs,C);
plot_coherence(S_matrix_rest_alpha,S_matrix_task_alpha, chanlocs,C);

