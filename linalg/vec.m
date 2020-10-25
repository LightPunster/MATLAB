function vecX = vec(X)
%vec takes the vector of a matrix (i.e. stacks its columns)
%     [n,m] = size(X);
%     vecX = zeros(n*m,1);
%     for i=1:m
%         vecX(m*(i-1)+1:m*i) = X(:,i);
%     end
    vecX = X(:);
end

