
function averageGCM()

%cd ('/Users/xcitech/Documents/Runs/MIS11/test');
%cd ('/Users/xcitech/Documents/Runs/wavelet/files');
Files = dir('*LSX.nc');

Temp= zeros(180,90,365);  %Store all the averaged TS2
Temp_summer = zeros(180,90,1); % Store the averaged summer temperature
Sum_TS= zeros(180,90,length(Files));  %Store the sum for calculating summer metrics

for i=1:length(Files)
    disp(i);
    ts2= ncread(Files(i).name,'TS2');

    for day=1:365
        for long=1:180
            for lat=1:90
                Temp(long,lat,day)= Temp(long,lat,day) + ts2(long,lat,day);

                ts_grid = ts2(long,lat,day) - 273.15;
                if ts_grid>0
                    Sum_TS(long,lat,i)= Sum_TS(long,lat,i)+ts_grid;
                end
            end   
        end
    end

    Temp_summer(:,46:90) = Temp_summer(:,46:90) + mean(ts2(:,46:90,151:240),3);
    Temp_summer(:,1:45) = Temp_summer(:,1:45) + mean(ts2(:,1:45,[1:60 336:365]),3);    
end    

Temp = Temp./length(Files);
Temp_summer = (Temp_summer./length(Files))-273.15;
S = sum(Sum_TS,3)./length(Files);
LMASK = ncread(Files(1).name,'LMASK');


%%%%%%%%%%%%%%
lat2x2 = linspace(-89,89,90);
lon2x2 = linspace(1,359,180);
[long, lat] = meshgrid(lon2x2-0.25,lat2x2+0.25);

%cd ('/Users/xcitech/Documents/Runs/wavelet/averages');
output_file = Files(1).name;
output_file = output_file(1:end-9);
output_file = strcat(output_file,'_SM.nc');

%%%%%Create a new NETCDF file

ncid = netcdf.create(output_file,'NC_WRITE');
% Create dimensions
dimid_lon = netcdf.defDim(ncid,'longitude',180);
dimid_lat = netcdf.defDim(ncid,'latitude',90); 
dimid_time = netcdf.defDim(ncid,'time',1); 
dimid_time2 = netcdf.defDim(ncid,'time2',365); 

% 
varid_lon = netcdf.defVar(ncid,'longitude','double',dimid_lon);
netcdf.putAtt(ncid,varid_lon,'long_name','Longitude')
netcdf.putAtt(ncid,varid_lon,'units','degrees_east')
% 
varid_lat = netcdf.defVar(ncid,'latitude','double',dimid_lat);
netcdf.putAtt(ncid,varid_lat,'long_name','Latitude')
netcdf.putAtt(ncid,varid_lat,'units','degrees_north')
%
varid_time = netcdf.defVar(ncid,'time','double',dimid_time);
netcdf.putAtt(ncid,varid_time,'long_name','Time')
netcdf.putAtt(ncid,varid_time,'units','')
% 
varid_prec2 = netcdf.defVar(ncid,'TS2','double',[dimid_lon,dimid_lat,dimid_time2]);
netcdf.putAtt(ncid,varid_prec2,'long_name','Temperature')
netcdf.putAtt(ncid,varid_prec2,'units','K')
netcdf.putAtt(ncid,varid_prec2,'missing_value',-9999)
% 
varid_LMASK = netcdf.defVar(ncid,'LMASK','float',[dimid_lon,dimid_lat,dimid_time2]);
netcdf.putAtt(ncid,varid_LMASK,'long_name','LMASK')
netcdf.putAtt(ncid,varid_LMASK,'units','  ')
netcdf.putAtt(ncid,varid_LMASK,'missing_value',-9999)
%
varid_prec = netcdf.defVar(ncid,'summer_metric','double',[dimid_lon,dimid_lat,dimid_time]);
netcdf.putAtt(ncid,varid_prec,'long_name','Summer Metric')
netcdf.putAtt(ncid,varid_prec,'units','mm')
netcdf.putAtt(ncid,varid_prec,'missing_value',-9999)
%
varid_prec3 = netcdf.defVar(ncid,'summer_temperature','double',[dimid_lon,dimid_lat,dimid_time]);
netcdf.putAtt(ncid,varid_prec3,'long_name','Summer Average Temperature')
netcdf.putAtt(ncid,varid_prec3,'Kelvin','K')
netcdf.putAtt(ncid,varid_prec3,'missing_value',-9999)
netcdf.endDef(ncid)

% write the summer meteric
netcdf.putVar(ncid,varid_lon,lon2x2);
netcdf.putVar(ncid,varid_lat,lat2x2);
netcdf.putVar(ncid,varid_time,1);
    
