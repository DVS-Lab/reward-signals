% msg{1} = 'At the beginning of each trial, you will see a picture of fruit in the center of the screen, an APPLE, or an ORANGE.';
% msg{2} = 'After few seconds, you will see two aliens on the screen(left and right). And only one of them will carry a one-dollar bill.';
% msg{3} = 'Each alien has two body parts(head and body), and these body parts will provide clues for the MONEY alien.';
% msg{4} = 'Each body part comes in two types: the head can be a TRIANGLE or a SQUARE, the body color can be LIGHT or DARK.';
% msg{5} = 'Your job is to learn how different types of body parts can be used to identify the MONEY alien,'; % use the different type of body parts to choose the rich one
% msg{6} = 'and choose the one you think carries money in order to collect as many dollar bills as possible,';
% msg{7} = 'which will be redeemed proportionally by the end of the experiment.';
% msg{8} = ' ';
% msg{9} = 'Wait! Before you make the choice, do you remember the fruit? It tells you how to make choices if you see different fruit!';
% msg{10} = 'If you see an ORANGE, you can choose any alien, that you think that carries dollar bill, on either side of the screen.';
% msg{11} = 'However, if you see an APPLE, you can ONLY choose one option: the option WITHOUT a RED X below it.';
% msg{12} = 'After you make the choice, you will be given feedback that whether you get a one-dollar bill or a 0-dollar bill from the alien you chose.';
% msg{13} = 'With these feedbacks, you can learn which type of body parts are more likely to carry money, and which are less likely.';
% msg{14} = 'You will collect more and more dollar bills as you learn this, but you can never be 100% accurate at making choices.';
% msg{15} = ' ';
% msg{16} = 'Remember, you can ONLY choose the option WITHOUT the red X sign when you see an APPLE.';

msg{1} = 'FRUIT:';
msg{2} = 'ORANGE: Free choice.';
msg{3} = 'APPLE: Forced choice.';
msg{4} = ' ';
msg{5} = 'ALIENS'; % use the different type of body parts to choose the rich one
msg{6} = 'HEAD: Triangle vs. Square';
msg{7} = 'BODY: Light    vs. Dark';
msg{8} = ' ';
msg{9} = 'FEEDBACK:';
msg{10} = 'ONE DOLLAR vs. ZERO DOLLAR ';
msg{11} = ' ';
msg{12} = 'Use feedback and body parts to choose the money alien!';


textColor = [0 0 0];
Screen('TextSize', screens.subjectW, 16);
msg_y = 100;
for n = 1:length(msg)
    msg_y = msg_y+30;
    DrawFormattedText(screens.subjectW, msg{n},'center',msg_y,textColor);
end
Screen('Flip', screens.subjectW);