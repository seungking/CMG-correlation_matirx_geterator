function k_w_correlation(varargin)
%% Get variables inputted by user
[cax,args,nargs] = axescheck(varargin{:});

cax = newplot(cax);
nextPlot = cax.NextPlot;

[dir_name,method,dt,response_type,on_bt,on_bs,off_bt,off_bs,p1,p2,p3,create_image] = deal(args{1:12});
% dir_name : directory selected by user
% method : (1) sttc_correlation / (2) k_w_correlation
% response_type : (1) Light / (2) Electric
% on_bt, on_bs, off_bt, off_bs : cell-type selected by user
% p1, p2, p3 : conditions of the cell
% create_image : (1) create / (2) not create

%% Set conditions
working_dir = pwd;
data_dir_path = dir_name;
cell_list_path = 'Journal of Physiology 2015 paper summary of cells.xlsx';

[~,~,a_cell_path] = xlsread(fullfile(data_dir_path,cell_list_path),1,'D999:D999');
[~,~,b_cell_path] = xlsread(fullfile(data_dir_path,cell_list_path),1,'D999:D999');
[~,~,c_cell_path] = xlsread(fullfile(data_dir_path,cell_list_path),1,'D999:D999');
[~,~,d_cell_path] = xlsread(fullfile(data_dir_path,cell_list_path),1,'D999:D999');

size_cell = [];
oncell_count = 0;
if on_bt == 1 % ON_BT
    [~,~,a_cell_path] = xlsread(fullfile(data_dir_path,cell_list_path),1,'D2:D20');
    oncell_count = oncell_count + 19;
    size_cell = [size_cell,19];
end
if on_bs == 1 % ON_BS
    [~,~,b_cell_path] = xlsread(fullfile(data_dir_path,cell_list_path),1,'D23:D45');
    oncell_count = oncell_count + 23;
    size_cell = [size_cell,23];
end
if off_bt == 1 % OFF_BT
    [~,~,c_cell_path] = xlsread(fullfile(data_dir_path,cell_list_path),1,'D51:D75');
    size_cell = [size_cell,25];
end
if off_bs == 1 % OFF_BS
    [~,~,d_cell_path] = xlsread(fullfile(data_dir_path,cell_list_path),1,'D84:D100');
    size_cell = [size_cell,17];
end
cell_path = vertcat(a_cell_path, b_cell_path, c_cell_path, d_cell_path);
cell_path(any(cellfun(@(x) any(isnan(x)),cell_path),2),:) = [];; % delete NaN

if response_type == 1 % Light response
    psth_path = '0_Light_Responses\6_New_Results\PSTH';
    spike_path = '0_Light_Responses\5_Spike_And_Artifact_Onsets';
    conditions = sprintf('%s%s%s%s%s%s',p1{1},'um',p2{1},'sec',p3{1},'percent');
    Time = [0, 3];
else if response_type == 2% Electric response
    spike_path = '3_Long\5_Spike_And_Artifact_Onsets';
    psth_path = '3_Long\6_New_Results\PSTH';
    conditions = sprintf('%s%s%s%s%s%s',p1{1},'Hz-',p2{1},'sec-',p3{1},'uA');
    Time = [0, 2];
    end
end

correlation_r = [length(cell_path),length(cell_path)];
dtdt = dt/10^3;

psth_txt = sprintf('%s%d%s','Averaged_Rolling_Histogram(',dt,'ms).txt');
X = (0:length(cell_path));
Y = (0:length(cell_path));

ch_first=1;

%% Calculate the correlation_r
%% First cell comparison
for ch_first = 1 : length(cell_path)

    f = waitbar(ch_first/length(cell_path),'Please wait...');

    Files_first = struct2cell(dir(fullfile(data_dir_path,cell_path{ch_first}(22:length(cell_path{ch_first})),spike_path)))';
    Files_first = Files_first(:,1);

    save_match_first = [];

    for i=1 : length(Files_first)
            check_match = strfind(Files_first(i),conditions);
        
        if check_match{1} > 0
           save_match_first = [save_match_first,Files_first(i)];
        end
        
    end

