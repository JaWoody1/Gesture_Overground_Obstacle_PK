%This Program identifies gestures based on the finger marker and calculates
%the amount of time (percentage) someone gestures during a walking trial 
clear;
close all;
clc;


%% **************Select Directory******************************************
% Import Data Set
% Set Directory and use prompt to choose exported files for analysis
[files,datapath] = uigetfile('*.csv','Select Exported Data','MultiSelect','on');
for j=1:length(files)
    Files{j} = [datapath, files{j}];  % (an error here means you need to select multiple files)
end

filenum=length(files);
for gg=1:2

    [pname, name, ext]=fileparts(cell2mat(Files(gg)));% break file name into path name(w/o extension) and the extension
    fname=strcat(name,ext);% File name w/ extension
    pathfilename=cell2mat(files(gg)); % String variable of file path and file name  
    cd(datapath);% Set the current directory

    % Pull the trial name from the selected trial and create a column vector
    trial_names(gg,1) = {name};

    % Read in the data from the selected trial
    [trial_num, trial_txt, trial_raw] = xlsread(pathfilename);

    [xtrial_num, ytrial_num] = size(trial_num);
    linecounter = 4; %this is the FIRST ROW the event data includes the time and descriptions in the text file
    eventcounter = 0;
    camrate = trial_num(1,1);


    % *************************************************************************
    % Trajectories Data
    for ii = linecounter:xtrial_num
        if strcmp(trial_raw(linecounter,1), 'Trajectories') == 1
            Trajstart = ii; % where do "Trajectories" start?
            break
        end
        linecounter = linecounter + 1;
    end

    crop = (xtrial_num) - (Trajstart+4); %how many frames are in the trajectories?

    % Separate Trajectory (Coordinate) data into a new matrix
    for ii = 1:crop %from where the "Trajectories" line +4 down (i.e., the actual start of the trajectories)
        coordata(ii,:) = trial_num(ii+Trajstart+4,:); % redefining the coordinate data for easy access and reference...according to how it is stored in the excel sheet
    end



   [coordatarows, coordatacols] = size(coordata);
    for ii = 1:coordatacols
        newtextb(1,ii) =(trial_txt(Trajstart+2,ii));
        if newtextb(1,ii) == ""  % if empty, move to the next column
            ii=ii+1;
        else
            newtextb2 = [newtextb{1,ii}];
            newtextb4 = split(newtextb2,':'); % Parse off subject name
            newtextb5(1,1) = newtextb4(2,1);
            trial_txt(Trajstart+2,ii) = newtextb5(1,1); % Replace names with generic version
            ii=ii+1; 
        end 
    end

