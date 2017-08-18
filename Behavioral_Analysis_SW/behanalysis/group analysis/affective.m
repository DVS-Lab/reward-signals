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
                sign(s) = any(PE(s)>0);
                
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
                sign(s) = any(PE(s)>0);
                ratingaff(s) = soc_win(trialnum-1);
            case 2 % aff at this trial, info from last trial
                ratinginf(s) = info(trialnum-1);
                PE(s) = pe(trialnum-1);
                sign(s) = any(PE(s)>0);
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
aff_pred = [ratinginf,ratingaff,sign];%,ratinginf.*ratingaff,ratinginf.*ratingaff,ratinginf.*sign,ratingaff.*sign,(ratinginf.*sign).*ratingaff];

mdl = fitglm(aff_pred,ratings,'CategoricalVars',1:3,'Intercept',false);

indx_win = find(ratingaff>0);
win_pred = aff_pred(indx_win,:);
mdl = fitglm(win_pred,ratings(indx_win),'CategoricalVars',1:3,'Intercept',false);

indx_win = find(ratingaff<1);
win_pred = aff_pred(indx_win,:);
mdl = fitglm(win_pred,ratings(indx_win),'CategoricalVars',1:3,'Intercept',false);
%mdl = fitglm(ratingaff,ratings,'Intercept',false);

sign_indx = find(sign>0);
nonsign_indx = find(sign<1);
signs = ratings(sign_indx);
nonsigns = ratings(nonsign_indx);
[h,p,ci,stats] = ttest2(signs,nonsigns);





