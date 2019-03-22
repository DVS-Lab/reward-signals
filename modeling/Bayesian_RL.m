% Bayesian reinforcement learning model
    %
    % USAGE: [model, lik] = Bayesian_RL(param, data)
    %
    % INPUTS:
    %   data - individual subject data with following fields
    %           .c - [N x 1] deck choice
    %           .r - [N x 1] reward feedback
    %           .N - # of trials
    %   param - parameter structure with the following fields:
    %                       .c - prior variance (default: 4)
    %                       .s - observation noise variance (constant: 4) 
	%                       param(1) - decay rate
    %                       param(2) - decay center  
    %                       param(3) - diffusion noise variance
    %                       param(4) - inverse temperature 
    %
    % OUTPUTS:
    %   model - [1 x N] structure with the following fields for each timepoint:
    %           .w - [D x 1] posterior mean weight vector
    %           .C - [D x D] posterior weight covariance
    %           .K - [D x 1] Kalman gain (learning rates for each dimension)
    %           .dt - prediction error
    %           .rhat - reward prediction
    %	lik - log-likelihood
    %
    % Shaoming Wang, 2019
    
    % initialization
    N = data.N;
    D = max(unique(data.c));
    X = zeros(N,D);
    ix = sub2ind(size(X),[1:N]',data.c);
    X(ix) = 1;
    w = zeros(D,1);         % weights
    X = [X; zeros(1,D)];    % add buffer at end
    
    % parameters
    c = 4;
    s = 4;				% observation noise variance
    d = param(1);		% decay rate
    m = param(2);		% decay center
    q = param(3);
    b = param(4);		% inverse temperature
    
    C = c*eye(D); 		% prior variance       
    Q = param.q*eye(D); % diffusion noise variance		
    
    % run Kalman filter
    for n = 1:N
        
        w = d*w + (1-d)*m;						% a priori mean
        C = C*d^2 + Q;              			% a priori covariance
        h = X(n,:);                 			% chosen bandit
        lik = lik + b*h*w - logsumexp(b*w,2);	% choice likelihood
        rhat = h*w;                 			% reward prediction
        dt = r(n) - rhat;           			% prediction error
        P = h*C*h'+s;               			% residual covariance
        K = C*h'/P;                 			% Kalman gain
        w = w + K*dt;               			% weight update
        C = C - K*h*C;              			% posterior covariance update
        
        % store results
        model(n) = struct('w',w,'C',C,'K',K,'dt',dt,'rhat',rhat);
        
    end