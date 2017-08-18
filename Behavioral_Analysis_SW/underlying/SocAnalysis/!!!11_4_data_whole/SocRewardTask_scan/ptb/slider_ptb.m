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
[normBoundsRect, ~] = Screen('TextBounds', mywindow, bid_msg);
Screen('DrawText', mywindow, bid_msg, (centerhoriz-(normBoundsRect(3)/2)), (centervert-(normBoundsRect(4)/2)), black);
w = sprintf('%s',words{1});
[normBoundsRect, ~] = Screen('TextBounds', mywindow, w);
Screen('TextStyle', mywindow, 1);
Screen('DrawText', mywindow, w, (centerhoriz-(normBoundsRect(3)/2)), (centervert+30), black);
Screen('TextStyle', mywindow, 0);

draw_scale;
Screen('Flip', mywindow);
%end