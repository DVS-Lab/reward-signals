% ============ Reward Learning in Social Context: Model fitting =============
%
% code for fitting behavioral data to Bayesian reinfocement learning model
%
% Shaoming Wang 2019
% ===========================================================================
% load behavioral data
load('summary.mat')
data = summary;

% create parameter space
a = 1.2; b = 1.2;	% parameters of beta prior
param(1).name = 'decay rate';
param(1).logpdf = @(x) sum(log(betapdf(x,a,b)));
param(1).lb = 0;
param(1).ub = 1;
  
param(2).name = 'decay center';
param(2).logpdf = @(x) sum(log(betapdf(x,a,b)));
param(2).lb = 1;
param(2).ub = 100;

g = [2 3];  		% parameters of the gamma prior
param(3).name = 'diffusion noise variance';
param(3).logpdf = @(x) sum(log(gampdf(x,g(2),g(2))));  
param(3).lb = 0;   % lower bound
param(3).ub = 1000;   % upper bound

param(4).name = 'inverse temperature';
param(4).logpdf = @(x) sum(log(gampdf(x,g(2),g(2))));  
param(4).lb = 0;   % lower bound
param(4).ub = 50;   % upper bound

% run optimization
nstarts = 5;		% number of random parameter initilizations
disp('... Fitting Bayesian RL');
results = mfit_optimize(@Bayesian_RL, param, data, nstarts);


