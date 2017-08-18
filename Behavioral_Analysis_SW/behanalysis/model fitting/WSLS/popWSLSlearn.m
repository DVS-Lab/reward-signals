function loglik = popWSLSlearn(x,data)  
     
     numsubj = length(data);
     
     logp = nan(numsubj,1);
     
     for s = 1:numsubj
         %input = [betas(s),lambda,theta,sigmad,mu0,sigma0];
         logp(s) = WSLSlearnlik(x,data(s));
     end
     loglik = sum(logp);
end