% make information plots
%% estimated choice persistence from logistic regression model:
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


% test info choice model:
info_pred =  [info,soc_win,info.*soc_win]; 
[info_b,~,info_stats] = glmfit(info_pred,[pattern ones(length(pattern),1)],'binomial','link','logit','constant','off');

% estimated choice persistence,recoverd from logit model:
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

%% ratio of exploratory choices made after receiving info
% exploration: pattern == 1;
pattern(pattern==1) = -1;
pattern(pattern==0) = 1;
pattern(pattern==-1) = 0;
info_pred =  [info,soc_win,pattern]; %info.*soc_win %[pe,soc_win,pe.*soc_win];

% info trials
infoindx = find(info>0);
trials_info = info_pred(infoindx,:);
  % win vs. loss
  info_win = trials_info(trials_info(:,2)>0,:);
  info_loss = trials_info(trials_info(:,2)<1,:);
  numwin = size(info_win,1);
  numloss = size(info_loss,1);
  infoW = mean(info_win(:,3));
  infoL = mean(info_loss(:,3));
  INFO = sum(trials_info(:,3))/size(trials_info,1);
  
 % no_info trials: 
 noindx = find(info<1);
 trials_no = info_pred(noindx,:);
  % win vs. loss:
  no_win = trials_no(trials_no(:,2)>0,:);
  no_loss = trials_no(trials_no(:,2)<1,:);
  Nnumwin = size(no_win,1);
  Nnumloss = size(no_loss,1);
  NinfoW = mean(no_win(:,3));
  NinfoL = mean(no_loss(:,3));
  NOINFO = sum(trials_no(:,3))/size(trials_no,1);
  
  info_soc = [infoW,infoL;NinfoW,NinfoL];
  errorB = [std(info_win(:,3)),std(info_loss(:,3));std(no_win(:,3)),std(no_loss(:,3))]./sqrt(numsub);
  
figure
handles = barweb(info_soc,errorB);
sigstar({[1.75 2.25],[0.75,1.25]},[0.02 .006]);
sigstar({[1 2]},[0.000001]);


xlabel('Information');
ylabel('Exploration');
set(gca,'XTickLabel',{'Info','No Info'})
ylim([0.1 0.6]);
legend('Win','Loss')
hold off