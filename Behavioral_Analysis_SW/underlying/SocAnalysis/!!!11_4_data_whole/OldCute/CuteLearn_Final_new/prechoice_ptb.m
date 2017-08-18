examplar = exemplars(j,:);
if examplar(1)== 1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue1aTex,[], package.positions.subject.A1);
elseif examplar(1)== -1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue1bTex,[], package.positions.subject.A1);
end
if examplar(2)== 1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue2aTex,[], package.positions.subject.A2);
elseif examplar(2)== -1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue2bTex,[], package.positions.subject.A2);
end

if examplar(3)== 1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue1aTex,[], package.positions.subject.B1);
elseif examplar(3)== -1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue1bTex,[], package.positions.subject.B1);
end
if examplar(4)== 1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue2aTex,[], package.positions.subject.B2);
elseif examplar(4)== -1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue2bTex,[], package.positions.subject.B2);
end
Screen('Flip',screens.subjectW);
choice_onset = GetSecs - startsecs;
RT1_start = GetSecs; %start RT clock
if examplar(1)== 1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue1aTex,[], package.positions.subject.A1);
elseif examplar(1)== -1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue1bTex,[], package.positions.subject.A1);
end
if examplar(2)== 1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue2aTex,[], package.positions.subject.A2);
elseif examplar(2)== -1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue2bTex,[], package.positions.subject.A2);
end

if examplar(3)== 1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue1aTex,[], package.positions.subject.B1);
elseif examplar(3)== -1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue1bTex,[], package.positions.subject.B1);
end
if examplar(4)== 1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue2aTex,[], package.positions.subject.B2);
elseif examplar(4)== -1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue2bTex,[], package.positions.subject.B2);
end

