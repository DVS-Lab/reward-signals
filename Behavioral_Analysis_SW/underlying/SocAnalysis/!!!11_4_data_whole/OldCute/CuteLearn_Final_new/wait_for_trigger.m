go = 1;
while go
    [keyIsDown, ~, keyCode] = KbCheck; %Keyboard input
    keyCode = find(keyCode);
    if keyIsDown == 1
        if keyCode(1) == go_button
            go = 0;
        end
        if keyCode(1) == esc_key %esc to close
            Screen('CloseAll');
            return;
        end
    end
end