%% Second cell comparison
   for ch_second = ch_first : length(cell_path)
       
        sum_correlation_coeffcient=[];
       
        Files_second = struct2cell(dir(fullfile(data_dir_path,cell_path{ch_second}(22:length(cell_path{ch_second})),spike_path)))';
        Files_second = Files_second(:,1);

         save_match_second = [];
         
        for k=1 : length(Files_second)
            check_match = strfind(Files_second(k),conditions);

            if check_match{1} > 0
               save_match_second = [save_match_second,Files_second(k)];
            end
            
        end

        T=Time(2)-Time(1);
        
        %% Make a histogram
        if ~exist(fullfile(data_dir_path,cell_path{ch_first}(22:length(cell_path{ch_first})),psth_path,psth_txt))
            my_make_Histogram(dt, T, fullfile(data_dir_path,cell_path{ch_first}(22:length(cell_path{ch_first}))), save_match_first,response_type);
        end
        
        if ~exist(fullfile(data_dir_path,cell_path{ch_second}(22:length(cell_path{ch_second})),psth_path,psth_txt))
             my_make_Histogram(dt, T, fullfile(data_dir_path,cell_path{ch_second}(22:length(cell_path{ch_second}))), save_match_second,response_type);
        end
        
        % first histogram comparison
        filename_to_load=fullfile(data_dir_path,cell_path{ch_first}(22:length(cell_path{ch_first})),psth_path,psth_txt);
        if exist(filename_to_load,'file');
            y1 = dlmread( filename_to_load);
            disp(['Read ' filename_to_load]);
        else
            disp('No file!');
            continue;
        end

        %second histogram comparison
        filename_to_load=fullfile(data_dir_path,cell_path{ch_second}(22:length(cell_path{ch_second})),psth_path,psth_txt);
        if exist(filename_to_load,'file');
            y2 = dlmread( filename_to_load);
            disp(['Read ' filename_to_load]);
        else
            disp('No file!');
            continue;
        end
        
        %% calculate correlation index 
        n = 55;
        window = dtdt;
        local_window = (2*n+1)*window;
        N = length(y1);
        up=0;
        adown=0;
        bdown=0;

        for count = 1 : N
            current = 1 - window - (count-1)*window;
            train1 = y1;
            train2 = y2;
            mean_train1 = [];
            mean_train2 = [];

            if count<=n
                for aa = 1:count+n
                    mean_train1 = [mean_train1,train1(aa)/(n+1)];
                    mean_train2 = [mean_train2,train2(aa)/(n+1)];
                end
            end 

            if (n<count&&count<=N-n)
                for aaa = count-n:count+n
                    mean_train1 = [mean_train1,train1(aa)/(2*n+1)];
                    mean_train2 = [mean_train2,train2(aa)/(2*n+1)];
                end                            
            end

            if count>N-n       
                for aaaa = count-n:N
                    mean_train1 = [mean_train1,train1(aaaa)/(n+N+count)];
                    mean_train2 = [mean_train2,train2(aaaa)/(n+N+count)];
                end                          
            end

            avg1 = sum(mean_train1)/length(mean_train1);
            avg2 = sum(mean_train2)/length(mean_train2);
            up = up + (y1(count)-avg1)*(train2(count)-avg2);
            adown = adown + (train1(count)-avg1)^2;
            bdown = bdown + (train2(count)-avg2)^2;
        end

        index = up/(adown^(1/2)*bdown^(1/2));

        correlation_r(ch_first,ch_second) = index;
        correlation_r(ch_second,ch_first) = index;
        
       %=================================================================================================     
        
   end
   close(f);
end

%% Set name of directroy and files
cells_name = '';
cells_order = cell(length(cell_path));
cells_order_count=1;

