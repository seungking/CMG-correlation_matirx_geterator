function sttc_correlation_create_new(varargin)
%% Get variables inputted by user
[cax,args,nargs] = axescheck(varargin{:});

cax = newplot(cax);
nextPlot = cax.NextPlot;

[dir_name,method,dt,response_type,list_order,spike_counter,spike_list,range1,range2,select_list] = deal(args{1:10});
% dir_name : directory selected by user
% method : (1) sttc_correlation / (2) k_w_correlation
% response_type : (1) Light / (2) Electric
% list_order : fullfile path of cell
% spike_counter : number of each spikes
% spike_list : name of slected spike
% range1, range2 : time range inputted from user
% select_list : all spikes

working_dir = pwd;

%% Set conditions
if response_type == 1 % Light response
    psth_path = '0_Light_Responses\6_New_Results\PSTH';
    spike_path = '0_Light_Responses\5_Spike_And_Artifact_Onsets';
    Time = [0, 3];
else if response_type == 2 % Electric response
    spike_path = '3_Long\5_Spike_And_Artifact_Onsets';
    psth_path = '3_Long\6_New_Results\PSTH';
    Time = [0, 2];
    end
end

correlation_r = [length(list_order),length(list_order)];
dtdt = dt/10^3;

psth_txt = sprintf('%s%d%s','Averaged_Rolling_Histogram(',dt,'ms).txt');
X = (0:length(list_order));
Y = (0:length(list_order));

