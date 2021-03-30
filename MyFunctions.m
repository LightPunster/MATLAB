function MyFunctions()
%MyFunctions.m lists all of the functions defined in this directory and
%subdirectories.
%   
    clc
    
    %Folders to exclude
    ExcludeList = {'GPOPS-II'};
    
    %Get function directory
    fileName = mfilename();
    filePath = mfilename('fullpath');
    functionFolder = filePath(1:end-length(fileName));
    D = dir(functionFolder);
    
    %Loop through items in directory
    for i=1:length(D)
        
        %Determine if item is a function subfolder
        excluded = false;
        for j=1:length(ExcludeList)
            if strcmp(ExcludeList{j},D(i).name)
                excluded = true;
            end
        end
        if (D(i).isdir) && (D(i).name(1)~='.') && (~excluded)
            
            %Print subfolder name
            subFolder = D(i).name;
            for j=1:length(subFolder)+2
                fprintf('-')
            end
            fprintf('\n')
            fprintf('<strong>%s</strong>:\n',subFolder)
            
            %Get subfolder items
            d = dir([functionFolder '/' subFolder]);
            
            %Loop through items in subfolder
            for k=1:length(d)
                
                %Determine if item is a function
                if isfunction(d(k).name)
                    
                    %Print function name
                    funct = d(k).name;
%                     fprintf('\t<a href="%s%s\\%s">%s%s\\%s</a>:',...
%                         functionFolder,subFolder,funct,...
%                         functionFolder,subFolder,funct(1:end-2))
                    fprintf('\t<a href="%s%s\\%s">%s</a>:',...
                        functionFolder,subFolder,funct,funct(1:end-2))
                    
                    %Print first line of function help
                    H = help(funct);
                    l = 1;
                    while H(l)~=newline
                        fprintf(H(l))
                        l=l+1;
                    end
                    fprintf('...\n')
                end
            end
        end
    end
        
    
end

