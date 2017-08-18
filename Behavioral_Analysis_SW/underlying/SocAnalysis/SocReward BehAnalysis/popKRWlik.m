function loglik = popKRWlik(x,data)  
     lambda = x(1);
     theta  = x(2);
     sigmad = x(3);
     mu0    = x(4);
     sigma0 = x(5);
     
     betas = x(6:end);
     
     numsubj = length(data);
     
     logp = nan(numsubj,1);
     
     for s = 1:numsubj
         input = [betas(s),lambda,theta,sigmad,mu0,sigma0];
         logp(s) = KRWlik(input,data(s));
     end
     loglik = sum(logp);
end