%% Calculate the correlation_r
%% First cell comparison
current_index = 1;
for ch_first = 1 : length(spike_counter)
    %get spikes of first comparison cell
    save_match_first = spike_list(current_index : current_index + str2double(cellstr(spike_counter(ch_first)))-1);
    numm = current_index;
    %% Second cell comparison
    for ch_second = ch_first : length(spike_counter)
        num1 = numm;
        num2 = num1 + str2double(cellstr(spike_counter(ch_second)));
        numm = num2;
        %get spikes of first comparison cell
        save_match_second = spike_list(num1 : num2 -1);
        sum_correlation_coeffcient = [];
        %% First spike_train comparison
        for ii = 1 : length(save_match_first)
            %% Second spike_train comparison
            for kk = 1 : length(save_match_second)

                spike_times_1 = load(save_match_first{ii}, 'SomaSpkOnset');
                spike_times_2 = load(save_match_second{kk}, 'SomaSpkOnset');

                if(length(spike_times_1.SomaSpkOnset)==1 || length(spike_times_2.SomaSpkOnset)==1)
                    continue;
                end

                TA=0; TB=0; PA=0; PB=0; T=0; index=0;
                N1 = 0; N2 = 0;

                %set range of spike and get spike train                
                if (~isnan(range1) && ~isnan(range2))
                    period1 = range1*10^5;
                    period2 = range2*10^5;
                else if response_type == 2
                    period1 = 0.5*10^5;
                    period2 = (p22(p2)*10^5);               
                else 
                    period1 = 10^5;
                    period2 = (10^5)*2;
                end
                end

                spike_times_1.SomaSpkOnset(spike_times_1.SomaSpkOnset < (period1 - dt*10^2)) = [];
                spike_times_1.SomaSpkOnset(spike_times_1.SomaSpkOnset > (period2 - dt*10^2)) = [];
                spike_times_1.SomaSpkOnset = spike_times_1.SomaSpkOnset/10^5;
                if (length(spike_times_1.SomaSpkOnset) < 2)
                    continue
                end
                N1=length(spike_times_1.SomaSpkOnset);

                spike_times_2.SomaSpkOnset(spike_times_2.SomaSpkOnset < (period1 - dt*10^2)) = [];
                spike_times_2.SomaSpkOnset(spike_times_2.SomaSpkOnset > (period2 - dt*10^2)) = [];
                spike_times_2.SomaSpkOnset = spike_times_2.SomaSpkOnset/10^5;
                if (length(spike_times_2.SomaSpkOnset) < 2 )
                    continue
                end
                N2=length(spike_times_2.SomaSpkOnset);
                
                if (N2 == 1 || N2 == 0)
                    continue
                end
                if(N1==0 || N2==0)
                    index=0;
                else
                    %% calculate correlation index                    
                    T=Time(2)-Time(1);
                    start = Time(1);
                    endv = Time(2);
                                        
                    TA=2*N1*dtdt;
                    diff1=0;
                    if(N1==1)
                        if((spike_times_1.SomaSpkOnset(1)-start)<dtdt)
                            TA=TA-start+spike_times_1.SomaSpkOnset(1)-dtdt;
                        else if((spike_times_1.SomaSpkOnset(1)+dtdt)>endv)
                                TA=TA-spike_times_1.SomaSpkOnset(1)-dtdt+endv;
                            end
                        end
                    else
                        it = 0;
                        while(it<(N1-1))
                            diff1=spike_times_1.SomaSpkOnset(it+2)-spike_times_1.SomaSpkOnset(it+1);
                            if(diff1<2*dtdt) 	
                                TA=TA-2*dtdt+diff1;
                            end
                                it = it+1;
                        end

                        if((spike_times_1.SomaSpkOnset(1)-start)<dtdt)
                            TA=TA-start+spike_times_1.SomaSpkOnset(1)-dtdt;
                        end
                        if((endv-spike_times_1.SomaSpkOnset(N1))<dtdt)
                            TA=TA-spike_times_1.SomaSpkOnset(N1)-dtdt+endv;
                        end
                    end
                    TA=TA/T;
                   %=================================================================================================                     
                    TB=2*N2*dtdt;
                    diff1=0;
                    if(N2==1)
                        if((spike_times_2.SomaSpkOnset(1)-start)<dtdt)
                            TB=TB-start+spike_times_2.SomaSpkOnset(1)-dtdt;
                        else if((spike_times_2.SomaSpkOnset(1)+dtdt)>endv)
                                TB=TB-spike_times_2.SomaSpkOnset(1)-dtdt+endv;
                            end
                        end
                    else
                        it = 0;
                        while(it<(N2-1))
                            diff2=spike_times_2.SomaSpkOnset(it+2)-spike_times_2.SomaSpkOnset(it+1);
                            if(diff2<2*dtdt) 	
                                TB=TB-2*dtdt+diff2;
                            end
                                it = it+1;
                        end

                        if((spike_times_2.SomaSpkOnset(1)-start)<dtdt)
                            TB=TB-start+spike_times_2.SomaSpkOnset(1)-dtdt;
                        end
                        if((endv-spike_times_2.SomaSpkOnset(N2))<dtdt)
                            TB=TB-spike_times_2.SomaSpkOnset(N2)-dtdt+endv;
                        end
                    end

                    TB=TB/T;
                   %=================================================================================================                     
                    PA=0;
                    pi1=0;
                    pi2=0;
                    while(pi1<=(N1-1))
                        while(pi2<N2)	
                            if(abs(spike_times_1.SomaSpkOnset(pi1+1)-spike_times_2.SomaSpkOnset(pi2+1))<=dtdt)
                                PA=PA+1;	
                                break;
                                else if(spike_times_2.SomaSpkOnset(pi2+1)>spike_times_1.SomaSpkOnset(pi1+1))		
                                    break;            
                                else
                                    pi2=pi2+1;
                                end
                            end
                        end
                        pi1 = pi1+1;
                    end
                    PA=PA/N1;
                   %================================================================================================= 
                    PB=0;
                    pi1=0;
                    pi2=0;
                    while(pi1<=(N2-1))
                        while(pi2<N1)	
                            if(abs(spike_times_2.SomaSpkOnset(pi1+1)-spike_times_1.SomaSpkOnset(pi2+1))<=dtdt)
                                PB=PB+1;	
                                break;
                                else if(spike_times_1.SomaSpkOnset(pi2+1)>spike_times_2.SomaSpkOnset(pi1+1))		
                                    break;            
                                else
                                    pi2=pi2+1;
                                end
                            end
                        end
                        pi1 = pi1+1;
                    end
                    PB=PB/N2;
                   %================================================================================================                     

                    index=0.5*(PA-TB)/(1-TB*PA)+0.5*(PB-TA)/(1-TA*PB);% correlation index

                end
                %array of correlation coefficient
               sum_correlation_coeffcient = [sum_correlation_coeffcient, index];
            end
        end
        %save average of index from all spike train compared each other
        correlation_r(ch_first,ch_second) = sum(sum_correlation_coeffcient)/length(sum_correlation_coeffcient);
        correlation_r(ch_second,ch_first) = sum(sum_correlation_coeffcient)/length(sum_correlation_coeffcient);

    end
    current_index = current_index + str2double(cellstr(spike_counter(ch_first)));