end
    SubID = newtextb4(1,1);

    
    % *************************************************************************
    % Separate out the arrays of interest (Finger Marker)
    
    column_length = 1:coordatacols;

    LFINxcol = get_marker('LFIN', 'x',column_length,Trajstart,trial_txt);
    LFINzcol = get_marker('LFIN', 'z',column_length,Trajstart,trial_txt);
    
    
    % separate individual trajectory columns fo interest 
    RFINxcol = get_marker('RFIN', 'x',column_length,Trajstart,trial_txt);
    RFINycol = get_marker('RFIN', 'y',column_length,Trajstart,trial_txt);
    RFINzcol = get_marker('RFIN', 'z',column_length,Trajstart,trial_txt);
    
    %shoulder markers 

    RSHOxcol = get_marker('RSHO', 'x',column_length,Trajstart,trial_txt);
    RSHOycol = get_marker('RSHO', 'y',column_length,Trajstart,trial_txt);
    RSHOzcol = get_marker('RSHO', 'z',column_length,Trajstart,trial_txt);

    LSHOxcol = get_marker('LSHO', 'x',column_length,Trajstart,trial_txt);
    LSHOycol = get_marker('LSHO', 'y',column_length,Trajstart,trial_txt);
    LSHOzcol = get_marker('LSHO', 'z',column_length,Trajstart,trial_txt);
    
    
    %wrist markers

    LWRAxcol = get_marker('LWRA', 'x',column_length,Trajstart,trial_txt);
    LWRAycol = get_marker('LWRA', 'y',column_length,Trajstart,trial_txt);
    LWRAzcol = get_marker('LWRA', 'z',column_length,Trajstart,trial_txt);

    LWRBxcol = get_marker('LWRB', 'x',column_length,Trajstart,trial_txt);
    LWRBycol = get_marker('LWRB', 'y',column_length,Trajstart,trial_txt);
    LWRBzcol = get_marker('LWRB', 'z',column_length,Trajstart,trial_txt);
    
    RWRAxcol = get_marker('RWRA', 'x',column_length,Trajstart,trial_txt);
    RWRAycol = get_marker('RWRA', 'y',column_length,Trajstart,trial_txt);
    RWRAzcol = get_marker('RWRA', 'z',column_length,Trajstart,trial_txt);

    RWRBxcol = get_marker('RWRB', 'x',column_length,Trajstart,trial_txt);
    RWRBycol = get_marker('RWRB', 'y',column_length,Trajstart,trial_txt);
    RWRBzcol = get_marker('RWRB', 'z',column_length,Trajstart,trial_txt);
    
    
    %Create matrix for LWrist, LShoulder, RWrist, RShoulder
    
    LWrist = create_matrix(coordata, 3);
    RWrist = create_matrix(coordata, 3);
    LShoulder = create_matrix(coordata, 3);
    RShoulder = create_matrix(coordata, 3);
        
    
    %RWrist = zeros(length(coordata(:, 1)), 3);
    

    %get row data
    lfinx = get_data_from_rows(coordata,coordatarows,LFINxcol);
    lfinz = get_data_from_rows(coordata,coordatarows,LFINzcol);

    rfinx = get_data_from_rows(coordata,coordatarows,RFINxcol);
    rfinz = get_data_from_rows(coordata,coordatarows,RFINzcol);

    lshox = get_data_from_rows(coordata,coordatarows,LSHOxcol);
    lshoy = get_data_from_rows(coordata,coordatarows,LSHOycol);
    lshoz = get_data_from_rows(coordata,coordatarows,LSHOzcol);
    
    rshox = get_data_from_rows(coordata,coordatarows,RSHOxcol);
    rshoy = get_data_from_rows(coordata,coordatarows,RSHOycol);
    rshoz = get_data_from_rows(coordata,coordatarows,RSHOzcol);
    
    lwrax = get_data_from_rows(coordata,coordatarows,LWRAxcol);
    lwrbx = get_data_from_rows(coordata,coordatarows,LWRBxcol);
    LWristmidx = midpoint(lwrax,lwrbx);

    lwray = get_data_from_rows(coordata,coordatarows,LWRAycol);
    lwrby = get_data_from_rows(coordata,coordatarows,LWRBycol);
    LWristmidy = midpoint(lwray, lwrby);
    
    lwraz = get_data_from_rows(coordata,coordatarows,LWRAzcol);
    lwrbz = get_data_from_rows(coordata,coordatarows,LWRBzcol);
    LWristmidz = midpoint(lwraz, lwrbz);

    rwrax = get_data_from_rows(coordata,coordatarows,RWRAxcol);
    rwrbx = get_data_from_rows(coordata,coordatarows,RWRBxcol);
    RWristmidx = midpoint(rwrax, rwrbx);

    rwray = get_data_from_rows(coordata,coordatarows,RWRAycol);
    rwrby = get_data_from_rows(coordata,coordatarows,RWRBycol);
    RWristmidy = midpoint(rwray, rwrby);
    
    rwraz = get_data_from_rows(coordata,coordatarows,RWRAzcol);
    rwrbz = get_data_from_rows(coordata,coordatarows,RWRBzcol);
    RWristmidz = midpoint(rwraz, rwrbz);
     
        
        
    % make xyz from the wrist midpoint to the shoulder midpoint

    LWrist = xyz_position_array(LWristmidx,LWristmidy,LWristmidz);
    RWrist = xyz_position_array(RWristmidx,RWristmidy,RWristmidz);
    LShoulder = xyz_position_array(lshox,lshoy,lshoz);
    RShoulder = xyz_position_array(rshox,rshoy,rshoz);
    
    
    % calculate the distance between the shoulder and wrist markers 
    Ldist = vector(LShoulder(:,1), LWrist(:,1),LShoulder(:,2), LWrist(:,2),LShoulder(:,3), LWrist(:,3));
    Rdist = vector(RShoulder(:,1), RWrist(:,1),RShoulder(:,2), RWrist(:,2),RShoulder(:,3), RWrist(:,3));
     
