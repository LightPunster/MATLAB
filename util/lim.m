function x = lim(x,range,varargin)
%lim Limits input to a specified range
%   usage: x = lim(x,[x_lo,x_hi],...);
%       x = input
%       range = limits for x in format [lower limit, upper limit]
%
%   Accepts inf/-inf as inputs signifying that x may be unbounded from
%   above or below. Accepts array and matrix values for x.
%
%   Optional arguments:
%       handler = specifies how to handle elements outside of range:
%                 'lim' = set to value at limit (default)
%                 'nan' = set to NaN
%                 'zero' = set to zero

    switch nargin
        case 2 %Use default
            x(x<range(1)) = range(1);
            x(x>range(2)) = range(2);
        case 3 %Apply specified handler
            switch varargin{1}
                case 'lim'
                    x(x<range(1)) = range(1);
                    x(x>range(2)) = range(2);
                case 'nan'
                    x(x<range(1)) = NaN;
                    x(x>range(2)) = NaN;
                case 'zero'
                    x(x<range(1)) = 0;
                    x(x>range(2)) = 0;
                otherwise
                    error("Invalid limiting method specified. Must be 'lim', 'nan', or 'zero'.")
            end
        otherwise
            error("Invalid number of arguments given. Expected 2 or 3, got %d.",nargin)
    end
end

