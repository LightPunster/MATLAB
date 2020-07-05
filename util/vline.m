function vline(x,varargin)
%vline plots a vertical line at the specified x coordinate
%   The line will span the current plot's y-limits. An optional formatting
%   argument may be provided in the same form as for the 'plot' command.

y_limits = ylim;
switch nargin
    case 1
        plot([x,x],[y_limits(1),y_limits(2)])
    case 2
        plot([x,x],[y_limits(1),y_limits(2)],varargin{1})
    otherwise
        error('Expected 1 or 2 inputs, got %d.',nargin);
end

end

