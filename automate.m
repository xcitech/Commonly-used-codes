tic

download_dir = ('F:\lion\highecc\');

for i = 1183:1183
    disp(num2str(i));
    
    folder_path = strcat(download_dir,'Run',num2str(i));
    cd(folder_path);
    
%    average_daily2monthly();
    average_daily2monthlyT31();
    averageGCM();
    delete('*T31.nc');
    delete('*LSX.nc')
end
toc