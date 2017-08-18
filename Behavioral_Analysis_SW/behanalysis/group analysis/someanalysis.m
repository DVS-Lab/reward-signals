clear all;
close all;

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

social = partner;
social_indx = find(social>0);
nonsocial_indx = find(social<1);
socials = pattern(social_indx);
nonsocials = pattern(nonsocial_indx);

soc_choice = sum(socials)/length(socials);
nonsoc_choice = sum(nonsocials)/length(nonsocials);

figure
labels = {'computer' , 'confederate'}; 
bar([nonsoc_choice;soc_choice;]);
hold on
    set(gca, 'XTick', 1:2, 'XTickLabel', labels);
    xlabel('partner');
   ylabel('exploration');
   ylim([0 1]);
    hold off

info_pred =  partner; %[pe,soc_win,pe.*soc_win];
%info_pred =  [info,soc_win,partner,info.*soc_win,info.*partner,soc_win.*partner,(info.*soc_win).*partner];
info_out = pattern;
[info_b,~,info_stats] = glmfit(info_pred,[pattern ones(length(pattern),1)],'binomial','link','logit','constant','off');
% mdl = fitglm(info_out,info_pred,'Distribution','binomial','Link','logit','CategoricalVars',1,'Intercept',false);
pred = [0 1];
p = (1+exp(-info_b*pred));
p = 100./p;
plotdata = [p(1);p(2)];
  figure
   labels = {'computer' , 'confederate'}; 
bar(plotdata);
hold on
    set(gca, 'XTick', 1:2, 'XTickLabel', labels);
    xlabel('partner');
   ylabel('choice persistence(%)');
   ylim([0 80]);



% test info model:
info_pred =  partner; %[pe,soc_win,pe.*soc_win];
%info_pred =  [info,soc_win,partner,info.*soc_win,info.*partner,soc_win.*partner,(info.*soc_win).*partner];
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





%%
clear all;

pattern = [];
soc_win = [];
is_catch = [];
rating = [];
word = [];
info = [];
partner = [];
pe = [];

subjects = [1001:1004,1006:1028];
numsub = length(subjects);
% Recover data
for i = 1:numsub
    N(i) = length(pattern) + 1;
    clear data
    filename = ['gen', num2str(subjects(i)), '.mat'];
    data = load(filename);
    data = data.summary;
    pattern = [pattern; data.choice];
    info = [info; data.info];
    soc_win = [soc_win; data.aff];
    is_catch = [is_catch; data.is_catch];
    rating = [rating; data.rating];
    word = [word; data.word];
    partner = [partner;data.partner];
    pe = [pe;data.pe];
end

data_matrix = [pattern,info,soc_win];
rating_matrix = [is_catch,rating];

ratindx = find(is_catch~=0);
rating_matrix = rating_matrix(ratindx,:);
ratword = word(ratindx,:);

    pos = {'interested','excited','attentive','strong' ...
        'enthusiastic','proud','alert','active','inspired','determined'};
    
    neg = {'distressed','upset','guilty','scared','hostile','jittery', ...
        'irritable','ashamed','nervous','afraid'};
    
    reverse = 1 + (-2*ismember(ratword,neg));
    
    ratings = rating_matrix(:,2).*reverse;
    
    for s = 1: length(ratings)
        trialnum = ratindx(s);
        value = ismember(trialnum,N);
        catch_t = is_catch(trialnum);
        social(s) = partner(trialnum);
        if value
            switch catch_t
            case 1 %information at this trial, soc_win from last trial
                ratinginf(s) = info(trialnum);
                ratingaff(s) = 0;
                PE(s) = pe(trialnum);
                sign(s) = any(PE>0);
                
            case 2 % aff at this trial, info from last trial
                ratinginf(s) = 0;
                ratingaff(s) = soc_win(trialnum);
                PE(s) = 0;
                sign(s) = 0;
            end
        else
            switch catch_t
            case 1 %information at this trial, soc_win from last trial
                ratinginf(s) = info(trialnum);
                PE(s) = pe(trialnum);
                sign(s) = any(PE>0);
                ratingaff(s) = soc_win(trialnum-1);
            case 2 % aff at this trial, info from last trial
                ratinginf(s) = info(trialnum-1);
                PE(s) = pe(trialnum-1);
                sign(s) = any(PE>0);
                ratingaff(s) = soc_win(trialnum);
            end
        end
    end
    
    ratingaff = ratingaff';
    ratinginf = ratinginf';
    sign = sign';
    PE = PE';
    social = social';
    
    % test info model:
%aff_pred = [ratinginf,ratingaff,sign];%,ratinginf.*ratingaff,ratinginf.*ratingaff,ratinginf.*sign,ratingaff.*sign,(ratinginf.*sign).*ratingaff];
aff_pred = [ratinginf,ratingaff,social,ratinginf.*ratingaff,ratinginf.*social,ratingaff.*social,(ratinginf.*social).*ratingaff];
mdl = fitglm(aff_pred,ratings,'CategoricalVars',1:7,'Intercept',false);

indx_win = find(ratingaff>0);
win_pred = aff_pred(indx_win,:);
mdl = fitglm(win_pred,ratings(indx_win),'CategoricalVars',1:3,'Intercept',false);

indx_win = find(ratingaff<1);
win_pred = aff_pred(indx_win,:);
mdl = fitglm(win_pred,ratings(indx_win),'CategoricalVars',1:3,'Intercept',false);




social_indx = find(social>0);
nonsocial_indx = find(social<1);
socials = ratings(social_indx);
nonsocials = ratings(nonsocial_indx);

[h,p,ci,stats] = ttest2(socials,nonsocials);











