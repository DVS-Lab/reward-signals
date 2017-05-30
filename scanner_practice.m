

% set all Trial Information
trial_setup;
ntrials = 20;
soc_win = [ones(1,ntrials/2) zeros(1,ntrials/2)];
partner = [ones(1,ntrials/2) zeros(1,ntrials/2)];
is_catch = [1 2 1 2 zeros(1,16)];
point_total = 0;
Vwalks = load('Vwalk_all_v1.mat');
clear data;
block = 1;

%distribute points
deck1 = Vwalks.data(1:ntrials,1);
deck2 = Vwalks.data(1:ntrials,2);

[imagename, ~, alpha] = imread(fullfile(maindir,'imgs','star.png'));
imagename(:,:,4) = alpha(:,:);
scan1_texture = Screen('MakeTexture', mywindow, imagename);
[imagename, ~, alpha] = imread(fullfile(maindir,'imgs','pentagon.png'));
imagename(:,:,4) = alpha(:,:);
scan2_texture = Screen('MakeTexture', mywindow, imagename);


% set stim conditions amd activate
stim_conditions;
ss.tacs(amplitude,stimElectrode,transition,5000,frequency);
WaitSecs(2);

fix1_list = Shuffle(fix1_list);
fix2_list = Shuffle(fix2_list);
fix3_list = Shuffle(fix3_list);
fix4_list = Shuffle(fix4_list);
soc_win = Shuffle(soc_win);
is_catch = Shuffle(is_catch);
partner = Shuffle(partner);

deckorders = [1 2; 2 1];

msg1 = sprintf('Practice only: Get ready!');
Screen('TextSize', mywindow, floor((30*scale_res(2))));
Screen('TextFont', mywindow, 'Helvetica');
% oldStyle=Screen('TextStyle', mywindowPtr [,style]);
% [,style] could be 0=normal,1=bold,2=italic,4=underline,8=outline,32=condense,64=extend.
Screen('TextStyle', mywindow, 0);
longest_msg = 'Each shape will yield 1 to 100 points, but the value of the shape changes over time.';
[normBoundsRect, ~] = Screen('TextBounds', mywindow, longest_msg);

%%%Setting the intro screen%%%
Screen('TextSize', mywindow, floor((25*scale_res(2))));
Screen('TextStyle', mywindow, 1);
Screen('DrawText', mywindow, msg1, (centerhoriz-(normBoundsRect(3)/2)), (centervert-(90*scale_res(2))), black);
Screen('TextStyle', mywindow, 0);
Screen('DrawText', mywindow, 'On each trial, you will see two shapes (star and pentagon).', (centerhoriz-(normBoundsRect(3)/2)), (centervert-(35*scale_res(2))), black);
Screen('DrawText', mywindow, longest_msg, (centerhoriz-(normBoundsRect(3)/2)), centervert, black);
Screen('DrawText', mywindow, 'Keep track of the value of each shape and choose accordingly.', (centerhoriz-(normBoundsRect(3)/2)), (centervert+(35*scale_res(2))), black);
Screen('DrawText', mywindow, 'Please keep your head/legs still. The task will start soon.', (centerhoriz-(normBoundsRect(3)/2)), (centervert+(70*scale_res(2))), black);
%oldTextSize=Screen('TextSize', mywindowPtr [,textSize]);
Screen('Flip', mywindow);

wait_for_trigger;
fixation_ptb;

