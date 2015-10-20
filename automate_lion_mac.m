tic

download_dir = ('/Volumes/GDRIVE/lion/highecc');


for i = 1000:1050
    cd(download_dir);
    mkdir (strcat('Run',num2str(i)));
    
    folder_path = strcat(download_dir,'/Run',num2str(i));
    cd(folder_path);
    
    %download 10 LSX files
    for j = 42:51
        disp(strcat('file-',num2str(j)));
        command = strcat('/usr/local/bin/sshpass -p inspiron1 scp rfr5151@lionxg.rcc.psu.edu:/gpfs/scratch/rfr5151/highecc/Run',num2str(i),'/',num2str(i),'0',num2str(j),'LSX.nc /Volumes/GDRIVE/lion/highecc/Run',num2str(i),'/',num2str(i),'0',num2str(j),'LSX.nc'); 
        system(command);
    end    
    %download T31 file
    command = strcat('/usr/local/bin/sshpass -p inspiron1 scp rfr5151@lionxg.rcc.psu.edu:/gpfs/scratch/rfr5151/highecc/Run',num2str(i),'/',num2str(i),'051.nc /Volumes/GDRIVE/lion/highecc/Run',num2str(i),'/',num2str(i),'051T31.nc'); 
    system(command);
    
    average_daily2monthly();
    average_daily2monthlyT31();
    averageGCM();
    delete('*T31.nc');
    delete('*LSX.nc');
end
toc