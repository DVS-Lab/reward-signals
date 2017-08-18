function TwoArmedBandit_StimPilot(subjectnum,cbtype,whichhuman)

if ~ischar(subjectnum)
    subjectnum = num2str(subjectnum);
end

for block = 1:8
    % real trials blocks 1-4 (will randomize of course)
    if block == 1
        frequency = 55;
        duration = 1750;
        stimaff = 1;
        stiminf = 0;
    elseif block == 2
        frequency = 55;
        duration = 1750;
        stimaff = 0;
        stiminf = 1;
    elseif block == 3
        frequency = 110;
        duration = 1750;
        stimaff = 1;
        stiminf = 0;
    elseif block == 4
        frequency = 110;
        duration = 1750;
        stimaff = 0;
        stiminf = 1;
        % sham trials blocks 5-6 (will randomize of course)
    elseif block == 5
        frequency = 55;
        duration = 500;
        stimaff = 1;
        stiminf = 0;
    elseif block == 6
        frequency = 55;
        duration = 500;
        stimaff = 0;
        stiminf = 1;
    elseif block == 7
        frequency = 110;
        duration = 500;
        stimaff = 1;
        stiminf = 0;
    elseif block == 8
        frequency = 110;
        duration = 500;
        stimaff = 0;
        stiminf = 1;
    end
end

Screen('Preference', 'SkipSyncTests', 1);
if cbtype == 1
    partnerorder = [1 2 1 2];
else
    partnerorder = [2 1 2 1];
end