if response_type == 1% Light response
    cells_name = sprintf('%s%s', cells_name, 'Light');
end
if response_type == 2% Electric response
    cells_name = sprintf('%s%s', cells_name, 'Electric');
end

if on_bt == 1% ON-BT
    cells_name = sprintf('%s%s', cells_name,'(ON-BT)');
    for i1 = 1 : 19
        temp_name = sprintf('%s%d', 'ON-BT', i1);
        cells_order(cells_order_count) = cellstr(temp_name);
        cells_order_count = cells_order_count + 1;
    end
end
if on_bs == 1% ON-BS
    cells_name = sprintf('%s%s', cells_name,'(ON-BS)');
    for i2 = 1 : 23
        temp_name = sprintf('%s%d', 'ON-BS', i2);
        cells_order(cells_order_count) = cellstr(temp_name);
        cells_order_count = cells_order_count + 1;
    end
end
if off_bt == 1% OFF-BT
    cells_name = sprintf('%s%s', cells_name,'(OFF-BT)');
    for i3 = 1 : 25
        temp_name = sprintf('%s%d', 'OFF-BT', i3);
        cells_order(cells_order_count) = cellstr(temp_name);
        cells_order_count = cells_order_count + 1;
    end
end
if off_bs == 1% OFF-BS
    cells_name = sprintf('%s%s', cells_name,'(OFF-BS)');
    for i4 = 1 : 17
        temp_name = sprintf('%s%d', 'OFF-BS', i4);
        cells_order(cells_order_count) = cellstr(temp_name);
        cells_order_count = cells_order_count + 1;
    end;
end

if method == 1% STTC
   psth_dirname = sprintf('%s%s%s%d%s', '(STTC)', cells_name, 'PSTH', dt,'ms');
end
if method == 2% K_W
   psth_dirname = sprintf('%s%s%s%d%s', '(K_W)', cells_name, 'PSTH', dt,'ms');
end
psth_store = cell(length(cell_path),length(cell_path));

% make directory
if ~exist(fullfile(data_dir_path, psth_dirname))
    mkdir(fullfile(data_dir_path, psth_dirname)); 
end

correlation_r_copy = [length(cell_path),length(cell_path)];
correlation_r_copy = correlation_r;
for n = 1 : length(cell_path)+1
    correlation_r_copy(n,length(cell_path)+1) = 0;
    correlation_r_copy(length(cell_path)+1,n) = 0;
end

%% Create image file
%% Frist PSTH comparison
for ch_first = 1 : length(cell_path)

        filename_to_load=fullfile(data_dir_path,cell_path{ch_first}(22:length(cell_path{ch_first})),psth_path,psth_txt);
        % read histogram text file
        if exist(filename_to_load,'file');
            y1 = dlmread( filename_to_load);
            disp(['Read ' filename_to_load]);
        else
            disp('No file!');
            continue;
        end

