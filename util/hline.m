function hline(y,varargin)
%vline plots a horizontal line at the specified y coordinate
%   The line will span the current plot's x-limits. An optional formatting
%   argument may be provided in the same form as for the 'plot' command.

x_limits = xlim;
switch nargin
    case 1
        plot([x_limits(1),x_limits(2)],[y,y])
    case 2
        plot([x_limits(1),x_limits(2)],[y,y],varargin{1})
    otherwise
        error('Expected 1 or 2 inputs, got %d.',nargin);
end

end

