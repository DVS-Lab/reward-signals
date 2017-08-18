% Fit Kalman Filter RW model
fitindi = false;


% ---------- get data ----------%
if fitindi
   subjects = input('subjectnum');
   getdata;
else
   getpopdata;
end

% ------------ fit models --------------------%

% create parameter structure
g = [1 10];  % parameters of the gamma prior
param(1).name = 'inverse temperature';
param(1).logpdf = @(x) sum(log(gampdf(x,g(1),g(2))));  % log density function for prior
param(1).lb = 0;    % lower bound
param(1).ub = 5;   % upper bound

a = 0; b = 1;   % parameters of lambda prior
param(2).name = 'lambda';
param(2).logpdf = @(x) sum(log(unifpdf(x,a,b)));
param(2).lb = .9;
param(2).ub = 1;

a = 1; b = 100;   % parameters of theta prior
param(3).name = 'theta';
param(3).logpdf = @(x) sum(log(unifpdf(x,a,b)));
param(3).lb = 1;
param(3).ub = 100;

a = 0; b = 100;   % parameters of sigmad prior
param(4).name = 'sigmad';
param(4).logpdf = @(x) sum(log(unifpdf(x,a,b)));
param(4).lb = 0;
param(4).ub = 100;

a = 0; b = 100;   % parameters of mu0 prior
param(5).name = 'mu0';
param(5).logpdf = @(x) sum(log(unifpdf(x,a,b)));
param(5).lb = 1;
param(5).ub = 100;

a = 0; b = 10;   % parameters of sigma0 prior
param(6).name = 'sigma0';
param(6).logpdf = @(x) sum(log(unifpdf(x,a,b)));
param(6).lb = 0;
param(6).ub = 10;


% run optimization
nstarts = 5;    % number of random parameter initializations
disp('... Fitting Kalman RW');

if fitindi
   results(1) = fit_optimize(@KRWlik,param(1:6),data,nstarts);
else
   [result(1),results] = popfit_optimize(@KRWlik,param(1:6),data,nstarts);
end
