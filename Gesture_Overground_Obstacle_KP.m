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

%     %Create matrix of all single task data 
%     STWalk = zeros(length(coordata(:, 1)), 5);
%     % First Column = frame numbers
%     STWalk(:, 1) = coordata(:,1);
%     STWalk(:, 
    
   
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
    for ii = 1:coordatacols
        lfin = strmatch('LFIN',trial_txt(Trajstart+2,ii));  
        if lfin == 1
            LFINzcol = ii+2;
            LFINxcol = ii;
            break
        end
    end
    
    
    % separate individual trajectory columns fo interest 
    for ii = 1:coordatacols
        rfin = strmatch('RFIN',trial_txt(Trajstart+2,ii));
        if rfin == 1
            RFINzcol = ii+2;
            RFINxcol = ii;
            break
        end
    end
    
    %shoulder markers 
    for ii = 1:coordatacols
        rfin = strmatch('RSHO',trial_txt(Trajstart+2,ii));
        if rfin == 1
            RSHOzcol = ii+2;
            RSHOycol = ii+1;
            RSHOxcol = ii;
            break
        end
    end
    
    for ii = 1:coordatacols
        rfin = strmatch('LSHO',trial_txt(Trajstart+2,ii));
        if rfin == 1
            LSHOzcol = ii+2;
            LSHOycol = ii+1;
            LSHOxcol = ii;
            break
        end
    end
    
    %wrist markers
    for ii = 1:coordatacols
        rfin = strmatch('LWRA',trial_txt(Trajstart+2,ii));
        if rfin == 1
            LWRAzcol = ii+2;
            LWRAycol = ii+1;
            LWRAxcol = ii;
            break
        end
    end
    
    for ii = 1:coordatacols
        rfin = strmatch('LWRB',trial_txt(Trajstart+2,ii));
        if rfin == 1
            LWRBzcol = ii+2;
            LWRBycol = ii+1;
            LWRBxcol = ii;
            break
        end
    end
    
    
    for ii = 1:coordatacols
        rfin = strmatch('RWRA',trial_txt(Trajstart+2,ii));
        if rfin == 1
            RWRAzcol = ii+2;
            RWRAycol = ii+1;
            RWRAxcol = ii;
            break
        end
    end
    
    for ii = 1:coordatacols
        rfin = strmatch('RWRB',trial_txt(Trajstart+2,ii));
        if rfin == 1
            RWRBzcol = ii+2;
            RWRBycol = ii+1;
            RWRBxcol = ii;
            break
        end
    end
  
%     %Create matrix for LWrist, LShoulder, RWrist, RShoulder
        LWrist = zeros(length(coordata(:, 1)), 3);
        RWrist = zeros(length(coordata(:, 1)), 3);
        LShoulder = zeros(length(coordata(:, 1)), 3);
        RShoulder = zeros(length(coordata(:, 1)), 3);
        
    
    
    
    
% do something else     
     for ii = 1:coordatarows % separate individual trajectory columns of interest
        lfinz(ii,1) = coordata(ii, LFINzcol);
        rfinz(ii,1) = coordata(ii, RFINzcol);
        lfinx(ii,1) = coordata(ii, LFINxcol);
        rfinx(ii,1) = coordata(ii, RFINxcol);
        lshoz(ii,1) = coordata(ii, LSHOzcol);
        rshoz(ii,1) = coordata(ii, RSHOzcol);
        lshox(ii,1) = coordata(ii, LSHOxcol);
        rshox(ii,1) = coordata(ii, RSHOxcol);
        lshoy(ii,1) = coordata(ii, LSHOycol);
        rshoy(ii,1) = coordata(ii, RSHOycol);
        lwraz(ii,1) = coordata(ii, LWRAzcol);
        lwrbz(ii,1) = coordata(ii, LWRBzcol);
        LWristmidz(ii, 1) = ((lwraz(ii,1) + lwrbz(ii,1))/2);
        lwrax(ii,1) = coordata(ii, LWRAxcol);
        lwrbx(ii,1) = coordata(ii, LWRBxcol);
        LWristmidx(ii, 1) = ((lwrax(ii,1) + lwrbx(ii,1))/2);
        lwray(ii,1) = coordata(ii, LWRAycol);
        lwrby(ii,1) = coordata(ii, LWRBycol);
        LWristmidy(ii, 1) = ((lwray(ii,1) + lwrby(ii,1))/2);
        rwraz(ii,1) = coordata(ii, RWRAzcol);
        rwrbz(ii,1) = coordata(ii, RWRBzcol);
        RWristmidz(ii, 1) = ((rwraz(ii,1) + rwrbz(ii,1))/2);
        rwrax(ii,1) = coordata(ii, RWRAxcol);
        rwrbx(ii,1) = coordata(ii, RWRBxcol);
        RWristmidx(ii, 1) = ((rwrax(ii,1) + rwrbx(ii,1))/2);
        rwray(ii,1) = coordata(ii, RWRAycol);
        rwrby(ii,1) = coordata(ii, RWRBycol);
        RWristmidy(ii, 1) = ((rwray(ii,1) + rwrby(ii,1))/2);
     
        
        
        % make xyz from the wrist midpoint to the shoulder midpoint 
        LWrist(ii,1) = LWristmidx(ii,1); 
        LWrist(ii,2) = LWristmidy(ii,1); 
        LWrist(ii,3) = LWristmidz(ii,1);
        RWrist(ii,1) = RWristmidx(ii,1); 
        RWrist(ii,2) = RWristmidy(ii,1); 
        RWrist(ii,3) = RWristmidz(ii,1);
        LShoulder(ii,1) = lshox(ii,1);
        LShoulder(ii,2) = lshoy(ii,1);
        LShoulder(ii,3) = lshoz(ii,1);
        RShoulder(ii,1) = rshox(ii,1);
        RShoulder(ii,2) = rshoy(ii,1);
        RShoulder(ii,3) = rshoz(ii,1);

%         LSWvector = Lshoudler - LWrist;
%         RSWvector = RShoulder - RWrist; 
        % calculate the distance between the shoulder and wrist markers 
        Ldist(ii,1) = [sqrt(((LShoulder(ii,1)-LWrist(ii,1))^2) + ((LShoulder(ii,2)-LWrist(ii,2))^2) + ((LShoulder(ii,3)-LWrist(ii,3))^2))];
        Rdist(ii,1) = [sqrt(((RShoulder(ii,1)-RWrist(ii,1))^2) + ((RShoulder(ii,2)-RWrist(ii,2))^2) + ((RShoulder(ii,3)-RWrist(ii,3))^2))];
%         
        
     end

     
     
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
