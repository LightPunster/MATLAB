function [outputArg1,outputArg2] = expandPlotLimits(xLimNew,yLimNew,varargin)
%expandPlotLimits: expands limits of 2D or 3D plot
%   Parameters:
%       xLimNew = 1x2 vector of new minimal x-limits
%       yLimNew = 1x2 vector of new minimal y-limits
%   Optional Parameters:
%       Z = 1x2 vector of new minimal z-limits
%   The new plot limits will contain the specified values of X, Y, and Z in
%   addition to the parts of the plot current shown.
%   Example: Current limits are [-1,1],[-2,2]. expandPlotLimits is called
%   with xLimNew = [0,2], yLimNew = [-3,-1]. The new plot limits will be
%   [-1,2], [-3,2].

    if nargin==2
        xLimOld = xlim;
        yLimOld = ylim;
        axis([min([xLimOld xLimNew]), max([xLimOld xLimNew]),...
              min([yLimOld yLimNew]), max([yLimOld yLimNew])])
    elseif nargin==3
        zLimNew = varargin{1};
        xLimOld = xlim;
        yLimOld = ylim;
        zLimOld = zlim;
        axis([min([xLimOld xLimNew]), max([xLimOld xLimNew]),...
              min([yLimOld yLimNew]), max([yLimOld yLimNew]),...
              min([zLimOld zLimNew]), max([zLimOld zLimNew])])
    end
end

