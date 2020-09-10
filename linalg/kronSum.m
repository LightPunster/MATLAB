function sum = kronSum(A,B)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if (size(A,1)~=size(A,2)) || (size(B,1)~=size(B,2))
    error("Both arguments in a Kronecker Sum must be square matrices.")
end
n = size(A,1);
m = size(B,1);

sum = kron(A,eye(m)) + kron(eye(n),B);

end

