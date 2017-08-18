function lik = KRWlik(x,data)
    
    %Choice: 1 = deck1; 2 = deck2; 3 = deck3
    %Outcome: 0, 1, 2, 3
    %data = [ decision(:,1), outcome(:,1)];

    
    %Standard RW: 2 Parameter
     lambda = x(2);
     theta  = x(3);
     sigmad = x(4);
     mu0    = x(5);
     sigma0 = x(6);
     beta = x(1);
    %Free parameters

     lik = 0;
     
     sigmao = 4;
     mu = mu0*ones(1,2);
     sigma = sigma0*ones(1,2);
     
% muS,muP,sigmaS,sigmaP

     N = data.N;
     PP = nan(N,2);
     
for trialnum = 1:N
    c = data.c(trialnum);
    r = data.r(trialnum);
    %ev = exp(beta*mu);
    %sev = sum(ev);
    %p = ev/sev;
    %PP(trialnum,:) = p;
   if c == 1 || c == 11 %deck1 action
      data.c(trialnum) = 1;
      c = 1;
      lik = lik + beta*mu(c) - logsumexp(beta*mu,2);
      
      % chosen option 
       dt = r - mu(c); % prediction error
       K  = sigma(c)^2/(sigma(c)^2 + sigmao^2); %kalman gain
      % transitions:
       sigma(c) = sqrt((1-K)*sigma(c)^2);
       mu(c) = mu(c) + K*dt;
       % prior for next trial
       mu(c) = lambda*mu(c) + (1-lambda)*theta;
       sigma(c) = sqrt(lambda^2*sigma(c)^2 + sigmad^2);
       mu(3-c) = lambda*mu(3-c) + (1-lambda)*theta;
       sigma(3-c) = sqrt(lambda^2*sigma(3-c)^2 + sigmad^2);
       
    elseif c == 2 || c == 22 %deck2 action
      
      data.c(trialnum) = 2;
      c = 2;
      lik = lik + beta*mu(c) - logsumexp(beta*mu,2);
      
      % chosen option 
       dt = r - mu(c); % prediction error
       K  = sigma(c)^2/(sigma(c)^2 + sigmao^2); %kalman gain
      % transitions:
       sigma(c) = sqrt((1-K)*sigma(c)^2);
       mu(c) = mu(c) + K*dt;
       % prior for next trial
       mu(c) = lambda*mu(c) + (1-lambda)*theta;
       sigma(c) = sqrt(lambda^2*sigma(c)^2 + sigmad^2);
       mu(3-c) = lambda*mu(3-c) + (1-lambda)*theta;
       sigma(3-c) = sqrt(lambda^2*sigma(3-c)^2 + sigmad^2);
    
   end
    
end
%lik = sum(log(PP(data.c==1,1)))+sum(log(PP(data.c==2,2)));
end    
