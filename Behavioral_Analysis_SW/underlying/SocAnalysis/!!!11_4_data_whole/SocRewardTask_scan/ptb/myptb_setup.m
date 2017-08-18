black = [0 0 0];
white = [255 255 255];
red = [255 0 0];
green = [0 255 0];

esc_key = KbName('ESCAPE');
space_key = KbName('space');
%L_arrow = KbName('LeftArrow');
%D_arrow = KbName('DownArrow');
%R_arrow = KbName('RightArrow');
%go_button = space_key;
L_arrow = KbName('b');
D_arrow = KbName('y');
R_arrow = KbName('g');
go_button = KbName('t');



% Get the screen numbers
screens = Screen('Screens');
screenNumber = max(screens);

% set color scalars. assume white is 1
grey = 1 * 0.667;
% Open an on screen mywindow and color it grey
[mywindow, screenRect] = PsychImaging('Openwindow', screenNumber, grey);
Screen('BlendFunction', mywindow, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
HideCursor;

centerhoriz = screenRect(3)/2;
centervert = screenRect(4)/2;
scale_res = [1 1];

%%%set image and rect sizes%%%
above_fixation = 0;
above_fixation2 = 150;
scale_pic_size = 1; % 1 keeps original. < 1 makes it smaller. > 1 makes it bigger
xDim_F = (180*scale_res(1)); % size of the squares (pixels)
yDim_F = xDim_F;
xDim_F2 = (150*scale_res(1)); % size of the squares (pixels)
yDim_F2 = xDim_F2;

moveleft = -240;
moveright = 240;
LeftRect = [(screenRect(3)/2-xDim_F/2)+moveleft ((screenRect(4)/2-yDim_F/2)-above_fixation) (screenRect(3)/2+xDim_F/2)+moveleft ((screenRect(4)/2+yDim_F/2)-above_fixation)];
RightRect = [(screenRect(3)/2-xDim_F/2)+moveright ((screenRect(4)/2-yDim_F/2)-above_fixation) (screenRect(3)/2+xDim_F/2)+moveright ((screenRect(4)/2+yDim_F/2)-above_fixation)];
MiddleRect = [(screenRect(3)/2-xDim_F2/2) (screenRect(4)/2-yDim_F2/2)-above_fixation2 (screenRect(3)/2+xDim_F2/2) (screenRect(4)/2+yDim_F2/2)-above_fixation2];

xDim_F = (185*scale_res(1))*scale_pic_size; % size of the squares (pixels)
yDim_F = xDim_F;
LeftRect2 = [(screenRect(3)/2-xDim_F/2)+moveleft ((screenRect(4)/2-yDim_F/2)-above_fixation) (screenRect(3)/2+xDim_F/2)+moveleft ((screenRect(4)/2+yDim_F/2)-above_fixation)];
RightRect2 = [(screenRect(3)/2-xDim_F/2)+moveright ((screenRect(4)/2-yDim_F/2)-above_fixation) (screenRect(3)/2+xDim_F/2)+moveright ((screenRect(4)/2+yDim_F/2)-above_fixation)];


CenterSpotHor = centerhoriz;
CenterSpotVert = centervert+90;
FB_rect = [CenterSpotHor-35 CenterSpotVert-35 CenterSpotHor+35 CenterSpotVert+35];



[imagename, ~, ~] = imread(fullfile(maindir,'imgs','computer.jpg'));
comp_texture = Screen('MakeTexture', mywindow, imagename);
[imagename, ~, ~] = imread(fullfile(maindir,'imgs',[partner_name '.jpg']));
human_texture = Screen('MakeTexture', mywindow, imagename);

[imagename, ~, alpha] = imread(fullfile(maindir,'imgs','fb_pos.png'));
imagename(:,:,4) = alpha(:,:);
FBpos_texture = Screen('MakeTexture', mywindow, imagename);
[imagename, ~, alpha] = imread(fullfile(maindir,'imgs','fb_neg.png'));
imagename(:,:,4) = alpha(:,:);
FBneg_texture = Screen('MakeTexture', mywindow, imagename);
