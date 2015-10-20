
%open all files for averaging 
T31Files = dir('*T31.nc')

fields = cellstr(['TOPOG  '; 'TOPOGUN'; 'SOLIN  '; 'PRECL  '; 'PRECC  '; 'QFLR   ']);
field_val = zeros(96,48,12,length(fields));
T_val = zeros(96,48,18,12);

for f = 1:length(fields)
    for i=1:length(T31Files)
        disp(strcat(fields(f),' ',num2str(i)));
        readval = ncread(T31Files(i).name,char(fields(f)));
        
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

for i =1:length(T31Files)
    disp(strcat('T',num2str(i)));
    readval = ncread(T31Files(i).name,'T');
    T_val(:,:,:,1) = mean(readval(:,:,:,1:31),4);
    T_val(:,:,:,2) = mean(readval(:,:,:,32:59),4);
    T_val(:,:,:,3) = mean(readval(:,:,:,60:90),4);
    T_val(:,:,:,4) = mean(readval(:,:,:,91:120),4);
    T_val(:,:,:,5) = mean(readval(:,:,:,121:151),4);
    T_val(:,:,:,6) = mean(readval(:,:,:,152:181),4);
    T_val(:,:,:,7) = mean(readval(:,:,:,182:212),4);
    T_val(:,:,:,8) = mean(readval(:,:,:,213:243),4);
    T_val(:,:,:,9) = mean(readval(:,:,:,244:273),4);
    T_val(:,:,:,10) = mean(readval(:,:,:,274:304),4);
    T_val(:,:,:,11) = mean(readval(:,:,:,305:334),4);
    T_val(:,:,:,12) = mean(readval(:,:,:,335:365),4);
end
    

lat2x2 = linspace(-87.159,87.159,48);
lon2x2 = linspace(1.875,358.125,96);
lev2x2 = [0.005 0.013 0.033 0.064 0.099 0.0139 0.189 0.251 0.325 0.409 0.501 0.598 0.695 0.787 0.866 0.929 0.970 0.993];
output_file = T31Files(1).name;
output_file = output_file(1:end-9);
output_file = strcat(output_file,'_T31AVG.nc');
%%%%%Create a new NETCDF file with just my result(summer metric) which can
%%%%%be later plotted using Panoply

ncid = netcdf.create(output_file,'NC_WRITE');
% Create dimensions
dimid_lon = netcdf.defDim(ncid,'lon',96);
dimid_lat = netcdf.defDim(ncid,'lat',48); 
dimid_time = netcdf.defDim(ncid,'time',12);
dimid_lev = netcdf.defDim(ncid,'lev',18);

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
%
varid_lev = netcdf.defVar(ncid,'lev','float',dimid_lev);
netcdf.putAtt(ncid,varid_lev,'long_name','height')
netcdf.putAtt(ncid,varid_lev,'units','sigma')
netcdf.putAtt(ncid,varid_lev,'FORTRAN_format','f6.3')
%%Create the fields

varid_field = zeros(length(fields),1);

for f =1:length(fields)
    varid_field(f,1) = netcdf.defVar(ncid,char(fields(f)),'float',[dimid_lon,dimid_lat,dimid_time]);
    netcdf.putAtt(ncid,varid_field(f,1),'long_name',char(fields(f)))
    netcdf.putAtt(ncid,varid_field(f,1),'units','units')
    netcdf.putAtt(ncid,varid_field(f,1),'FORTRAN_format','e13.5')
end

varid_T = netcdf.defVar(ncid,'T','float',[dimid_lon,dimid_lat,dimid_lev,dimid_time]);
netcdf.putAtt(ncid,varid_T,'long_name','T')
netcdf.putAtt(ncid,varid_T,'units','deg K')
netcdf.putAtt(ncid,varid_T,'FORTRAN_format','e13.5')
netcdf.endDef(ncid)

% write the fields
netcdf.putVar(ncid,varid_lon,lon2x2);
netcdf.putVar(ncid,varid_lat,lat2x2);
netcdf.putVar(ncid,varid_time,1:12);
netcdf.putVar(ncid,varid_lev,lev2x2);

for f=1:length(fields)
    netcdf.putVar(ncid,varid_field(f,1),field_val(:,:,:,f));
end
netcdf.putVar(ncid,varid_T,T_val);
netcdf.close(ncid) 
%%%
