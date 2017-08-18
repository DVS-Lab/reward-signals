%place bid message on screen -- need to expand this section to
%record input
Low = -7.5;
High = 7.5;


Screen('DrawLine', mywindow, black, ((screenRect(3)/2)-(150*scale_res(1))), (screenRect(4)/2+200), ((screenRect(3)/2)+(150*scale_res(1))), (screenRect(4)/2+200), 3); %horizontal line of scale
Screen('DrawLine', mywindow, black, (centerhoriz-(150*scale_res(1))), ((screenRect(4)/2)+190), (centerhoriz-(150*scale_res(1))), ((screenRect(4)/2)+210), 2); %left end point
Screen('DrawLine', mywindow, black, (centerhoriz-(112.5*scale_res(1))), ((screenRect(4)/2)+190), (centerhoriz-(112.5*scale_res(1))), ((screenRect(4)/2)+210), 2); %1/8 point
Screen('DrawLine', mywindow, black, (centerhoriz-(75*scale_res(1))), ((screenRect(4)/2)+190), (centerhoriz-(75*scale_res(1))), ((screenRect(4)/2)+210), 2); %2/8 (1/4) point
Screen('DrawLine', mywindow, black, (centerhoriz-(37.5*scale_res(1))), ((screenRect(4)/2)+190), (centerhoriz-(37.5*scale_res(1))), ((screenRect(4)/2)+210), 2); %3/8 point
Screen('DrawLine', mywindow, black, centerhoriz, ((screenRect(4)/2)+190), centerhoriz, ((screenRect(4)/2)+210), 2); %4/8 - middle line of the scale
Screen('DrawLine', mywindow, black, (centerhoriz+(37.5*scale_res(1))), ((screenRect(4)/2)+190), (centerhoriz+(37.5*scale_res(1))), ((screenRect(4)/2)+210), 2); %5/8 point
Screen('DrawLine', mywindow, black, (centerhoriz+(75*scale_res(1))), ((screenRect(4)/2)+190), (centerhoriz+(75*scale_res(1))), ((screenRect(4)/2)+210), 2); %6/8 (3/4) point
Screen('DrawLine', mywindow, black, (centerhoriz+(112.5*scale_res(1))), ((screenRect(4)/2)+190), (centerhoriz+(112.5*scale_res(1))), ((screenRect(4)/2)+210), 2); %7/8 point
Screen('DrawLine', mywindow, black, (centerhoriz+(150*scale_res(1))), ((screenRect(4)/2)+190), (centerhoriz+(150*scale_res(1))), ((screenRect(4)/2)+210), 2); %right end point


%placing numbers on the scale
Screen('TextSize', mywindow, floor((20*scale_res(2))));
Leftscale_msg = sprintf('%.1f',Low);
Screen('DrawText', mywindow, Leftscale_msg, (centerhoriz-175), (centervert+165), black);
Screen('DrawText', mywindow, 'Not at all', (centerhoriz-205), (centervert+215), black);

Rightscale_msg = sprintf('%.1f',High);
Screen('DrawText', mywindow, Rightscale_msg, (centerhoriz+145), (centervert+165), black);
Screen('DrawText', mywindow, 'Extremely', (centerhoriz+145), (centervert+215), black);



high_end = [(centerhoriz+160) (centervert+(200))];
low_end = [(centerhoriz-140) (centervert+(200))];
middle_point = [centerhoriz (centervert+200)];
up_scale = high_end - middle_point;
down_scale = middle_point - low_end;
increment = 150;


