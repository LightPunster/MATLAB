function stability = stable(lambda)
%stable.m determines the stability of an equilibrium point from its eigen
%values
%   Accepts matrix where column vectors are eigen values

    [n,m] = size(lambda);
    stability = cell(1,m);
    
    if n==1
        real_lambda_min = real(lambda);
        real_lambda_max = real(lambda);
        lambda_complex = true*zeros(size(lambda));
        lambda_real = true*ones(size(lambda));
    else
        real_lambda_min = min(real(lambda));
        real_lambda_max = max(real(lambda));

        [~,j_c] = find(imag(lambda));
        lambda_complex = true*e(m,j_c)';
        lambda_real = ~lambda_complex;
    end
    
    for i=1:m
        if (real_lambda_max(i)<0)&&(lambda_real(i))
            stability{i} = 'stable node';
        end
        if (real_lambda_max(i)<0)&&(lambda_complex(i))
            stability{i} = 'stable focus';
        end
        if (real_lambda_max(i)==0)&&(lambda_real(i))
            stability{i} = 'marginally stable';
        end
        if (real_lambda_max(i)==0)&&(lambda_complex(i))
            stability{i} = 'marginally stable focus';
        end
        if (real_lambda_max(i)>0)&&(real_lambda_min(i)>=0)&&(lambda_real(i))
            stability{i} = 'unstable node';
        end
        if (real_lambda_max(i)>0)&&(real_lambda_min(i)>=0)&&(lambda_complex(i))
            stability{i} = 'unstable focus';
        end
        if (real_lambda_max(i)>0)&&(real_lambda_min(i)<0)
            stability{i} = 'saddle';
        end
    end
end