netcdf.putVar(ncid,varid_prec,S);
netcdf.putVar(ncid,varid_prec2,Temp);
netcdf.putVar(ncid,varid_prec3,Temp_summer);
netcdf.putVar(ncid,varid_LMASK,LMASK);
netcdf.close(ncid) 
%%%
%%%
%%%
%%%
%%%

%%%% Calculate J and insolation from T31 file
%cd ('/Users/xcitech/Documents/Runs/wavelet/files');
Files = dir('*T31.nc');

SOLIN_year= zeros(96,48,365);  %Store all the averaged SOLIN
SOLIN_summer = zeros(96,48,1); % Store the averaged summer SOLIN
sum_SOLIN= zeros(96,48,length(Files));  %Store the sum for calculating summer metrics

for i=1:length(Files)
    disp(i);
    solin = ncread(Files(i).name,'SOLIN');

    for day=1:365
        for long=1:96
            for lat=1:48
                SOLIN_year(long,lat,day)= SOLIN_year(long,lat,day) + solin(long,lat,day);

                solin_grid = solin(long,lat,day);
                if solin_grid>275
                    sum_SOLIN(long,lat,i)=sum_SOLIN(long,lat,i)+(solin_grid*86400);
                end
            end   
        end
    end

    SOLIN_summer(:,25:48) = SOLIN_summer(:,25:48) + mean(solin(:,25:48,151:240),3);
    SOLIN_summer(:,1:24) = SOLIN_summer(:,1:24) + mean(solin(:,1:24,[1:60 336:365]),3);    
end    

SOLIN_year = SOLIN_year./length(Files);
SOLIN_summer = (SOLIN_summer./length(Files));
J = sum(sum_SOLIN,3)./length(Files);

%%%%%%%%%%%%%%
lat2x2 = linspace(-87.159,87.159,48);
lon2x2 = linspace(1.875,358.125,96);
[long, lat] = meshgrid(lon2x2-0.25,lat2x2+0.25);

%%%%%%%%%%%%%%%
%cd ('/Users/xcitech/Documents/Runs/wavelet/averages');
output_file = Files(1).name;
output_file = output_file(1:end-9);
output_file = strcat(output_file,'_J.nc');

%%%%%Create a new NETCDF file with just my result(summer metric) which can
%%%%%be later plotted using Panoply

ncid = netcdf.create(output_file,'NC_WRITE');
% Create dimensions
dimid_lon = netcdf.defDim(ncid,'longitude',96);
dimid_lat = netcdf.defDim(ncid,'latitude',48); 
dimid_time = netcdf.defDim(ncid,'time',1);
dimid_time2 = netcdf.defDim(ncid,'time2',365);

% 
varid_lon = netcdf.defVar(ncid,'longitude','double',dimid_lon);
netcdf.putAtt(ncid,varid_lon,'long_name','Longitude')
netcdf.putAtt(ncid,varid_lon,'units','degrees_east')
% 
varid_lat = netcdf.defVar(ncid,'latitude','double',dimid_lat);
netcdf.putAtt(ncid,varid_lat,'long_name','Latitude')
netcdf.putAtt(ncid,varid_lat,'units','degrees_north')
%
varid_time = netcdf.defVar(ncid,'time','double',dimid_time);
netcdf.putAtt(ncid,varid_time,'long_name','Time')
netcdf.putAtt(ncid,varid_time,'units','')
% 
varid_prec = netcdf.defVar(ncid,'summer_energy','double',[dimid_lon,dimid_lat,dimid_time]);
netcdf.putAtt(ncid,varid_prec,'long_name','Summer Energy (J)')
netcdf.putAtt(ncid,varid_prec,'units','W/m2')
netcdf.putAtt(ncid,varid_prec,'missing_value',-9999)
% 
varid_prec2 = netcdf.defVar(ncid,'summer_insolation','double',[dimid_lon,dimid_lat,dimid_time]);
netcdf.putAtt(ncid,varid_prec,'long_name','Summer Insolation')
netcdf.putAtt(ncid,varid_prec,'units','W/m2')
netcdf.putAtt(ncid,varid_prec,'missing_value',-9999)
%
varid_prec3 = netcdf.defVar(ncid,'SOLIN','double',[dimid_lon,dimid_lat,dimid_time2]);
netcdf.putAtt(ncid,varid_prec,'long_name','SOLIN')
netcdf.putAtt(ncid,varid_prec,'units','W/m2')
netcdf.putAtt(ncid,varid_prec,'missing_value',-9999)
netcdf.endDef(ncid)

% write the summer meteric
netcdf.putVar(ncid,varid_lon,lon2x2);
netcdf.putVar(ncid,varid_lat,lat2x2);
netcdf.putVar(ncid,varid_time,1);
    
netcdf.putVar(ncid,varid_prec,J);
netcdf.putVar(ncid,varid_prec2,SOLIN_summer);
netcdf.putVar(ncid,varid_prec3,SOLIN_year);

netcdf.close(ncid) 

%%%

end