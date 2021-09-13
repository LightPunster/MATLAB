function [] = LowPassFilter(wp, ws, rp, rs, type)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
maxLog = ceil(log10(ws)) + 1;
w = logspace(0,maxLog,1000);

switch(type) 
    case 'b'
        [n,wc] = buttord(wp,ws,rp,rs,'s');
        [b,a] = butter(n,wc,'s');
        filterType = 'Butterworth';
    case 'c1'
        [n,wc] = cheb1ord(wp,ws,rp,rs,'s');
        [b,a] = cheby1(n,rp,wc,'s');
        filterType = 'Type I Chebyshev';
    case 'c2'
        [n,wc] = cheb2ord(wp,ws,rp,rs,'s');
        [b,a] = cheby2(n,rs,wc,'s');
        filterType = 'Type II Chebyshev';
    case 'e'
        [n,wc] = ellipord(wp,ws,rp,rs,'s');
        [b,a] = ellip(n,rp,rs,wc,'s');
        filterType = 'Elliptic';
    otherwise
        error('Invalid filter type.');
end
        
switch(n)
    case 1
        orderSuffix = 'st';
    case 2
        orderSuffix = 'nd';
    case 3
        orderSuffix = 'rd';
    otherwise
        orderSuffix = 'th';
end
        
H = 20*log10(abs(freqs(b,a,w)));
semilogx(w,H);
Title = [num2str(n), orderSuffix, ' Order ', filterType, ' Filter with w_c = ', num2str(wc) ' rad/s'];
title(Title);
xlabel('omega (rad/s)');
ylabel('|H(f)| (dB)');

opamps = floor(n/2);

if (mod(n,2) == 0) 
    fprintf('Opamps to construct filter:\n  %.f x 2nd Order\n',opamps);
else
    fprintf('Opamps to construct filter:\n  1 x 1st Order\n  %.f x 2nd Order\n',opamps);
end
end

