%cd('/Users/xcitech/Documents/Runs/RUN1100');

%open all files for averaging 
LSXFiles = dir('*LSX.nc');

fields = cellstr(['PRECIP'; 'AVAP  '; 'LMASK '; 'TS2   '; 'TS    '; 'RUNOFF'; 'DRAIN ']);
field_val = zeros(180,90,12,length(fields));

for f = 1:length(fields)
    for i=1:length(LSXFiles)
        disp(strcat(fields(f),' ',num2str(i)));
        readval = ncread(LSXFiles(i).name,char(fields(f)));
        
        field_val(:,:,1,f) = mean(readval(:,:,1:31),3);
        field_val(:,:,2,f) = mean(readval(:,:,32:59),3);
        field_val(:,:,3,f) = mean(readval(:,:,60:90),3);
        field_val(:,:,4,f) = mean(readval(:,:,91:120),3);
        field_val(:,:,5,f) = mean(readval(:,:,121:151),3);
        field_val(:,:,6,f) = mean(readval(:,:,152:181),3);
        field_val(:,:,7,f) = mean(readval(:,:,182:212),3);
        field_val(:,:,8,f) = mean(readval(:,:,213:243),3);
        field_val(:,:,9,f) = mean(readval(:,:,244:273),3);
        field_val(:,:,10,f) = mean(readval(:,:,274:304),3);
        field_val(:,:,11,f) = mean(readval(:,:,305:334),3);
        field_val(:,:,12,f) = mean(readval(:,:,335:365),3);
    end
end


 
lat2x2 = linspace(-89,89,90);
lon2x2 = linspace(1,359,180);
output_file = LSXFiles(1).name;
output_file = output_file(1:end-9);
output_file = strcat(output_file,'_LSXAVG.nc');
%%%%%Create a new NETCDF file 

ncid = netcdf.create(output_file,'NC_WRITE');
% Create dimensions
dimid_lon = netcdf.defDim(ncid,'lon',180);
dimid_lat = netcdf.defDim(ncid,'lat',90); 
dimid_time = netcdf.defDim(ncid,'time',12); 

% 
varid_lon = netcdf.defVar(ncid,'lon','float',dimid_lon);
netcdf.putAtt(ncid,varid_lon,'long_name','longitude')
netcdf.putAtt(ncid,varid_lon,'units','degrees east')
netcdf.putAtt(ncid,varid_lon,'FORTRAN_format','f8.3')
% 
varid_lat = netcdf.defVar(ncid,'lat','float',dimid_lat);
netcdf.putAtt(ncid,varid_lat,'long_name','latitude')
netcdf.putAtt(ncid,varid_lat,'units','degrees north')
netcdf.putAtt(ncid,varid_lat,'FORTRAN_format','f8.3')
%
varid_time = netcdf.defVar(ncid,'time','float',dimid_time);
netcdf.putAtt(ncid,varid_time,'long_name','time')
netcdf.putAtt(ncid,varid_time,'units','days')
netcdf.putAtt(ncid,varid_time,'FORTRAN_format','f9.3')

%%Create the fields

varid_field = zeros(length(fields),1);

for f =1:length(fields)
    varid_field(f,1) = netcdf.defVar(ncid,char(fields(f)),'float',[dimid_lon,dimid_lat,dimid_time]);
    netcdf.putAtt(ncid,varid_field(f,1),'long_name',char(fields(f)))
    netcdf.putAtt(ncid,varid_field(f,1),'units','units')
    netcdf.putAtt(ncid,varid_field(f,1),'FORTRAN_format','e13.5')
end    
netcdf.endDef(ncid)

 
% write the fields
netcdf.putVar(ncid,varid_lon,lon2x2);
netcdf.putVar(ncid,varid_lat,lat2x2);
netcdf.putVar(ncid,varid_time,1:12);

for f=1:length(fields)
    netcdf.putVar(ncid,varid_field(f,1),field_val(:,:,:,f));
end

netcdf.close(ncid) 
%%%s