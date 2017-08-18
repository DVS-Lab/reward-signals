% Fit Kalman Filter RW model
fitindi = false;
softmax = false;

% ---------- get data ----------%
if fitindi
   subjects = input('subjectnum');
   getdata;
else
   getpopdata;
end

% ------------ fit models --------------------%

% % create parameter structure
% g = [1 10];  % parameters of the gamma prior
% param(1).name = 'inverse temperature';
% param(1).logpdf = @(x) sum(log(gampdf(x,g(1),g(2))));  % log density function for prior
% param(1).lb = 0;    % lower bound
% param(1).ub = 1;   % upper bound

a = 0; b = 1;   % parameters of lambda prior
param(1).name = 'lambda';
param(1).logpdf = @(x) sum(log(unifpdf(x,a,b)));
param(1).lb = 0;
param(1).ub = 1;

a = 0; b = 100;   % parameters of theta prior
param(2).name = 'theta';
param(2).logpdf = @(x) sum(log(unifpdf(x,a,b)));
param(2).lb = 0;
param(2).ub = 100;

a = 0; b = 100;   % parameters of sigmad prior
param(3).name = 'sigmad';
param(3).logpdf = @(x) sum(log(unifpdf(x,a,b)));
param(3).lb = 0;
param(3).ub = 100;

a = 1; b = 100;   % parameters of mu0 prior
param(4).name = 'mu0';
param(4).logpdf = @(x) sum(log(unifpdf(x,a,b)));
param(4).lb = 1;
param(4).ub = 100;

a = 0; b = 10;   % parameters of sigma0 prior
param(5).name = 'sigma0';
param(5).logpdf = @(x) sum(log(unifpdf(x,a,b)));
param(5).lb = 0;
param(5).ub = 10;

for numbeta = 1:length(data)
    index = 5+numbeta;
    param(index).name = ['beta no.', num2str(numbeta)];
    g = [1 10];  % parameters of the gamma prior
    param(index).name = 'inverse temperature';
    param(index).logpdf = @(x) sum(log(gampdf(x,g(1),g(2))));  % log density function for prior
    param(index).lb = 0;    % lower bound
    param(index).ub = 4;   % upper bound
end

% phi:
% for numphi = 1:length(data)
%     index = 5+length(data)+numphi;
%     param(index).name = ['phi no.', num2str(numphi)];
%     g = [1 10];  % parameters of the gamma prior
%     param(index).name = 'exploration bonus';
%     param(index).logpdf = @(x) sum(log(gampdf(x,g(1),g(2))));  % log density function for prior
%     param(index).lb = 0;    % lower bound
%     param(index).ub = 4;   % upper bound
% end

%phi:
index = 5 + length(data) + 1;
param(index).name = 'phi';
    g = [0 4];  % parameters of the gamma prior
     % parameters of sigmad prior
    param(index).name = 'bonus';
    param(index).logpdf = @(x) sum(log(unifpdf(x,g(1),g(2))));  % log density function for prior
    param(index).lb = 0;    % lower bound
    param(index).ub = 1; 


% run optimization
nstarts = 5;    % number of random parameter initializations


if softmax
   disp('... Fitting softmax');
   results = popfit_optimize(@popKRWlik,param(1:5+length(data)),data,nstarts); %results(1) = fit_optimize(@KRWlik,param(1:6),data,nstarts);
else
      disp('Fitting bonus');
      results = popfit_optimize(@bonuspopKRWlik,param(1:end),data,nstarts);
end
