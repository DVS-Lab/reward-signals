N = 0;

for s = 1:length(data)
    N = N + data(s).N;
end


K = 33; 
results.bic = K*log(N) - 2*results.loglik;

betas = results.x(6:end);
center = mean(betas)
spread = std(betas)