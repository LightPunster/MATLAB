function P = lyap2(A,R)
%lyap2 solves Lyapunov equation for possibly symbolic A & R (which is not
%handled by built in lyap function)

n = size(A,1);
A_kronSum_A = kronSum(A,A);
if det(A_kronSum_A)==0
    error('kronSum(A,A) must be invertible.')
end
P = -vec_inv(kronSum(A,A)\vec(R),n);
    
end

