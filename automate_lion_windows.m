tic

download_dir = ('F:\MIS11');


for i = 482:487
    cd(download_dir);
    mkdir (strcat('Run',num2str(i)));
    
    folder_path = strcat(download_dir,'\Run',num2str(i));
    cd(folder_path);
    
    %download 10LSX files
    for j = 42:44
        disp(strcat('file-',num2str(j)));
        command = strcat('pscp -pw inspiron1 rfr5151@lionxg.rcc.psu.edu:/gpfs/scratch/rfr5151/MIS11/Run',num2str(i),'/',num2str(i),'0',num2str(j),'LSX.nc F:\MIS11\Run',num2str(i),'\',num2str(i),'0',num2str(j),'LSX.nc'); 
        system(command);
    end    
    %download T31 file
    command = strcat('pscp -pw inspiron1 rfr5151@lionxg.rcc.psu.edu:/gpfs/scratch/rfr5151/MIS11/Run',num2str(i),'/',num2str(i),'043.nc F:\MIS11\Run',num2str(i),'\',num2str(i),'051T31.nc'); 
    [status,result] = system(command);
    
    average_daily2monthly();
    average_daily2monthlyT31();
    averageGCM();
    delete('*T31.nc');
    delete('*LSX.nc');
end
toc