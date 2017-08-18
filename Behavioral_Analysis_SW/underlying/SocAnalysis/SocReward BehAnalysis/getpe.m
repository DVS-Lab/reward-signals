function model = getpe(data,subjnum)
% betas:

% defparam:
  param = data.param;
  lambda = param(1);
  theta = param(2);
  sigmad = param(3);
  mu0 = param(4);
  sigma0 = param(5);
  beta = data.beta;
  dt = 0;
  
  lik = 0;
     
     sigmao = 4;
     mu = mu0*ones(1,2);
     sigma = sigma0*ones(1,2);
     
% muS,muP,sigmaS,sigmaP

     N = data.N;
     model.dt = nan(N,1);
     model.choice = model.dt;
     model.mu = nan(N,3);
     model.sigma = model.mu;
     
     model.mu(1,:) = mu0;
     model.sigma(1,:) = sigma0;
     
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
   else
       c = nan;
       dt = 0;
   end
   
   model.dt(trialnum) = dt;
   model.c(trialnum) = c;
   model.r(trialnum) = r;
   if ~isnan(c)
       model.mu(trialnum+1,:) = [mu,model.mu(trialnum,c)];
       model.sigma(trialnum+1,:) = [sigma,model.sigma(trialnum,c)];
    else
       model.mu(trialnum+1,:) = [model.mu(trialnum,1:2),model.mu(trialnum,3)];
       model.sigma(trialnum+1,:) = [model.sigma(trialnum,1:2),model.sigma(trialnum,3)];
   end
end
end