end

%% Set name of directroy and files
cells_name = '';
cells_order = cell(length(list_order));
cells_order_count=1;

if response_type == 1 % Light response
    cells_name = sprintf('%s%s', cells_name, 'Light');
end
if response_type == 2% Electric response
    cells_name = sprintf('%s%s', cells_name, 'Electric');
end

% % %=======================================================================================================================================
data_dir_path = dir_name;
if method == 1% STTC
   for dir_num = 1 : 9999
    psth_dirname = sprintf('%s%s%s%d%s%d%s', '(STTC)', cells_name, 'NEW', dt,'ms(',dir_num,')');
    if ~exist(fullfile(data_dir_path, psth_dirname))
        break;
    end
   end
end
if method == 2% K_W
   for dir_num = 1 : 9999    
    psth_dirname = sprintf('%s%s%s%d%s%d%s', '(K_W)', cells_name, 'NEW', dt,'ms(', dir_num, ')');
    if ~exist(fullfile(data_dir_path, psth_dirname))
        break;
    end
   end
end
psth_store = cell(length(list_order),length(list_order));

% make directory
if ~exist(fullfile(data_dir_path, psth_dirname))
    mkdir(fullfile(data_dir_path, psth_dirname)); 
end


%% Save result in Excel file
cd(fullfile(data_dir_path, psth_dirname))

filename = 'correlation_values(matrix).xlsx';
xlswrite(filename,correlation_r)

filename = 'correlation_values.xlsx';
xlswrite(filename,reshape(correlation_r,1,length(list_order)^2)')

select_list_name = 'selected_cell_list.xlsx';
xlswrite(select_list_name,cellstr(select_list));


%% Save matrix as a image file
for n = 1 : length(spike_counter)+1
     correlation_r(n,length(spike_counter)+1) = 0;
     correlation_r(length(spike_counter)+1,n) = 0;
end


cd(working_dir)
figure(3)
my_pcolor(X,Y,correlation_r,psth_store,1);
title(cells_name);
colorbar;

caxis([-0.5 1]);
xlabel('UNIT#');
ylabel('UNIT#');
axis([0 length(list_order) 0 length(list_order)]);
colormap jet;

legend('off');
if length(spike_counter) > 4
    set(gca,'Xtick',[0, round(length(spike_counter)*(1/4)) , round(length(spike_counter)*(2/4)), round(length(spike_counter)*(3/4)), length(spike_counter)])
    set(gca,'Ytick',[0, round(length(spike_counter)*(1/4)) , round(length(spike_counter)*(2/4)), round(length(spike_counter)*(3/4)), length(spike_counter)])
else
    set(gca,'Xtick',[0, round(length(spike_counter)*(2/4)), length(spike_counter)])
    set(gca,'Ytick',[0, round(length(spike_counter)*(2/4)), length(spike_counter)])    
end
set(gca,'YDir','rev');
saveas(gcf, fullfile(data_dir_path, psth_dirname,'Correlation_matrix'),'jpeg');
close(3);

%% Plot correlation matrix on figure
my_pcolor(X,Y,correlation_r,psth_store,1);
title(cells_name);
colorbar;

caxis([-0.5 1]);
xlabel('UNIT#');
ylabel('UNIT#');
axis([0 length(list_order) 0 length(list_order)]);
colormap jet;

legend('off');
if length(spike_counter) > 4
    set(gca,'Xtick',[0, round(length(spike_counter)*(1/4)) , round(length(spike_counter)*(2/4)), round(length(spike_counter)*(3/4)), length(spike_counter)])
    set(gca,'Ytick',[0, round(length(spike_counter)*(1/4)) , round(length(spike_counter)*(2/4)), round(length(spike_counter)*(3/4)), length(spike_counter)])
else
    set(gca,'Xtick',[0, round(length(spike_counter)*(2/4)), length(spike_counter)])
    set(gca,'Ytick',[0, round(length(spike_counter)*(2/4)), length(spike_counter)])    
end

set(gca,'YDir','rev');
