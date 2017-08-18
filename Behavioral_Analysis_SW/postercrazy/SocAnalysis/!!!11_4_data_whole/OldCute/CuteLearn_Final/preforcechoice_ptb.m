a = exemplars(j,:);
if a(1)== 1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue1aTex,[], package.positions.subject.A1);
elseif a(1)== -1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue1bTex,[], package.positions.subject.A1);
end
if a(2)== 1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue2aTex,[], package.positions.subject.A2);
elseif a(2)== -1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue2bTex,[], package.positions.subject.A2);
end

if a(3)== 1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue1aTex,[], package.positions.subject.B1);
elseif a(3)== -1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue1bTex,[], package.positions.subject.B1);
end
if a(4)== 1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue2aTex,[], package.positions.subject.B2);
elseif a(4)== -1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue2bTex,[], package.positions.subject.B2);
end

if abs(a(9) - 1) < 1.0e-12 %force choice is on the left, cannot choose the right one
%     Screen('DrawTexture', screens.subjectW, package.textures.NoChoice,[], package.positions.subject.NoChoiceR);
    Screen('DrawLine', screens.subjectW, red, package.positions.subject.frameR(1),package.positions.subject.frameR(2),package.positions.subject.frameR(3),package.positions.subject.frameR(4),4);
    Screen('DrawLine', screens.subjectW, red, package.positions.subject.frameR(3),package.positions.subject.frameR(2),package.positions.subject.frameR(1),package.positions.subject.frameR(4),4);
    shouldbe = L_arrow;
elseif abs(a(9) - 2) < 1.0e-12 
%     Screen('DrawTexture', screens.subjectW, package.textures.NoChoice,[], package.positions.subject.NoChoiceL);
    Screen('DrawLine', screens.subjectW, red, package.positions.subject.frameL(1),package.positions.subject.frameL(2),package.positions.subject.frameL(3),package.positions.subject.frameL(4),4);
    Screen('DrawLine', screens.subjectW, red, package.positions.subject.frameL(3),package.positions.subject.frameL(2),package.positions.subject.frameL(1),package.positions.subject.frameL(4),4);
    shouldbe = R_arrow;
end

    
Screen('Flip',screens.subjectW);
choice_onset = GetSecs - startsecs;
RT1_start = GetSecs; %start RT clock
if a(1)== 1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue1aTex,[], package.positions.subject.A1);
elseif a(1)== -1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue1bTex,[], package.positions.subject.A1);
end
if a(2)== 1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue2aTex,[], package.positions.subject.A2);
elseif a(2)== -1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue2bTex,[], package.positions.subject.A2);
end

if a(3)== 1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue1aTex,[], package.positions.subject.B1);
elseif a(3)== -1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue1bTex,[], package.positions.subject.B1);
end
if a(4)== 1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue2aTex,[], package.positions.subject.B2);
elseif a(4)== -1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue2bTex,[], package.positions.subject.B2);
end

% if a(9) == 1 %force choice is on the left, cannot choose the right one
%     shouldbe = L_arrow;
% else
%     shouldbe = R_arrow;
% end
