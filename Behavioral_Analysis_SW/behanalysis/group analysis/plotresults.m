%% make information plots
clear all;
close all;

pattern = [];
soc_win = [];
is_catch = [];
rating = [];
word = [];
info = [];
pe= [];

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
end


% test info model:
info_pred =  [info,soc_win,info.*soc_win]; %[pe,soc_win,pe.*soc_win];
info_out = pattern;
[info_b,~,info_stats] = glmfit(info_pred,[pattern ones(length(pattern),1)],'binomial','link','logit','constant','off');

%choice persistent:
INFO_WIN = [1,1];
INFO_LOSS = [1,0];
NOIN_WIN = [0,1];
NOIN_LOSS = [0,0];
output = [INFO_WIN;INFO_LOSS;NOIN_WIN;NOIN_LOSS];
inter = output(:,1).*output(:,2);
output = [output,inter];

output = output*info_b;
p = (1+exp(-output));
p = 100./p;
plotdata = [p(1) p(2);p(3), p(4)];

figure
labels = {'info' , 'no info'}; 
bar(plotdata,'histc');
hold on;
set(gca, 'XTick', 1.25:2.25, 'XTickLabel', labels);
legend('win','loss');
xlabel('information');
ylabel('estimated choice persistence(%)');
ylim([0 80]);
xlim([0.5 3]);
%%
% test info model:
pattern(pattern==1) = -1;
pattern(pattern==0) = 1;
pattern(pattern==-1) = 0;
info_pred =  [info,soc_win,pattern]; %info.*soc_win %[pe,soc_win,pe.*soc_win];



% info trials
infoindx = find(info>0);
trials_info = info_pred(infoindx,:);
  % soc_win trials
  info_win = trials_info(trials_info(:,2)>0,:);
  info_loss = trials_info(trials_info(:,2)<1,:);
  
  numwin = size(info_win,1);
  numloss = size(info_loss,1);
  
  infoW = sum(info_win(:,3))/numwin;
  infoL = sum(info_loss(:,3))/numloss;
  
  INFO = sum(trials_info(:,3))/size(trials_info,1);
  
 noindx = find(info<1);
 trials_no = info_pred(noindx,:);
       % soc_win trials
  no_win = trials_no(trials_no(:,2)>0,:);
  no_loss = trials_no(trials_no(:,2)<1,:);
  
  Nnumwin = size(no_win,1);
  Nnumloss = size(no_loss,1);
  
  NinfoW = sum(no_win(:,3))/Nnumwin;
  NinfoL = sum(no_loss(:,3))/Nnumloss;
  
  NOINFO = sum(trials_no(:,3))/size(trials_no,1);
  
  [h,p,ci,stats] = ttest2(trials_info(:,3),trials_no(:,3));
  plotdata = [infoW,infoL;NinfoW,NinfoL];
  figure
   labels = {'info' , 'no info'}; 
   bar(plotdata,'histc');
   hold on;
    set(gca, 'XTick', 1.25:2.25, 'XTickLabel', labels);
   legend('win','loss');
   xlabel('information');
   ylabel('exploration');
   ylim([0 0.5]);
   xlim([0.5 3])
 %% making aff plots
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

data.t1 = N;
data.choice = pattern;
data.info 
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
    
    % test info model:
aff_pred = [ratinginf,ratingaff,sign];%,ratinginf.*ratingaff,ratinginf.*ratingaff,ratinginf.*sign,ratingaff.*sign,(ratinginf.*sign).*ratingaff];

%ratings = ratings/7.5;
aff_win = find(ratingaff>0);
aff_loss = find(ratingaff<1);

rat_win = ratings(aff_win);
rat_loss = ratings(aff_loss);
[h,p,ci,stats] = ttest2(rat_win,rat_loss);

std_win = std(rat_win);
std_loss = std(rat_loss);
mean_win = mean(rat_win);
mean_loss = mean(rat_loss);
 y = [mean_win,mean_loss];
 e = [std_win,std_loss];
figure
labels = {'win' , 'loss'}; x = 1:2;
bar(y);
hold on
errorbar(x(1),y(1),e(1));
errorbar(x(2),y(2),e(2));
   hold on;
    set(gca, 'XTick', 1:2, 'XTickLabel', labels);
    xlabel('affective');
   ylabel('self-reported feeling');
   ylim([-6 6]);
    hold off
   