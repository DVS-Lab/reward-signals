function  [newTrials,choicePat,forceOut] = genBlock(filename, logicalSet) % logicalSet(1) = Order of stimuli weight; logicalSet(2) = condition;
% creats a new WPT block of 200 trials based on Shanomey, et al. (2005).
% the input catStruct is modifed by the locialSet counter-balancing variable and 
% the trial order is randomized.

% 1)dim1A; 2)dim2A; 3)dim1B; 4)dim2B; 5)CorrectA(1)/B(2); 6)pattern
% 7)single(1)/double(2) 8)forced-choice outcome

% swap cue columns based on locial counter-balanceing set
stimuli = xlsread(filename);

logicalSet1 = logicalSet(1); % logicalSet(1) = dim; logicalSet(2) = control;
if logicalSet1==1
    logicalSwap = stimuli(:, [1 2 3 4 5 6 7 8 9]); % head == dim1
elseif logicalSet1==2
    logicalSwap = stimuli(:, [2 1 4 3 5 6 7 8 9]); % body == dim1
end

for i = 1: size(logicalSwap,1)
    win = execute_classicLot(.5,1000);
    if win
        clear pre
        pre = logicalSwap(i,1:2);
        logicalSwap(i,1:2) = logicalSwap(i,3:4);
        logicalSwap(i,3:4) = pre;
        logicalSwap(i,5) = 3 - logicalSwap(i,5);
        logicalSwap(i,9) = 2;
    end
end

% randomize trials
newTrials = randomOrder(logicalSwap);
% generate force-choices
choicePat = abs(logicalSet(2)-newTrials(:,7)); % 1 == free choice; 0 == forced choice
forceOut = newTrials(:,8);
end