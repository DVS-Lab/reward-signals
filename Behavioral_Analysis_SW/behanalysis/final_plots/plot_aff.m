% making aff plots
clear all;
close all;
 
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

rating_org = [is_catch,rating];
ratindx = find(is_catch~=0);
rating_matrix = rating_org(ratindx,:);
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
    
% test aff model:
aff_pred = [ratinginf,ratingaff,sign]; %,ratinginf.*ratingaff,ratinginf.*ratingaff,ratinginf.*sign,ratingaff.*sign,(ratinginf.*sign).*ratingaff];

aff_win = find(ratingaff>0);
aff_loss = find(ratingaff<1);
rat_win = ratings(aff_win);
rat_loss = ratings(aff_loss);

std_win = std(rat_win);
std_loss = std(rat_loss);
mean_win = mean(rat_win);
mean_loss = mean(rat_loss);
y = [mean_win,mean_loss];
e = [std_win,std_loss];

%% sign:
% aff_win: 
    sign_win = sign(aff_win);
    pos_win = find(sign_win>0);
    neg_win = find(sign_win<1);
    
    sign_loss = sign(aff_loss);
    pos_loss = find(sign_loss>0);
    neg_loss = find(sign_loss<1);
    
    rating_pwin = ratings(pos_win);
    rating_nwin = ratings(neg_win);
    rating_ploss = ratings(pos_loss);
    rating_nloss = ratings(neg_loss);
    
    meanplot = [mean(rating_pwin),mean(rating_nwin);mean(rating_ploss), mean(rating_nloss)];
    errorB = [std(rating_pwin),std(rating_nwin);std(rating_ploss), std(rating_nloss)]./sqrt(numsub);

% N = [N,length(pe)+1];
% for i = 1:length(N)-1
%     trials = [N(i),N(i+1)-1];
%     subdata= rating_org(trials(1):trials(2),2);
%     subcatch = rating_org(trials(1):trials(2),1);
%     subword = word(trials(1):trials(2));
%     subword = subword(find(subcatch~=0));
%     subrat = subdata(find(subcatch~=0));
%     reverse = 1 + (-2*ismember(subword,neg));
%     subrat = subrat.*reverse;
%     average(i) = mean(subrat);
% end
%%
figure
handles = barweb(meanplot,errorB);

xlabel('Affective Outcome');
ylabel('Self-Reported Feeling');
set(gca,'XTickLabel',{'Win','Loss'})
ylim([-1 3]);
legend('+RPE','-RPE')
hold off
   