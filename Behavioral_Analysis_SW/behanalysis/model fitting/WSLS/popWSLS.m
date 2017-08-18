function loglik = popWSLS(x,data)  
     
     numsubj = length(data);
     
     logp = nan(numsubj,1);
     
     for s = 1:numsubj
         %input = [betas(s),lambda,theta,sigmad,mu0,sigma0];
         logp(s) = WSLSlik(x,data(s));
     end
     loglik = sum(logp);
end