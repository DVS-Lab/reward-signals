function CardTask(subjectnum)
Screen('Preference', 'SkipSyncTests', 1);
%{

TO DO LIST
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


%}


% Converts argument passed to function into a char array if necessary.
if ~ischar(subjectnum)
    subjectnum = num2str(subjectnum);
end


%rand('state',sum(100*clock));
RandStream.setGlobalStream(RandStream('mt19937ar','seed',sum(100*clock)));

%defining some colors for later [r g b]
gray = [190 190 190];
black = [0 0 0];
white = [255 255 255];
blue = [0 0 200];
middle_card_color = blue;



% TRIAL INFO
ntrials = 45; %


ITI_list = [repmat(3,1,23) repmat(4.75,1,12) repmat(6.5,1,6) repmat(8.25,1,3) 3];
ITI_list = Shuffle(ITI_list);
ISI_list = [repmat(2,1,23) repmat(3.5,1,12) repmat(5,1,6) repmat(6.5,1,3) 2];
ISI_list = Shuffle(ISI_list);


%%%scanning timing%%%
%ITI_list = [repmat(4,1,19) repmat(5.5,1,10) repmat(7,1,4) repmat(8.5,1,2) 10];
%ITI_list = Shuffle(ITI_list);
%ISI_list = [repmat(3,1,19) repmat(4.5,1,10) repmat(6,1,4) repmat(7.5,1,2) 9];
%ISI_list = Shuffle(ISI_list);
responsewindow = 1.75;
outcomedur = 1.0;

%outcomes = [repmat(1,1,15) repmat(2,1,15) repmat(3,1,15)];
%outcomes = Shuffle(outcomes);
%outcomes = [ Shuffle([1 2 3 1 2 3]) Shuffle([1 2 3]) Shuffle([1 2 3]) Shuffle([1 2 3]) ...
%    Shuffle([1 2 3]) Shuffle([1 2 3]) Shuffle([1 2 3]) Shuffle([1 2 3]) Shuffle([1 2 3]) ...
%    Shuffle([1 2 3]) Shuffle([1 2 3]) Shuffle([1 2 3]) Shuffle([1 2 3]) Shuffle([1 2 3]) Shuffle([1 2 3]) ];
% outcomes = [ Shuffle([1 2 3 1 2 3]) Shuffle([1 2 3 1 2 3]) Shuffle([1 2 3 1 2 3]) ...
%     Shuffle([1 2 3 1 2 3]) Shuffle([1 2 3 1 2 3]) Shuffle([1 2 3 1 2 3]) ...
%     Shuffle([1 2 3 1 2 3]) Shuffle([1 2 3]) ];
load('outcomes.mat');

% 1 = loss; 2 = neutral; 3 = gain;


