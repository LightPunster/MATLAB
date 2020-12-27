function k = gpopsLagrangeCurvature(s, y, NumPoints)

% gpopsLagrangeCurvature
% this function computes the curvature of the function y(s)
% by interpolating y using opLagrangeInterp on NumPoints on the interval s

% initial and final values, and step size
s0 = s(1);
sf = s(end);
step = (sf - s0)/(NumPoints);

% get interpolation grid
sinterp = (s0:step:sf)';

% find midpoints of interpolation grid
smid = (sinterp(1:end-1) + sinterp(2:end))./2;

% interpulate y to both sinterp and smid
yinterp = gpopsLagrangeInterp(s, y, sinterp);
ymid = gpopsLagrangeInterp(s, y, smid);

% first central difference derivative
dyds = (ymid(2:end) - ymid(1:end-1))./step;

% second central difference
ddyds2 = (yinterp(3:end) - 2*yinterp(2:end-1) + yinterp(1:end-2))./(step^2);

% compute curvature
k = abs(ddyds2)./((1+dyds.^2).^(3/2));
