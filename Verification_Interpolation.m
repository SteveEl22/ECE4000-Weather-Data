clear 
clc

%Import October 2023 hourly and 15 minute data sets
DataImportOct15 = readmatrix("Data 2023 Oct.csv");
DataImportOctH = readmatrix("Data 2023 Oct Hour.csv");

% 2023 October 15 min
DataTempOct15 = DataImportOct15(3:2978,2)'; 
DataRadOct15 = DataImportOct15(3:2978,3)';

% 2023 October 15 min
DataTempOctH = DataImportOctH(3:746,2)'; 
DataRadOctH = DataImportOctH(3:746,3)';

% Range
range = [1:0.25:length(DataRadOctH)+0.75];
DataTime = [1:744];

% Interpolate Data
for (r = 1:length(range));

DataRad(r) = spline(DataTime,DataRadOctH,range(r));
DataTemp(r) = spline(DataTime,DataTempOctH,range(r));

    if (DataRad(r) <= 0)
    DataRad(r) = [0];
    end

    if (DataTemp(r) <= 0)
    DataTemp(r) = [0];
    end

end


loop = 0;
    for(days = 1:31)
        for(hour = 1:24*4)
            if(loop == 0)
            DataHoursRad(days,hour) = DataRad(hour);    
            DataHoursTemp(days,hour) = DataTemp(hour); 
            DataMinRad(days,hour) = DataRadOct15(hour);    
            DataMinTemp(days,hour) = DataTempOct15(hour);
            end

            if(loop > 0)
            DataHoursRad(days,hour) = DataRad(hour+(loop*96));    
            DataHoursTemp(days,hour) = DataTemp(hour+(loop*96));   
            DataMinRad(days,hour) = DataRadOct15(hour+(loop*96));    
            DataMinTemp(days,hour) = DataTempOct15(hour+(loop*96));
            end
        end
        loop = loop + 1;
    end

for(m = 1:96)
    sumHoursRad(m) = sum(DataHoursRad(:,m))/31;
    sumHoursTemp(m) = sum(DataHoursTemp(:,m))/31;
    sumMinRad(m) = sum(DataMinRad(:,m))/31;
    sumMinTemp(m) = sum(DataMinTemp(:,m))/31;
end

avgErrRad = 0;
for(n = 1:96)
    errRad(n) = ((sumHoursRad(n)-sumMinRad(n))/sumMinRad(n))*100;
    errTemp(n) = ((sumHoursTemp(n)-sumMinTemp(n))/sumMinTemp(n))*100;
end

errRad(isnan(errRad)) = 0;
errRad(isinf(errRad)) = 0;


max(errRad)
max(errTemp)

figure(1)
plot(1:96,errRad)
figure(2)
plot(1:96,errTemp)