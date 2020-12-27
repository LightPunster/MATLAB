function P = riccati(A,B,R1,R12,R2)
%riccati.m  Solves an algebraic Riccati equation
%   P = riccati(A,B,R1,R12,R2) solves the algebraic Riccati equation of the form:
%       A'*P + P*A + R1 - (B'P + R12')'*(R2^-1)*(B'P + R12') = 0
%   where P is symmetric. One alternate notation is:
%       Ar'*P + P*Ar - P*Br*P + R = 0
%   where
%       Ar = A - B*(R2^-1)*R12'
%       Br = B*(R2^-1)*B'
%       R = R1 - R12*(R2^-1)*R12'

R2inv = inv(R2);
Ar = A - B*R2inv*R12';
Br = B*R2inv*B';
R = R1 - R12*R2inv*R12';

%n=size(Ar,1);
Z = [ Ar -Br
    -R  -Ar'];
n = size(Z,1);
m = size(Z,2);
[eigenVectors,eigenValues] = eig(Z)

% X = zeros(n,m);
% Y = zeros(n,n);
% for j=1:m
%     v = Z(:,j);
%     for i=1:j-1
%         Y(i,j) = X(:,i)'*A(:,j);
%         v = v - Y(i,j)*Q(:,i);
%     end
%     Y(j,j) = norm(v);
%     X(:,j)=v/R(j,j);
% end
% X

V = Z;
V(:,1) = eigenVectors(:,1);

%TODO: Try QR decomposition
%https://en.wikipedia.org/wiki/QR_decomposition
%http://web.math.ucsb.edu/~padraic/ucsb_2013_14/math108b_w2014/math108b_w2014_lecture5.pdf
%Graham Schmidt Process
for j=2:m
    u_j = Z(:,j);
    u_j_proj = zeros(size(u_j));
    for k=1:j-1
        v_k = V(:,k);
        u_j_proj = u_j_proj + (dot(u_j,v_k)/norm(v_k))*v_k;
    end
    u_j_orth = u_j - u_j_proj
    V(:,j) = u_j_orth/norm(u_j_orth);
end
P = Z*V
Z*V(:,2)
        


%[U1,S1]=schur(Z)
% [U,~]=ordschur(U1,S1,'lhp')
% P = U(n+1:end,1:n)*U(1:n,1:n)^-1;