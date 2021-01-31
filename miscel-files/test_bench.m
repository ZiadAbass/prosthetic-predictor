

% publish('main.m','format','pdf','evalCode',false,'outputDir',"./pdfs/main3.pdf",'figureSnapMethod','print')


% Get a list of all .dat files in the folder
filePattern = fullfile("", '*.m');
theFiles = dir(filePattern);
% We now want to loop through all the files in the current folder of
% interest
for kk = 1 : length(theFiles)
  baseFileName = theFiles(kk).name;
  fullFileName = fullfile("", baseFileName);
  fprintf(1, 'Now reading %s\n', fullFileName);
  publish(fullFileName,'format','pdf','evalCode',false,'outputDir',"./pdfs/",'figureSnapMethod','print')
end
