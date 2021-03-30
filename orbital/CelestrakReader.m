function [inc,O,e,w,M,n] = CelestrakReader(dataFileName)
%CelestrakReader: Extracts orbital elements from Celestrak data file
%   Detailed explanation goes here

    data = fileread(dataFileName);
    num = ceil(length(data)/168);
    inc = zeros(1,num);
    O = zeros(1,num);
    e = zeros(1,num);
    w = zeros(1,num);
    M = zeros(1,num);
    n = zeros(1,num);
    for i=1:num
    %     %Name
    %     name{i} = data((168*(i-1)+1):(168*(i-1)+24));
    %     %Line 1
    %     l = 26; x = 168*(i-1)+l;
    %     number{i} = data(x+3:x+8);
    %     designator{i} = data(x+10:x+17);
    %     year(i) = 2000 + str2double(data(x+19:x+20));
    %     day(i) = str2double(data(x+21:x+32));
    %     dndt(i) = str2double(data(x+34:x+43));
    %     ddndtdt(i) = str2double(data(x+45:x+52));
    %     BSTARdrag{i} = data(x+54:x+61);
    %     ephemeris(i) = str2double(data(x+63));
    %     element(i) = str2double(data(x+65:x+68));
    %     checksum1(i) = str2double(data(x+69));
        %Line 2
        l = 97; x = 168*(i-1)+l;
        inc(i) = str2double(data(x+9:x+16))*pi/180;
        O(i) = str2double(data(x+18:x+25))*pi/180;
        e(i) = str2double(['0.' data(x+27:x+33)]);
        w(i) = str2double(data(x+35:x+42))*pi/180;
        M(i) = str2double(data(x+44:x+51))*pi/180;
        n(i) = str2double(data(x+53:x+63))/(24*3600);
    %     revolution(i) = str2double(data(x+64:x+68));
    %     checksum2(i) = str2double(data(x+69));
    end

end

