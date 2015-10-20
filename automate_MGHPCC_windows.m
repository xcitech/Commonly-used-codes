tic

download_dir = ('F:\lion\highecc');


for i = 1146:1150
    cd(download_dir);
    mkdir (strcat('Run',num2str(i)));
    
    folder_path = strcat(download_dir,'\Run',num2str(i));
    cd(folder_path);
    
    %download 10LSX files
    for j = 42:51
        disp(strcat('file-',num2str(j)));
        command = strcat('pscp -pw 1985$toofan1302$1985 pd34a@ghpcc06.umassrc.org:/project/uma_michael_rawlins/pawlok/rajarshi/highecc/Run',num2str(i),'/',num2str(i),'0',num2str(j),'LSX.nc F:\lion\highecc\Run',num2str(i),'\',num2str(i),'0',num2str(j),'LSX.nc'); 
        system(command);
    end    
    %download T31 file
    command = strcat('pscp -pw 1985$toofan1302$1985 pd34a@ghpcc06.umassrc.org:/project/uma_michael_rawlins/pawlok/rajarshi/highecc/Run',num2str(i),'/',num2str(i),'051.nc F:\lion\highecc\Run',num2str(i),'\',num2str(i),'051T31.nc'); 
    [status,result] = system(command);
    
    average_daily2monthly();
    average_daily2monthlyT31();
    averageGCM();
    delete('*T31.nc');
    delete('*LSX.nc');
end
toc