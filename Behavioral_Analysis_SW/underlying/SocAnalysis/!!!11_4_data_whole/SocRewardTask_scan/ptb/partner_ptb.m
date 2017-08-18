Screen('DrawTexture', mywindow, partner_texture, [], MiddleRect);
Screen('TextSize', mywindow, 30);
msg = 'Press any button to see if you won points!';
[normBoundsRect, ~] = Screen('TextBounds', mywindow, msg);
Screen('DrawText', mywindow, msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert+(60*scale_res(2))), black);
Screen('Flip', mywindow);

Screen('DrawTexture', mywindow, partner_texture, [], MiddleRect);
Screen('TextSize', mywindow, 30);
msg = 'Press any button to see if you won points!';
[normBoundsRect, ~] = Screen('TextBounds', mywindow, msg);
Screen('DrawText', mywindow, msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert+(60*scale_res(2))), black);
