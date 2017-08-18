
Ndisplays=Screen('Screens');
subjectMonitor=max(Ndisplays);% the stimuli is displayed on the 'highest' monitor
black=BlackIndex(subjectMonitor);
white=WhiteIndex(subjectMonitor);
red = [255 0 0];
[screens.subjectW, screens.subjectWRect] = PsychImaging('Openwindow', subjectMonitor, white); %[0 0 1280 1024]);%[320 88 1600 1112]);% open subject display
% set priority level to max
priorityLevel=MaxPriority(screens.subjectW);
Priority(priorityLevel);
%enables alpha bending
Screen('BlendFunction', screens.subjectW, GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
screens.windowInfo = Screen('GetWindowInfo', screens.subjectW);


% L_arrow = KbName('LeftArrow'); 
% D_arrow = KbName('DownArrow');
% R_arrow = KbName('RightArrow');
% esc_key = KbName('ESCAPE');
% space_key = KbName('space');
% go_button = space_key;

L_arrow = KbName('b'); 
D_arrow = KbName('y');
R_arrow = KbName('g');
esc_key = KbName('ESCAPE');
space_key = KbName('space');
go_button = KbName('t');
scale_res = [1 1];

HideCursor;

