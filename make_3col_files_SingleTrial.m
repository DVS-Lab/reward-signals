function make_3col_files_SingleTrial(subject)

maindir = pwd;
datadir = fullfile(maindir,'data',num2str(subject));

blocks = 1:4;
for r = 1:length(blocks)
    load(fullfile(datadir,sprintf('%s_feedback_%d.mat',num2str(subject),r)))
    outputdir = fullfile(maindir,'evfiles_SingleTrial_AffOnly',num2str(subject),['run' num2str(r)]);
    if ~exist(outputdir,'dir')
        mkdir(outputdir);
    end
    
    ntrials = length(data);
    
    % 86 regressors. yikes.
    cselfchoice = zeros(ntrials,3);
    selfchoice = zeros(ntrials,3);
    FB1 = zeros(ntrials,4); %split later
    FB2 = zeros(ntrials,3);
    cpartnerchoice = zeros(ntrials,3);
    partnerchoice = zeros(ntrials,3);
    lapse1 = zeros(ntrials,3);
    lapse2 = zeros(ntrials,3);
    
    for t = 1:ntrials
        
        if data(t).lapse1
            lapse1(t,1) = data(t).choice_onset;
            lapse1(t,2) = 3;
            lapse1(t,3) = 1;
        else
            
            %feedback responses
            if data(t).info_onset
                FB1(t,1) = data(t).info_onset;
                FB1(t,2) = 1.75;
                FB1(t,3) = 1;
                FB1(t,4) = data(t).partner;
            end
            if data(t).aff_onset
                FB2(t,1) = data(t).aff_onset;
                FB2(t,2) = 1.75;
                FB2(t,3) = 1;
            end
            
            if data(t).partner
                selfchoice(t,1) = data(t).choice_onset;
                selfchoice(t,2) = data(t).RT1 + .5;
                selfchoice(t,3) = 1;
                if data(t).lapse2
                    lapse2(t,1) = data(t).partner_onset;
                    lapse2(t,2) = 3;
                    lapse2(t,3) = 1;
                else
                    partnerchoice(t,1) = data(t).partner_onset;
                    partnerchoice(t,2) = data(t).RT2 + 1.25; % 0.75 before and 0.5 after
                    partnerchoice(t,3) = 1;
                end
                
            else
                cselfchoice(t,1) = data(t).choice_onset;
                cselfchoice(t,2) = data(t).RT1 + .5;
                cselfchoice(t,3) = 1;
                if data(t).lapse2
                    lapse2(t,1) = data(t).partner_onset;
                    lapse2(t,2) = 3;
                    lapse2(t,3) = 1;
                else
                    cpartnerchoice(t,1) = data(t).partner_onset;
                    cpartnerchoice(t,2) = data(t).RT2 + 1.25; % 0.75 before and 0.5 after
                    cpartnerchoice(t,3) = 1;
                end
            end
        end
    end
    
    lapse2(~lapse2(:,1),:) = [];
    lapse1(~lapse1(:,1),:) = [];
    FB1(~FB1(:,1),:) = [];
    sFB1 = FB1(FB1(:,4)==1,1:3);
    cFB1 = FB1(FB1(:,4)==0,1:3);

    partnerchoice(~partnerchoice(:,1),:) = [];
    selfchoice(~selfchoice(:,1),:) = [];
    cpartnerchoice(~cpartnerchoice(:,1),:) = [];
    cselfchoice(~cselfchoice(:,1),:) = [];
    
    cd(outputdir);
    if ~isempty(lapse1)
        dlmwrite(sprintf('lapseA%d.txt',r),lapse1,'delimiter','\t','precision','%.6f')
    else
        lapse1 = [0 0 0];
        dlmwrite(sprintf('lapseA%d.txt',r),lapse1,'delimiter','\t','precision','%.6f')
    end
    if ~isempty(lapse2)
        dlmwrite(sprintf('lapseB%d.txt',r),lapse2,'delimiter','\t','precision','%.6f')
    else
        lapse2 = [0 0 0];
        dlmwrite(sprintf('lapseB%d.txt',r),lapse2,'delimiter','\t','precision','%.6f')
    end
    
    dlmwrite(sprintf('partnerchoice%d.txt',r),partnerchoice,'delimiter','\t','precision','%.6f')
    dlmwrite(sprintf('selfchoice%d.txt',r),selfchoice,'delimiter','\t','precision','%.6f')
    dlmwrite(sprintf('cpartnerchoice%d.txt',r),cpartnerchoice,'delimiter','\t','precision','%.6f')
    dlmwrite(sprintf('cselfchoice%d.txt',r),cselfchoice,'delimiter','\t','precision','%.6f')
    dlmwrite(sprintf('FB1_run%d.txt',r),sFB1,'delimiter','\t','precision','%.6f')
    dlmwrite(sprintf('cFB1_run%d.txt',r),cFB1,'delimiter','\t','precision','%.6f')
    for t = 1:ntrials
        %dlmwrite(sprintf('FB1_trial%02d_run%d.txt',t,r),FB1(t,:),'delimiter','\t','precision','%.6f')
        dlmwrite(sprintf('FB2_trial%02d_run%d.txt',t,r),FB2(t,:),'delimiter','\t','precision','%.6f')
    end
    cd(maindir);
end

