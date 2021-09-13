% Creates a pole plot of a Butterworth Filter of specified order and corner
% frequency. Precision and scale of plot may be changed by altering the
% variables 'points' and 'ratio'.

order = input('Enter Butterworth Filter Order: ');          %Inputs
frequency = input('Enter Butterworth Filter Corner Frequency: ');

points = 1000;                                              %Plot settings
ratio = 2;

[A,B] = butter(order,frequency,'s');       % Initialize butterworth filter
P = roots(B);
minRealPole = min(real(P));
maxImagPole = max(imag(P));
minImagPole = min(imag(P));

o = linspace(ratio*minRealPole,0,points);               % Creation of axes
w = linspace(ratio*minImagPole,ratio*maxImagPole,points);
[O,W] = meshgrid(o,w);

prodDenom = ones(points,points); % Calculates the denomenator at each point
for i=1:order
    prodDenom = prodDenom.*(O + j*W - P(i));
end

sumNume = zeros(points,points);    % Calculates the numerator at each point
for i=1:length(A)
    sumNume = sumNume + (A(i)*((O + j*W).^(length(A)-i)));
end

H_s = abs(sumNume./prodDenom); % Calculates the frequency response magnitude
H_s_dB = 20*log10(H_s);

mesh(O,W,H_s_dB)
Title = ['Order ',num2str(order), ' Butterworth Lowpass Filter (corner frequency = ', num2str(frequency), ')'];
title(Title)
xlabel('sigma')
ylabel('j*omega')
zlabel('|H_s| (dB)')

