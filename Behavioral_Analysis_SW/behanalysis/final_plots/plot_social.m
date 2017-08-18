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

info_pred =  partner; 
info_out = pattern;
[info_b,~,info_stats] = glmfit(info_pred,[pattern ones(length(pattern),1)],'binomial','link','logit','constant','off');

pred = [0 1];
p = (1+exp(-info_b*pred));
p = 100./p;
plotdata = [p(1);p(2)];
figure
labels = {'Computer' , 'Confederate'}; 
bar(plotdata);
hold on
set(gca, 'XTick', 1:2, 'XTickLabel', labels);
xlabel('Partner');
ylabel('Estimated Choice Persistence(%)');
ylim([0 80]);
%%
pattern(pattern==1) = -1;
pattern(pattern==0) = 1;
pattern(pattern==-1) = 0;

social = partner;
social_indx = find(social>0);
nonsocial_indx = find(social<1);
socials = pattern(social_indx);
nonsocials = pattern(nonsocial_indx);

soc_choice = sum(socials)/length(socials);
nonsoc_choice = sum(nonsocials)/length(nonsocials);
plotsocial = [nonsoc_choice;soc_choice;];
errorB = [std(socials);std(nonsocials)]./sqrt(numsub);

figure
labels = {'Computer' , 'Confederate'}; 
bar(plotsocial);
hold on
errorbar(1,plotsocial(1),errorB(1));
errorbar(2,plotsocial(2),errorB(2));
set(gca, 'XTick', 1:2, 'XTickLabel', labels);
xlabel('Partner');
ylabel('Exploration');
ylim([0 0.5]);

% handles = barweb(plotsocial,errorB);
% hold on
% xlabel('Partner');
% ylabel('Exploration');
% set(gca,'XTickLabel',{'Computer','Confederate'})
% ylim([0 1]);
% legend('Win','Loss')
% hold off


