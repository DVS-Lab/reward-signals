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