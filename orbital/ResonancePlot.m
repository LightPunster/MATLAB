function ResonancePlot( sat, I, e, alpha_range, beta_range, alt_range, alt_target)

    J2 = 1082.6267e-6; % Oblateness term
    Sdot = 1.00273781191*2*pi; % Mean angular rotation of Earth, in revs/day
    GM = 398600.4418*(3600*24*3600*24); % Standard gravitational parameter, km3/day^2
    R = 6378.135; % Mean Earth radius, km

    alpha_list = alpha_range(1):alpha_range(2);
    Beta_list = beta_range(1):beta_range(2);
    Results = zeros(3,length(alpha_list)*length(Beta_list));

    for alpha = alpha_list
        for Beta = Beta_list
            %iteratively solve for n
            n_guess = (Beta/alpha)*Sdot; delta = 100; num = 0;
            while abs(delta)>1e-8
                a_guess = (GM/n_guess^2)^(1/3);
                n = (Beta/alpha)*Sdot - (3/4)*J2*n_guess*((R/a_guess)^2)*(5*cosd(I)^2 - 2*(Beta/alpha)*cosd(I) - 1);
                a = (GM/n^2)^(1/3);
                delta = n-n_guess; %Change

                num = num + 1; %Number of iterations
                n_guess = n; %Reset guesses
                a_guess = a;
            end

            i = length(Beta_list)*(alpha-1)+(Beta-1)+1;
            Results(1,i)=alpha;
            Results(2,i)=Beta;
            Results(3,i)=a;

        end
    end

    alpha = Results(1,:);
    Beta = Results(2,:);
    a = Results(3,:); A = a - R;

    alpha = alpha((A<=alt_range(2))&(A>=alt_range(1)));
    Beta = Beta((A<=alt_range(2))&(A>=alt_range(1)));
    A = A((A<=alt_range(2))&(A>=alt_range(1)));

    %Generate labels
    for i=1:length(Beta)
        Beta_label{i} = num2str(Beta(i));
    end

    close all
    figure(1),hold on
    plot(alpha,A,'.')
    text(alpha,A,Beta_label)

    if nargin==7
        line = alt_target*ones(1,length(A));
        plot(alpha,line,'r')
    end
    axis([0,max(alpha_list),alt_range(1),alt_range(2)])        
    xlabel('repeat period (synodic days)')
    ylabel('Satellite altitude (km above mean Earth radius)')
    title(['Predicted resonances for the ' sat ' mission'])

end