%rand('state',sum(100*clock));
RandStream.setGlobalStream(RandStream('mt19937ar','seed',sum(100*clock)));
PsychDefaultSetup(2);
ExpStartTime = GetSecs;
try
    
    %% Initialize PTB
    %load all rects/mywindows and set up texturs
    %initialize_PTB;
    %defining some colors for later
    black = [0 0 0];
    white = [255 255 255];
    blue = [0 0 255];
    red = [255 0 0];
    
    %KbName('UnifyKeyNames'); %redundant with PsychDefaultSetup(2)
    L_arrow = KbName('LeftArrow');
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
    
    
    %% Make Textures
    [imagename, ~, alpha] = imread(fullfile(maindir,'cropped_imgs','fixation.png'));
    imagename(:,:,4) = alpha(:,:);
    fix_tex = Screen('MakeTexture', mywindow, imagename);
    
    [imagename, ~, alpha] = imread(fullfile(maindir,'cropped_imgs','FB1_gain.png'));
    imagename(:,:,4) = alpha(:,:);
    FB1G_tex = Screen('MakeTexture', mywindow, imagename);
    [imagename, ~, alpha] = imread(fullfile(maindir,'cropped_imgs','FB1_loss.png'));
    imagename(:,:,4) = alpha(:,:);
    FB1L_tex = Screen('MakeTexture', mywindow, imagename);
    
    [imagename, ~, alpha] = imread(fullfile(maindir,'cropped_imgs','FB2_gain.png'));
    imagename(:,:,4) = alpha(:,:);
    FB2G_tex = Screen('MakeTexture', mywindow, imagename);
    [imagename, ~, alpha] = imread(fullfile(maindir,'cropped_imgs','FB2_loss.png'));
    imagename(:,:,4) = alpha(:,:);
    FB2L_tex = Screen('MakeTexture', mywindow, imagename);
    
    [imagename, ~, alpha] = imread(fullfile(maindir,'cropped_imgs','FB3_gain.png'));
    imagename(:,:,4) = alpha(:,:);
    FB3G_tex = Screen('MakeTexture', mywindow, imagename);
    [imagename, ~, alpha] = imread(fullfile(maindir,'cropped_imgs','FB3_loss.png'));
    imagename(:,:,4) = alpha(:,:);
    FB3L_tex = Screen('MakeTexture', mywindow, imagename);
    
    [imagename, ~, alpha] = imread(fullfile(maindir,'cropped_imgs','FB4_gain.png'));
    imagename(:,:,4) = alpha(:,:);
    FB4G_tex = Screen('MakeTexture', mywindow, imagename);
    [imagename, ~, alpha] = imread(fullfile(maindir,'cropped_imgs','FB4_loss.png'));
    imagename(:,:,4) = alpha(:,:);
    FB4L_tex = Screen('MakeTexture', mywindow, imagename);
    
    %load images
    [imagename, ~, alpha] = imread(fullfile(maindir,'star.png'));
    imagename(:,:,4) = alpha(:,:);
    scan1_texture = Screen('MakeTexture', mywindow, imagename);
    [imagename, ~, alpha] = imread(fullfile(maindir,'pentagon.png'));
    imagename(:,:,4) = alpha(:,:);
    scan2_texture = Screen('MakeTexture', mywindow, imagename);
    
    [imagename, ~, ~] = imread(fullfile(maindir,'cropped_imgs','EunbinKim.jpg'));
    steph_texture = Screen('MakeTexture', mywindow, imagename);
    [imagename, ~, ~] = imread(fullfile(maindir,'cropped_imgs','Dave_thumb.jpg'));
    dave_texture = Screen('MakeTexture', mywindow, imagename);
    [imagename, ~, ~] = imread(fullfile(maindir,'cropped_imgs','apple.jpg'));
    comp_texture = Screen('MakeTexture', mywindow, imagename);
    
    
    
    
    %% Set all Trial Information
    %trial info is here. timing, values, etc...
    %set_trials;
    ntrials = 50;
    needed_points = 195;
    
    %timing
    fix1_list = [repmat(1.5,1,25) repmat(2.75,1,15) repmat(4,1,10)];
    fix2_list = [repmat(1.5,1,25) repmat(2.75,1,15) repmat(4,1,10)];
    fix3_list = [repmat(1.5,1,25) repmat(2.75,1,15) repmat(4,1,10)];
    fix4_list = [ones(1,30) repmat(2,1,15) repmat(3,1,5)];
    partner_dec1 = 0.50;
    partner_dec2 = 2;
    self_dec = 2.5;
    infodur = 1.5;
    affdur = 1.5;
    
    
    highval = ones(1,14) * .8;
    lowval = ones(1,14) * .2;
    deck1 = [highval lowval highval (ones(1,8) * .2)];
    deck2 = [lowval highval lowval (ones(1,8) * .8)];
    
    soc_win = [ones(1,ntrials/2) zeros(1,ntrials/2)];
    
    count = 0;
    tcount = 0;
    point_count = 0;
    for gametype = partnerorder
        count = count + 1;
        
        fix1_list = Shuffle(fix1_list);
        fix2_list = Shuffle(fix2_list);
        fix3_list = Shuffle(fix3_list);
        fix4_list = Shuffle(fix4_list);
        soc_win = Shuffle(soc_win);
        
        
            type = 'Computer';
            partner_texture = comp_texture;
        instruction_msg = sprintf('Run %d of %d', count, length(partnerorder));

        deckorders = [1 2; 2 1];
        Screen('TextSize', mywindow, floor((30*scale_res(2))));
        Screen('TextFont', mywindow, 'Helvetica');
        
        % oldStyle=Screen('TextStyle', mywindowPtr [,style]);
        % [,style] could be 0=normal,1=bold,2=italic,4=underline,8=outline,32=condense,64=extend.
        Screen('TextStyle', mywindow, 0);
        
        %%%Setting the intro screen%%%
        Screen('TextSize', mywindow, floor((25*scale_res(2))));
        longest_msg = instruction_msg;
        [normBoundsRect, ~] = Screen('TextBounds', mywindow, longest_msg);
        Screen('TextStyle', mywindow, 1);
        Screen('DrawText', mywindow, instruction_msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert-(90*scale_res(2))), black);
        Screen('TextStyle', mywindow, 0);
        Screen('DrawText', mywindow, 'On each trial, you will see two options.', (centerhoriz-(normBoundsRect(3)/2)), (centervert-(35*scale_res(2))), black);
        Screen('DrawText', mywindow, 'Choose the option that is most likely to yield reward.', (centerhoriz-(normBoundsRect(3)/2)), centervert, black);
        Screen('DrawText', mywindow, 'Win as much reward as you can leave with money.', (centerhoriz-(normBoundsRect(3)/2)), (centervert+(35*scale_res(2))), black);
        Screen('DrawText', mywindow, 'Task will start soon. Please stay very still.', (centerhoriz-(normBoundsRect(3)/2)), (centervert+(70*scale_res(2))), black);
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
        %%%saving data info%%%
        outputname = fullfile(outputdir, [subjectnum '_' type 'feedback_' num2str(count) '.mat']);
        startsecs = GetSecs;
        for k = 1:ntrials
            tcount = tcount + 1;
            [lapse1, lapse2, RT1, RT2] = deal(0);
            [press1_onset, info_onset, partner_onset, press2_onset, aff_onset] = deal(0);
            %choice_onset is always defined.
            
            eventsecs = GetSecs; %start event clock
            if k == 1
                delayt = 4;
                WaitSecs(delayt);
            else
                delayt = 0;
            end
            
            %% CHOICE PHASE
            deckorder = deckorders(ceil(rand*2),:);
            %deckorder = deckorders(1,:);
            eval(['left_card_val = deck' num2str(deckorder(1)) '(tcount);'])
            eval(['right_card_val = deck' num2str(deckorder(2)) '(tcount);'])
            eval(['left_card_color = scan' num2str(deckorder(1)) '_texture;']) %deck1_color
            eval(['right_card_color = scan' num2str(deckorder(2)) '_texture;']) %deck1_color
            
            %Screen('DrawTexture', mywindowPointer, texturePointer [,sourceRect] [,destinationRect] [,rotationAngle] [, filterMode] [, globalAlpha] [, modulateColor] [, textureShader] [, specialFlags] [, auxParameters]);
            %Screen('FillRect', mywindowPtr [,color] [,rect] )
            Screen('DrawTexture', mywindow, left_card_color, [], LeftRect);
            Screen('DrawTexture', mywindow, right_card_color, [], RightRect);
            %Screen('FrameRect',mywindow,white,LeftRect,5);
            %Screen('FrameRect',mywindow,white,RightRect,5);
            Screen('Flip', mywindow);
            choice_onset = GetSecs - startsecs;
            RT1_start = GetSecs; %start RT clock
            
            Screen('DrawTexture', mywindow, left_card_color, [], LeftRect);
            Screen('DrawTexture', mywindow, right_card_color, [], RightRect);
            %Screen('FrameRect',mywindow,white,LeftRect,5);
            %Screen('FrameRect',mywindow,white,RightRect,5);
            
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
                    Screen('DrawText', mywindow, msg, (centerhoriz-(normBoundsRect(3)/2)), centervert, red);
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
                        choice = left_card_val;
                        Screen('Flip', mywindow);
                        press1_onset = GetSecs - startsecs;
                        deckchoice = deckorder(1);
                    elseif find(responsecode) == R_arrow %RIGHT
                        Screen('FrameRect',mywindow,red,RightRect2,5);
                        RT1 = GetSecs - RT1_start;
                        press = 1;
                        choice = right_card_val;
                        press1_onset = GetSecs - startsecs;
                        Screen('Flip', mywindow);
                        deckchoice = deckorder(2);
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
                Screen('DrawTexture', mywindow, fix_tex, [], MiddleRect);
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
                vname = [num2str(choice) 'G'];
                eval(['FB_tex = FB' vname '_tex;'])
                Screen('DrawTexture', mywindow, FB_tex, [], MiddleRect);
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
                Screen('DrawTexture', mywindow, fix_tex, [], MiddleRect);
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
                        Screen('DrawText', mywindow, msg, (centerhoriz-(normBoundsRect(3)/2)), centervert, red);
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
                    Screen('DrawTexture', mywindow, fix_tex, [], MiddleRect);
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
                    if soc_win(k)
                        vname = [num2str(choice) 'G'];
                        point_count = point_count + choice;
                    else
                        vname = [num2str(choice) 'L'];
                    end
                    eval(['FB_tex = FB' vname '_tex;'])
                    Screen('DrawTexture', mywindow, FB_tex, [], MiddleRect);
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
                    Screen('DrawTexture', mywindow, fix_tex, [], MiddleRect);
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
            
            %% Save data here%%%
            data(k).Npoints = choice; %information / points. input to learning model
            data(k).lapse1 = lapse1;
            data(k).lapse2 = lapse2;
            data(k).deckorder = deckorder;
            data(k).deckchoice = deckchoice;
            data(k).point_count = point_count;
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
            
        end
        WaitSecs(4); %wait 4 seconds at the end to let last feedback HRF return to baseline.
        run_time = GetSecs - startsecs;
        save(outputname, 'data','run_time');
    end
    
    sca;
    task_dur = GetSecs - ExpStartTime;
    task_dur_info = fullfile(outputdir, [subjectnum '_TaskDuration.mat']);
    save(task_dur_info, 'task_dur','task_dur');
    
catch ME
    disp(ME.message);
    sca;
    keyboard
end



