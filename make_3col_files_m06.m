function make_3col_files_m06(subject)

try
    
    maindir = pwd;
    datadir = fullfile(maindir,'data',num2str(subject));
    outputdir = fullfile(maindir,'evfiles_m06',num2str(subject));
    if ~exist(outputdir,'dir')
        mkdir(outputdir);
    end
    summarydatadir = fullfile(maindir,'summarydata',sprintf('summary%d.mat',subject));
    
    blocks = 1:4;
    load(summarydatadir)
    
    %{

Column 1 is choice type: stay(1) vs. switch(0);
Column 2 is raw PE
Column 3 is information: info(1) vs. non-info(0); A trials containing information is defined as: |PE| > sigma(chosen, trial t).
Column 4 is mu1
Column 5 is mu2
Column 6 is mu(chosen)
Column 7 is sigma1
Column 8 is sigma2
Column 9 is sigma(chosen)
Column 10 is raw payoff for chosen option

    %}
    
    %start on correct trial
    if subject == 1005
        tcount = 16;
    elseif subject == 1002 || subject == 1003 || subject == 1006
        tcount = 0;
    else
        tcount = 20;
    end
    
    for r = 1:length(blocks)
        load(fullfile(datadir,sprintf('%s_feedback_%d.mat',num2str(subject),r)))
        
        ntrials = length(data);
        
        keyboard
        %make empty mats
        isstay = zeros(ntrials,3);
        isswitch = zeros(ntrials,3);
        chosenval = zeros(ntrials,3);
        rpe = zeros(ntrials,3);
        inf_yes = zeros(ntrials,3);
        inf_no = zeros(ntrials,3);
        aff_gain = zeros(ntrials,3);
        aff_loss = zeros(ntrials,3);
        partnerchoice = zeros(ntrials,3);
        lapse1 = zeros(ntrials,3);
        lapse2 = zeros(ntrials,3);
        dummy = zeros(ntrials,3);
        
        for t = 1:ntrials
            tcount = tcount + 1;
            
            if data(t).lapse1 || (~summary(tcount,10) && ~summary(tcount,2)) %didn't respond
                lapse1(t,1) = data(t).choice_onset;
                lapse1(t,2) = 3;
                lapse1(t,3) = 1;
            else
                if data(t).deckchoice < 10 %trial numbers above this were catches
                    if summary(tcount,1) %stay trial
                        isstay(t,1) = data(t).choice_onset;
                        isstay(t,2) = data(t).RT1 + .5;
                        isstay(t,3) = 1;
                    else
                        isswitch(t,1) = data(t).choice_onset;
                        isswitch(t,2) = data(t).RT1 + .5;
                        isswitch(t,3) = 1;
                    end
                    chosenval(t,1) = data(t).choice_onset;
                    chosenval(t,2) = data(t).RT1 + .5;
                    chosenval(t,3) = summary(tcount,6); %chosen value
                    
                    if subject < 1007 && t < 8 && r == 1
                        dummy(t,1) = data(t).info_onset;
                        dummy(t,2) = 1.75;
                        dummy(t,3) = 1;
                    else
                        
                        if summary(tcount,3) %has information
                            inf_yes(t,1) = data(t).info_onset;
                            inf_yes(t,2) = 1.75;
                            inf_yes(t,3) = 1;
                        else
                            inf_no(t,1) = data(t).info_onset;
                            inf_no(t,2) = 1.75;
                            inf_no(t,3) = 1;
                        end
                        
                        rpe(t,1) = data(t).info_onset;
                        rpe(t,2) = 1.75;
                        rpe(t,3) = summary(tcount,2);
                        
                    end
                end
                
                if data(t).lapse2
                    lapse2(t,1) = data(t).partner_onset;
                    lapse2(t,2) = 3;
                    lapse2(t,3) = 1;
                else
                    if ~data(t).is_catch == 1
                        partnerchoice(t,1) = data(t).partner_onset;
                        partnerchoice(t,2) = data(t).RT2 + 1.25; % 0.75 before and 0.5 after
                        partnerchoice(t,3) = 1;
                        if data(t).soc_win
                            aff_gain(t,1) = data(t).aff_onset;
                            aff_gain(t,2) = 1.75;
                            aff_gain(t,3) = 1;
                        else
                            aff_loss(t,1) = data(t).aff_onset;
                            aff_loss(t,2) = 1.75;
                            aff_loss(t,3) = 1;
                        end
                    end
                end
            end
        end
        
        dummy(~dummy(:,1),:) = [];
        lapse2(~lapse2(:,1),:) = [];
        lapse1(~lapse1(:,1),:) = [];
        
        
        isstay(~isstay(:,1),:) = [];
        isswitch(~isswitch(:,1),:) = [];
        inf_yes(~inf_yes(:,1),:) = [];
        inf_no(~inf_no(:,1),:) = [];
        aff_loss(~aff_loss(:,1),:) = [];
        aff_gain(~aff_gain(:,1),:) = [];
        partnerchoice(~partnerchoice(:,1),:) = [];
        
        %parametric regressors
        rpe(~rpe(:,1),:) = [];
        rpe(:,3) = rpe(:,3)-mean(rpe(:,3));
        chosenval(~chosenval(:,1),:) = [];
        chosenval(:,3) = chosenval(:,3)-mean(chosenval(:,3));
        
        
        cd(outputdir);
        if isempty(dummy)
            dlmwrite(sprintf('dummy%d.txt',r),[0 0 0],'delimiter','\t','precision','%.6f')
        else
            dlmwrite(sprintf('dummy%d.txt',r),dummy,'delimiter','\t','precision','%.6f')
        end
        if isempty(lapse1)
            dlmwrite(sprintf('lapseA%d.txt',r),[0 0 0],'delimiter','\t','precision','%.6f')
        else
            dlmwrite(sprintf('lapseA%d.txt',r),lapse1,'delimiter','\t','precision','%.6f')
        end
        if isempty(lapse2)
            dlmwrite(sprintf('lapseB%d.txt',r),[0 0 0],'delimiter','\t','precision','%.6f')
        else
            dlmwrite(sprintf('lapseB%d.txt',r),lapse2,'delimiter','\t','precision','%.6f')
        end
        
        
        dlmwrite(sprintf('inf_yes%d.txt',r),inf_yes,'delimiter','\t','precision','%.6f')
        dlmwrite(sprintf('inf_no%d.txt',r),inf_no,'delimiter','\t','precision','%.6f')
        dlmwrite(sprintf('stay%d.txt',r),isstay,'delimiter','\t','precision','%.6f')
        dlmwrite(sprintf('switch%d.txt',r),isswitch,'delimiter','\t','precision','%.6f')
        dlmwrite(sprintf('aff_loss%d.txt',r),aff_loss,'delimiter','\t','precision','%.6f')
        dlmwrite(sprintf('aff_gain%d.txt',r),aff_gain,'delimiter','\t','precision','%.6f')
        dlmwrite(sprintf('partnerchoice%d.txt',r),partnerchoice,'delimiter','\t','precision','%.6f')
        dlmwrite(sprintf('rpe%d.txt',r),rpe,'delimiter','\t','precision','%.6f')
        dlmwrite(sprintf('chosenval%d.txt',r),chosenval,'delimiter','\t','precision','%.6f')
        
        
        cd(maindir);
    end
    
catch ME
    disp(ME.message)
    keyboard
end
