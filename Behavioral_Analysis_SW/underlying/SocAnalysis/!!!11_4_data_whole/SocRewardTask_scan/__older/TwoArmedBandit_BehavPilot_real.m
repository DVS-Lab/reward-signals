
prompt = 'Enter subject number: ';
subjectnum = input(prompt);

if ~ischar(subjectnum)
    subjectnum = num2str(subjectnum);
end
Screen('Preference', 'SkipSyncTests', 1);

%Make outputdir if it does not already exist%%%
maindir = pwd;
outputdir = fullfile(maindir,'BehavioralData',subjectnum);
if ~exist(outputdir,'dir')
    mkdir(outputdir);
end


RandStream.setGlobalStream(RandStream('mt19937ar','seed',sum(100*clock)));
PsychDefaultSetup(2);
ExpStartTime = GetSecs;
try
    
    % stim setup
    run stim_setup;
    
    % set up screens and rects
    run myptb_setup;
    
    % Set all Trial Information
    ntrials = 40;
    fix1_list = [repmat(1.75,1,20) repmat(2.75,1,12) repmat(4.75,1,8)];
    fix2_list = [repmat(1.75,1,20) repmat(2.75,1,12) repmat(4.75,1,8)];
    fix3_list = [repmat(1.75,1,20) repmat(2.75,1,12) repmat(4.75,1,8)];
    fix4_list = [repmat(1.75,1,20) repmat(2.50,1,12) repmat(3.25,1,8)];
    partner_dec1 = 0.75;
    partner_dec2 = 2.25;
    self_dec = 3.00;
    infodur = 1.75;
    affdur = 1.75;
    
    words = {'interested','distressed','excited','upset','attentive', ...
        'strong','guilty','scared','hostile','jittery', ...
        'enthusiastic','proud','irritable','alert','active',...
        'ashamed','inspired','nervous','determined','afraid'};
    
    words = Shuffle(words);
    
    soc_win = [ones(1,ntrials/2) zeros(1,ntrials/2)];
    is_catch = [1 1 1 2 2 2 zeros(1,34)];
    
    point_total = 0;
    randblocks = 1:4; %not random
    Vwalks = load('Vwalks.mat');
    for b = 1:length(randblocks)
        block = randblocks(b);
        
        %distribute points
        deck1 = Vwalks.data{block}(:,1);
        deck2 = Vwalks.data{block}(:,2);
        
        %sprintf('use %d and %d',b,b+4)
        [imagename, ~, alpha] = imread(fullfile(maindir,'cropped_imgs',sprintf('cue%d.png',b)));
        imagename(:,:,4) = alpha(:,:);
        scan1_texture = Screen('MakeTexture', mywindow, imagename);
        [imagename, ~, alpha] = imread(fullfile(maindir,'cropped_imgs',sprintf('cue%d.png',b+4)));
        imagename(:,:,4) = alpha(:,:);
        scan2_texture = Screen('MakeTexture', mywindow, imagename);
        
        
        % set stim conditions amd activate
        run stim_conditions;
        ss.tacs(amplitude,stimElectrode,transition,5000,frequency);
        WaitSecs(2);
        
        fix1_list = Shuffle(fix1_list);
        fix2_list = Shuffle(fix2_list);
        fix3_list = Shuffle(fix3_list);
        fix4_list = Shuffle(fix4_list);
        soc_win = Shuffle(soc_win);
        is_catch = Shuffle(is_catch);
        
        type = 'Computer';
        partner_texture = comp_texture;
        msg1 = sprintf('Run %d of %d: You''ve earned %d points.', b, length(randblocks),point_total);
        
        deckorders = [1 2; 2 1];
        Screen('TextSize', mywindow, floor((30*scale_res(2))));
        Screen('TextFont', mywindow, 'Helvetica');
        
        % oldStyle=Screen('TextStyle', mywindowPtr [,style]);
        % [,style] could be 0=normal,1=bold,2=italic,4=underline,8=outline,32=condense,64=extend.
        Screen('TextStyle', mywindow, 0);
        
        longest_msg = 'Each option will yield 1 to 99 points, but the value of each option changes over time.';
        [normBoundsRect, ~] = Screen('TextBounds', mywindow, longest_msg);
        
        %%%Setting the intro screen%%%
        Screen('TextSize', mywindow, floor((25*scale_res(2))));
        Screen('TextStyle', mywindow, 1);
        Screen('DrawText', mywindow, msg1, (centerhoriz-(normBoundsRect(3)/2)), (centervert-(90*scale_res(2))), black);
        Screen('TextStyle', mywindow, 0);
        Screen('DrawText', mywindow, 'On each trial, you will see two options.', (centerhoriz-(normBoundsRect(3)/2)), (centervert-(35*scale_res(2))), black);
        Screen('DrawText', mywindow, longest_msg, (centerhoriz-(normBoundsRect(3)/2)), centervert, black);
        Screen('DrawText', mywindow, 'Keep track of the value of each option and choose accordingly.', (centerhoriz-(normBoundsRect(3)/2)), (centervert+(35*scale_res(2))), black);
        Screen('DrawText', mywindow, 'Press the spacebar when you''re ready to start.', (centerhoriz-(normBoundsRect(3)/2)), (centervert+(70*scale_res(2))), black);
        %oldTextSize=Screen('TextSize', mywindowPtr [,textSize]);
        Screen('Flip', mywindow);
        
        %start sequence. will change this to receive a scanner pulse
        go = 1;
        while go
            [keyIsDown, ~, keyCode] = KbCheck; %Keyboard input
            keyCode = find(keyCode);
            if keyIsDown == 1
                if keyCode(1) == go_button
                    go = 0;
                end
                if keyCode(1) == esc_key %esc to close
                    Screen('CloseAll');
                    return;
                end
            end
        end
        Screen('DrawLine', mywindow, black, ((screenRect(3)/2)-(10*scale_res(1))), screenRect(4)/2, ((screenRect(3)/2)+(10*scale_res(1))), screenRect(4)/2, 2);
        Screen('DrawLine', mywindow, black, screenRect(3)/2, ((screenRect(4)/2)-(10*scale_res(2))), screenRect(3)/2, ((screenRect(4)/2)+(10*scale_res(2))), 2);
        Screen('Flip', mywindow);
        
        
        %%START TRIAL LOOP%%%
        outputname = fullfile(outputdir, [subjectnum '_' type 'feedback_' num2str(b) '.mat']);
        startsecs = GetSecs;
        for k = 1:ntrials
            [lapse1, lapse2, RT1, RT2] = deal(0);
            [press1_onset, info_onset, partner_onset, press2_onset, aff_onset, value] = deal(0);
            %choice_onset is always defined.
            
            eventsecs = GetSecs; %start event clock
            if k == 1
                delayt = 4;
                WaitSecs(delayt);
            else
                delayt = 0;
            end
            
            if is_catch(k) == 0
                % CHOICE PHASE
                deckorder = deckorders(ceil(rand*2),:);
                %deckorder = deckorders(1,:);
                eval(['left_card_val = deck' num2str(deckorder(1)) '(k);'])
                eval(['right_card_val = deck' num2str(deckorder(2)) '(k);'])
                eval(['left_card_color = scan' num2str(deckorder(1)) '_texture;']) %deck1_color
                eval(['right_card_color = scan' num2str(deckorder(2)) '_texture;']) %deck1_color
                
                %Screen('DrawTexture', mywindowPointer, texturePointer [,sourceRect] [,destinationRect] [,rotationAngle] [, filterMode] [, globalAlpha] [, modulateColor] [, textureShader] [, specialFlags] [, auxParameters]);
                %Screen('FillRect', mywindowPtr [,color] [,rect] )
                Screen('DrawTexture', mywindow, left_card_color, [], LeftRect);
                Screen('DrawTexture', mywindow, right_card_color, [], RightRect);
                Screen('Flip', mywindow);
                choice_onset = GetSecs - startsecs;
                RT1_start = GetSecs; %start RT clock
                
                Screen('DrawTexture', mywindow, left_card_color, [], LeftRect);
                Screen('DrawTexture', mywindow, right_card_color, [], RightRect);
                
                %%%MAKE CHOICE%%%
                press = 0;
                while ~press
                    [~, ~, responsecode] = KbCheck; %Keyboard input
                    if GetSecs - (eventsecs+delayt) > self_dec
                        Screen('Flip', mywindow);
                        msg = 'Respond faster!';
                        Screen('TextStyle', mywindow, 0);
                        Screen('TextSize', mywindow, 40);
                        [normBoundsRect, ~] = Screen('TextBounds', mywindow, msg);
                        Screen('DrawText', mywindow, msg, (centerhoriz-(normBoundsRect(3)/2)), centervert, black);
                        Screen('Flip', mywindow);
                        lapse1 = 1;
                        press = 1;
                        choice = 0;
                        deckchoice = 0;
                        WaitSecs(.5);
                    else
                        if find(responsecode) == L_arrow %LEFT
                            Screen('FrameRect',mywindow,red,LeftRect2,5);
                            RT1 = GetSecs - RT1_start;
                            press = 1;
                            Screen('Flip', mywindow);
                            press1_onset = GetSecs - startsecs;
                            deckchoice = deckorder(1);
                            choice = left_card_val;
                        elseif find(responsecode) == R_arrow %RIGHT
                            Screen('FrameRect',mywindow,red,RightRect2,5);
                            RT1 = GetSecs - RT1_start;
                            press = 1;
                            press1_onset = GetSecs - startsecs;
                            Screen('Flip', mywindow);
                            deckchoice = deckorder(2);
                            choice = right_card_val;
                        elseif find(responsecode) == esc_key
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
                end
                WaitSecs(.5);
                
                %fixation for the remainder of the trial
                if lapse1
                    Screen('DrawLine', mywindow, black, ((screenRect(3)/2)-(10*scale_res(1))), screenRect(4)/2, ((screenRect(3)/2)+(10*scale_res(1))), screenRect(4)/2, 2);
                    Screen('DrawLine', mywindow, black, screenRect(3)/2, ((screenRect(4)/2)-(10*scale_res(2))), screenRect(3)/2, ((screenRect(4)/2)+(10*scale_res(2))), 2);
                    Screen('Flip', mywindow);
                    %(eventsecs+delayt+self_dec+fix1_list(k)+infodur+fix2_list(k)+partner_dec1+partner_dec2+fix3_list(k)+affdur) < fix4_list(k) %timing loop
                    while GetSecs - (eventsecs+delayt+self_dec) < fix1_list(k)+infodur+fix2_list(k)+partner_dec1+partner_dec2+fix3_list(k)+affdur+fix4_list(k)
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
                else
                    
                    
                    %% Real Fixation #1
                    Screen('DrawLine', mywindow, black, ((screenRect(3)/2)-(10*scale_res(1))), screenRect(4)/2, ((screenRect(3)/2)+(10*scale_res(1))), screenRect(4)/2, 2);
                    Screen('DrawLine', mywindow, black, screenRect(3)/2, ((screenRect(4)/2)-(10*scale_res(2))), screenRect(3)/2, ((screenRect(4)/2)+(10*scale_res(2))), 2);
                    Screen('Flip', mywindow);
                    while GetSecs - (eventsecs+delayt+self_dec) < fix1_list(k) %timing loop
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
                    
                    
                    %% Informative Feedback
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
                    
                    
                    
                    %% Fixation #2
                    Screen('DrawLine', mywindow, black, ((screenRect(3)/2)-(10*scale_res(1))), screenRect(4)/2, ((screenRect(3)/2)+(10*scale_res(1))), screenRect(4)/2, 2);
                    Screen('DrawLine', mywindow, black, screenRect(3)/2, ((screenRect(4)/2)-(10*scale_res(2))), screenRect(3)/2, ((screenRect(4)/2)+(10*scale_res(2))), 2);
                    Screen('Flip', mywindow);
                    while GetSecs - (eventsecs+delayt+self_dec+fix1_list(k)+infodur) < fix2_list(k) %timing loop
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
                    
                    %% Partner is Deciding
                    Screen('DrawTexture', mywindow, partner_texture, [], MiddleRect);
                    Screen('TextStyle', mywindow, 0);
                    Screen('TextSize', mywindow, 30);
                    msg = 'Partner is deciding...';
                    [normBoundsRect, ~] = Screen('TextBounds', mywindow, msg);
                    Screen('DrawText', mywindow, msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert-(180*scale_res(2))), black);
                    Screen('Flip', mywindow);
                    partner_onset = GetSecs - startsecs;
                    RT2_start = GetSecs; %start RT clock. add a second.
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
                    Screen('DrawTexture', mywindow, partner_texture, [], MiddleRect);
                    Screen('TextStyle', mywindow, 0);
                    Screen('TextSize', mywindow, 30);
                    msg = 'Partner is deciding...';
                    [normBoundsRect, ~] = Screen('TextBounds', mywindow, msg);
                    Screen('DrawText', mywindow, msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert-(180*scale_res(2))), black);
                    Screen('TextStyle', mywindow, 1);
                    msg = 'Press any button to see whether you won or loss.';
                    [normBoundsRect, ~] = Screen('TextBounds', mywindow, msg);
                    Screen('DrawText', mywindow, msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert+(120*scale_res(2))), black);
                    Screen('TextStyle', mywindow, 0);
                    Screen('Flip', mywindow);
                    
                    
                    Screen('DrawTexture', mywindow, partner_texture, [], MiddleRect);
                    Screen('TextStyle', mywindow, 0);
                    Screen('TextSize', mywindow, 30);
                    msg = 'Partner is deciding...';
                    [normBoundsRect, ~] = Screen('TextBounds', mywindow, msg);
                    Screen('DrawText', mywindow, msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert-(180*scale_res(2))), black);
                    Screen('TextStyle', mywindow, 1);
                    msg = 'Press any button to see whether you won or loss.';
                    [normBoundsRect, ~] = Screen('TextBounds', mywindow, msg);
                    Screen('DrawText', mywindow, msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert+(120*scale_res(2))), black);
                    Screen('TextStyle', mywindow, 0);
                    
                    press = 0;
                    while ~press
                        [~, ~, responsecode] = KbCheck; %Keyboard input
                        if GetSecs - (eventsecs+delayt+self_dec+fix1_list(k)+infodur+fix2_list(k)+partner_dec1) > partner_dec2
                            Screen('Flip', mywindow);
                            msg = 'Respond faster!';
                            Screen('TextStyle', mywindow, 0);
                            Screen('TextSize', mywindow, 40);
                            [normBoundsRect, ~] = Screen('TextBounds', mywindow, msg);
                            Screen('DrawText', mywindow, msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert-(normBoundsRect(4)/2)), black);
                            Screen('Flip', mywindow);
                            lapse2 = 1;
                            press = 1;
                            WaitSecs(.5);
                        else
                            if find(responsecode) == L_arrow | find(responsecode) == R_arrow | find(responsecode) == D_arrow
                                Screen('FrameRect',mywindow,red,MiddleRect,5);
                                RT2 = GetSecs - RT2_start;
                                press = 1;
                                press2_onset = GetSecs - startsecs;
                                Screen('Flip', mywindow);
                            elseif find(responsecode) == esc_key
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
                    end
                    WaitSecs(.5);
                    
                    
                    %% Fixation #3
                    if lapse2
                        Screen('DrawLine', mywindow, black, ((screenRect(3)/2)-(10*scale_res(1))), screenRect(4)/2, ((screenRect(3)/2)+(10*scale_res(1))), screenRect(4)/2, 2);
                        Screen('DrawLine', mywindow, black, screenRect(3)/2, ((screenRect(4)/2)-(10*scale_res(2))), screenRect(3)/2, ((screenRect(4)/2)+(10*scale_res(2))), 2);
                        Screen('Flip', mywindow);
                        %self_dec+fix1_list(k)+infodur+fix2_list(k)+partner_dec1+partner_dec2+fix3_list(k)+affdur) < fix4_list(k) %timing loop
                        while GetSecs - (eventsecs+delayt+self_dec+fix1_list(k)+infodur+fix2_list(k)+partner_dec1+partner_dec2) < fix3_list(k)+affdur+fix4_list(k) %timing loop
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
                    else
                        Screen('DrawLine', mywindow, black, ((screenRect(3)/2)-(10*scale_res(1))), screenRect(4)/2, ((screenRect(3)/2)+(10*scale_res(1))), screenRect(4)/2, 2);
                        Screen('DrawLine', mywindow, black, screenRect(3)/2, ((screenRect(4)/2)-(10*scale_res(2))), screenRect(3)/2, ((screenRect(4)/2)+(10*scale_res(2))), 2);
                        Screen('Flip', mywindow);
                        while GetSecs - (eventsecs+delayt+self_dec+fix1_list(k)+infodur+fix2_list(k)+partner_dec1+partner_dec2) < fix3_list(k) %timing loop
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
                        
                        %% Affective Feedback
                        if stimaff
                            ss.tacs(amplitude,stimElectrode,transition,duration,frequency);
                            WaitSecs(0.250);
                        end
                        if soc_win(k)
                            msg = num2str(choice);
                            mcolor = black;
                            point_total = point_total + choice;
                            Screen('DrawTexture', mywindow, FBpos_texture, [], FB_rect);
                        else
                            msg = num2str(choice);
                            mcolor = black;
                            Screen('DrawTexture', mywindow, FBneg_texture, [], FB_rect);
                        end
                        Screen('TextStyle', mywindow, 0);
                        Screen('TextSize', mywindow, 80);
                        [normBoundsRect, ~] = Screen('TextBounds', mywindow, msg);
                        Screen('DrawText', mywindow, msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert-(normBoundsRect(4)/2)), mcolor);
                        Screen('Flip', mywindow);
                        
                        aff_onset = GetSecs - startsecs;
                        while GetSecs - (eventsecs+delayt+self_dec+fix1_list(k)+infodur+fix2_list(k)+partner_dec1+partner_dec2+fix3_list(k)) < affdur %timing loop
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
                        
                        
                        %% Fixation #4
                        Screen('DrawLine', mywindow, black, ((screenRect(3)/2)-(10*scale_res(1))), screenRect(4)/2, ((screenRect(3)/2)+(10*scale_res(1))), screenRect(4)/2, 2);
                        Screen('DrawLine', mywindow, black, screenRect(3)/2, ((screenRect(4)/2)-(10*scale_res(2))), screenRect(3)/2, ((screenRect(4)/2)+(10*scale_res(2))), 2);
                        Screen('Flip', mywindow);
                        while GetSecs - (eventsecs+delayt+self_dec+fix1_list(k)+infodur+fix2_list(k)+partner_dec1+partner_dec2+fix3_list(k)+affdur) < fix4_list(k) %timing loop
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
                    end
                end
                
                
            elseif is_catch(k) == 1 %inf only with rating
                
                words = Shuffle(words);
                %CHOICE PHASE
                deckorder = deckorders(ceil(rand*2),:);
                %deckorder = deckorders(1,:);
                eval(['left_card_val = deck' num2str(deckorder(1)) '(k);'])
                eval(['right_card_val = deck' num2str(deckorder(2)) '(k);'])
                eval(['left_card_color = scan' num2str(deckorder(1)) '_texture;']) %deck1_color
                eval(['right_card_color = scan' num2str(deckorder(2)) '_texture;']) %deck1_color
                
                %Screen('DrawTexture', mywindowPointer, texturePointer [,sourceRect] [,destinationRect] [,rotationAngle] [, filterMode] [, globalAlpha] [, modulateColor] [, textureShader] [, specialFlags] [, auxParameters]);
                %Screen('FillRect', mywindowPtr [,color] [,rect] )
                Screen('DrawTexture', mywindow, left_card_color, [], LeftRect);
                Screen('DrawTexture', mywindow, right_card_color, [], RightRect);
                Screen('Flip', mywindow);
                choice_onset = GetSecs - startsecs;
                RT1_start = GetSecs; %start RT clock
                
                Screen('DrawTexture', mywindow, left_card_color, [], LeftRect);
                Screen('DrawTexture', mywindow, right_card_color, [], RightRect);
                
                %%%MAKE CHOICE%%%
                press = 0;
                while ~press
                    [~, ~, responsecode] = KbCheck; %Keyboard input
                    if GetSecs - (eventsecs+delayt) > self_dec
                        Screen('Flip', mywindow);
                        msg = 'Respond faster!';
                        Screen('TextStyle', mywindow, 0);
                        Screen('TextSize', mywindow, 40);
                        [normBoundsRect, ~] = Screen('TextBounds', mywindow, msg);
                        Screen('DrawText', mywindow, msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert-(normBoundsRect(4)/2)), black);
                        Screen('Flip', mywindow);
                        lapse1 = 1;
                        press = 1;
                        choice = 0;
                        deckchoice = 0;
                        WaitSecs(.5);
                    else
                        if find(responsecode) == L_arrow %LEFT
                            Screen('FrameRect',mywindow,red,LeftRect2,5);
                            RT1 = GetSecs - RT1_start;
                            press = 1;
                            Screen('Flip', mywindow);
                            press1_onset = GetSecs - startsecs;
                            deckchoice = deckorder(1);
                            choice = left_card_val;
                        elseif find(responsecode) == R_arrow %RIGHT
                            Screen('FrameRect',mywindow,red,RightRect2,5);
                            RT1 = GetSecs - RT1_start;
                            press = 1;
                            press1_onset = GetSecs - startsecs;
                            Screen('Flip', mywindow);
                            deckchoice = deckorder(2);
                            choice = right_card_val;
                        elseif find(responsecode) == esc_key
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
                end
                WaitSecs(.5);
                
                %% Fixation 1
                Screen('DrawLine', mywindow, black, ((screenRect(3)/2)-(10*scale_res(1))), screenRect(4)/2, ((screenRect(3)/2)+(10*scale_res(1))), screenRect(4)/2, 2);
                Screen('DrawLine', mywindow, black, screenRect(3)/2, ((screenRect(4)/2)-(10*scale_res(2))), screenRect(3)/2, ((screenRect(4)/2)+(10*scale_res(2))), 2);
                Screen('Flip', mywindow);
                while GetSecs - (eventsecs+delayt+self_dec) < fix1_list(k) %timing loop
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
                
                %% Informative Feedback
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
                
                %% Fixation 2
                Screen('DrawLine', mywindow, black, ((screenRect(3)/2)-(10*scale_res(1))), screenRect(4)/2, ((screenRect(3)/2)+(10*scale_res(1))), screenRect(4)/2, 2);
                Screen('DrawLine', mywindow, black, screenRect(3)/2, ((screenRect(4)/2)-(10*scale_res(2))), screenRect(3)/2, ((screenRect(4)/2)+(10*scale_res(2))), 2);
                Screen('Flip', mywindow);
                while GetSecs - (eventsecs+delayt+self_dec+fix1_list(k)+infodur) < fix2_list(k) %timing loop
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
                
                
                %%--DRAW SLIDER
                Screen('TextSize', mywindow, floor((30*scale_res(2))));
                bid_msg = sprintf('Indicate to what extent you feel this way right now:');
                [normBoundsRect, ~] = Screen('TextBounds', mywindow, bid_msg);
                Screen('DrawText', mywindow, bid_msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert-(normBoundsRect(4)/2)), black);
                w = sprintf('%s',words{1});
                [normBoundsRect, ~] = Screen('TextBounds', mywindow, w);
                Screen('TextStyle', mywindow, 1);
                Screen('DrawText', mywindow, w, (centerhoriz-(normBoundsRect(3)/2)), (centervert+30), black);
                Screen('TextStyle', mywindow, 0);
                CenterSpotHor = centerhoriz;
                CenterSpotVert = centervert+190;
                value = 0;
                oval_rect = [CenterSpotHor-10 CenterSpotVert-10 CenterSpotHor+10 CenterSpotVert+10];
                xRad_O = 10; % size of the oval (pixels)
                yRad_O = xRad_O;
                %Screen('TextSize', mywindow, 30);
                Screen('TextFont', mywindow, 'Helvetica');
                Screen('TextStyle', mywindow, 0);
                Screen('TextSize', mywindow, 25);
                value_msg = sprintf('%.2g ',value);
                [normBoundsRect, ~] = Screen('TextBounds', mywindow, value_msg);
                Screen('DrawText', mywindow, value_msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert+(155)), black);
                Screen('FillOval', mywindow, black, oval_rect );
                draw_scale;
                Screen('Flip', mywindow);
                
                Screen('TextSize', mywindow, floor((30*scale_res(2))));
                bid_msg = sprintf('Indicate to what extent you feel this way right now:');
                [normBoundsRect, ~] = Screen('TextBounds', mywindow, bid_msg);
                Screen('DrawText', mywindow, bid_msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert-(normBoundsRect(4)/2)), black);
                w = sprintf('%s',words{1});
                [normBoundsRect, ~] = Screen('TextBounds', mywindow, w);
                Screen('TextStyle', mywindow, 1);
                Screen('DrawText', mywindow, w, (centerhoriz-(normBoundsRect(3)/2)), (centervert+30), black);
                Screen('TextStyle', mywindow, 0);
                fix_color = black;
                text_color = black;
                keep_going = 1;
                while keep_going
                    [~, ~, responsecode] = KbCheck; %Keyboard input
                    if find(responsecode) == L_arrow %LEFT
                        if oval_rect(3) == low_end(1)
                            fix_color = white;
                            keep_going = 0;
                            text_color = green;
                        else
                            fix_color = black;
                            oval_rect(1) = oval_rect(1) - 1;
                            oval_rect(3) = oval_rect(3) - 1;
                            value = value - .05;
                            text_color = black;
                            keep_going = 1;
                        end
                    elseif find(responsecode) == R_arrow %RIGHT
                        if oval_rect(3) == high_end(1)
                            fix_color = white;
                            keep_going = 0;
                            text_color = green;
                        else
                            fix_color = black;
                            oval_rect(1) = oval_rect(1) + 1;
                            oval_rect(3) = oval_rect(3) + 1;
                            value = value + .05;
                            text_color = black;
                            keep_going = 1;
                        end
                    elseif find(responsecode) == D_arrow %Middle
                        if value > 0.05 || value < -0.05
                            fix_color = white;
                            keep_going = 0;
                            text_color = green;
                        else
                            fix_color = black;
                            keep_going = 1;
                            text_color = black;
                        end
                    elseif find(responsecode) == esc_key
                        ListenChar(0);
                        Screen('CloseAll');
                        return
                    end
                    value_msg = sprintf('%.2f',value);
                    [normBoundsRect, ~] = Screen('TextBounds', mywindow, value_msg);
                    Screen('DrawText', mywindow, value_msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert+(155)), text_color);
                    Screen('FillOval', mywindow, fix_color, oval_rect );
                    Screen('TextSize', mywindow, floor((30*scale_res(2))));
                    bid_msg = sprintf('Indicate to what extent you feel this way right now:');
                    [normBoundsRect, ~] = Screen('TextBounds', mywindow, bid_msg);
                    Screen('DrawText', mywindow, bid_msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert-(normBoundsRect(4)/2)), black);
                    w = sprintf('%s',words{1});
                    [normBoundsRect, ~] = Screen('TextBounds', mywindow, w);
                    Screen('TextStyle', mywindow, 1);
                    Screen('DrawText', mywindow, w, (centerhoriz-(normBoundsRect(3)/2)), (centervert+30), black);
                    Screen('TextStyle', mywindow, 0);
                    
                    draw_scale;
                    Screen('Flip', mywindow);
                    %end
                end
                WaitSecs(.50);
                
                %% Fixation 4
                Screen('DrawLine', mywindow, black, ((screenRect(3)/2)-(10*scale_res(1))), screenRect(4)/2, ((screenRect(3)/2)+(10*scale_res(1))), screenRect(4)/2, 2);
                Screen('DrawLine', mywindow, black, screenRect(3)/2, ((screenRect(4)/2)-(10*scale_res(2))), screenRect(3)/2, ((screenRect(4)/2)+(10*scale_res(2))), 2);
                Screen('Flip', mywindow);
                WaitSecs(fix4_list(k));
                
                
                
                
            elseif is_catch(k) == 2 %aff only with rating
                
                words = Shuffle(words);
                %Partner is Deciding
                Screen('DrawTexture', mywindow, partner_texture, [], MiddleRect);
                Screen('TextStyle', mywindow, 0);
                Screen('TextSize', mywindow, 30);
                msg = 'Partner is deciding...';
                [normBoundsRect, ~] = Screen('TextBounds', mywindow, msg);
                Screen('DrawText', mywindow, msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert-(180*scale_res(2))), black);
                Screen('Flip', mywindow);
                partner_onset = GetSecs - startsecs;
                RT2_start = GetSecs; %start RT clock. add a second.
                while GetSecs - (eventsecs+delayt) < partner_dec1 %timing loop
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
                Screen('DrawTexture', mywindow, partner_texture, [], MiddleRect);
                Screen('TextStyle', mywindow, 0);
                Screen('TextSize', mywindow, 30);
                msg = 'Partner is deciding...';
                [normBoundsRect, ~] = Screen('TextBounds', mywindow, msg);
                Screen('DrawText', mywindow, msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert-(180*scale_res(2))), black);
                Screen('TextStyle', mywindow, 1);
                msg = 'Press any button to see whether you won or loss.';
                [normBoundsRect, ~] = Screen('TextBounds', mywindow, msg);
                Screen('DrawText', mywindow, msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert+(120*scale_res(2))), black);
                Screen('TextStyle', mywindow, 0);
                Screen('Flip', mywindow);
                
                
                Screen('DrawTexture', mywindow, partner_texture, [], MiddleRect);
                Screen('TextStyle', mywindow, 0);
                Screen('TextSize', mywindow, 30);
                msg = 'Partner is deciding...';
                [normBoundsRect, ~] = Screen('TextBounds', mywindow, msg);
                Screen('DrawText', mywindow, msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert-(180*scale_res(2))), black);
                Screen('TextStyle', mywindow, 1);
                msg = 'Press any button to see whether you won or loss.';
                [normBoundsRect, ~] = Screen('TextBounds', mywindow, msg);
                Screen('DrawText', mywindow, msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert+(120*scale_res(2))), black);
                Screen('TextStyle', mywindow, 0);
                
                press = 0;
                while ~press
                    [~, ~, responsecode] = KbCheck; %Keyboard input
                    if GetSecs - (eventsecs+delayt+partner_dec1) > partner_dec2
                        Screen('Flip', mywindow);
                        msg = 'Respond faster!';
                        Screen('TextStyle', mywindow, 0);
                        Screen('TextSize', mywindow, 40);
                        [normBoundsRect, ~] = Screen('TextBounds', mywindow, msg);
                        Screen('DrawText', mywindow, msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert-(normBoundsRect(4)/2)), black);
                        Screen('Flip', mywindow);
                        lapse2 = 1;
                        press = 1;
                        WaitSecs(.5);
                    else
                        if find(responsecode) == L_arrow | find(responsecode) == R_arrow | find(responsecode) == D_arrow
                            Screen('FrameRect',mywindow,red,MiddleRect,5);
                            RT2 = GetSecs - RT2_start;
                            press = 1;
                            press2_onset = GetSecs - startsecs;
                            Screen('Flip', mywindow);
                        elseif find(responsecode) == esc_key
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
                end
                WaitSecs(.5);
                
                
                %% Fixation #3
                if lapse2
                    Screen('DrawLine', mywindow, black, ((screenRect(3)/2)-(10*scale_res(1))), screenRect(4)/2, ((screenRect(3)/2)+(10*scale_res(1))), screenRect(4)/2, 2);
                    Screen('DrawLine', mywindow, black, screenRect(3)/2, ((screenRect(4)/2)-(10*scale_res(2))), screenRect(3)/2, ((screenRect(4)/2)+(10*scale_res(2))), 2);
                    Screen('Flip', mywindow);
                    while GetSecs - (eventsecs+delayt+partner_dec1+partner_dec2) < fix3_list(k)+affdur+fix4_list(k) %timing loop
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
                else
                    Screen('DrawLine', mywindow, black, ((screenRect(3)/2)-(10*scale_res(1))), screenRect(4)/2, ((screenRect(3)/2)+(10*scale_res(1))), screenRect(4)/2, 2);
                    Screen('DrawLine', mywindow, black, screenRect(3)/2, ((screenRect(4)/2)-(10*scale_res(2))), screenRect(3)/2, ((screenRect(4)/2)+(10*scale_res(2))), 2);
                    Screen('Flip', mywindow);
                    while GetSecs - (eventsecs+delayt+partner_dec1+partner_dec2) < fix3_list(k) %timing loop
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
                    %% Affective Feedback
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
                    if soc_win(k)
                        msg = num2str(choice);
                        point_total = point_total + choice;
                        Screen('DrawTexture', mywindow, FBpos_texture, [], FB_rect);
                    else
                        msg = num2str(choice);
                        Screen('DrawTexture', mywindow, FBneg_texture, [], FB_rect);
                    end
                    Screen('TextStyle', mywindow, 0);
                    Screen('TextSize', mywindow, 80);
                    [normBoundsRect, ~] = Screen('TextBounds', mywindow, msg);
                        Screen('DrawText', mywindow, msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert-(normBoundsRect(4)/2)), black);
                    Screen('Flip', mywindow);
                    aff_onset = GetSecs - startsecs;
                    while GetSecs - (eventsecs+delayt+partner_dec1+partner_dec2+fix3_list(k)) < affdur %timing loop
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
                    
                    %%--DRAW SLIDER
                    Screen('TextSize', mywindow, floor((30*scale_res(2))));
                    bid_msg = sprintf('Indicate to what extent you feel this way right now:');
                    [normBoundsRect, ~] = Screen('TextBounds', mywindow, bid_msg);
                    Screen('DrawText', mywindow, bid_msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert-(normBoundsRect(4)/2)), black);
                    w = sprintf('%s',words{1});
                    [normBoundsRect, ~] = Screen('TextBounds', mywindow, w);
                    Screen('TextStyle', mywindow, 1);
                    Screen('DrawText', mywindow, w, (centerhoriz-(normBoundsRect(3)/2)), (centervert+30), black);
                    Screen('TextStyle', mywindow, 0);
                    CenterSpotHor = centerhoriz;
                    CenterSpotVert = centervert+190;
                    value = 0;
                    oval_rect = [CenterSpotHor-10 CenterSpotVert-10 CenterSpotHor+10 CenterSpotVert+10];
                    xRad_O = 10; % size of the oval (pixels)
                    yRad_O = xRad_O;
                    %Screen('TextSize', mywindow, 30);
                    Screen('TextFont', mywindow, 'Helvetica');
                    Screen('TextStyle', mywindow, 0);
                    Screen('TextSize', mywindow, 25);
                    value_msg = sprintf('%.2g ',value);
                    [normBoundsRect, ~] = Screen('TextBounds', mywindow, value_msg);
                    Screen('DrawText', mywindow, value_msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert+(155)), black);
                    Screen('FillOval', mywindow, black, oval_rect );
                    draw_scale;
                    Screen('Flip', mywindow);
                    
                    Screen('TextSize', mywindow, floor((30*scale_res(2))));
                    bid_msg = sprintf('Indicate to what extent you feel this way right now:');
                    [normBoundsRect, ~] = Screen('TextBounds', mywindow, bid_msg);
                    Screen('DrawText', mywindow, bid_msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert-(normBoundsRect(4)/2)), black);
                    w = sprintf('%s',words{1});
                    [normBoundsRect, ~] = Screen('TextBounds', mywindow, w);
                    Screen('TextStyle', mywindow, 1);
                    Screen('DrawText', mywindow, w, (centerhoriz-(normBoundsRect(3)/2)), (centervert+30), black);
                    Screen('TextStyle', mywindow, 0);
                    fix_color = black;
                    text_color = black;
                    keep_going = 1;
                    while keep_going
                        [~, ~, responsecode] = KbCheck; %Keyboard input
                        if find(responsecode) == L_arrow %LEFT
                            if oval_rect(3) == low_end(1)
                                fix_color = white;
                                keep_going = 0;
                                text_color = green;
                            else
                                fix_color = black;
                                oval_rect(1) = oval_rect(1) - 1;
                                oval_rect(3) = oval_rect(3) - 1;
                                value = value - .05;
                                text_color = black;
                                keep_going = 1;
                            end
                        elseif find(responsecode) == R_arrow %RIGHT
                            if oval_rect(3) == high_end(1)
                                fix_color = white;
                                keep_going = 0;
                                text_color = green;
                            else
                                fix_color = black;
                                oval_rect(1) = oval_rect(1) + 1;
                                oval_rect(3) = oval_rect(3) + 1;
                                value = value + .05;
                                text_color = black;
                                keep_going = 1;
                            end
                        elseif find(responsecode) == D_arrow %Middle
                            if value > 0.05 || value < -0.05
                                fix_color = white;
                                keep_going = 0;
                                text_color = green;
                            else
                                fix_color = black;
                                keep_going = 1;
                                text_color = black;
                            end
                        elseif find(responsecode) == esc_key
                            ListenChar(0);
                            Screen('CloseAll');
                            return
                        end
                        value_msg = sprintf('%.2f',value);
                        [normBoundsRect, ~] = Screen('TextBounds', mywindow, value_msg);
                        Screen('DrawText', mywindow, value_msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert+(155)), text_color);
                        Screen('FillOval', mywindow, fix_color, oval_rect );
                        Screen('TextSize', mywindow, floor((30*scale_res(2))));
                        bid_msg = sprintf('Indicate to what extent you feel this way right now:');
                        [normBoundsRect, ~] = Screen('TextBounds', mywindow, bid_msg);
                        Screen('DrawText', mywindow, bid_msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert-(normBoundsRect(4)/2)), black);
                        w = sprintf('%s',words{1});
                        [normBoundsRect, ~] = Screen('TextBounds', mywindow, w);
                        Screen('TextStyle', mywindow, 1);
                        Screen('DrawText', mywindow, w, (centerhoriz-(normBoundsRect(3)/2)), (centervert+30), black);
                        Screen('TextStyle', mywindow, 0);
                        
                        draw_scale;
                        Screen('Flip', mywindow);
                        %end
                    end
                    WaitSecs(.50);
                    
                    %% Fixation 4
                    Screen('DrawLine', mywindow, black, ((screenRect(3)/2)-(10*scale_res(1))), screenRect(4)/2, ((screenRect(3)/2)+(10*scale_res(1))), screenRect(4)/2, 2);
                    Screen('DrawLine', mywindow, black, screenRect(3)/2, ((screenRect(4)/2)-(10*scale_res(2))), screenRect(3)/2, ((screenRect(4)/2)+(10*scale_res(2))), 2);
                    Screen('Flip', mywindow);
                    WaitSecs(fix4_list(k));
                    
                    
                end
            end
            
            %% Save data here%%%
            data(k).Npoints = choice; %information / points. input to learning model
            data(k).lapse1 = lapse1;
            data(k).lapse2 = lapse2;
            data(k).deckchoice = deckchoice;
            data(k).RT1 = RT1;
            data(k).RT2 = RT2;
            data(k).choice_onset = choice_onset;
            data(k).press1_onset = press1_onset;
            data(k).info_onset = info_onset;
            data(k).partner_onset = partner_onset;
            data(k).press2_onset = press2_onset;
            data(k).aff_onset = aff_onset;
            data(k).fix1_list = fix1_list(k);
            data(k).fix2_list = fix2_list(k);
            data(k).fix3_list = fix3_list(k);
            data(k).fix4_list = fix4_list(k);
            data(k).soc_win = soc_win(k); % win or lose the points
            data(k).block = block;
            data(k).duration = duration;
            data(k).frequency = frequency;
            data(k).stimaff = stimaff;
            data(k).stiminf = stiminf;
            data(k).point_total = point_total;
            data(k).word = words{1};
            data(k).rating = value;
            data(k).is_catch = is_catch(k);
        end
        WaitSecs(2); %wait 4 seconds at the end to let last feedback HRF return to baseline.
        run_time = GetSecs - startsecs;
        save(outputname, 'data','run_time');
    end
    
    msg = sprintf('Good job! You won %d points!', point_total);
    [normBoundsRect, ~] = Screen('TextBounds', mywindow, msg);
    Screen('DrawText', mywindow, msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert-(normBoundsRect(4)/2)), black);
    Screen('Flip', mywindow);
    
    go = 1;
    while go
        [keyIsDown, ~, keyCode] = KbCheck; %Keyboard input
        keyCode = find(keyCode);
        if keyIsDown == 1
            if keyCode(1) == go_button
                go = 0;
            end
            if keyCode(1) == esc_key %esc to close
                Screen('CloseAll');
                return;
            end
        end
    end
    
    
    sca;
    task_dur = GetSecs - ExpStartTime;
    task_dur_info = fullfile(outputdir, [subjectnum '_TaskDuration.mat']);
    save(task_dur_info, 'task_dur','task_dur');
    ss.stop;
    % Probably a good idea to save the impedances with the rest of our data.
    ss.z
    ss.zTime
    
catch ME
    disp(ME.message);
    sca;
    keyboard
    ss.stop;
    % Probably a good idea to save the impedances with the rest of our data.
    ss.z
    ss.zTime
    keyboard
end



