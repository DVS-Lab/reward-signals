function logp = popmfit_post(x,param,data,likfun)
    
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
    logp = nan(length(data),1);
    for s = 1:length(data)
        logp(s) = likfun(x,data);
    end
    logp = sum(logp);
    
    for k = 1:length(param)
        logp = logp + param(k).logpdf(x(:,k));
    end