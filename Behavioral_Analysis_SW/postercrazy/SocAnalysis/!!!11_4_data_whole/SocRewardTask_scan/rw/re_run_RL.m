
maindir = pwd;
outdir = fullfile(maindir,'fine_grids_1000_beta_redos');
mkdir(outdir)

betas = 1:500000:1000000000;
alphas = 0.00001:0.01:1;

inf_aff  = [214 220];
fid = fopen('behavioral_Qlearning_1000by1000_beta200000_InfAff.csv','w');
fprintf(fid,'subnum,aff_alpha,aff_beta,inf_alpha,inf_beta\n');
data = zeros(2,5);
for s = 1:length(inf_aff)
    
    data(s,1) = inf_aff(s);
    
    fprintf('working on both for %d...\n',inf_aff(s));
    
    [~, ~, ~, ~, ~, ~, ~, ~, all_aff, all_inf] = get_pswitch_graded(inf_aff(s));
    
    %% estimate affective value
    dec = all_aff(:,1);
    out = all_aff(:,2);
    
    %betas = [1 5 10 20 40 80];
    
    loglike_surface = zeros(length(alphas),length(betas));
    for a = 1:length(alphas)
        for b = 1:length(betas)
            alpha = alphas(a);
            beta = betas(b);
            [loglike_e, alpha_e, beta_e, pe_e]  = estimate_RLmodel(dec, out, alpha, beta);
            loglike_surface(a,b) = loglike_e;
        end
    end
    %figure,imagesc(loglike_surface);
    [alpha_idx,beta_idx,v] = find(loglike_surface == max(max(loglike_surface)));
    data(s,2) = alphas(alpha_idx(1));
    data(s,3) = betas(beta_idx(1));
    aff_loglike_surface = loglike_surface;
    
    %% estimate informative value
    dec = all_inf(:,1);
    out = all_inf(:,2);
    loglike_surface = zeros(length(alphas),length(betas));
    for a = 1:length(alphas)
        for b = 1:length(betas)
            alpha = alphas(a);
            beta = betas(b);
            [loglike_e, alpha_e, beta_e, pe_e] = estimate_RLmodel(dec, out, alpha, beta);
            loglike_surface(a,b) = loglike_e;
        end
    end
    %figure,imagesc(loglike_surface);
    [alpha_idx,beta_idx,~] = find(loglike_surface == max(max(loglike_surface)));
    data(s,4) = alphas(alpha_idx(1));
    data(s,5) = betas(beta_idx(1));
    inf_loglike_surface = loglike_surface;
    fname = sprintf('gridsurface_%d.mat',inf_aff(s));
    save(fullfile(outdir,fname),'inf_loglike_surface','aff_loglike_surface','all_aff','all_inf');
    
    fprintf(fid,'%d,%.6f,%.6f,%.6f,%.6f\n',data(s,:));
    
end
fclose(fid);


inf_only = [205 208 209 210 211 219 223 227 229 233 234];
fid = fopen('behavioral_Qlearning_1000by1000_beta200000_Infonly.csv','w');
fprintf(fid,'subnum,inf_alpha,inf_beta\n');
data = zeros(length(inf_only),3);
for s = 1:length(inf_only)
    
    data(s,1) = inf_only(s);
    subnum = data(s,1);
    
    fprintf('working on informative for %d...\n',subnum);
    
    [~, ~, ~, ~, ~, ~, ~, ~, all_aff, all_inf] = get_pswitch_graded(subnum);
    
    
    
    %% estimate informative value
    dec = all_inf(:,1);
    out = all_inf(:,2);
    loglike_surface = zeros(length(alphas),length(betas));
    for a = 1:length(alphas)
        for b = 1:length(betas)
            alpha = alphas(a);
            beta = betas(b);
            [loglike_e, alpha_e, beta_e, pe_e] = estimate_RLmodel(dec, out, alpha, beta);
            loglike_surface(a,b) = loglike_e;
        end
    end
    %figure,imagesc(loglike_surface);
    [alpha_idx,beta_idx,~] = find(loglike_surface == max(max(loglike_surface)));
    data(s,2) = alphas(alpha_idx(1));
    data(s,3) = betas(beta_idx(1));
    inf_loglike_surface = loglike_surface;
    fname = sprintf('gridsurface_%d.mat',subnum);
    save(fullfile(outdir,fname),'inf_loglike_surface','all_inf');
    
    fprintf(fid,'%d,%.6f,%.6f\n',data(s,:));
    
end
fclose(fid);


fid = fopen('behavioral_Qlearning_1000by1000_beta200000_Affonly.csv','w');
fprintf(fid,'subnum,aff_alpha,aff_beta\n');
data = zeros(1,3);

data(1,1) = 225;
subnum = data(1,1);

