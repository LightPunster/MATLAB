function [product] = polyMult(varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

num = nargin;
poly = varargin;
product = 1;
thisPoly = 0;
thisOrder = 0;
lastOrder = 0;
padding = 0;

for i = 1:num
    thisPoly = cell2mat(poly(i));
    
    thisOrder = length(thisPoly);
    lastOrder = length(product);
    padding = abs(thisOrder - lastOrder);
    
    if i==1
    else
        if thisOrder > lastOrder
            product = [zeros(1,padding) product];
        elseif thisOrder < lastOrder
            thisPoly = [zeros(1,padding) thisPoly];
        end
    end
    
    product = conv(thisPoly,product);
end

while product(1) == 0
    product = product(2:end);

end

