function PlotPlanet(varargin)
%PlotEarth: plot a large ellipsoid body for orbit visualization plots
%
%   Optional Parameters:
%       projection = image projected onto ellipsoid surface (if image
%                    processing toolbox is available). Current options
%                    include Earth maps 'EarthMercator1.jpg' and
%                    'EarthMercator2.jpg'.
%       erad = equatorial radius (meters)
%       prad = polar radius (meters)
%       npanels = approximately, resolution of ellipsoid
%
%   Default values are erad = 6378135, prad = 6371009 (these correspond to
%   Earth), npanels = 20, and projection = none.

    switch nargin
        case 0
            projection = 'none';
            erad = 6378135;
            prad = 6371009;
            npanels = 20;
        case 1
            projection = varargin{1};
            erad = 6378135;
            prad = 6371009;
            npanels = 20;
        case 2
            projection = varargin{1};
            erad = varargin{2};
            prad = 6371009;
            npanels = 20;
        case 3
            projection = varargin{1};
            erad = varargin{2};
            prad = varargin{3};
            npanels = 20;
        case 4
            projection = varargin{1};
            erad = varargin{2};
            prad = varargin{3};
            npanels = varargin{4};
    end
    
    %Make sure that other plots are not overwritten
    precallState = ishold;
    if ~precallState
        hold on
    end
    
    axis vis3d;
    [ xx, yy, zz ] = ellipsoid(0, 0, 0, erad, erad, prad, npanels);
    surf(xx,yy,-zz, 'FaceColor', 'none', 'EdgeColor', 0.5*[1 1 1]);
    if ~strcmp(projection,'none')
        I = imread(projection);
        try
            warp(-xx,yy,-zz, I) %Plot map of Earth onto sphere
        catch
            fprintf('Image processing toolbox not available;\nno image projected onto ellipsoid body\n');
        end
    end
    
    %Turn hold back off if it was off before call
    if ~precallState
        hold off
    end
    
end

