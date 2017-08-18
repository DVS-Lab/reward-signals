function TwoArmedBandit_BehavPilot_prac(subjectnum)

if ~ischar(subjectnum)
    subjectnum = num2str(subjectnum);
end
Screen('Preference', 'SkipSyncTests', 1);


RandStream.setGlobalStream(RandStream('mt19937ar','seed',sum(100*clock)));
PsychDefaultSetup(2);
try
    
    %% Initialize PTB
    %load all rects/mywindows and set up texturs
    %initialize_PTB;
    %defining some colors for later
    black = [0 0 0];
    white = [255 255 255];
    red = [255 0 0];
    green = [0 255 0];
    
    %KbName('UnifyKeyNames'); %redundant with PsychDefaultSetup(2)
    L_arrow = KbName('LeftArrow');
    D_arrow = KbName('DownArrow');
    R_arrow = KbName('RightArrow');
    esc_key = KbName('ESCAPE');
    space_key = KbName('space');
    go_button = space_key;
    
    %%%Make outputdir if it does not already exist%%%
    maindir = pwd;
    outputdir = fullfile(maindir,'BehavioralData',subjectnum);
    if ~exist(outputdir,'dir')
        mkdir(outputdir);
    end
    
    %setting up the screens
    %[mywindow,screenRect] = Screen('Openmywindow', 0, gray, [], 32);
    
    
    % Get the screen numbers
    screens = Screen('Screens');
    screenNumber = max(screens);
    
    % set color scalars. assume white is 1
    grey = 1 * 0.667;
    % Open an on screen mywindow and color it grey
    [mywindow, screenRect] = PsychImaging('Openwindow', screenNumber, grey);
    Screen('BlendFunction', mywindow, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    HideCursor;
    
    centerhoriz = screenRect(3)/2;
    centervert = screenRect(4)/2;
    scale_res = [1 1];
    
    %%%set image and rect sizes%%%
    above_fixation = (15*scale_res(2));
    scale_pic_size = 1.2; % 1 keeps original. < 1 makes it smaller. > 1 makes it bigger
    xDim_F = (200*scale_res(1))*scale_pic_size; % size of the squares (pixels)
    yDim_F = xDim_F;
    moveleft = -200;
    moveright = 200;
    LeftRect = [(screenRect(3)/2-xDim_F/2)+moveleft ((screenRect(4)/2-yDim_F/2)-above_fixation) (screenRect(3)/2+xDim_F/2)+moveleft ((screenRect(4)/2+yDim_F/2)-above_fixation)];
    RightRect = [(screenRect(3)/2-xDim_F/2)+moveright ((screenRect(4)/2-yDim_F/2)-above_fixation) (screenRect(3)/2+xDim_F/2)+moveright ((screenRect(4)/2+yDim_F/2)-above_fixation)];
    MiddleRect = [(screenRect(3)/2-xDim_F/2) (screenRect(4)/2-yDim_F/2)-above_fixation (screenRect(3)/2+xDim_F/2) (screenRect(4)/2+yDim_F/2)-above_fixation];
    
    xDim_F = (225*scale_res(1))*scale_pic_size; % size of the squares (pixels)
    yDim_F = xDim_F;
    moveleft = -200;
    moveright = 200;
    LeftRect2 = [(screenRect(3)/2-xDim_F/2)+moveleft ((screenRect(4)/2-yDim_F/2)-above_fixation) (screenRect(3)/2+xDim_F/2)+moveleft ((screenRect(4)/2+yDim_F/2)-above_fixation)];
    RightRect2 = [(screenRect(3)/2-xDim_F/2)+moveright ((screenRect(4)/2-yDim_F/2)-above_fixation) (screenRect(3)/2+xDim_F/2)+moveright ((screenRect(4)/2+yDim_F/2)-above_fixation)];
    
    
    [imagename, ~, ~] = imread(fullfile(maindir,'cropped_imgs','apple.jpg'));
    comp_texture = Screen('MakeTexture', mywindow, imagename);
    
    
    
    %% Set all Trial Information
    %trial info is here. timing, values, etc...
    %set_trials;
    ntrials = 10;
    
    %timing -- FIX ME
    fix1_list = [repmat(1.5,1,25) repmat(2.75,1,15) repmat(4,1,10)];
    fix2_list = [repmat(1.5,1,25) repmat(2.75,1,15) repmat(4,1,10)];
    fix3_list = [repmat(1.5,1,25) repmat(2.75,1,15) repmat(4,1,10)];
    fix4_list = [ones(1,30) repmat(2,1,15) repmat(3,1,5)];
    partner_dec1 = 0.50;
    partner_dec2 = 2;
    self_dec = 2.5;
    infodur = 1.5;
    affdur = 1.5;
    
    words = {'interested','distressed','excited','upset','attentive', ...
        'strong','guilty','scared','hostile','jittery', ...
        'enthusiastic','proud','irritable','alert','active',...
        'ashamed','inspired','nervous','determined','afraid'};
    
    words = Shuffle(words);
    
    
    
    %build trials
    soc_win = [ones(1,ntrials/2) zeros(1,ntrials/2)];
    is_catch = [1 2 zeros(1,8)];
    
    
    %distribute points
    deck1 = zeros(ntrials,1);
    deck2 = zeros(ntrials,1);
    for t = 1:ntrials
        p1 = round(normrnd(4,1.25));
        p2 = round(normrnd(6,1.25));
        if p1 <= 0; p1 = 1; elseif p1 > 9; p1 = 9; end
        if p2 <= 0; p2 = 1; elseif p2 > 9; p2 = 9; end
        deck1(t,1) = p1;
        deck2(t,1) = p2;
    end
    
    [imagename, ~, alpha] = imread(fullfile(maindir,'cropped_imgs','star.png'));
    imagename(:,:,4) = alpha(:,:);
    scan1_texture = Screen('MakeTexture', mywindow, imagename);
    [imagename, ~, alpha] = imread(fullfile(maindir,'cropped_imgs','pentagon.png'));
    imagename(:,:,4) = alpha(:,:);
    scan2_texture = Screen('MakeTexture', mywindow, imagename);
    
    
    stimaff = 0;
    stiminf = 0;
    
    
    fix1_list = Shuffle(fix1_list);
    fix2_list = Shuffle(fix2_list);
    fix3_list = Shuffle(fix3_list);
    fix4_list = Shuffle(fix4_list);
    soc_win = Shuffle(soc_win);
    is_catch = Shuffle(is_catch);
    
    type = 'Computer';
    partner_texture = comp_texture;
    msg1 = 'Short Practice';
    
    deckorders = [1 2; 2 1];
    Screen('TextSize', mywindow, floor((30*scale_res(2))));
    Screen('TextFont', mywindow, 'Helvetica');
    
    % oldStyle=Screen('TextStyle', mywindowPtr [,style]);
    % [,style] could be 0=normal,1=bold,2=italic,4=underline,8=outline,32=condense,64=extend.
    Screen('TextStyle', mywindow, 0);
    
    longest_msg = 'Choose the option that is most likely to yield more points.';
    [normBoundsRect, ~] = Screen('TextBounds', mywindow, longest_msg);
    
    %%%Setting the intro screen%%%
    Screen('TextSize', mywindow, floor((25*scale_res(2))));
    Screen('TextStyle', mywindow, 1);
    Screen('DrawText', mywindow, msg1, (centerhoriz-(normBoundsRect(3)/2)), (centervert-(90*scale_res(2))), black);
    Screen('TextStyle', mywindow, 0);
    Screen('DrawText', mywindow, 'On each trial, you will see two options.', (centerhoriz-(normBoundsRect(3)/2)), (centervert-(35*scale_res(2))), black);
    Screen('DrawText', mywindow, longest_msg, (centerhoriz-(normBoundsRect(3)/2)), centervert, black);
    Screen('DrawText', mywindow, 'Win as many points as you can so you can leave with money.', (centerhoriz-(normBoundsRect(3)/2)), (centervert+(35*scale_res(2))), black);
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
    point_total = 0;
    outputname = fullfile(outputdir, [subjectnum '_' type 'feedback_practice.mat']);
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
            %% CHOICE PHASE
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
                    WaitSecs(.25);
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
                Screen('DrawText', mywindow, msg, (centerhoriz-(normBoundsRect(3)/2)), centervert, black);
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
                        Screen('DrawText', mywindow, msg, (centerhoriz-(normBoundsRect(3)/2)), centervert, black);
                        Screen('Flip', mywindow);
                        lapse2 = 1;
                        press = 1;
                        WaitSecs(.5);
                    else
                        if find(responsecode) == L_arrow | find(responsecode) == R_arrow
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
                        msg = ['+' num2str(choice)];
                        mcolor = green;
                        point_total = point_total + choice;
                    else
                        msg = num2str(choice);
                        mcolor = black;
                    end
                    Screen('TextStyle', mywindow, 0);
                    Screen('TextSize', mywindow, 80);
                    [normBoundsRect, ~] = Screen('TextBounds', mywindow, msg);
                    Screen('DrawText', mywindow, msg, (centerhoriz-(normBoundsRect(3)/2)), centervert, mcolor);
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
            %% CHOICE PHASE
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
                    WaitSecs(.25);
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
            
            %% Informative Feedback
            if stiminf
                ss.tacs(amplitude,stimElectrode,transition,duration,frequency);
                WaitSecs(0.250);
            end
            msg = num2str(choice);
            Screen('TextStyle', mywindow, 0);
            Screen('TextSize', mywindow, 80);
            [normBoundsRect, ~] = Screen('TextBounds', mywindow, msg);
            Screen('DrawText', mywindow, msg, (centerhoriz-(normBoundsRect(3)/2)), centervert, black);
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
            
            %%--DRAW SLIDER
            Screen('TextSize', mywindow, floor((30*scale_res(2))));
            bid_msg = sprintf('Indicate to what extent you feel this way right now:');
            [normBoundsRect, notused] = Screen('TextBounds', mywindow, bid_msg);
            Screen('DrawText', mywindow, bid_msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert-(normBoundsRect(4)/2)), black);
            w = sprintf('%s',words{1});
            [normBoundsRect, notused] = Screen('TextBounds', mywindow, w);
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
            [normBoundsRect, notused] = Screen('TextBounds', mywindow, bid_msg);
            Screen('DrawText', mywindow, bid_msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert-(normBoundsRect(4)/2)), black);
            w = sprintf('%s',words{1});
            [normBoundsRect, notused] = Screen('TextBounds', mywindow, w);
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
                [normBoundsRect, notused] = Screen('TextBounds', mywindow, bid_msg);
                Screen('DrawText', mywindow, bid_msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert-(normBoundsRect(4)/2)), black);
                w = sprintf('%s',words{1});
                [normBoundsRect, notused] = Screen('TextBounds', mywindow, w);
                Screen('TextStyle', mywindow, 1);
                Screen('DrawText', mywindow, w, (centerhoriz-(normBoundsRect(3)/2)), (centervert+30), black);
                Screen('TextStyle', mywindow, 0);
                
                draw_scale;
                Screen('Flip', mywindow);
                %end
            end
            WaitSecs(.750);
            
            
            
        elseif is_catch(k) == 2 %aff only with rating
            words = Shuffle(words);
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
                    Screen('DrawText', mywindow, msg, (centerhoriz-(normBoundsRect(3)/2)), centervert, black);
                    Screen('Flip', mywindow);
                    lapse2 = 1;
                    press = 1;
                    WaitSecs(.5);
                else
                    if find(responsecode) == L_arrow | find(responsecode) == R_arrow
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
                if soc_win(k)
                    msg = ['+' num2str(choice)];
                    mcolor = green;
                    point_total = point_total + choice;
                else
                    msg = num2str(choice);
                    mcolor = black;
                end
                Screen('TextStyle', mywindow, 0);
                Screen('TextSize', mywindow, 80);
                [normBoundsRect, ~] = Screen('TextBounds', mywindow, msg);
                Screen('DrawText', mywindow, msg, (centerhoriz-(normBoundsRect(3)/2)), centervert, mcolor);
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
                [normBoundsRect, notused] = Screen('TextBounds', mywindow, bid_msg);
                Screen('DrawText', mywindow, bid_msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert-(normBoundsRect(4)/2)), black);
                w = sprintf('%s',words{1});
                [normBoundsRect, notused] = Screen('TextBounds', mywindow, w);
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
                [normBoundsRect, notused] = Screen('TextBounds', mywindow, bid_msg);
                Screen('DrawText', mywindow, bid_msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert-(normBoundsRect(4)/2)), black);
                w = sprintf('%s',words{1});
                [normBoundsRect, notused] = Screen('TextBounds', mywindow, w);
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
                    [normBoundsRect, notused] = Screen('TextBounds', mywindow, bid_msg);
                    Screen('DrawText', mywindow, bid_msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert-(normBoundsRect(4)/2)), black);
                    w = sprintf('%s',words{1});
                    [normBoundsRect, notused] = Screen('TextBounds', mywindow, w);
                    Screen('TextStyle', mywindow, 1);
                    Screen('DrawText', mywindow, w, (centerhoriz-(normBoundsRect(3)/2)), (centervert+30), black);
                    Screen('TextStyle', mywindow, 0);
                    
                    draw_scale;
                    Screen('Flip', mywindow);
                    %end
                end
                WaitSecs(.750);
                
                
            end
        end
        
        %% Save data here%%%
        data(k).Npoints = choice; %information / points. input to learning model
        data(k).lapse1 = lapse1;
        data(k).lapse2 = lapse2;
        data(k).deckorder = deckorder;
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
        data(k).word = words{1};
        data(k).rating = value;
        data(k).is_catch = is_catch(k);
    end
    WaitSecs(2); %wait 4 seconds at the end to let last feedback HRF return to baseline.
    save(outputname, 'data');
    sca;
    
    
    
catch ME
    disp(ME.message);
    sca;
    
    keyboard
end



