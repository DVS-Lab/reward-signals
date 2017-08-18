filename = 'alldata.mat';
data = load(filename);
data = data.alldata;

numsub = 18;
c = [];
pe = [];
soc_win = [];
is_catch = [];
rating = [];

% Recover data
for i = 1:numsub
    c = [c;data(i).c'];
    pe = [pe;data(i).pe];
    soc_win = [soc_win;data(i).soc_win];
    is_catch = [is_catch;data(i).is_catch];
    rating = [rating;data(i).rating];
end

pe_abs = abs(pe);
pe_mean = mean(pe_abs);
pe_std = std(pe);

pe_trials = zeros(length(pe_abs),1);
pe_trials(find(pe_abs>pe_std))=1;

X = [pe_trials, soc_win, pe_trials.*soc_win];

for i = 1:length(c)
    if c(i) == 0
        c(i) = c(i-1);
    end
end

c_next = c(2:end);
c_next = [c_next; c(end)];
c_exp = abs(c_next-c);

% test prediction model:
[beta_choice,dev,stats] = glmfit(X,[c_exp ones(length(c_exp),1)],'binomial','link','logit','constant','off');

% pe>sigma:
big_pe = c_exp(find(pe_trials==1));
X1 = X(find(pe_trials==1),:);
[beta_choice,dev,stats_big] = glmfit(X1,[big_pe ones(length(big_pe),1)],'binomial','link','logit','constant','off');

small_pe = c_exp(find(pe_trials==0));
X1 = X(find(pe_trials==0),:);
[beta_choice,dev,stats_small] = glmfit(X1,[small_pe ones(length(small_pe),1)],'binomial','link','logit','constant','off');


% test affective model
% [beta_rating,dev.stats] = glmfit(X1,[rating_exp ones(length(rating_exp),1)],'binomial','link','logit','constant','off');

%%%%%
