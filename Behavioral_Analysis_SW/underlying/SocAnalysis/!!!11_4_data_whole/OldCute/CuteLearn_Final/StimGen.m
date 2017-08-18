function [textures] = StimGen(examplar, screens, package)
% generates stimuli textures form logical category structure
Screen('Flip',screens.subjectW);
% Generate QUERY Image from examplar category structure
if examplar(1)== 1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue1aTex,[], package.positions.subject.A1);
elseif examplar(1)== -1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue1bTex,[], package.positions.subject.A1);
end
if examplar(2)== 1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue2aTex,[], package.positions.subject.A2);
elseif examplar(2)== -1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue2bTex,[], package.positions.subject.A2);
end

if examplar(3)== 1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue1aTex,[], package.positions.subject.B1);
elseif examplar(3)== -1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue1bTex,[], package.positions.subject.B1);
end
if examplar(4)== 1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue2aTex,[], package.positions.subject.B2);
elseif examplar(4)== -1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue2bTex,[], package.positions.subject.B2);
end

%Convert queried image into fovea texture
queryImg=Screen('GetImage',screens.subjectW,[],'backBuffer');
textures.queryTex=Screen('MakeTexture', screens.subjectW, queryImg);
if ~isempty(screens.statusW)% if status dislay is aviable
    % color-inverted examplar image
    inveredeQueryImg(:,:,:) = 255 - queryImg(:,:,:);
    textures.statusQueryTex=Screen('MakeTexture', screens.statusW, inveredeQueryImg);
else
    textures.statusQueryTex=[];
end


%Convert queried image into fovea texture
queryMaskImg=Screen('GetImage',screens.subjectW,[],'backBuffer');
textures.queryMaskTex=Screen('MakeTexture', screens.subjectW, queryMaskImg);

% Screen('FillRect', screens.subjectW,sky,top);
% Screen('FillRect', screens.subjectW, ground, bottom);
%Generate FEEDBACK Image from examplar category structure
if examplar(1)== 1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue1aTex,[], package.positions.subject.A1);
elseif examplar(1)== -1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue1bTex,[], package.positions.subject.A1);
end
if examplar(2)== 1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue2aTex,[], package.positions.subject.A2);
elseif examplar(2)== -1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue2bTex,[], package.positions.subject.A2);
end

if examplar(3)== 1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue1aTex,[], package.positions.subject.B1);
elseif examplar(3)== -1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue1bTex,[], package.positions.subject.B1);
end
if examplar(4)== 1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue2aTex,[], package.positions.subject.B2);
elseif examplar(4)== -1;
    Screen('DrawTexture', screens.subjectW, package.textures.cue2bTex,[], package.positions.subject.B2);
end


%Convert queried image into texture
feedbackImg=Screen('GetImage',screens.subjectW,[],'backBuffer');
textures.feedbackTex=Screen('MakeTexture', screens.subjectW, feedbackImg);
if ~isempty(screens.statusW)% if status dislay is aviable
    % color-inverted examplar image
    inveredFeedbackImg(:,:,:) = 255 - feedbackImg(:,:,:);
    textures.statusFeedbackTex=Screen('MakeTexture', screens.statusW, inveredFeedbackImg);
else
    textures.statusFeedbackTex=[];
end

centerX=package.positions.subject.centerX; centerY=package.positions.subject.centerY;

%Convert feedback image into texture
feedbackMaskImg=Screen('GetImage',screens.subjectW,[],'backBuffer');
textures.feedbackMaskTex=Screen('MakeTexture', screens.subjectW, feedbackMaskImg);
Screen('Flip',screens.subjectW);
end

