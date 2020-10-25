function X = vec_inv(vecX,n)
%vec inverts the vector operation on a matrix (i.e. 'un-stacks' its columns)
    if size(vecX,2)~=1
        error('Input vecX must be a column vector')
    end
    if mod(size(vecX,1),n)~=0
        error('Input vecX must have a length which is an integer multiple of input n')
    end

    m = size(vecX,1)/n;
    X = reshape(vecX,[n,m]);
end
