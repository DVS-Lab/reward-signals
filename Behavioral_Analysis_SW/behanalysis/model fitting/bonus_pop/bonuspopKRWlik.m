function loglik = bonuspopKRWlik(x,data)  
     lambda = x(1);
     theta  = x(2);
     sigmad = x(3);
     mu0    = x(4);
     sigma0 = x(5);
     phi = x(end);
     
     numsubj = length(data);
     
     betas = x(6:end);
     betas = betas(1:end-1);
     %%%% phi
     
     
     logp = nan(numsubj,1);
     
     for s = 1:numsubj
         input = [betas(s),lambda,theta,sigmad,mu0,sigma0,phi];
         logp(s) = bonus_KRWlik(input,data(s));
     end
     loglik = sum(logp);
end
