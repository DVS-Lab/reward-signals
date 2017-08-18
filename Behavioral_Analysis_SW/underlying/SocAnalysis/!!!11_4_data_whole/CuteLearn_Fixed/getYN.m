function resp = getYN(message)
% yes = getYN(message)
% Echo message to the command window and wait for the user to type a yY/nN.
% Return True on yor Y and False on n or N

% 3/3/06: changed to work with java vm

FlushEvents;
while CharAvail
    GetChar;        % Discard any characters already typed
end
while 1
    disp(sprintf(message))
    resp = input('\nEnter Y or N: ', 's');     % This two step gets
    fprintf('\n');         % fprintf to handle \n embedded in the message
%     resp = getChar;
    fprintf('%s\n', resp);    % Apparently getChar does not echo
    if (resp == 'y' || resp == 'Y')
        resp = true;
        break
    elseif (resp == 'n' || resp == 'N')
        resp = false;
        break
    else
        fprintf('I do not understand that response. Please type y, Y, n, or N.');
    end
end
            