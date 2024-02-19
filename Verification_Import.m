clc
clear

%% Import Varification
% Automatic detection and trimming

% Data file names
DataFileNames = ["Data 2020.csv", "Data 2021.csv", "Data 2022.csv"]; 

% Trimming data
for(i = 1:length(DataFileNames))
    DataImport = readcell(DataFileNames(i)); % Import a single Data set
    if(length(DataImport) == 8763) %Normal year
        searchString1 = 'temperature_2m (°C)'; % String to detect
        searchString2 = 'direct_normal_irradiance (W/m²)'; %String to detect
        TempIndices(:,i) = find(strcmp(DataImport(3,:), searchString1));% Detect temperature data
        RadIndices(:,i) = find(strcmp(DataImport(3,:), searchString2)); % Detect irradiance data
        
        DataRad(:,i) = DataImport(4:8763,RadIndices(i)); % Store
        DataTemp(:,i) = DataImport(4:8763,TempIndices(i)); % Store
    end
    if(length(DataImport) == 8787) %Leap year
        for(n = 1:width(DataImport))
            searchString1 = 'temperature_2m (°C)'; % String to detect
            searchString2 = 'direct_normal_irradiance (W/m²)';% String to detect
            TempIndices(:,i) = find(strcmp(DataImport(3,:), searchString1)); % Detect temperature data
            RadIndices(:,i) = find(strcmp(DataImport(3,:), searchString2));% Detect irradiance data
            
            DataRadLeap(:,i) = DataImport(4:8787,RadIndices(i)); % Store
            DataTempLeap(:,i) = DataImport(4:8787,TempIndices(i)); % Store
            DataTempLeapR = DataTempLeap;
            DataTempLeapR(1420:1443) = []; % Trim Leap year data
            DataRadLeapR = DataRadLeap;
            DataRadLeapR(1420:1443) = []; % Trim Leap year data
            
            DataRad(:,i) = DataRadLeapR; % Store
            DataTemp(:,i) = DataTempLeapR; % Store
        end
    end
      if(length(DataImport) ~= 8763)
        if(length(DataImport) ~= 8787)
            fprintf("Data set %s not compatable", DataFileNames(i));
        end
    end
end

% Verify process
DataImport2020 = readmatrix("Data 2020.csv"); % Import data
DataImport2021 = readmatrix("Data 2021.csv"); % Import data
DataImport2022 = readmatrix("Data 2022.csv"); % Import data

% Manually trim
% 2020 October 1 hour
DataTemp2022 = DataImport2022(3:8762,2); 
DataRad2022 = DataImport2022(3:8762,3);

% 2021 October 1 hour
DataTemp2021 = DataImport2021(3:8762,2); 
DataRad2021 = DataImport2021(3:8762,3);

% 2022 October 1 hour
DataTemp2020 = DataImport2020(3:8786,2); 
DataRad2020 = DataImport2020(3:8786,3);
DataTemp2020(1417:1440) = [];
DataRad2020(1417:1440) = [];

DataRad = cell2mat(DataRad);

for(k = 1:length(DataRad2020))
    diff(k,1) = DataRad2020(k)-DataRad(k,1); % Check for any errors
    diff(k,2) = DataRad2021(k)-DataRad(k,2); % Check for any errors
    diff(k,3) = DataRad2022(k)-DataRad(k,3); % Check for any errors
end

sum(diff)

