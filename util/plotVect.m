function plotVect(v,varargin)
%plotVect plots 2D or 3D vectors as lines starting from origin.
%Substitutes for 'plotv' from deep learning toolbox, but with additional
%capability to plot from arbitrary specified point.

%TODO: add ability to plot multiple vectors

switch nargin
    case 1
        origin = zeros(size(v));
        color = '';
    case 2
        origin = varargin{1};
        color = '';
    case 3
        origin = varargin{1};
        color = varargin{2};
    otherwise
        error('Expected 1, 2, or 3 arguments; got %d.',nargin)
end

%Make sure that other plots are not overwritten
precallState = ishold;
if ~precallState
    hold on
end

%Plot vector
switch length(v)
    case 2
        plot([origin(1),origin(1)+v(1)],...
             [origin(2),origin(2)+v(2)],...
              color)
    case 3
        plot3([origin(1),origin(1)+v(1)],...
              [origin(2),origin(2)+v(2)],...
              [origin(3),origin(3)+v(3)],...
               color)
    otherwise
        error('v should be a vector or list of vectors of length 2 or 3')
end

%Turn hold back off if it was off before call
if ~precallState
    hold off
end

end