try
    
    
    %%%MAKE BUTTON CODES PORTABLE. ALL BUTTON CHANGES SHOULD BE HERE%%%
    KbName('UnifyKeyNames'); %I think this only helps with the escape key
    
    L_arrow = KbName('LeftArrow'); %(make index finger)
    R_arrow = KbName('RightArrow'); %different from before (make middle finger)
    
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
    Screen('CloseAll');
    [window,screenRect] = Screen('OpenWindow', 0, gray, []);
    Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

    HideCursor;
    ListenChar(2);
    WaitSecs(.5);
    
    centerhoriz = screenRect(3)/2;
    centervert = screenRect(4)/2;
    scale_res = [1 1];
    
    %Create offscreen window to save displays to
    %[display]=Screen('OpenOffscreenWindow',window,screencolor);
    
    %%%set image and rect sizes%%%
    above_fixation = 0;
    scale_pic_size = 1.2; % 1 keeps original. < 1 makes it smaller. > 1 makes it bigger
    
    xDim_F = (200*scale_res(1))*scale_pic_size; % size of the squares (pixels)
    yDim_F = xDim_F;
    
    xDim_O = (180*scale_res(1))*scale_pic_size; % size of the oval (pixels)
    yDim_O = xDim_O;
    
    ML_r = 150;
    
    MiddleRect = [(screenRect(3)/2-xDim_F/2) (screenRect(4)/2-yDim_F/2)-above_fixation (screenRect(3)/2+xDim_F/2) (screenRect(4)/2+yDim_F/2)-above_fixation];
    MiddleRect_little = [(screenRect(3)/2-ML_r/2) (screenRect(4)/2-ML_r/2) (screenRect(3)/2+ML_r/2) (screenRect(4)/2+ML_r/2)];
    MiddleRect = MiddleRect_little;
    
    CenterSpotHor = centerhoriz;
    CenterSpotVert = centervert+150;
    FB_rect = [CenterSpotHor-35 CenterSpotVert-35 CenterSpotHor+35 CenterSpotVert+35];
    
    [imagename, ~, alpha] = imread(fullfile(maindir,'imgs','fb_pos.png'));
    imagename(:,:,4) = alpha(:,:);
    FBpos_texture = Screen('MakeTexture', window, imagename);
    [imagename, ~, alpha] = imread(fullfile(maindir,'imgs','fb_neg.png'));
    imagename(:,:,4) = alpha(:,:);
    FBneg_texture = Screen('MakeTexture', window, imagename);
    
    
    
    
    
    %%%Setting the intro screen%%%
    Screen('TextFont', window, 'Helvetica');
    Screen('TextSize', window, floor((25*scale_res(2))));
    longest_msg = 'Your job is to guess if the card is above (high) or below (low) the number 5.';
    [normBoundsRect, notused] = Screen('TextBounds', window, longest_msg);
    Screen('TextStyle', window, 1);
    Screen('DrawText', window, 'NEW TASK: You are about to play the Gambling Game!', (centerhoriz-(normBoundsRect(3)/2)), (centervert-(180*scale_res(2))), black);
    Screen('TextStyle', window, 0);
    Screen('DrawText', window, 'On each trial, you will see a blue card with a question mark.', (centerhoriz-(normBoundsRect(3)/2)), (centervert-(120*scale_res(2))), black);
    Screen('DrawText', window, 'The card has a number with a value of 1 to 9.', (centerhoriz-(normBoundsRect(3)/2)), centervert-90, black);
    Screen('DrawText', window, longest_msg, (centerhoriz-(normBoundsRect(3)/2)), centervert-60, black);
    Screen('TextStyle', window, 1);
    Screen('DrawText', window, 'If you guess correctly, you gain $1.00. (GREEN)', (centerhoriz-(normBoundsRect(3)/2)), centervert-30, [0 200 0]);
    Screen('DrawText', window, 'But if you guess wrong, you lose $0.50. (RED)', (centerhoriz-(normBoundsRect(3)/2)), centervert, [200 0 0]);
    Screen('TextStyle', window, 0);
    Screen('DrawText', window, 'If the number is 5, you neither gain nor lose money.', (centerhoriz-(normBoundsRect(3)/2)), centervert+30, black);
    Screen('DrawText', window, 'Use the left (high) and right (low) buttons to make your choice.', (centerhoriz-(normBoundsRect(3)/2)), centervert+90, black);
    Screen('DrawText', window, 'Press the spacebar to start the task.', (centerhoriz-(normBoundsRect(3)/2)), centervert+120, black);
    %oldTextSize=Screen('TextSize', windowPtr [,textSize]);
    
    Screen('Flip', window);
    
    
    
    
    %start sequence. will change this to receive a scanner pulse
    go = 1;
    while go
        [keyIsDown, notused, keyCode] = KbCheck; %Keyboard input
        keyCode = find(keyCode);
        if keyIsDown == 1
            if keyCode(1) == go_button
                go = 0;
            end
            if keyCode(1) == esc_key %esc to close
                Screen('CloseAll');
                ListenChar(0);
                return;
            end
        end
    end
    
    
    Screen('DrawLine', window, black, ((screenRect(3)/2)-(10*scale_res(1))), screenRect(4)/2, ((screenRect(3)/2)+(10*scale_res(1))), screenRect(4)/2, 2);
    Screen('DrawLine', window, black, screenRect(3)/2, ((screenRect(4)/2)-(10*scale_res(2))), screenRect(3)/2, ((screenRect(4)/2)+(10*scale_res(2))), 2);
    Screen('Flip', window);
    
    
    %%%START TRIAL LOOP%%%
    
    %%%saving data info%%%
    outputname = fullfile(outputdir, [subjectnum '_GuessingGame.mat']);
    startsecs = GetSecs;
    for k = 1:ntrials
        abort = 0;
        lapse = 0;
        ishigh = 0;
        feedback_onset = 0;
        cardvalue = 0;
        
        eventsecs = GetSecs; %start event clock
        if k == 1
            delayt = 2;
            WaitSecs(delayt);
        else
            delayt = 0;
        end
        
        
        ITI = ITI_list(k);
        ISI = ISI_list(k);
        outcome = outcomes(k);
        if outcome == 2
            flip = rand<0.5;
            if flip
                outcome = 1;
            else
                outcome = 3;
            end
        end
        
        
        %Screen('DrawTexture', windowPointer, texturePointer [,sourceRect] [,destinationRect] [,rotationAngle] [, filterMode] [, globalAlpha] [, modulateColor] [, textureShader] [, specialFlags] [, auxParameters]);
        %Screen('FillRect', windowPtr [,color] [,rect] )
        Screen('FillRect', window, middle_card_color, MiddleRect);
        Screen('FrameRect',window,black,MiddleRect,7);
        Screen('TextSize', window, floor((60*scale_res(2))));
        msg = '?';
        [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', window, msg);
        Screen('TextStyle', window, 1);
        Screen('DrawText', window, msg, (centerhoriz-(normBoundsRect(3)/2)), centervert-(normBoundsRect(4)/2), white);
        Screen('TextStyle', window, 0);
        Screen('Flip', window);
        decisionphase_onset = GetSecs - startsecs;
        
        msg = '?';
        [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', window, msg);
        Screen('TextStyle', window, 1);
        Screen('DrawText', window, msg, (centerhoriz-(normBoundsRect(3)/2)), centervert-(normBoundsRect(4)/2), white);
        Screen('TextStyle', window, 0);
        Screen('FillRect', window, middle_card_color, MiddleRect);
        Screen('FrameRect',window,black,MiddleRect,7);
        
        
        %%%MAKE CHOICE%%%
        RT_start = GetSecs; %start RT clock
        press = 0;
        while ~press
            RT = 0;
            [~, ~, responsecode] = KbCheck; %Keyboard input
            if GetSecs - (eventsecs+delayt) > responsewindow
                Screen('Flip', window);
                msg = 'Respond faster!';
                Screen('TextSize', window, floor((40*scale_res(2))));
                [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', window, msg);
                Screen('TextStyle', window, 0);
                Screen('DrawText', window, msg, (centerhoriz-(normBoundsRect(3)/2)), centervert-(normBoundsRect(4)/2), black);
                Screen('Flip', window);
                lapse = 1;
                press = 1;
                RT_onset = 0;
            else
                if find(responsecode) == L_arrow %LEFT / HIGH
                    Screen('FrameRect',window,white,MiddleRect,7);
                    RT = GetSecs - RT_start;
                    press = 1;
                    msg = '?';
                    [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', window, msg);
                    Screen('TextStyle', window, 1);
                    Screen('DrawText', window, msg, (centerhoriz-(normBoundsRect(3)/2)), centervert-(normBoundsRect(4)/2), white);
                    Screen('TextStyle', window, 0);
                    Screen('Flip', window);
                    RT_onset = GetSecs - startsecs;
                    ishigh = 1;
                elseif find(responsecode) == R_arrow %RIGHT / LOW
                    Screen('FrameRect',window,white,MiddleRect,7);
                    RT = GetSecs - RT_start;
                    press = 1;
                    msg = '?';
                    [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', window, msg);
                    Screen('TextStyle', window, 1);
                    Screen('DrawText', window, msg, (centerhoriz-(normBoundsRect(3)/2)), centervert-(normBoundsRect(4)/2), white);
                    Screen('TextStyle', window, 0);
                    RT_onset = GetSecs - startsecs;
                    Screen('Flip', window);
                    ishigh = 0;
                elseif find(responsecode) == esc_key
                    abort = 1;
                end
            end
        end
        WaitSecs(.50);
        
        
        
        Screen('DrawLine', window, black, ((screenRect(3)/2)-(10*scale_res(1))), screenRect(4)/2, ((screenRect(3)/2)+(10*scale_res(1))), screenRect(4)/2, 2);
        Screen('DrawLine', window, black, screenRect(3)/2, ((screenRect(4)/2)-(10*scale_res(2))), screenRect(3)/2, ((screenRect(4)/2)+(10*scale_res(2))), 2);
        Screen('Flip', window);
        while GetSecs - (eventsecs+delayt+responsewindow) < ISI %timing loop
            [responded, responsetime, keyCode] = KbCheck; %Keyboard input
            if find(keyCode) == esc_key %escape
                abort = 1;
            end
        end
        
        if ~lapse
            if outcome == 1 %loss
                if ishigh
                    cardvalue = ceil(rand*4);
                else
                    cardvalue = 5+ceil(rand*4);
                end
                o_color = [128 128 128];
                Screen('DrawTexture', window, FBpos_texture, [], FB_rect);
            elseif outcome == 2 %neutral
                cardvalue = 5;
                o_color = [128 128 128];
            elseif outcome == 3 %gain
                if ishigh
                    cardvalue = 5+ceil(rand*4);
                else
                    cardvalue = ceil(rand*4);
                end
                o_color = [128 128 128];
                Screen('DrawTexture', window, FBneg_texture, [], FB_rect);
            end
            mcolor = [0 0 0];
            Screen('TextStyle', window, 0);
            Screen('TextSize', window, 75);
            [normBoundsRect, ~] = Screen('TextBounds', window, msg);
            Screen('DrawText', window, msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert-(normBoundsRect(4)/2)), mcolor);
            
            Screen('FillRect', window, o_color, MiddleRect_little);
            Screen('FrameRect',window,black,MiddleRect_little,5);
            msg = num2str(cardvalue);
            Screen('TextSize', window, 75);
            [normBoundsRect, offsetBoundsRect] = Screen('TextBounds', window, msg);
            Screen('TextStyle', window, 1);
            Screen('DrawText', window, msg, (centerhoriz-(normBoundsRect(3)/2)), centervert-(normBoundsRect(4)/2), white);
            Screen('TextStyle', window, 0);
            Screen('Flip', window);
            feedback_onset = GetSecs - startsecs;
        end
        
        while GetSecs - (eventsecs+delayt+ISI+responsewindow) < outcomedur %timing loop
            [~, ~, keyCode] = KbCheck; %Keyboard input
            if find(keyCode) == esc_key %escape
                abort = 1;
            end
        end
        
        %%%save data here%%%
        data(k).RT = RT;
        data(k).RT_onset = RT_onset;
        data(k).lapse = lapse;
        data(k).ishigh = ishigh;
        data(k).ITI = ITI;
        data(k).ISI = ISI;
        data(k).decisionphase_onset = decisionphase_onset;
        data(k).feedback_onset = feedback_onset;
        data(k).outcome = outcome;
        data(k).cardvalue = cardvalue;
        
        %%%ITI PERIOD: DRAW FIXATION CROSS%%%
        Screen('DrawLine', window, black, ((screenRect(3)/2)-(10*scale_res(1))), screenRect(4)/2, ((screenRect(3)/2)+(10*scale_res(1))), screenRect(4)/2, 2);
        Screen('DrawLine', window, black, screenRect(3)/2, ((screenRect(4)/2)-(10*scale_res(2))), screenRect(3)/2, ((screenRect(4)/2)+(10*scale_res(2))), 2);
        Screen('Flip', window);
        while GetSecs - (eventsecs+delayt+ISI+responsewindow+outcomedur) < ITI %timing loop
            [keyIsDown, secs, keyCode] = KbCheck; %Keyboard input
            if find(keyCode) == esc_key %escape
                abort = 1;
            end
        end
        
        if abort
            ListenChar(0);
            Screen('CloseAll');
            end_secs = GetSecs;
            run_time = end_secs - startsecs;
            save(outputname, 'data','run_time');
            return;
        end
    end
    WaitSecs(5); %wait 5 seconds at the end to let last feedback HRF return to baseline.
    end_secs = GetSecs;
    run_time = end_secs - startsecs;
    save(outputname, 'data','run_time');
    
    
    ListenChar(0);
    Screen('CloseAll');
    
catch ME
    disp(ME.message);
    ListenChar(0);
    Screen('CloseAll');
    keyboard
end
