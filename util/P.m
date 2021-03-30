function y = P(x,coeffs)
%P applies a polynomial defined by a coefficient vector to x

    y = zeros(size(x));
    n = length(coeffs);
    for k=1:n
        y = y + coeffs(k)*x.^(n-k);
    end
end

