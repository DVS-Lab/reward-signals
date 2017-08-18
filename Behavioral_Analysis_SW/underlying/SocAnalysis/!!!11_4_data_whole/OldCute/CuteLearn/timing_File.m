SubjectNumber = input('Subject Number = ');
maindir = pwd;
outputdir = fullfile(maindir,'timing',num2str(SubjectNumber));
if ~exist(outputdir,'dir')
    mkdir(outputdir);
end

outputname = fullfile(outputdir, [num2str(SubjectNumber) '.mat']);

filename = [num2str(SubjectNumber) '.mat'];
data = load(filename);
data = data.data; logicalSet = 2; %%

numTrials = size(data,2);
cuedur = .75;
infodur = 1.5;%infodur = 1.5; %for subjects1 and2
choicedur = 3;
postWait = .5;
[Nfree,Nforce,NfreeC,NforceC,NfreeR,NfreeNR,NforceR,NforceNR,Nabort] = deal(0);


for i = 1:numTrials
    
    
    tempdat = data(i);
    deckchoice = tempdat.deckchoice;
    lapse1 = tempdat.lapse1;
    RT1 = tempdat.RT1;
    cue_onset = tempdat.cue_onset;
    choice_onset = tempdat.choice_onset;
    press1_onset = tempdat.press1_onset;
    info_onset = tempdat.info_onset;
    ISI1 = tempdat.ISI1_list;
    ISI2 = tempdat.ISI2_list;
    ITI = tempdat.ITI_list;
    info_onset = press1_onset + postWait + ISI2;

    exemplars = tempdat.exemplars;
    Ctype = abs(logicalSet-exemplars(7));
    side = exemplars(9);
    outcome = exemplars(8);
    
    dif = abs(deckchoice - side);
    
    if dif<eps
        correct = outcome;
    else
        correct = 1 - outcome;
    end
    
    if lapse1 == 0
        if Ctype == 1
            Nfree = Nfree + 1;
            NfreeC = NfreeC + 1;
            cuefree(Nfree,1) = cue_onset;
            cuefree(Nfree,2) = cuedur;
            cuefree(Nfree,3) = 1;
            freechoice(NfreeC,1) = choice_onset;
            freechoice(NfreeC,2) = RT1 + postWait;
            freechoice(NfreeC,3) = 1;
                
                if correct == 1
                    NfreeR = NfreeR + 1;
                    freeR(NfreeR,1) = info_onset;
                    freeR(NfreeR,2) = infodur;
                    freeR(NfreeR,3) = 1;
                else
                    NfreeNR = NfreeNR + 1;
                    freeNR(NfreeNR,1) = info_onset;
                    freeNR(NfreeNR,2) = infodur;
                    freeNR(NfreeNR,3) = 1;
                end
        elseif Ctype == 0
            Nforce = Nforce + 1;
            NforceC = NforceC + 1;
            cueforce(Nforce,1) = cue_onset;
            cueforce(Nforce,2) = cuedur;
            cueforce(Nforce,3) = 1;
            forcechoice(NforceC,1) = choice_onset;
            forcechoice(NforceC,2) = RT1 + postWait;
            forcechoice(NforceC,3) = 1;
            if correct == 1
                    NforceR = NforceR + 1;
                    forceR(NforceR,1) = info_onset;
                    forceR(NforceR,2) = infodur;
                    forceR(NforceR,3) = 1;
            else
                    NforceNR = NforceNR + 1;
                    forceNR(NforceNR,1) = info_onset;
                    forceNR(NforceNR,2) = infodur;
                    forceNR(NforceNR,3) = 1;
            end
        end
    else
        if Ctype == 1
            Nfree = Nfree + 1;
            cuefree(Nfree,1) = cue_onset;
            cuefree(Nfree,2) = cuedur;
            cuefree(Nfree,3) = 1;
        elseif Ctype == 0
            Nforce = Nforce + 1;
            cueforce(Nforce,1) = cue_onset;
            cueforce(Nforce,2) = cuedur;
            cueforce(Nforce,3) = 1;
        end
                Nabort = Nabort + 1;
                abort(Nabort,1) = choice_onset;
                abort(Nabort,2) = choicedur + ISI2 + ITI;
                abort(Nabort,3) = 1;

    end
end

timing.cuefree = cuefree;
timing.cueforce = cueforce;
timing.freechoice = freechoice;
timing.forcechoice = forcechoice;
timing.freeR = freeR;
timing.freeNR = freeNR;
timing.forceR = forceR;
timing.forceNR = forceNR;
timing.abort = abort;

dlmwrite(sprintf('freecue.txt'),cuefree,'delimiter','\t','precision','%.6f');
dlmwrite(sprintf('forcecue.txt'),cueforce,'delimiter','\t','precision','%.6f');
dlmwrite(sprintf('freechoice.txt'),freechoice,'delimiter','\t','precision','%.6f');
dlmwrite(sprintf('forcechoice.txt'),forcechoice,'delimiter','\t','precision','%.6f');
dlmwrite(sprintf('freeReward.txt'),freeR,'delimiter','\t','precision','%.6f');
dlmwrite(sprintf('freeNoReward.txt'),freeNR,'delimiter','\t','precision','%.6f');
dlmwrite(sprintf('forceReward.txt'),forceR,'delimiter','\t','precision','%.6f');
dlmwrite(sprintf('forceNoReward.txt'),forceNR,'delimiter','\t','precision','%.6f');
dlmwrite(sprintf('abort.txt'),abort,'delimiter','\t','precision','%.6f');

save(outputname, 'timing');


% infinite weights: bayesian model- adjusting the data to avoid the
% infinite weights, 
% inference, the most likely : beta distributions
% researcher's estimate about the people's binomial parameter
% choice probabilites: adjusting the estimate from 100% to 95%
% p = (r+1/2) / (N+1)
% skewed not because your weights- see if thay helps
% testing trials 72% testing trails 72 is better than 36