fprintf('working on affective for %d...\n',subnum);
[~, ~, ~, ~, ~, ~, ~, ~, all_aff, all_inf] = get_pswitch_graded(subnum);


%% estimate affective value
dec = all_aff(:,1);
out = all_aff(:,2);
loglike_surface = zeros(length(alphas),length(betas));
for a = 1:length(alphas)
    for b = 1:length(betas)
        alpha = alphas(a);
        beta = betas(b);
        [loglike_e, alpha_e, beta_e, pe_e] = estimate_RLmodel(dec, out, alpha, beta);
        loglike_surface(a,b) = loglike_e;
    end
end
%figure,imagesc(loglike_surface);
[alpha_idx,beta_idx,~] = find(loglike_surface == max(max(loglike_surface)));
data(1,2) = alphas(alpha_idx(1));
data(1,3) = betas(beta_idx(1));
aff_loglike_surface = loglike_surface;
fname = sprintf('gridsurface_%d.mat',subnum);
save(fullfile(outdir,fname),'aff_loglike_surface','all_aff');

fprintf(fid,'%d,%.6f,%.6f\n',data(1,:));
fclose(fid);


%
%
% %% --beta too small--
%
% inf_only = [206 215 226];
% fid = fopen('behavioral_Qlearning_1000by1000_beta1_Infonly.csv','w');
% fprintf(fid,'subnum,inf_alpha,inf_beta\n');
% data = zeros(length(inf_only),3);
% for s = 1:length(inf_only)
%
%     data(s,1) = inf_only(s);
%     subnum = data(s,1);
%
%     fprintf('working on lil informative for %d...\n',subnum);
%
%     [~, ~, ~, ~, ~, ~, ~, ~, all_aff, all_inf] = get_pswitch_graded(subnum);
%
%
%     alphas = 0.001:0.001:1;
%     betas = 0.01:0.002:1.1;
%
%     %% estimate informative value
%     dec = all_inf(:,1);
%     out = all_inf(:,2);
%     loglike_surface = zeros(length(alphas),length(betas));
%     for a = 1:length(alphas)
%         for b = 1:length(betas)
%             alpha = alphas(a);
%             beta = betas(b);
%             [loglike_e, alpha_e, beta_e, pe_e] = estimate_RLmodel(dec, out, alpha, beta);
%             loglike_surface(a,b) = loglike_e;
%         end
%     end
%     %figure,imagesc(loglike_surface);
%     [alpha_idx,beta_idx,~] = find(loglike_surface == max(max(loglike_surface)));
%     data(s,2) = alphas(alpha_idx(1));
%     data(s,3) = betas(beta_idx(1));
%     inf_loglike_surface = loglike_surface;
%     fname = sprintf('gridsurface_%d.mat',subnum);
%     save(fullfile(outdir,fname),'inf_loglike_surface','all_inf');
%
%     fprintf(fid,'%d,%.6f,%.6f\n',data(s,:));
%
% end
% fclose(fid);
%
%
%
%
%
% aff_only = [205 213 218 219 221 223 227 233 235];
% fid = fopen('behavioral_Qlearning_1000by1000_beta1_Affonly.csv','w');
% fprintf(fid,'subnum,aff_alpha,aff_beta\n');
% data = zeros(length(aff_only),3);
% for s = 1:length(aff_only)
%
%     data(s,1) = aff_only(s);
%     subnum = data(s,1);
%
%     fprintf('working on lil affective for %d...\n',subnum);
%
%     [~, ~, ~, ~, ~, ~, ~, ~, all_aff, all_inf] = get_pswitch_graded(subnum);
%
%
%     alphas = 0.001:0.001:1;
%     betas = 0.01:0.002:1.1;
%
%     %% estimate affective value
%     dec = all_aff(:,1);
%     out = all_aff(:,2);
%     loglike_surface = zeros(length(alphas),length(betas));
%     for a = 1:length(alphas)
%         for b = 1:length(betas)
%             alpha = alphas(a);
%             beta = betas(b);
%             [loglike_e, alpha_e, beta_e, pe_e] = estimate_RLmodel(dec, out, alpha, beta);
%             loglike_surface(a,b) = loglike_e;
%         end
%     end
%     %figure,imagesc(loglike_surface);
%     [alpha_idx,beta_idx,~] = find(loglike_surface == max(max(loglike_surface)));
%     data(s,2) = alphas(alpha_idx(1));
%     data(s,3) = betas(beta_idx(1));
%     inf_loglike_surface = loglike_surface;
%     fname = sprintf('gridsurface_%d.mat',subnum);
%     save(fullfile(outdir,fname),'aff_loglike_surface','all_aff');
%
%     fprintf(fid,'%d,%.6f,%.6f\n',data(s,:));
%
% end
% fclose(fid);
