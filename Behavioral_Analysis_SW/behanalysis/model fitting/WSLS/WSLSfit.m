% Fit basic WSLS
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
a = 1; b = 1;  % parameters of the gamma prior
param(1).name = 'p(win|stay)';
param(1).logpdf = @(x) sum(log(betapdf(x,a,b)));
param(1).lb = 0;    % lower bound
param(1).ub = 1;   % upper bound

a = 1; b = 1;   % parameters of lambda prior
param(2).name = 'p(lose|shift)';
param(2).logpdf = @(x) sum(log(betapdf(x,a,b)));
param(2).lb = 0;
param(2).ub = 1;

% run optimization
nstarts = 5;    % number of random parameter initializations

%individual
% disp('Fitting bonus');
% results = mfit_optimize(@WSLSlik,param(1:end),data,nstarts);
% save('WSLS.mat','results');

% population
disp('Fitting WSLS');
results = popfit_optimize(@popWSLS,param(1:end),data,nstarts);
save('popWSLS.mat','results');