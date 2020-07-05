function vectorPlot(v,varargin)
%vectorPlot plots 2D or 3D vectors as lines starting from origin

%TODO: add ability to plot multiple vectors

switch nargin
    case 1
        origin = zeros(size(v));
    case 2
        origin = varargin{1};
    otherwise
        error('Expected 1 or 2 arguments; got %d.',nargin)
end

switch length(v)
    case 2
        plot([origin(1),v(1)],...
             [origin(2),v(2)])
    case 3
        plot3([origin(1),v(1)],...
              [origin(2),v(2)],...
              [origin(3),v(3)])
    otherwise
        error('v should be a vector or list of vectors of length 2 or 3')
end

end

