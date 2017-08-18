clear all;
close all;

% ------ Get subject variables -------
load logicalCB
dataDir = pwd; %This code will save data to 'CCL' folder
SubjectNumber = input('Subject Number = ');
SubjectLS=logicalCB(:,SubjectNumber);
%Make outputdir if it does not already exist%%%
maindir = pwd;
outputdir = fullfile(maindir,'data',num2str(SubjectNumber));
if ~exist(outputdir,'dir')
    mkdir(outputdir);
end
addpath(fullfile(maindir,'ptb'));

% ------- Window setup --------
Screen('Preference','SkipSyncTests',1);

RandStream.setGlobalStream(RandStream('mt19937ar','seed',sum(100*clock)));
PsychDefaultSetup(2);
ExpStartTime = GetSecs;

myptb_setup;

[package] = StimLoad(screens);
% ------- Start experiment --------
whichCondition = logicalCB(:,SubjectNumber);
filename = 'Exemplars.xls';
[exemplars,choicePat,forceOut]=genBlock(filename,logicalCB(:,SubjectNumber));
totalTrials=size(exemplars,1);


% ------- Instructions ------
% [done1] = instructions_static(screens, package,exemplars,whichCondition);%%%%%%%%%%%%%

learningfinished = false;
nTrial = 1;
numTrials = size(exemplars,1);
TrialNB = 1;
condition = logicalCB(2,SubjectNumber);
group = exemplars(:,7);
signal = choicePat;

trial_setup;

while ~learningfinished
     WaitSecs(2);
     ISI1_list = Shuffle(ISI1_list);
     ISI2_list = Shuffle(ISI2_list);
     ITI_list = Shuffle(ITI_list);
     
%instruction
      instruction;
      wait_for_trigger;
      fixation_ptb;
      outputname = fullfile(outputdir, [num2str(SubjectNumber) '.mat']);

      startsecs = GetSecs;
      
     for j = 1:numTrials
         [lapse1, lapse2, RT1] = deal(0);
         [cue_onset, choice_onset, press1_onset, info_onset, value] = deal(0);
         
         eventsecs = GetSecs; %start event clock
         if j == 1
             delayt = 4;
             WaitSecs(delayt);
         else
             delayt = 0;
         end
         
         if signal(j) == 1 %free choice
             press = 0;
             % Cue phase
             freecue_ptb
              while GetSecs - (eventsecs+delayt) < cuedur %timing loop
                        [~, ~, keyCode] = KbCheck; %Keyboard input
                        if find(keyCode) == esc_key %escape
                            abort_all;
                        end
              end
              
              fixation_ptb;
              while GetSecs - (eventsecs+delayt+cuedur) < ISI1_list(j) %timing loop
                        [~, ~, keyCode] = KbCheck; %Keyboard input
                        if find(keyCode) == esc_key %escape
                            abort_all;
                        end
              end
              
              % Choice phase:
              prechoice_ptb;
              while ~press
                    [~, ~, responsecode] = KbCheck; %Keyboard input
                    if GetSecs - (eventsecs+delayt+cuedur+ISI1_list(j)) > self_dec
                        lapse_ptb;
                        lapse1 = 1;
                    else
                        % runs all the stuff for getting the choice
                        choice_ptb;
                    end
              end
              WaitSecs(.5);
              
              % if the don't response, then fixation for the rest of the trial
              if lapse1
                    fixation_ptb;
                    while GetSecs - (eventsecs+delayt+cuedur+ISI1_list(j)+self_dec) < ISI2_list(j)+infodur+ITI_list(j)
                        [~, ~, keyCode] = KbCheck; %Keyboard input
                        if find(keyCode) == esc_key %escape
                            abort_all;
                        end
                    end
              else
                  fixation_ptb;
                  while GetSecs - (eventsecs+delayt+cuedur+ISI1_list(j)+self_dec) < ISI2_list(j) %timing loop
                        [~, ~, keyCode] = KbCheck; %Keyboard input
                        if find(keyCode) == esc_key %escape
                            abort_all;
                        end
                  end
                  
                  % feedback
                  genFeedback;
                  if correct == 1
                      Screen('DrawTexture', screens.subjectW, package.textures.rewardTex,[],package.positions.subject.Pfeedback);
                  elseif correct == 0
                      Screen('DrawTexture', screens.subjectW, package.textures.no_rewardTex,[],package.positions.subject.Pfeedback);
                  end
                  Screen('Flip',screens.subjectW);
                  
                  while GetSecs - (eventsecs+delayt+cuedur+ISI1_list(j)+self_dec+ISI2_list(j)) <  infodur%timing loop
                        [~, ~, keyCode] = KbCheck; %Keyboard input
                        if find(keyCode) == esc_key %escape
                            abort_all;
                        end
                  end
                  
                  fixation_ptb;
                  while GetSecs - (eventsecs+delayt+cuedur+ISI1_list(j)+self_dec+ISI2_list(j)+infodur) < ITI_list(j) %timing loop
                            [~, ~, keyCode] = KbCheck; %Keyboard input
                            if find(keyCode) == esc_key %escape
                                abort_all;
                            end
                  end
              end
              
         elseif  signal(j) == 0
              press = 0;
                           % Cue phase
             forcecue_ptb
              while GetSecs - (eventsecs+delayt) < cuedur %timing loop
                        [~, ~, keyCode] = KbCheck; %Keyboard input
                        if find(keyCode) == esc_key %escape
                            abort_all;
                        end
              end
              
              fixation_ptb;
              while GetSecs - (eventsecs+delayt+cuedur) < ISI1_list(j) %timing loop
                        [~, ~, keyCode] = KbCheck; %Keyboard input
                        if find(keyCode) == esc_key %escape
                            abort_all;
                        end
              end
              
              % Choice phase:
              preforcechoice_ptb;
