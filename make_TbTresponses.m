maindir = pwd;

sublist = [1002 1003 1005:1024];
count = 0;
for s = 1:length(sublist)
    if sublist(s) == 1011 || sublist(s) == 1014 || sublist(s) == 1020
        continue
    end
    subj = num2str(sublist(s));
    for r = 1:4
    clear netbetas
        data = load(fullfile(maindir,'DR_output_n19',sprintf('dr_stage1_subject%05d.txt',count)));
        count = count + 1;
        design = load(fullfile(maindir,'fsl',subj,['trialdata_run' num2str(r) '.mtx']));
        design = design(:,9:end);
        nodata = ~any(design);
        mytrials = [nodata; 1:40]';
        mytrials(mytrials(:,1)==1,:) = [];
        design = design(:,~nodata);
        for n = 1:10
            stats = regstats(zscore(data(:,n)),design,'linear','all');
            b = stats.beta(2:end);
            if n == 1
                netbetas = [mytrials(:,2) b];
            else
                netbetas = [netbetas b];
            end
        end
        fname = ['NetAffect_sub' subj '_run' num2str(r) '.mat'];
        save(fname,'netbetas')
    end
end
