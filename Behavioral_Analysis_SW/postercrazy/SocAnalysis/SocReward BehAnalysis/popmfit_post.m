function logpo = popmfit_post(x,param,data,likfun)
    
    % Evaluate log probability of parameters under the (unnormalized) posterior.
    %
    % USAGE: logp = mfit_post(x,param,data,likfun)
    %
    % INPUTS:
    %   x - parameter values
    %   param - parameter structure
    %   data - data structure
    %   likfun - function handle for likelihood function
    %
    % OUTPUTS:
    %   logp - log unnormalized posterior probability
    %
    % Sam Gershman, July 2015
    
    logpo = nan(length(data),1);
    
    for s = 1:length(data)
        logpo(s) = likfun(x,data(s));
    end
   
    logpo = sum(logpo);
    
    for k = 1:length(param)
        logpo = logpo + param(k).logpdf(x(:,k));
    end