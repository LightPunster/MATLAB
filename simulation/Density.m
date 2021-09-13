function [ rho ] = Density(A)
    if A<=0
        rho = 1.225;
    else
        %https://en.wikipedia.org/wiki/File:Comparison_US_standard_atmosphere_1962.svg
        %https://en.wikipedia.org/wiki/Ionosphere
        if A<11000
            t = 288.15 - 0.0065*A;
        elseif A<20000
            t = 217;
        elseif A<32000
            t = 198.6666 + 0.00091667*A;
        elseif A<47500
            t = 141.6 + 0.0027*A;
        elseif A<52500
            t = 270;
        elseif A<60500
            t = 364.6782 - 0.0018*A;
        elseif A<80000
            t = 461.7 - 0.0034*A;
        elseif A<90000
            t = 189.5;
        elseif A<300000
            t = 0.0048*A - 242.5;
        else
            t = 1200;
        end

        % P0 = 101325; g = 9.805; M = 0.0289644; T0 = 288.15; R0 = 8.31447;
        % C = P0; a = g*M/(T0*R0);
        % P = C*e^(-a*A); % https://en.wikipedia.org/wiki/Atmospheric_pressure
        p = 101325*exp(-0.00011854*A);
        if A>300000
            p=0;
        end

        %R = 287.05;
        % rho = P/(R*T); %https://www.brisbanehotairballooning.com.au/calculate-air-density/
        rho = p/(287.05*t);
    end
end

