function [t,x,varargout] = nlsim(f,x0,t,varargin)
%nlsim simulates a time-invariant system with nonlinear dynamics
%   This function is meant to serve as a nonlinear variant of the lsim
%   function. Inputs are:
%       - f: the function handle which has inputs x (1xn) and u (1xn) and outs x_d
%       (the state derivatives) and y (the system out, if applicable)
%       - u: 

    %Input checking
    switch nargin
        case 3
            input = false;
        case 4
            input = true;
            u = varargin{1};
        otherwise
            input = false;
    end
    switch nargout
        case 2
            out = false;
        case 3
            out = true;
        otherwise
            out = false;
    end

    if numel(x0)>length(x0)
        error('x0 should be a 1-dimensional column or row vector.')
    end
    if size(x0,1)==1 %If x0 is given as row vector, convert it to a column vector
        x0 = x0';
    end

    x = zeros(length(x0),length(t));
    x(:,1) = x0; %State @ t=0
    %State derivate & out @ t=0
    if out
        if input
            [x_d,y] = f(x(:,1),u(:,1));
        else
            [x_d,y] = f(x(:,1));
        end
    else
        if input
            x_d = f(x(:,1),u(:,1));
        else
            x_d = f(x(:,1));
        end
    end
    
    for i=2:length(t)
        dt = t(i)-t(i-1); %Calculate time increment
        x(:,i) = x(:,i-1) + dt*x_d; %Update state
        %Update state derivative & out
        if out
            if input
                [x_d,y_i] = f(x(:,i),u(:,i));
            else
                [x_d,y_i] = f(x(:,i));
            end
            y = [y y_i];
        else
            if input
                x_d = f(x(:,i),u(:,i));
            else
                x_d = f(x(:,i));
            end
        end
    end

    %Return transposed outs
    x = x';
    if out
        varargout{1} = y';
    end
end