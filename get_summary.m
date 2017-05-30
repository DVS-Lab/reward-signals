clear;
maindir = pwd;

sublist = [1002 1003 1005 1006:1028];
data = zeros(length(sublist),1);
for s = 1:length(sublist)
    subj = sublist(s);
    %make_3col_files_m06(subj);
    load(fullfile(maindir,'summarydata',sprintf('summary%d.mat',subj)));
    data(s,1) = length(find(summary(:,10)==0));

end

