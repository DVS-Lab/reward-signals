function analyze_behavior()

maindir = pwd;
addpath(fullfile(maindir,'rw'));

betas = linspace(0.001,15,100);
alphas = linspace(0.0001,0.9999,100);

pos = {'interested','excited','attentive','strong' ...
    'enthusiastic','proud','alert','active','inspired','determined'};

neg = {'distressed','upset','guilty','scared','hostile','jittery', ...
    'irritable','ashamed','nervous','afraid'};


loglike_surface = zeros(length(alphas),length(betas));
for a = 1:length(alphas)
    for b = 1:length(betas)
        blocks = 1:4;
        subjects = 501:508;
        loglike_i = 0;
        for subject = subjects
            for r = 1:length(blocks)
                datadir = fullfile(maindir,'data',num2str(subject));
                load(fullfile(datadir,sprintf('%s_Computer_feedback_%d.mat',num2str(subject),r)))
                choicedata = [data.Npoints; data.deckchoice]';
                choicedata(~choicedata(:,2),:) = [];
                choicedata(choicedata(:,2)>2,:) = [];
                
                % estimate learning
                out = choicedata(:,1);
                dec = choicedata(:,2);
                
                alpha = alphas(a);
                beta = betas(b);
                
                [loglike_e, ~, ~, ~] = runRW_fe(dec, out, alpha, beta, loglike_i);
                loglike_surface(a,b) = loglike_e;
            end
        end
    end
    disp(a)
end
figure,imagesc(loglike_surface);
[alpha_idx,beta_idx,~] = find(loglike_surface == max(max(loglike_surface)));
a_mle = alphas(alpha_idx(1));
b_mle = betas(beta_idx(1));
fprintf('FE: alpha = %3.3f, beta = %3.3f', a_mle, b_mle);
keyboard

