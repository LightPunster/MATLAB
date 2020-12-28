function [v1,v2] = GaussProblem(mu,r1,r2,t,varargin)
%GaussProblem: solves Gauss's Problem from orbital mechanics
%
%   Given two orbital radius vectors and the time between them,
%   determines the velocity vectors at both points.
%
%   Parameters:
%       mu = standard gravitational parameter of the body being orbited
%            (the value for Earth in SI units is 3.986e14)
%       r1 = radial vector at first point
%       r2 = radial vector at second point
%       t = time between the two points
%       w = opt. input defining short way or long way
%           -'S' --> short way
%           -'L' --> long way
%           -default --> short way
%
%   Outputs:
%       v1 = velocity vector at first point
%       v2 = velocity vector at second point

%Determine way
if nargin==5
    w = varargin{1};
    if w=='S'
        DM = 1;
    elseif w=='L'
        DM = -1;
    else
        error('Invalid input for "w"; must be "S" (short way) or "L" (long way).');
    end
else
    DM = 1;
end

df = acos(sum(r1.*r2)/(norm(r1)*norm(r2)));
A = DM*sqrt(norm(r1)*norm(r2))*sin(df)/sqrt(1-cos(df));

z_range = [-4*pi, 4*pi^2];
z = 0;
tn = t + 1;

while abs(t-tn)>1e-6
    C = C_funct(z);
    S = S_funct(z);
    
    %Calculate universal variable y
    y = norm(r1) + norm(r2) - A*(1-z*S)/sqrt(C);
    %Correct z until y and A are the same sign
    while (A>0)&&(y<0)
        z = z - y;
        y = norm(r1) + norm(r2) - A*(1-z*S)/sqrt(C);
    end
    
    %Calculate universal variable x and t estimate
    x = sqrt(y/C);
    tn = (S*x^3 + A*sqrt(y))/sqrt(mu);
    
    %Make adjustment to universal variabl z
    if tn<t
        z_range(1) = z;
    elseif tn>t
        z_range(2) = z;
    end
    z = mean(z_range);

end

%F & G functions
F = 1 - (x^2)*C/norm(r1);
G = t - (x^3)*S/sqrt(mu);
F_dot = sqrt(mu)*x*(z*S-1)/(norm(r1)*norm(r2));
G_dot = 1 - (x^2)*C/norm(r2);

%Def. of F & G: r2 = F*r1 + G*v1
v1 = (r2 - F*r1)/G;
%Def. of F & G: v2 = F_dot*r1 + G_dot*v1
v2 = F_dot*r1 + G_dot*v1;

end

function c = C_funct(z)
    if z>0.01 %Positive: Ellipse
        c = (1-cos(sqrt(z)))/z;
    elseif z<-0.01 %Negative: Hyperbola
        c = (cosh(sqrt(-z))-1)/(-z);
    else %Near Zero: Approaching hyperbola, use series expansion
        c = (1/factorial(2)) - (z/factorial(4)) + (z^2)/factorial(6) - (z^3)/factorial(8);
    end
end

function s = S_funct(z)
    if z>0.01 %Positive: Ellipse
        s = (sqrt(z)-sin(sqrt(z)))/sqrt(z^3);
    elseif z<-0.01 %Negative: Hyperbola
        s = (sinh(sqrt(-z))-sqrt(-z))/sqrt((-z)^3);
    else %Near Zero: Approaching hyperbola, use series expansion
        s = (1/factorial(3)) - (z/factorial(5)) + (z^2)/factorial(7) - (z^3)/factorial(9);
    end
end

