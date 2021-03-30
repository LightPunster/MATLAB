function [P,A,r] = MaxRoA(f,varargin)
%MaxRoA Picks a quadratic Lyapunov function to maximize the region of
%attraction for a 2nd order nonlinear system with an equilibrium point at
%the origin
%   Todo: incorporate higher order systems

    switch nargin
        case 1
            x_eq = [0;0];
        case 2
            x_eq = varargin{1};
        otherwise
            error('Invalid number of inputs')
    end
    P = eye(2);

    r0 = 5;
    n0 = 1000;
    n = 3;
    i=0;
    eps = 1e-4;
    sigma = 0.1;
    
    %Create x grid
    for k=1:n
        x_1 = linspace(x_eq(1)-r0,x_eq(1)+r0,n0);
        x_2 = linspace(x_eq(2)-r0,x_eq(2)+r0,n0);
        [X_1,X_2] = meshgrid(x_1,x_2);
        %Calculate x_dot at each point
        X_dot = zeros([size(X_1),2]);
        for i=1:size(X_dot,1)
            for j=1:size(X_dot,2)
                X_dot(i,j,:) = f([X_1(i,j); X_2(i,j)]);
            end
        end
        J = Jacobian(@(P_vec) area(P_vec,X_1,X_2,X_dot),...
                     vec(P),r0/n0);
        i = 0;
        while(norm(J)>eps)
            P_234 = [P(1,2); P(2,1); P(2,2)];
            A = area(P_234,X_1,X_2,X_dot);
            J = Jacobian(@(p_234) area(p_234,X_1,X_2,X_dot),...
                     P_234,r0/n0);
            P_234 = P_234 + sigma*J';
            P = [1 P_234(1); P_234(2) P_234(3)];
            fprintf('%d.%d: vec(P)=[%f,%f;%f,%f], A=%f, J=[%f,%f,%f]\n',...
                k,i,P(1),P(2),P(3),P(4),A,J(1),J(2),J(3))
            i = i+1;
        end
        r0 = 2*radius(vec(P),X_1,X_2,X_dot);
    end

    [V_dot,R,A,r] = RoA(P,X_1,X_2,X_dot,3);
    figure,hold on
    mesh(X_1,X_2,V_dot)
    mesh(X_1,X_2,R)
    x_1 = linspace(-r,r,1000);
    plot3(x_1,sqrt(r^2-x_1.^2),zeros(size(x_1)),'r')
    plot3(x_1,-sqrt(r^2-x_1.^2),zeros(size(x_1)),'r')

end

function A = area(P_234,X_1,X_2,X_dot)
    P = [1 P_234(1); P_234(2) P_234(3)];
    [~,~,A,~] = RoA(P,X_1,X_2,X_dot,1);
end
function r = radius(P_234,X_1,X_2,X_dot)
    P = [1 P_234(1); P_234(2) P_234(3)];
    [~,~,~,r] = RoA(P,X_1,X_2,X_dot,2);
end
function [V_dot,R,A,r] = RoA(P,X_1,X_2,X_dot,c)
    dx1 = (X_1(1,2)-X_1(1,1));
    dx2 = (X_2(2,1)-X_2(1,1));
    
    %Calculate lyapunov function derivative
    V_dot = P(1,1)*X_1.*X_dot(:,:,1) + ...
        P(1,2)*X_2.*X_dot(:,:,1) + ...
        P(2,1)*X_1.*X_dot(:,:,2) + ...
        P(2,2)*X_2.*X_dot(:,:,2);
    R = V_dot<0;
    %figure
    %mesh(X_1,X_2,R)
    
    if(c==1)||(c==3)
        %Approximate area of region of attraction
        A = sum(sum(R))*dx1*dx2;
    else
        A = 0;
    end
    
    if(c==2)||(c==3)
        %Radius of attraction
        %figure
        dr = sqrt(dx1^2+dx2^2);
        r = 2*dr;
        B_r = (X_1.^2+X_2.^2)<r^2;
        while (max(V_dot(B_r))<0) && (r<min(max(max(X_1)),max(max(X_2))))
    %         clf(),hold on
    %         mesh(X_1,X_2,50*B_r)
    %         mesh(X_1,X_2,V_dot)
    %         x_1 = linspace(-r,r,1000);
    %         plot3(x_1,sqrt(r^2-x_1.^2),zeros(size(x_1)),'r')
    %         plot3(x_1,-sqrt(r^2-x_1.^2),zeros(size(x_1)),'r')
    %         max(V_dot(B_r))
    %         pause()

            r = r + dr;
            B_r = (X_1.^2+X_2.^2)<r^2;
        end
    else
        r = 0;
    end
end