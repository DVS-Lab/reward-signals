Screen('DrawTexture', screens.subjectW, package.textures.force_cueTex,[],package.positions.subject.Pcue);
Screen('Flip',screens.subjectW);
cue_onset = GetSecs - startsecs;
WaitSecs(0.75);


