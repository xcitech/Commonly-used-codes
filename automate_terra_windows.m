tic

download_dir = ('F:\MIS11_continuous');


for i = 310:2:314
    cd(download_dir);
    mkdir (strcat('Run',num2str(i)));
    
    folder_path = strcat(download_dir,'\Run',num2str(i));
    cd(folder_path);
    
    %download 10LSX files
    for j = 11:20
        disp(strcat('file-',num2str(j)));
        command = strcat('pscp -pw inspiron raj@terra.geo.umass.edu:/usr/data/raj/MIS/MIS11/Run',num2str(i),'/',num2str(i),'0',num2str(j),'LSX.nc F:\MIS11_continuous\Run',num2str(i),'\',num2str(i),'0',num2str(j),'LSX.nc'); 
        system(command);
    end    
    %download T31 file
    command = strcat('pscp -pw inspiron raj@terra.geo.umass.edu:/usr/data/raj/MIS/MIS11/Run',num2str(i),'/',num2str(i),'020.nc F:\MIS11_continuous\Run',num2str(i),'\',num2str(i),'051T31.nc'); 
    [status,result] = system(command);
    
    average_daily2monthly();
    average_daily2monthlyT31();
    averageGCM();
    delete('*T31.nc');
    delete('*LSX.nc');
end
toc