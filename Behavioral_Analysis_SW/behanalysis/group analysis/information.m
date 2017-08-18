clear all;

pattern = [];
soc_win = [];
is_catch = [];
rating = [];
word = [];
info = [];
pe= [];
partner = [];


subjects = [1001:1004,1006:1028];
numsub = length(subjects);
% Recover data
for i = 1:numsub
    N(i) = length(pattern) + 1;
    clear data
    filename = ['gen', num2str(subjects(i)), '.mat'];
    data = load(filename);
    data = data.summary;
    pattern = [pattern; data.choice(2:end)];
    info = [info; data.info(1:end-1)];
    soc_win = [soc_win; data.aff(1:end-1)];
    is_catch = [is_catch; data.is_catch];
    rating = [rating; data.rating];
    word = [word; data.word];
    pe = [pe;data.pe(1:end-1)];
    partner = [partner;data.partner(1:end-1)];
end

data_matrix = [pattern,info,soc_win];
rating_matrix = [is_catch,rating,{word}];


% test info model:
info_pred =  [info,soc_win,info.*soc_win]; %[pe,soc_win,pe.*soc_win];
info_out = pattern;
[info_b,~,info_stats] = glmfit(info_pred,[pattern ones(length(pattern),1)],'binomial','link','logit','constant','off');
disp(info_b);
disp(info_stats.p);
% mdl = fitglm(info_pred,pattern,'CategoricalVars',2,'Intercept',false,'Distribution','binomial','Link','logit');

% pe>sigma:
info_large = find(info>0);
large_pred = info_pred(info_large,:);
%large_pred = large_pred(:,1:2);
pattern_l = pattern(info_large);
[largeinfo_b,~,stats_large] = glmfit(large_pred,[pattern_l ones(length(pattern_l),1)],'binomial','link','logit','constant','off');
disp(largeinfo_b);
disp(stats_large.p);

% pe<sigma
info_small = find(info<1);
small_pred = info_pred(info_small,:);
small_pred(:,1) = 1;
pattern_s = pattern(info_small);
[smallinfo_b,~,stats_small] = glmfit(small_pred,[pattern_s ones(length(pattern_s),1)],'binomial','link','logit','constant','off');
disp(smallinfo_b);
disp(stats_small.p);

