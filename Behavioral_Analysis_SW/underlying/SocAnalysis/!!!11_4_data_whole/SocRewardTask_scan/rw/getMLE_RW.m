
maindir = pwd;

betas = 0.1:0.05:50;
alphas = 0:0.05:1;


blocks = 1:4;
for r = 1:length(blocks)
    
    load(fullfile(maindir,'3001',sprintf('3001_Computerfeedback_%d.mat',r)))
    choicedata = [data.Npoints; data.deckchoice]';
    
    %% estimate learning
    out = choicedata(:,1);
    out(out==4) = 2;
    out = out-1;
    dec = choicedata(:,2);
    
    
    loglike_surface = zeros(length(alphas),length(betas));
    for a = 1:length(alphas)
        for b = 1:length(betas)
            alpha = alphas(a);
            beta = betas(b);
            [loglike_e, alpha_e, beta_e, pe_e] = runRW(dec, out, alpha, beta);
            loglike_surface(a,b) = loglike_e;
        end
    end
    figure,imagesc(loglike_surface);
    [alpha_idx,beta_idx,v] = find(loglike_surface == max(max(loglike_surface)));
    a_mle = alphas(alpha_idx(1));
    b_mle = betas(beta_idx(1));
    fprintf('block %d: alpha = %3.3f, beta = %3.3f, points = %d\n', r, a_mle, b_mle, sum(out));
    
end

