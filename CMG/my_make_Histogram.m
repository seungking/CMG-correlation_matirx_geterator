function my_make_Histogram(bin_size, timelength, Data_dir, histogram_files,response_type)

    done = 0;
    Parent_dir = Data_dir;

        if response_type == 1
        save_filename_txt=sprintf('%s%s%s%d%s',Parent_dir,'\0_Light_Responses\6_New_Results\PSTH\','Averaged_Rolling_Histogram(',bin_size,'ms).txt');
    end
    if response_type == 2
        save_filename_txt=sprintf('%s%s%s%d%s',Parent_dir,'\3_Long_Responses\6_New_Results\PSTH\','Averaged_Rolling_Histogram(',bin_size,'ms).txt');
    end
    if ~exist(save_filename_txt)

    %% Histogram Height
    showheight_spikes=2;
    showheight_spikes_avg=4;

    %% Count the number of data files
    if ischar(histogram_files) % If a single file is selected as a template
        repeat_read=1;
    else % If multiple files are selected as templates
        repeat_read=size(histogram_files,2);
    end
    
    if response_type == 1
        if exist(fullfile(Parent_dir,'0_Light_Responses\6_New_Results\PSTH'),'dir')==0
            mkdir(fullfile(Parent_dir,'0_Light_Responses\6_New_Results\PSTH'));
        end
    end
    if response_type == 2
        if exist(fullfile(Parent_dir,'3_Long_Responses\6_New_Results\PSTH'),'dir')==0
            mkdir(fullfile(Parent_dir,'3_Long_Responses\6_New_Results\PSTH'));
        end
    end

    twindow = bin_size/1000; % Convert the bin size from msec to sec
    moving_step=twindow/5;

    showheight_spikes_avg=showheight_spikes_avg/twindow;

    num_bin = timelength/moving_step; % number of bins
    hist_spikes_avg = zeros(1,num_bin);

    %% Loop for analysis of data files
    for NN=[1:repeat_read]
        %% Display for remind 
        if ischar(histogram_files)
            filename=histogram_files;
        else
            filename=char(histogram_files(1,NN));
        end

        if response_type == 1
            filename_with_path=strcat(Data_dir,'\0_Light_Responses\5_Spike_And_Artifact_Onsets\',filename);
        end
        if response_type == 2
            filename_with_path=strcat(Data_dir,'\3_Long\5_Spike_And_Artifact_Onsets\',filename);
        end
        load(filename_with_path);

        sampling_rate=100000; % 100kHz sampling
        SomaSpkOnsetReal=SomaSpkOnset./sampling_rate;


           %% display the original data by 1 row
       if exist('hd21','var')==0
           hd21=figure('Position',[610 550 560 420]);
       end
        figure(hd21);
        
        for tt=1:length(SomaSpkOnsetReal)
            plot([SomaSpkOnsetReal(tt) SomaSpkOnsetReal(tt)],[0.2,0.8],'k','LineWidth',0.5);hold on;
        end
        
        
        plot([0 timelength],[0 0],'k');
        plot([0 0],[0 0.05],'k');
        for tlength=1:timelength
            plot([tlength tlength],[0 0.05],'k');
        end
        axis([-0.01 tlength 0 1]);
        set(gca,'YTickLabel',[]);
        set(gca,'XTickLabel',[]);
        axis off;
        clear tt;    
    
    
        clear v hist_spikes timebin;

        t = 0;
        for k=1:num_bin
%             clear v SomaSpkOnsetReal_in_bin;
            for i=1:length(SomaSpkOnsetReal)
                if (t-twindow) <= SomaSpkOnsetReal(i) % Revised on 08/22/2013 to fix the problem that shows histograms even before the stimulus onset
                    if SomaSpkOnsetReal(i) < t % Revised on 08/22/2013 to fix the problem that shows histograms even before the stimulus onset
                        hist_spikes_avg(1,k) = hist_spikes_avg(1,k) +1;
                    end
                end
            end
            t = t + moving_step;
        end

    end

    hist_spikes_avg=hist_spikes_avg./repeat_read;
    hist_spikes_avg=hist_spikes_avg./twindow; % In order to convert the unit into spikes/sec

    hd41=figure(41);
    set(hd41,'Position',[1210 550 560 420]);
    hold on;    

    timebin = [0 : moving_step : timelength - moving_step];
    bar(timebin,hist_spikes_avg(1,:), 'k');

%     tempname=regexprep(char(histogram_files(1,1)),'.mat','_');
    if response_type == 1
        save_filename_txt=sprintf('%s%s%s%d%s',Parent_dir,'\0_Light_Responses\6_New_Results\PSTH\','Averaged_Rolling_Histogram(',bin_size,'ms).txt');
    end
    if response_type == 2
        save_filename_txt=sprintf('%s%s%s%d%s',Parent_dir,'\3_Long_Responses\6_New_Results\PSTH\','Averaged_Rolling_Histogram(',bin_size,'ms).txt');
    end
    if ~exist(save_filename_txt)
        save(save_filename_txt,'hist_spikes_avg','-ascii');
    end

    close(hd41);
    close(hd21);

    end
