function [ x ] = UniversalVariable(r0,v0,dt,u,accuracy)
    %Uses Newton's method to iteratively solve for universal variable 'x' at
    %time t given an initial position r0, an initial velocity v0, t1-t0 = dt, 
    %gravitation constant of planet u, and specified accuracy of convergence
    num = 0; %Stores number of iterations

    sigma0 = sum(r0.*v0)/sqrt(u);
    alpha = (2/norm(r0))-(norm(v0)^2)/u;

    %Per Bates,Mueller,&White:
    x1 = sqrt(u)*dt*alpha; %Ellipse estimation
    %x1 = sign(dt)*sqrt(-a)*log((-2*u*dt)/(a*(sum(r0.*v0)+sign(dt)*sqrt(-u*a)*(1-(norm(r0)/a))))); %Hyperbola estimation
    x0 = 10*x1; %Ensures accuracy condition not met initially

    %Iterator
    while abs(x1-x0)>accuracy
        x0 = x1;
        z0 = alpha*x0^2;
        F = sigma0*(x0^2)*C(z0) + (1-norm(r0)*alpha)*(x0^3)*S(z0) + norm(r0)*x0 - sqrt(u)*dt;
        dFdx = sigma0*x0*(1-z0*S(z0)) + (1-norm(r0)*alpha)*(x0^2)*C(z0) + norm(r0);
        x1 = x0 - F/dFdx;
        num = num + 1;
    end
    
    x = x1;
    error = x1-x0; %Difference in current estimate from previous estimate
end

function c = C(y)
    if y>0.01 %Positive: Ellipse
        c = (1-cos(sqrt(y)))/y;
    elseif y<-0.01 %Negative: Hyperbola
        c = (cosh(sqrt(-y))-1)/(-y);
    else %Near Zero: Approaching hyperbola, use series expansion
        c = (1/factorial(2)) - (y/factorial(4)) + (y^2)/factorial(6) - (y^3)/factorial(8);
    end
end

function s = S(y)
    if y>0.01 %Positive: Ellipse
        s = (sqrt(y)-sin(sqrt(y)))/sqrt(y^3);
    elseif y<-0.01 %Negative: Hyperbola
        s = (sinh(sqrt(-y))-sqrt(-y))/sqrt((-y)^3);
    else %Near Zero: Approaching hyperbola, use series expansion
        s = (1/factorial(3)) - (y/factorial(5)) + (y^2)/factorial(7) - (y^3)/factorial(9);
    end
end