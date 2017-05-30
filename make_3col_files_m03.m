function make_3col_files_m03(subject)

maindir = pwd;
datadir = fullfile(maindir,'data',num2str(subject));
outputdir = fullfile(maindir,'evfiles_m03',num2str(subject));
if ~exist(outputdir,'dir')
    mkdir(outputdir);
end

addpath(fullfile(maindir,'rw'));


alpha = 0.30;
beta = 2;
clear out dec
for r = 1:4
    load(fullfile(datadir,sprintf('%s_feedback_%d.mat',num2str(subject),r)))
    choicedata = [data.Npoints; data.deckchoice]';
    if exist('out','var')
        out = [out; choicedata(:,1)];
        dec = [dec; choicedata(:,2)];
    else
        out = choicedata(:,1);
        dec = choicedata(:,2);
    end
end
[~, ~, ~, pe_e] = runRW(dec, out, alpha, beta);
%figure,plot(pe_e)

tcount = 0;
blocks = 1:4;
for r = 1:length(blocks)
    load(fullfile(datadir,sprintf('%s_feedback_%d.mat',num2str(subject),r)))
    
    ntrials = length(data);
    
    %make empty mats (for *_par, will make *_con last)
    selfchoice = zeros(ntrials,3);
    uinf_par = zeros(ntrials,3);
    sinf_par = zeros(ntrials,3);
    aff_par = zeros(ntrials,3);
    partnerchoice = zeros(ntrials,3);
    cselfchoice = zeros(ntrials,3);
    cuinf_par = zeros(ntrials,3);
    csinf_par = zeros(ntrials,3);
    caff_par = zeros(ntrials,3);
    cpartnerchoice = zeros(ntrials,3);
    lapse1 = zeros(ntrials,3);
    lapse2 = zeros(ntrials,3);
    
    for t = 1:ntrials
        tcount = tcount + 1;
        
        if data(t).is_catch
            continue
        end
        if data(t).lapse1
            lapse1(t,1) = data(t).choice_onset;
            lapse1(t,2) = 3;
            lapse1(t,3) = 1;
        else
            if data(t).partner
                selfchoice(t,1) = data(t).choice_onset;
                selfchoice(t,2) = data(t).RT1 + .5;
                selfchoice(t,3) = 1;
                uinf_par(t,1) = data(t).info_onset;
                uinf_par(t,2) = 1.75;
                uinf_par(t,3) = abs(pe_e(tcount));
                sinf_par(t,1) = data(t).info_onset;
                sinf_par(t,2) = 1.75;
                sinf_par(t,3) = pe_e(tcount);
                if data(t).lapse2
                    lapse2(t,1) = data(t).partner_onset;
                    lapse2(t,2) = 3;
                    lapse2(t,3) = 1;
                else
                    partnerchoice(t,1) = data(t).partner_onset;
                    partnerchoice(t,2) = data(t).RT2 + .5;
                    partnerchoice(t,3) = 1;
                    if data(t).soc_win
                        aff_par(t,1) = data(t).aff_onset;
                        aff_par(t,2) = 1.75;
                        aff_par(t,3) = data(t).Npoints;
                    else
                        aff_par(t,1) = data(t).aff_onset;
                        aff_par(t,2) = 1.75;
                        aff_par(t,3) = -data(t).Npoints;
                    end
                end
            else
                cselfchoice(t,1) = data(t).choice_onset;
                cselfchoice(t,2) = data(t).RT1 + .5;
                cselfchoice(t,3) = 1;
                cuinf_par(t,1) = data(t).info_onset;
                cuinf_par(t,2) = 1.75;
                cuinf_par(t,3) = abs(pe_e(tcount));
                csinf_par(t,1) = data(t).info_onset;
                csinf_par(t,2) = 1.75;
                csinf_par(t,3) = pe_e(tcount);
                if data(t).lapse2
                    lapse2(t,1) = data(t).partner_onset;
                    lapse2(t,2) = 3;
                    lapse2(t,3) = 1;
                else
                    cpartnerchoice(t,1) = data(t).partner_onset;
                    cpartnerchoice(t,2) = data(t).RT2 + .5;
                    cpartnerchoice(t,3) = 1;
                    if data(t).soc_win
                        caff_par(t,1) = data(t).aff_onset;
                        caff_par(t,2) = 1.75;
                        caff_par(t,3) = data(t).Npoints;
                    else
                        caff_par(t,1) = data(t).aff_onset;
                        caff_par(t,2) = 1.75;
                        caff_par(t,3) = -data(t).Npoints;
                    end
                end
            end
        end
    end
    
    lapse2(~lapse2(:,1),:) = [];
    lapse1(~lapse1(:,1),:) = [];

    %social
    partnerchoice(~partnerchoice(:,1),:) = [];
    selfchoice(~selfchoice(:,1),:) = [];
    sinf_par(~sinf_par(:,1),:) = [];
    sinf_par(:,3) = sinf_par(:,3)-mean(sinf_par(:,3));
    uinf_par(~uinf_par(:,1),:) = [];
    uinf_par(:,3) = uinf_par(:,3)-mean(uinf_par(:,3));
    aff_par(~aff_par(:,1),:) = [];
    aff_par(:,3) = aff_par(:,3)-mean(aff_par(:,3));
    inf_con = sinf_par;
    inf_con(:,3) = 1;
    aff_con = aff_par;
    aff_con(:,3) = 1;

    %computer
    cpartnerchoice(~cpartnerchoice(:,1),:) = [];
    cselfchoice(~cselfchoice(:,1),:) = [];
    csinf_par(~csinf_par(:,1),:) = [];
    csinf_par(:,3) = csinf_par(:,3)-mean(csinf_par(:,3));
    cuinf_par(~cuinf_par(:,1),:) = [];
    cuinf_par(:,3) = cuinf_par(:,3)-mean(cuinf_par(:,3));
    caff_par(~caff_par(:,1),:) = [];
    caff_par(:,3) = caff_par(:,3)-mean(caff_par(:,3));
    cinf_con = csinf_par;
    cinf_con(:,3) = 1;
    caff_con = caff_par;
    caff_con(:,3) = 1;
    
    
    cd(outputdir);
    %social
    dlmwrite(sprintf('inf_con%d.txt',r),inf_con,'delimiter','\t','precision','%.6f')
    dlmwrite(sprintf('sinf_par%d.txt',r),sinf_par,'delimiter','\t','precision','%.6f')
    dlmwrite(sprintf('uinf_par%d.txt',r),uinf_par,'delimiter','\t','precision','%.6f')
    dlmwrite(sprintf('aff_par%d.txt',r),aff_par,'delimiter','\t','precision','%.6f')
    dlmwrite(sprintf('aff_con%d.txt',r),aff_con,'delimiter','\t','precision','%.6f')
    dlmwrite(sprintf('partnerchoice%d.txt',r),partnerchoice,'delimiter','\t','precision','%.6f')
    dlmwrite(sprintf('selfchoice%d.txt',r),selfchoice,'delimiter','\t','precision','%.6f')
    
    %computer
    dlmwrite(sprintf('cinf_con%d.txt',r),cinf_con,'delimiter','\t','precision','%.6f')
    dlmwrite(sprintf('csinf_par%d.txt',r),csinf_par,'delimiter','\t','precision','%.6f')
    dlmwrite(sprintf('cuinf_par%d.txt',r),cuinf_par,'delimiter','\t','precision','%.6f')
    dlmwrite(sprintf('caff_par%d.txt',r),caff_par,'delimiter','\t','precision','%.6f')
    dlmwrite(sprintf('caff_con%d.txt',r),caff_con,'delimiter','\t','precision','%.6f')
    dlmwrite(sprintf('cpartnerchoice%d.txt',r),cpartnerchoice,'delimiter','\t','precision','%.6f')
    dlmwrite(sprintf('cselfchoice%d.txt',r),cselfchoice,'delimiter','\t','precision','%.6f')

    cd(maindir);
end

