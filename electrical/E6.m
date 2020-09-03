function array = E6(low_decade,high_decade)
    n = high_decade - low_decade;
    if n<=0
        error('The high decade power must be greater than the low decade power.\n')
    end
    array = zeros(1,6*n + 1);
    for i=1:n
        array(6*(i-1) + 1) = 1*10^(low_decade+i-1);
        array(6*(i-1) + 2) = 1.5*10^(low_decade+i-1);
        array(6*(i-1) + 3) = 2.2*10^(low_decade+i-1);
        array(6*(i-1) + 4) = 3.3*10^(low_decade+i-1);
        array(6*(i-1) + 5) = 4.7*10^(low_decade+i-1);
        array(6*(i-1) + 6) = 6.8*10^(low_decade+i-1);
    end
    array(end) = 10^high_decade;
end

