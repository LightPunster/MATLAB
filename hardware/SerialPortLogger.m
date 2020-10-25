function data = SerialPortLogger(port,varargin)
%SerialPortLogger.m Logs data from serial port
%   All data is stored in a text file with a time stamp. Data that can be
%   interpreted as comma-separated numbers is loaded into a float array
%   with time stamps in seconds in the first column and then saved into a
%   .mat file. Other scripts may not be run while this code is running. If 
%   no value for 'LOGTIME' is given, A popup with an 'OK' button is used
%   to stop this script.
%   
%   Parameters:
%       - 'TIMEOUT': time to wait for serial data (sec) (default: 0.5 sec)
%       - 'LOGTIME': time to log data (sec) (default: wait for stop button)
%       - 'BAUDRATE': baud rate of serial comm (default: 9600)
%       - 'PROMPT': command string to write to serial device to initialize
%                    logging (default: None)
%       - 'DATALABEL': datalabel for log files & directory (default: ask for
%                      user input)
%       - 'ECHO': set true to echo serial data to console, false to log it
%                 without echoing (default: true)

%#ok<*AGROW>     

    %% Parameters
    for n = 1:2:(nargin-1)
        switch(varargin{n})
            case 'TIMEOUT'
                timeout = varargin{n+1};
            case 'LOGTIME'
                logtime = varargin{n+1};
            case 'BAUDRATE'
                baudrate = varargin{n+1};
            case 'PROMPT'
                prompt = varargin{n+1};
            case 'DATALABEL'
                datalabel = varargin{n+1};
            case 'ECHO'
                echo = varargin{n+1};
            otherwise
                error('"%s" is not a valid input argument label. For valid\nlabels, type "help SerialPortLogger"',varargin{n});
        end
    end
    
    %Default values
    if ~exist('timeout','var')
        timeout = 0.5;
    end
    if ~exist('logtime','var')
        logtime = -1;
    end
    if ~exist('baudrate','var')
        baudrate = 9600;
    end
    if ~exist('datalabel','var')
        datalabel = input('Enter data datalabel (w/out file extension): ','s'); %Get data datalabel
    end
    if ~exist('echo','var')
        echo = true;
    end
 
    %% Setup files and open serial port
    
    %create folder for files
    if ~exist(datalabel, 'dir')
        mkdir(datalabel)
    end
    text_file = [datalabel '/' datalabel '.txt'];
    f = fopen(text_file,'w');
    fprintf(f,""); %Clear text file if it already exists
    fclose(f);
    data_file = [datalabel '/' datalabel '.mat'];
    data = []; %Data array
    save(data_file,'data')
    
    %If no logtime was passed, set up stop button
    if logtime < 0
        stop = stoploop('Press to stop logging data.');
    else
        %Even if timeout is long, should not record longer than logtime
        timeout = min([timeout logtime]);
    end
    
    %Open serial port
    s = serialport(port,baudrate,'TIMEOUT',timeout);
    pause(1) %Pause to wait for port to open
    fprintf('Opened serial port "%s":\n',port)
    
    %Write prompt
    if exist('prompt','var')
        write(s,prompt,'char');
        fprintf('Wrote prompt "%s":\n',prompt)
    end
    %% Log data
    warning ('off','serialport:serialport:ReadlineWarning'); %Disable timeout warning
    tic
    recording = true;
    while recording
        line = readline(s); %Readline from serial port
        t = toc; %time in seconds
        
        if ~isempty(line) %If something was read
            time_stamp = datetime(clock,'Format','HH:mm:ss.SSS'); %get time stamp
            if echo
                fprintf("%s >> %s",time_stamp,line) %Echo what was read to console
            end
            %Save text imediately
            f = fopen(text_file,'a');
            fprintf(f,"%s >> %s",time_stamp,line);
            fclose(f);

            fields = regexp(line, ',', 'split'); %Split line into comma-separated values
            datum = zeros(1,length(fields));

            %Convert to numeric
            numeric = true;
            for i=1:length(fields)
                datum(i) = str2double(fields(i));
                if isnan(datum(i))
                    numeric = false;
                end
            end
            if numeric %It it was successfully converted to numeric data
                data = [data; t datum]; %Add time stamp to data
                save(data_file,'data') %Save data to file immediately
            end
        end
        
        %Check recording condition
        if logtime < 0
            recording = ~stop.Stop();
        else
            recording = t < logtime;
        end
    end
    warning ('on','serialport:serialport:ReadlineWarning'); %Re-enable timeout warning

    %% Close port
    delete(s);
    fprintf('Closed serial port "%s".\n',port)
    fclose('all');

end