%% Second PSTH comparison
   for ch_second = ch_first : length(cell_path)

        filename_to_load=fullfile(data_dir_path,cell_path{ch_second}(22:length(cell_path{ch_second})),psth_path,psth_txt);
        % read histogram text file
        if exist(filename_to_load,'file');
            y2 = dlmread( filename_to_load);
            disp(['Read ' filename_to_load]);
        else
            disp('No file!');
            continue;
        end

        x = linspace(Time(1),Time(2),length(y2));

        titlename = '';
        if response_type == 1
            titlename = sprintf('%s', '[Light]');
        else if response_type == 2
                titlename = sprintf('%s', '[Electric]');
            end
        end

        titlename = sprintf('%s %s %s %s %s %s%d%s',titlename, 'Comparison', cells_order{ch_first,1}, 'and', cells_order{ch_second,1} , '(', dt, 'ms)');
        temp = sprintf('%s%s',fullfile(data_dir_path, psth_dirname,titlename),'.jpg');
        psth_store(ch_first,ch_second) = cellstr(temp);
        psth_store(ch_second,ch_first) = cellstr(temp);

         if exist(temp)
            continue;
         end
         if create_image == 0 
             continue;
         end

        figure(1);
        hold on
        bar(x,y1,'FaceColor','m','FaceAlpha', 0.5,'EdgeAlpha', 0, 'barwidth', 1);
        bar(x,y2,'FaceColor','r','FaceAlpha', 0.5,'EdgeAlpha', 0, 'barwidth', 1);

        title(titlename);

        off_check1 = strfind(cells_order{ch_first,1},'OFF');
        off_check2 = strfind(cells_order{ch_second,1},'OFF');
        if (response_type == 1 && (length(off_check1) > 0 || length(off_check2) > 0))
            legend('first cell','second cell','Location','northwest');
            axes('Position',[0.13 0.40 .35 .35]);
        else
            legend('first cell','second cell');
            axes('Position',[0.55 0.40 .35 .35]);
        end

        box on
        cd(working_dir);
        my_pcolor(X,Y,correlation_r_copy,psth_store,0);
        title(['Correlation value(r) : ',num2str(correlation_r_copy(ch_first,ch_second))]);
        set(gca,'XTickLabel',[],'YTickLabel',[]);
        set(gca,'YDir','rev');
        colormap jet;

        caxis([-0.5 1]);
        saveas(gcf, fullfile(data_dir_path, psth_dirname,titlename),'jpeg');
        close(1);
        hold off

   end
end

%% Save result in Excel file
cd(fullfile(data_dir_path, psth_dirname))

filename = 'correlation_values(matrix).xlsx';
xlswrite(filename,correlation_r)

filename = 'correlation_values.xlsx';
xlswrite(filename,reshape(correlation_r,1,length(cell_path)^2)')

if length(size_cell) == 2
    copyarr = [];
    for qq = 1:size_cell(1)
        for ww = 1:size_cell(2)
            copyarr = [copyarr,correlation_r(qq,size_cell(1)+ww)];
        end
    end
    filename = 'correlation_values_two.xlsx';
    xlswrite(filename,copyarr');
end

%% Save matrix as a image file
for n = 1 : length(cell_path)+1
     correlation_r(n,length(cell_path)+1) = 0;
     correlation_r(length(cell_path)+1,n) = 0;
end


cd(working_dir)
figure(3)
my_pcolor(X,Y,correlation_r,psth_store,1);
title(cells_name);
colorbar;

caxis([-0.5 1]);
xlabel('UNIT#');
ylabel('UNIT#');
axis([0 length(cell_path) 0 length(cell_path)]);
colormap jet;

legend('off');
if length(cell_path) > 4
    set(gca,'Xtick',[0, round(length(cell_path)*(1/4)) , round(length(cell_path)*(2/4)), round(length(cell_path)*(3/4)), length(cell_path)])
    set(gca,'Ytick',[0, round(length(cell_path)*(1/4)) , round(length(cell_path)*(2/4)), round(length(cell_path)*(3/4)), length(cell_path)])
else
    set(gca,'Xtick',[0, round(length(cell_path)*(2/4)), length(cell_path)])
    set(gca,'Ytick',[0, round(length(cell_path)*(2/4)), length(cell_path)])    
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
axis([0 length(cell_path) 0 length(cell_path)]);
colormap jet;

legend('off');
if length(cell_path) > 4
    set(gca,'Xtick',[0, round(length(cell_path)*(1/4)) , round(length(cell_path)*(2/4)), round(length(cell_path)*(3/4)), length(cell_path)])
    set(gca,'Ytick',[0, round(length(cell_path)*(1/4)) , round(length(cell_path)*(2/4)), round(length(cell_path)*(3/4)), length(cell_path)])
else
    set(gca,'Xtick',[0, round(length(cell_path)*(2/4)), length(cell_path)])
    set(gca,'Ytick',[0, round(length(cell_path)*(2/4)), length(cell_path)])    
end
set(gca,'YDir','rev');