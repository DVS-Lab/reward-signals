Screen('DrawTexture', mywindow, partner_texture, [], MiddleRect);
Screen('Flip', mywindow);
WaitSecs(0.75);
eval(['left_card_val = deck' num2str(deckorder(1)) '(k);'])
eval(['right_card_val = deck' num2str(deckorder(2)) '(k);'])
eval(['left_card_color = scan' num2str(deckorder(1)) '_texture;']) %deck1_color
eval(['right_card_color = scan' num2str(deckorder(2)) '_texture;']) %deck1_color
Screen('DrawTexture', mywindow, left_card_color, [], LeftRect);
Screen('DrawTexture', mywindow, right_card_color, [], RightRect);
Screen('DrawTexture', mywindow, partner_texture, [], MiddleRect);
Screen('Flip', mywindow);
choice_onset = GetSecs - startsecs;
RT1_start = GetSecs; %start RT clock
Screen('DrawTexture', mywindow, left_card_color, [], LeftRect);
Screen('DrawTexture', mywindow, right_card_color, [], RightRect);
Screen('DrawTexture', mywindow, partner_texture, [], MiddleRect);
