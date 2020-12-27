function circle(x,y,r,varargin)
    if nargin==3
        inc = pi/50;
    else
        inc = varargin{1};
    end

    hold on
    th = 0:inc:2*pi;
    xunit = r * cos(th) + x;
    yunit = r * sin(th) + y;
    h = plot(xunit, yunit);
    hold off
end