%               while ~press
%                     [~, ~, responsecode] = KbCheck; %Keyboard input
%                     if GetSecs - (eventsecs+delayt+cuedur+ISI1_list(j)) > self_dec
%                         lapse_ptb;
%                         lapse1 = 1;
%                     elseif find(responsecode) ~= shouldbe
%                         % runs all the stuff for getting the choice
%                     
%                         force_lapse;
%                         lapse1 = 1;
%                     else
%                         forcechoice_ptb;
%                     end
%               end
               while ~press
                    [~, ~, responsecode] = KbCheck; %Keyboard input
                    if GetSecs - (eventsecs+delayt+cuedur+ISI1_list(j)) < self_dec
                        if find(responsecode) ~= shouldbe
                          force_lapse;
                          lapse1 = 1;
                        else
                            forcechoice_ptb;
                        end
                    else
                        lapse_ptb;
                        lapse1 = 1;
                    end
               end
               WaitSecs(.5);
              
              % if the don't response, then fixation for the rest of the trial
              if lapse1
                    fixation_ptb;
                    while GetSecs - (eventsecs+delayt+cuedur+ISI1_list(j)+self_dec) < ISI2_list(j)+infodur+ITI_list(j)
                        [~, ~, keyCode] = KbCheck; %Keyboard input
                        if find(keyCode) == esc_key %escape
                            abort_all;
                        end
                    end
              else
                  fixation_ptb;
                  while GetSecs - (eventsecs+delayt+cuedur+ISI1_list(j)+self_dec) < ISI2_list(j) %timing loop
                      [~, ~, keyCode] = KbCheck; %Keyboard input
                      if find(keyCode) == esc_key %escape
                          abort_all;
                      end
                  end
                  
                  % feedback
                  correct = forceOut(j);
                  if correct == 1
                      Screen('DrawTexture', screens.subjectW, package.textures.rewardTex,[],package.positions.subject.Pfeedback);
                  elseif correct == 0
                      Screen('DrawTexture', screens.subjectW, package.textures.no_rewardTex,[],package.positions.subject.Pfeedback);
                  end
                  Screen('Flip',screens.subjectW);
                  
                  while GetSecs - (eventsecs+delayt+cuedur+ISI1_list(j)+self_dec+ISI2_list(j)) <  infodur%timing loop
                      [~, ~, keyCode] = KbCheck; %Keyboard input
                      if find(keyCode) == esc_key %escape
                          abort_all;
                      end
                  end
                  
                  fixation_ptb;
                  while GetSecs - (eventsecs+delayt+cuedur+ISI1_list(j)+self_dec+ISI2_list(j)+infodur) < ITI_list(j) %timing loop
                      [~, ~, keyCode] = KbCheck; %Keyboard input
                      if find(keyCode) == esc_key %escape
                          abort_all;
                      end
                  end
              end
              

         end
         k = j;
         data_struct;
     end
        WaitSecs(2); %wait 4 seconds at the end to let last feedback HRF return to baseline.
        run_time = GetSecs - startsecs;
%         while run_time < 788
%         end
        save(outputname, 'data','run_time');
    learningfinished = 1;
end
% DrawFormattedText(screens.subjectW, 'Congratulations! the experiment is finished.', 'center', 50, [255, 0, 0]);
% Screen(screens.subjectW,'Flip');
wait_for_esc;
    
    
    sca;
    task_dur = GetSecs - ExpStartTime;
    task_dur_info = fullfile(outputdir, [num2str(SubjectNumber) '_TaskDuration.mat']);
    save(task_dur_info, 'task_dur','task_dur');
