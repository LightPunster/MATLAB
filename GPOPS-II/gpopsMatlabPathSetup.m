% gpops2PathSetup
% this script adds the appropriate paths for use of gpops2 to the
% MATLAB path directory

% get current directory
currdir = pwd;

startupFileID = fopen('startupFileGPOPSII.m','w');
% add RPMintegration/opRPMIsnopt/
pathAdded = strcat([currdir,'/lib/gpopsRPMIntegration/gpopsSnoptRPMI/']);
writeToStartup = strcat('addpath(','''',pathAdded,'''',');','\n');
addpath(pathAdded,'-begin');
fprintf(startupFileID,writeToStartup);
% addpath([currdir,'/lib/gpopsRPMIntegration/gpopsSnoptRPMI/'],'-begin');
disp(['Adding Directory ',pathAdded,' to Path']);
disp(['Adding Directory ',currdir,'/lib/gpopsRPMIntegration/gpopsSnoptRPMI/ to Path']);

% add RPMintegration/opRPMIipopt/
pathAdded = strcat([currdir,'/lib/gpopsRPMIntegration/gpopsIpoptRPMI/']);
writeToStartup = strcat('addpath(','''',pathAdded,'''',');','\n');
addpath(pathAdded,'-begin');
fprintf(startupFileID,writeToStartup,'\n');
% addpath([currdir,'/lib/gpopsRPMIntegration/gpopsIpoptRPMI/'],'-begin');
disp(['Adding Directory ',pathAdded,' to Path']);

% add RPMintegration/
pathAdded = strcat([currdir,'/lib/gpopsRPMIntegration/']);
writeToStartup = strcat('addpath(','''',pathAdded,'''',');','\n');
addpath(pathAdded,'-begin');
fprintf(startupFileID,writeToStartup);
% addpath([currdir,'/lib/gpopsRPMIntegration/'],'-begin');
disp(['Adding Directory ',pathAdded,' to Path']);

% add RPMdifferentiation/opRPMDsnopt/
pathAdded = strcat([currdir,'/lib/gpopsRPMDifferentiation/gpopsSnoptRPMD/']);
writeToStartup = strcat('addpath(','''',pathAdded,'''',');','\n');
addpath(pathAdded,'-begin');
fprintf(startupFileID,writeToStartup);
% addpath([currdir,'/lib/gpopsRPMDifferentiation/gpopsSnoptRPMD/'],'-begin');
disp(['Adding Directory ',pathAdded,' to Path']);

% add RPMdifferentiation/opRPMDipopt/
pathAdded = strcat([currdir,'/lib/gpopsRPMDifferentiation/gpopsIpoptRPMD/']);
writeToStartup = strcat('addpath(','''',pathAdded,'''',');','\n');
addpath(pathAdded,'-begin');
fprintf(startupFileID,writeToStartup);
% addpath([currdir,'/lib/gpopsRPMDifferentiation/gpopsIpoptRPMD/'],'-begin');
disp(['Adding Directory ',pathAdded,' to Path']);

% add RPMdifferentiation/
pathAdded = strcat([currdir,'/lib/gpopsRPMDifferentiation/']);
writeToStartup = strcat('addpath(','''',pathAdded,'''',');','\n');
addpath(pathAdded,'-begin');
fprintf(startupFileID,writeToStartup);
% addpath([currdir,'/lib/gpopsRPMDifferentiation/'],'-begin');
disp(['Adding Directory ',pathAdded,' to Path']);

% add OCPfinitediff/
pathAdded = strcat([currdir,'/lib/gpopsFiniteDifference/']);
writeToStartup = strcat('addpath(','''',pathAdded,'''',');','\n');
addpath(pathAdded,'-begin');
fprintf(startupFileID,writeToStartup);
% addpath([currdir,'/lib/gpopsFiniteDifference/'],'-begin');
disp(['Adding Directory ',pathAdded,' to Path']);

% add AdiGator/
pathAdded = strcat([currdir,'/lib/gpopsADiGator/']);
writeToStartup = strcat('addpath(','''',pathAdded,'''',');','\n');
addpath(pathAdded,'-begin');
% addpath([currdir,'/lib/gpopsADiGator/'],'-begin');
disp(['Adding Directory ',pathAdded,' to Path']);