%     %% 
% 
%     if ~strcmp(trial_names(gg, 1), "DT") == 0
%         
%         %calculate mean for each trajectory for RFIN and LFIN
%         meanlfinz = mean(coordata(LFINzcol));
%         meanrfinz = mean(coordata(RFINzcol));
%         meanlfinx = mean(coordata(LFINxcol));
%         meanrfinx = mean(coordata(RFINxcol));
%      
%         %calculate SD for each trajectory for RFIN and LFIN
%         sdlfinz(ii,1) = std(coordata(ii, LFINzcol));
%         sdrfinz(ii,1) = std(coordata(ii, RFINzcol));
%         sdlfinx(ii,1) = std(coordata(ii, LFINxcol));
%         sdrfinx(ii,1) = std(coordata(ii, RFINxcol));
%        
%         %calculate a cutoff points +-2SD from the mean 
%             %2SDlow and 2SDhigh
%         
%     elseif ~strcmp(trial_names(gg, 1), "DT") == 1
%         
%         %loop through all the frames of the trajectories 
%         %if the trajectory is greater than or less than 2SD of the mean
%         %trajectory store the frame numbers in a temporary matrix 
%         %calculate gesture time from the max - min frame number * sampling
%         %frequency
%         %calculate total trial time from frame 
%         %store gesture time in a matrix to export after all trials
%         
%     else
%             
%         
%     end 
%     
%     
%         
% 
%    
% 
% 
% 
% 
%     % *************************************************************************
%    
%     trial = cellstr(name);
% 
%     % Combine all data
% %     OBS_data(gg,:) = [trial Lead_foot approach_dist_trail landing_dist_lead...
% %         approach_dist_lead landing_dist_trail...
% %         Lead_toe_clearance Trail_toe_clearance...
% %         Lead_heel_clearance Trail_heel_clearance obs1z_pos];
% 
% 
%     % *************************************************************************
% 
%     clearvars -except SubID files filenum Files datapath fname pname name ...
%         trial_num trial_txt trial_raw camrate OBS_data trial_type1...
%         trial_type2 trial_type3 trial_type4 trial_type5 obstacle...
% %         obs1y_pos obs1z_pos  %Uncomment if dowel not in all trials for a subject
% 
% 
%     % *************************************************************************
% 
% 
% 
% %% Saving data 
% % SubID = trial_txt(4,1);
% Subject = char(SubID);
% 
% % ***************** Export data to an Excel sheet ***********************
% % % Name the excel sheet: (with file path)
% % fname2 = [pname,'/','OBS_Outputs','.xlsx'];
% % headers = {'Trial','Lead Foot','Obstacle_approach_dist_trail','Obstacle_landing_dist_lead',...
% %     'Obstacle_approach_dist_lead','Obstacle_landing_dist_trail',...
% %     'Lead_toe_clearance','Trail_toe_clearance','Lead_heel_clearance','Trail_heel_clearance',...
% %     'Obstacle Height'};
% % Sheeta = string(SubID);
% % % Sheet = strcat(Sheeta,trial_type1);
% % xlswrite(fname2,headers,Sheeta);
% % xlswrite(fname2,OBS_data,Sheeta,'A2');
% 
% % *************************************************************************
% 
% disp('Hooray. One down.')
