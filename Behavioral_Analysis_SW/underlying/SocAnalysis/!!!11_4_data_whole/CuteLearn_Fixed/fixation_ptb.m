Screen('DrawLine', screens.subjectW, black, ((screens.subjectWRect(3)/2)-(10*scale_res(1))), screens.subjectWRect(4)/2, ((screens.subjectWRect(3)/2)+(10*scale_res(1))), screens.subjectWRect(4)/2, 2);
Screen('DrawLine', screens.subjectW, black, screens.subjectWRect(3)/2, ((screens.subjectWRect(4)/2)-(10*scale_res(2))), screens.subjectWRect(3)/2, ((screens.subjectWRect(4)/2)+(10*scale_res(2))), 2);
Screen('Flip', screens.subjectW);