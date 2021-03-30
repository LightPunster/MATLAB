function [x_eq,A,lambda,stability] = TunnelDiodeEqPnts(L,R,C,u,h)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    
    v_d_eq_1 = fzero(@(v) h(v)-(u-v)/R,0);
    v_d_eq_3 = fzero(@(v) h(v)-(u-v)/R,u);
    v_d_eq_2 = fzero(@(v) h(v)-(u-v)/R,(v_d_eq_1 + v_d_eq_3)/2);
   
    i_d_eq_1 = h(v_d_eq_1);
    i_d_eq_2 = h(v_d_eq_2);
    i_d_eq_3 = h(v_d_eq_3);
    
    x1 = [v_d_eq_1; i_d_eq_1];
    x2 = [v_d_eq_2; i_d_eq_2];
    x3 = [v_d_eq_3; i_d_eq_3];
    x_eq = [x1 x2 x3];
    A = {};
    lambda = zeros(size(x_eq));
    stability = {};
%     v_d = linspace(0,u);
%     plot(v_d,h(v_d),...
%          v_d,(u-v_d)/R,...
%          v_d_eq_1,i_d_eq_1,'*',...
%          v_d_eq_2,i_d_eq_2,'*',...
%          v_d_eq_3,i_d_eq_3,'*')
    for i=1:size(x_eq,2)
        [~,hp] = h(x_eq(1,i));
        A{end+1} = [-(1/C)*hp (1/C);
                    -(1/L) -(R/L)];
        lambda(:,i) = eig(A{end});
        if(real(lambda(1,i))<0)&&(real(lambda(2,i))<0)
            stability{end+1} = "stable";
        else if((real(lambda(1,i))<0)&&(real(lambda(2,i))>0))||...
                ((real(lambda(1,i))>0)&&(real(lambda(2,i))<0))
            stability{end+1} = "saddle";
        end
        else if(real(lambda(1,i))>0)&&(real(lambda(2,i))>0)
            stability{end+1} = "unstable";
        end
            
    end
    
end