% START TRIAL LOOP%%%
outputname = fullfile(outputdir, [subjectnum '_feedback_prac.mat']);
startsecs = GetSecs;
for k = 1:ntrials
    
    [lapse1, lapse2, RT1, RT2] = deal(0);
    [choice_onset, press1_onset, info_onset, partner_onset, press2_onset, aff_onset, value] = deal(0);
    words = Shuffle(words);
    deckorder = deckorders(ceil(rand*2),:);
    
    eventsecs = GetSecs; %start event clock
    if k == 1
        delayt = 4;
        WaitSecs(delayt);
    else
        delayt = 0;
    end
    
    if partner(k) % social
        partner_texture = human_texture;
    else
        partner_texture = comp_texture;
    end
    
    if is_catch(k) == 0 % REGULAR TRIAL
        
        % Choice phase
        prechoice_ptb;
        press = 0;
        while ~press
            [~, ~, responsecode] = KbCheck; %Keyboard input
            if GetSecs - (eventsecs+delayt) > self_dec
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
            while GetSecs - (eventsecs+delayt+self_dec) < fix1_list(k)+infodur+fix2_list(k)+partner_dec1+partner_dec2+fix3_list(k)+affdur+fix4_list(k)
                [~, ~, keyCode] = KbCheck; %Keyboard input
                if find(keyCode) == esc_key %escape
                    abort_all;
                end
            end
        else
            
            % fixation #1
            fixation_ptb;
            while GetSecs - (eventsecs+delayt+self_dec) < fix1_list(k) %timing loop
                [~, ~, keyCode] = KbCheck; %Keyboard input
                if find(keyCode) == esc_key %escape
                    abort_all;
                end
            end
            
            
            % Informative Feedback
            if stiminf
                ss.tacs(amplitude,stimElectrode,transition,duration,frequency);
                WaitSecs(0.250);
            end
            msg = num2str(choice);
            Screen('TextStyle', mywindow, 0);
            Screen('TextSize', mywindow, 80);
            [normBoundsRect, ~] = Screen('TextBounds', mywindow, msg);
            Screen('DrawText', mywindow, msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert-(normBoundsRect(4)/2)), black);
            Screen('Flip', mywindow);
            info_onset = GetSecs - startsecs;
            while GetSecs - (eventsecs+delayt+self_dec+fix1_list(k)) < infodur %timing loop
                [~, ~, keyCode] = KbCheck; %Keyboard input
                if find(keyCode) == esc_key %escape
                    abort_all;
                end
            end
            
            
            % Fixation #2
            fixation_ptb;
            while GetSecs - (eventsecs+delayt+self_dec+fix1_list(k)+infodur) < fix2_list(k) %timing loop
                [~, ~, keyCode] = KbCheck; %Keyboard input
                if find(keyCode) == esc_key %escape
                    abort_all;
                end
            end
            
            
            % Partner is Deciding
            prepartner_ptb;
            while GetSecs - (eventsecs+delayt+self_dec+fix1_list(k)+infodur+fix2_list(k)) < partner_dec1 %timing loop
                [~, ~, keyCode] = KbCheck; %Keyboard input
                if find(keyCode) == esc_key %escape
                    sca;
                    run_time = GetSecs - startsecs;
                    if exist('data','var')
                        save(outputname, 'data','run_time');
                    else
                        save(outputname,'run_time');
                    end
                    return;
                end
            end
            partner_ptb;
            press = 0;
            while ~press
                [~, ~, responsecode] = KbCheck; %Keyboard input
                if GetSecs - (eventsecs+delayt+self_dec+fix1_list(k)+infodur+fix2_list(k)+partner_dec1) > partner_dec2
                    lapse_ptb;
                    lapse2 = 1;
                else
                    partnerchoice_ptb;
                end
            end
            WaitSecs(.5);
            
            % Fixation #3
            if lapse2
                fixation_ptb;
                while GetSecs - (eventsecs+delayt+self_dec+fix1_list(k)+infodur+fix2_list(k)+partner_dec1+partner_dec2) < fix3_list(k)+affdur+fix4_list(k) %timing loop
                    [~, ~, keyCode] = KbCheck; %Keyboard input
                    if find(keyCode) == esc_key %escape
                        abort_all;
                    end
                end
            else
                fixation_ptb;
                while GetSecs - (eventsecs+delayt+self_dec+fix1_list(k)+infodur+fix2_list(k)+partner_dec1+partner_dec2) < fix3_list(k) %timing loop
                    [~, ~, keyCode] = KbCheck; %Keyboard input
                    if find(keyCode) == esc_key %escape
                        abort_all;
                    end
                end
                
                % Affective Feedback
                if stimaff
                    ss.tacs(amplitude,stimElectrode,transition,duration,frequency);
                    WaitSecs(0.250);
                end
                affect_ptb;
                aff_onset = GetSecs - startsecs;
                while GetSecs - (eventsecs+delayt+self_dec+fix1_list(k)+infodur+fix2_list(k)+partner_dec1+partner_dec2+fix3_list(k)) < affdur %timing loop
                    [~, ~, keyCode] = KbCheck; %Keyboard input
                    if find(keyCode) == esc_key %escape
                        abort_all;
                    end
                end
                
                % Fixation #4
                fixation_ptb;
                while GetSecs - (eventsecs+delayt+self_dec+fix1_list(k)+infodur+fix2_list(k)+partner_dec1+partner_dec2+fix3_list(k)+affdur) < fix4_list(k) %timing loop
                    [~, ~, keyCode] = KbCheck; %Keyboard input
                    if find(keyCode) == esc_key %escape
                        abort_all;
                    end
                end
                
            end % if lapse2
        end % if lapse1
        
        
    elseif is_catch(k) == 1 %inf only with rating
        
        prechoice_ptb;
        press = 0;
        while ~press
            [~, ~, responsecode] = KbCheck; %Keyboard input
            if GetSecs - (eventsecs+delayt) > self_dec
                lapse_ptb;
                lapse1 = 1;
            else
                % runs all the stuff for getting the choice
                choice_ptb;
            end
        end
        WaitSecs(.5);
        
        % Fixation 1
        fixation_ptb;
        while GetSecs - (eventsecs+delayt+self_dec) < fix1_list(k) %timing loop
            [~, ~, keyCode] = KbCheck; %Keyboard input
            if find(keyCode) == esc_key %escape
                abort_all;
            end
        end
        
        % Informative Feedback
        if stiminf
            ss.tacs(amplitude,stimElectrode,transition,duration,frequency);
            WaitSecs(0.250);
        end
        msg = num2str(choice);
        Screen('TextStyle', mywindow, 0);
        Screen('TextSize', mywindow, 80);
        [normBoundsRect, ~] = Screen('TextBounds', mywindow, msg);
        Screen('DrawText', mywindow, msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert-(normBoundsRect(4)/2)), black);
        Screen('Flip', mywindow);
        info_onset = GetSecs - startsecs;
        while GetSecs - (eventsecs+delayt+self_dec+fix1_list(k)) < infodur %timing loop
            [~, ~, keyCode] = KbCheck; %Keyboard input
            if find(keyCode) == esc_key %escape
                abort_all;
            end
        end
        
        % Fixation 2
        fixation_ptb;
        while GetSecs - (eventsecs+delayt+self_dec+fix1_list(k)+infodur) < fix2_list(k) %timing loop
            [~, ~, keyCode] = KbCheck; %Keyboard input
            if find(keyCode) == esc_key %escape
                abort_all;
            end
        end
        
        
        
        preslider_ptb;
        maxslidertime = slidertime+fix3_list(k);
        while keep_going
            % if GetSecs - (eventsecs+delayt) > self_dec
            if GetSecs - (eventsecs+delayt+self_dec+fix1_list(k)+infodur+fix2_list(k)) > maxslidertime
                keep_going = 0;
            end
            slider_ptb;
        end
        WaitSecs(.50);
        
        % Fixation 4
        fixation_ptb;
        while GetSecs - (eventsecs+delayt+self_dec+fix1_list(k)+infodur+fix2_list(k)+maxslidertime) < fix4_list(k)
            [~, ~, keyCode] = KbCheck; %Keyboard input
            if find(keyCode) == esc_key %escape
                abort_all;
            end
        end
        
        
    elseif is_catch(k) == 2 %aff only with rating
        
        
        %Partner is Deciding
        prepartner_ptb;
        while GetSecs - (eventsecs+delayt) < partner_dec1 %timing loop
            [~, ~, keyCode] = KbCheck; %Keyboard input
            if find(keyCode) == esc_key %escape
                abort_all;
            end
        end
        partner_ptb;
        press = 0;
        while ~press
            [~, ~, responsecode] = KbCheck; %Keyboard input
            if GetSecs - (eventsecs+delayt+partner_dec1) > partner_dec2
                lapse_ptb;
                lapse2 = 1;
            else
                partnerchoice_ptb;
            end
        end
        WaitSecs(.5);
        
        
        % Fixation #3
        if lapse2
            fixation_ptb;
            while GetSecs - (eventsecs+delayt+partner_dec1+partner_dec2) < fix3_list(k)+affdur+fix4_list(k) %timing loop
                [~, ~, keyCode] = KbCheck; %Keyboard input
                if find(keyCode) == esc_key %escape
                    abort_all;
                end
            end
        else
            fixation_ptb;
            while GetSecs - (eventsecs+delayt+partner_dec1+partner_dec2) < fix3_list(k) %timing loop
                [~, ~, keyCode] = KbCheck; %Keyboard input
                if find(keyCode) == esc_key %escape
                    abort_all;
                end
            end
            % Affective Feedback
            if stimaff
                ss.tacs(amplitude,stimElectrode,transition,duration,frequency);
                WaitSecs(0.250);
            end
            if rand < 0.5
                choice = deck1(k);
                deckchoice = 11;
            else
                choice = deck2(k);
                deckchoice = 22;
            end
            affect_ptb;
            aff_onset = GetSecs - startsecs;
            while GetSecs - (eventsecs+delayt+partner_dec1+partner_dec2+fix3_list(k)) < affdur %timing loop
                [~, ~, keyCode] = KbCheck; %Keyboard input
                if find(keyCode) == esc_key %escape
                    abort_all;
                end
            end
            
            
            preslider_ptb;
            maxslidertime = slidertime+fix1_list(k);
            while keep_going
                % if GetSecs - (eventsecs+delayt) > self_dec
                if GetSecs - (eventsecs+delayt+partner_dec1+partner_dec2+fix3_list(k)+affdur) > maxslidertime
                    keep_going = 0;
                end
                slider_ptb;
            end
            WaitSecs(.50);
            
            % Fixation 4
            fixation_ptb;
            while GetSecs - (eventsecs+delayt+partner_dec1+partner_dec2+fix3_list(k)+affdur+maxslidertime) < fix4_list(k)+fix2_list(k)
                [~, ~, keyCode] = KbCheck; %Keyboard input
                if find(keyCode) == esc_key %escape
                    abort_all;
                end
            end
            
            
        end
    end
    
    % Save data here
    data_struct;
    
end

Screen('TextSize', mywindow, floor((30*scale_res(2))));
msg = sprintf('Good job! You won %d points!', point_total);
[normBoundsRect, ~] = Screen('TextBounds', mywindow, msg);
Screen('DrawText', mywindow, msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert-(normBoundsRect(4)/2)), black);
Screen('Flip', mywindow);

WaitSecs(2);





