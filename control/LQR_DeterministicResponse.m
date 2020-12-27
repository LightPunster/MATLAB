function [Ks,Ps,Xs] = LQR_DeterministicResponse(t,x0,A,B,D1,R1,R2,R12)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here

%Ensure inputs are in usable format
if ~iscell(x0),  x0 =  {x0};  end
if ~iscell(A),   A =   {A};   end
if ~iscell(B),   B =   {B};   end
if ~iscell(R1),  R1 =  {R1};  end
if ~iscell(R2),  R2 =  {R2};  end
if ~iscell(R12), R12 = {R12}; end

Ks = {};
Ps = {};
Xs = {};
ns = [];

%Loop through every given case
for i=1:length(x0)
    x0_i = x0{i};
    ns(i) = length(x0_i);
    if ~isequal(size(x0_i),[ns(i),1])
        error('x must be a column vector\n');
    end
    for j=1:length(A)
        A_j = A{j};
        if ~isequal(size(A_j),[ns(i),ns(i)])
            error('A must be a square matrix with the same number of rows as x0.\n');
        end
        for k=1:length(B)
            B_k = B{k};
            if size(B_k,1)~=ns(i)
                error('B must be an nxm matrix with the same number of rows as x0.\n');
            end
            for p=1:length(R1)
                R1_p = R1{p};
                if ~isequal(size(R1_p),[ns(i),ns(i)])
                    error('R1 must be a square matrix with the same number of rows as x0.\n');
                end
                for q=1:length(R2)
                    R2_q = R2{q};
                    if size(R2_q,2)~=size(B_k,2)
                        error('R2 must have the same number of columns as B.\n');
                    end
                    for r=1:length(R12)
                        R12_r = R12{r};
                        
                        %Calculate LQR gain
                        [P,K,~] = icare(A_j,B_k,R1_p,R2_q,R12_r,eye(size(A_j)),0);
                        Ks{end+1} = -K;
                        Ps{end+1} = P;
                        
                        %Simulate
                        system = ss(A_j+B_k*K,D1,eye(size(A_j)),0);
                        Xs{end+1} = lsim(system,zeros(size(B_k,2),length(t)),t,x0_i);
                    end
                end
            end
        end
    end
end

cols = length(Ks);
rows = max(ns) + 1;

for i=1:rows
    for j=1:cols
        subplot(rows,cols,cols*(i-1) + j)
        if i<rows
            plot(t,Xs{j}(:,i))
        else
            plot(t,Ks{j}*Xs{j}')
        end
    end
end
% T = ['R_1/R_2 = 1I, K_{lqr} = [' num2str(K_lqr) ']'];
% title(T),ylabel('q(t)')
% axis([min(t),max(t),-0.5,0.5])
% subplot(3,2,3)
% plot(t,x(:,2)), grid on
% ylabel('q_d(t)')
% axis([min(t),max(t),-1.2,1.2])
% subplot(3,2,5)
% plot(t,K_lqr*x'),grid on
% xlabel('t'),ylabel('u(t)')
% axis([min(t),max(t),-4,2])
% 
% R1 = 100*R2*eye(2);
% [~,K,~] = icare(eval(A),eval(B),R1,R2,R12,eye(size(A)),0);
% K_lqr = -K;
% system100 = ss(eval(A) + eval(B)*K_lqr,eval(D1),eye(size(A)),0);
% x = lsim(system100,u,t,x0);
% subplot(3,2,2)
% plot(t,x(:,1)), grid on
% T = ['R_1/R_2 = 100I, K_{lqr} = [' num2str(K_lqr) ']'];
% title(T),ylabel('q(t)')
% axis([min(t),max(t),-0.5,0.5])
% subplot(3,2,4)
% plot(t,x(:,2)), grid on
% ylabel('q_d(t)')
% axis([min(t),max(t),-1.2,1.2])
% subplot(3,2,6)
% plot(t,K_lqr*x'),grid on
% xlabel('t')
% axis([min(t),max(t),-4,2])
end

