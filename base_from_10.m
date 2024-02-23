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
for gg=1:filenum

    [pname, name, ext]=fileparts(cell2mat(Files(gg)));% break file name into path name(w/o extension) and the extension
    fname(gg,1)=strcat(name,ext);% File name w/ extension
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