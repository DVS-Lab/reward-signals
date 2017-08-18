go = 1;
while go
    [keyIsDown, ~, keyCode] = KbCheck; %Keyboard input
    keyCode = find(keyCode);
    if keyIsDown == 1
        if keyCode(1) == esc_key
            go = 0;
        end
    end
end
