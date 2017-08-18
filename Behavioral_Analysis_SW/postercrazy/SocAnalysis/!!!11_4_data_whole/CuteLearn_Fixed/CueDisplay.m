function [abort] = CueDisplay(textures, screens, nTrial, TrialNB,package, signal)
% Displays textures in a gaze contingent loop

% set feedback trial loop variables
keyIsDown=0; KeyCode=zeros(1,256); buttons=[0];
abort=0;
[keyboardIndices]=GetKeyboardIndices;

currentTrial=strcat('Trial No.',num2str(TrialNB));
        if true
            if signal == 1
                Screen('DrawTexture', screens.subjectW, package.textures.force_cueTex,[],package.positions.subject.Pcue);
            elseif signal == 0
                Screen('DrawTexture', screens.subjectW, package.textures.free_cueTex,[],package.positions.subject.Pcue);
            end
        end

Screen('Flip',screens.subjectW);
WaitSecs(.001);
    finished  = false;
    buttonDown = false;
    button(1) = 0;
    while ~finished
        [x,y,button]=GetMouse(screens.subjectW);
        if any(button)
            if buttonDown
                continue;
            else
                buttonDown = true;
                finished = true;
            end
        else
            buttonDown = false;
        end
    end
end% end of the feedback loop__________________________________________________