% add gpopsAutomaticScaling/
pathAdded = strcat([currdir,'/lib/gpopsAutomaticScaling/']);
writeToStartup = strcat('addpath(','''',pathAdded,'''',');','\n');
addpath(pathAdded,'-begin');
fprintf(startupFileID,writeToStartup);
% addpath([currdir,'/lib/gpopsAutomaticScaling/'],'-begin');
disp(['Adding Directory ',pathAdded,' to Path']);

% add gpopsMeshRefinement/
pathAdded = strcat([currdir,'/lib/gpopsMeshRefinement/']);
writeToStartup = strcat('addpath(','''',pathAdded,'''',');','\n');
addpath(pathAdded,'-begin');
fprintf(startupFileID,writeToStartup);
% addpath([currdir,'/lib/gpopsMeshRefinement/'],'-begin');
disp(['Adding Directory ',pathAdded,' to Path']);

% add Common/
pathAdded = strcat([currdir,'/lib/gpopsCommon/']);
writeToStartup = strcat('addpath(','''',pathAdded,'''',');','\n');
addpath(pathAdded,'-begin');
fprintf(startupFileID,writeToStartup);
% addpath([currdir,'/lib/gpopsCommon/'],'-begin');
disp(['Adding Directory ',pathAdded,' to Path']);

% add gpopsUtilities/
pathAdded = strcat([currdir,'/gpopsUtilities/']);
writeToStartup = strcat('addpath(','''',pathAdded,'''',');','\n');
addpath(pathAdded,'-begin');
fprintf(startupFileID,writeToStartup);
% addpath([currdir,'/gpopsUtilities/'],'-begin');
disp(['Adding Directory ',pathAdded,' to Path']);

% add license/
pathAdded = strcat([currdir,'/license/']);
writeToStartup = strcat('addpath(','''',pathAdded,'''',');','\n');
addpath(pathAdded,'-begin');
fprintf(startupFileID,writeToStartup);
% addpath([currdir,'/license/'],'-begin');
disp(['Adding Directory ',pathAdded,' to Path']);

% add NLP solver directory
if isdir('nlp/snopt/'),
  writeToStartup = strcat('addpath(','''',pathAdded,'''',');','\n');
  pathAdded = strcat([currdir,'/nlp/snopt/snopt2017']);
  addpath(pathAdded,'-begin');
  fprintf(startupFileID,writeToStartup);
  % addpath([currdir,'/nlp/snopt/snopt2017'],'-begin');
  disp(['Adding Directory ',pathAdded,' to Path']);
end
if isdir('nlp/ipopt'),
  pathAdded = strcat([currdir,'/nlp/ipopt/']);
  writeToStartup = strcat('addpath(','''',pathAdded,'''',');','\n');
  addpath(pathAdded,'-begin');
  fprintf(startupFileID,writeToStartup);
  % addpath([currdir,'/nlp/ipopt/'],'-begin');
  disp(['Adding Directory ',pathAdded,' to Path']);
end

disp('-------------------------------------------------------------------------');
disp('The GPOPS-II directories have been successfully added to the MATLAB path.');
disp('and have been written to a file named "startupFileGPOPSII.m".');
disp('-------------------------------------------------------------------------');
disp('');
pathNotSaved = savepath;
if pathNotSaved;
  warning('% The MATLAB path could not be saved to the master path definition file PATHDEF.M.    %');
  warning('% In order to include the GPOPS-II directories automatically each time MATLAB starts, %');
  warning('% please see the instructions in the GPOPS-II user guide.                             %');
end;

disp('');

if exist('adigator.m','file') < 2;
  disp('%--------------------------------------------------------------------------%');
  disp('% In order to install ADiGator, please visit the AdiGator project website: %')
  disp('% <a href="http://sourceforge.net/projects/adigator/">http://sourceforge.net/projects/adigator/</a>.                               %')
  disp('%--------------------------------------------------------------------------%');
end

fclose(startupFileID);
