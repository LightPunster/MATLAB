function L = SpectralRadiance(T,lambda)
%UNTITLED Spectral Radiance by Maxwell's calculations using quantum
%mechanics
h = 6.62607004e-34;
c = 299792458;
k = 1.38064852e-23;

L = (2*h*c^2)./(lambda.^5*(exp(h*c./(k*lambda.*T)) - 1));

end

