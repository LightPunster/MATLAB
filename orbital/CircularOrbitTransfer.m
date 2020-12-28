function CircularOrbitTransfer(mu,r1,r2,varargin)
%CircularOrbitTransfer: plots transfer orbit between two circular orbits
%
%   Parameters:
%       mu = standard gravitational parameter of the body being orbited
%            (the value for Earth in SI units is 3.986e14)
%       r1 = radius of initial orbit
%       r2 = radius of final orbit
%
%   Optional Parameters:
%       a_t, e_t = semimajor axis and eccentricity of transfer orbit
%       type = used to specify specific types of orbit transfers. The
%              options currently available are 'Hohmann' (Hohmann Transfer)
%
%   Use EITHER both a_t & e_t OR specify the type of transfer. If no
%   transfer parameters are provided, a Hohmann Transfer is used.
%   
%   Examples:
%       CircularOrbitTransfer(3.986e14,1,4);
%       CircularOrbitTransfer(3.986e14,1,4,'Hohmann');
%       CircularOrbitTransfer(3.986e14,2,5,4.9953,0.76);

    if nargin==4
        type = varargin{1};
        switch type
            case 'Hohmann'
                a_t = (r1+r2)/2;
                e_t = 1 - min([r1 r2])/a_t;
            otherwise
                error('No valid transfer type provided.')
        end
    elseif nargin==5
        a_t = varargin{1};
        e_t = varargin{2};
    else
        %If unspecified, use Hohmann transfer
        a_t = (r1+r2)/2;
        e_t = 1 - min([r1 r2])/a_t;
    end
    
    a = [r1, a_t, r2]*(6378135+6371009)/2;
    e = [0, e_t, 0];
    
    %Propogate orbits and plot
    figure
    PlotPlanet('EarthMercator1.jpg')
    for i=1:length(a)
        r0 = [a(i)*(1-e(i)),0,0];
        v0 = [0 ,sqrt(mu*((2/norm(r0))-(1/a(i)))), 0];
        tf = 2*pi*sqrt((a(i)^3)/mu);
        OrbitPropogate(mu,r0,v0,tf);
    end
end
