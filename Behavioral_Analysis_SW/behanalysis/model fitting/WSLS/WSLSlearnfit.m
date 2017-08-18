% Fit basic WSLS with learning

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
a = 1; b = 1;  % parameters of p0_s
param(1).name = 'p0(win|stay)';
param(1).logpdf = @(x) sum(log(betapdf(x,a,b)));
param(1).lb = 0;    % lower bound
param(1).ub = 1;   % upper bound

a = 1; b = 1;   % parameters of lambda prior
param(2).name = 'p0(lose|shift)';
param(2).logpdf = @(x) sum(log(betapdf(x,a,b)));
param(2).lb = 0;
param(2).ub = 1;

a = 1; b = 1;  % parameters of p0_s
param(3).name = 'theta_win|stay';
param(3).logpdf = @(x) sum(log(betapdf(x,a,b)));
param(3).lb = 0;    % lower bound
param(3).ub = 1;   % upper bound

a = 1; b = 1;   % parameters of lambda prior
param(4).name = 'theta_loss|shift';
param(4).logpdf = @(x) sum(log(betapdf(x,a,b)));
param(4).lb = 0;
param(4).ub = 1;

% run optimization
nstarts = 5;    % number of random parameter initializations


% disp('Fitting WSLSlearn');
% results = mfit_optimize(@WSLSlearnlik,param(1:end),data,nstarts);
% save('WSLSlearn.mat','results');

% population
disp('Fitting WSLSlearn');
results = popfit_optimize(@popWSLSlearn,param(1:end),data,nstarts);
save('popWSLSlearn.mat','results');