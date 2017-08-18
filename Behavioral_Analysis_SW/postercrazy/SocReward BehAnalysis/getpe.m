function model = getpe(data,subjnum)
% betas:
  betas = [0.1621,0.1405,0.1300,0.1392,0.3809,0.001,0.0339,0.0382,0.0000,0.1207,1.4125,0.0710,0.0564,0.1037,0.0776,0.1175,0.0673,0.3649];

% defparam:
  lambda = .9221;
  theta = 42.88;
  sigmad = 32.93;
  mu0 = 66.07;
  sigma0 = 5.1426;
  beta = betas(subjnum);
  dt = 0;
  
  lik = 0;
     
     sigmao = 4;
     mu = mu0*ones(1,2);
     sigma = sigma0*ones(1,2);
     
% muS,muP,sigmaS,sigmaP

     N = size(data.r,1);
     model.dt = nan(N,1);
     model.choice = model.dt;
     
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
    
    end
    model.dt(trialnum) = dt;
    model.c(trialnum) = c;  
end
end