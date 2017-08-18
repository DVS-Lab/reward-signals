function [package] = StimLoad(screens)

% loads images and sounds and retures a structure 'package' with textures, sounds, and screeen positions. 


    % ---------- set local variables ----------
    subjectW=screens.subjectW;
    subjectWRect= screens.subjectWRect;
   
    % SUBJECT dispay setup
    %reads stimuli image files including alpha channel into matrix
    [cue1a,map,alpha]=imread('dim_1_pro_1.png');
    [cue2a]=imread('dim_2_pro_1.png');
    [cue1b]=imread('dim_1_pro_2.png');
    [cue2b]=imread('dim_2_pro_2.png');
    [mask]=imread('mask.png');
    [reward] = imread('reward.png');
    [no_reward] = imread('no_reward.png');
    [cue_free] = imread('apple.png');
    [cue_control] = imread('orange.png');
    [NoChoice] = imread('no_choice.png');
    
    %gets rects of ImagesArrays
    featureRect = RectOfMatrix(cue1a);
    feedbackRect = RectOfMatrix(reward);
    cueRect = RectOfMatrix(cue_free);
    NoCRect = RectOfMatrix(NoChoice);
    
    %combines RBG matrix and alpha (transperency)
    cue1a=cat(3,cue1a,alpha);
    cue2a=cat(3,cue2a,alpha);
    cue1b=cat(3,cue1b,alpha);
    cue2b=cat(3,cue2b,alpha);
    
    %converts image&alpha matrix into openGL texture
    package.textures.cue1aTex=Screen('MakeTexture', subjectW, cue1a);
    package.textures.cue2aTex=Screen('MakeTexture', subjectW, cue2a);
    package.textures.cue1bTex=Screen('MakeTexture', subjectW, cue1b);
    package.textures.cue2bTex=Screen('MakeTexture', subjectW, cue2b);
    package.textures.maskTex=Screen('MakeTexture', subjectW, mask);
    package.textures.rewardTex=Screen('MakeTexture', subjectW, reward);
    package.textures.no_rewardTex=Screen('MakeTexture', subjectW, no_reward);
    package.textures.force_cueTex=Screen('MakeTexture', subjectW, cue_free);
    package.textures.free_cueTex=Screen('MakeTexture', subjectW, cue_control);
    package.textures.NoChoice = Screen('MakeTexture', subjectW, NoChoice);

    %_____________________________________________________________

    %Move rects on screen to relitive corrdinents
    
    
    xCenter=(subjectWRect(3)/2);
    yCenter=(subjectWRect(4)/2);
    diam = 2*yCenter; % Set up the diam of oval
    baseRect = [0 0 diam diam];
    h = diam/sqrt(8);
    xPosVectorL = [xCenter-h,xCenter-diam/2,xCenter-h];
    xPosVectorR = [xCenter+h,xCenter+diam/2,xCenter+h];
    yPosVector = [yCenter-h/3,yCenter,yCenter+h/3];

    PointListL=[xPosVectorL; yPosVector]';
    PointListR=[xPosVectorR; yPosVector]';
    package.positions.subject.subjectWRect=subjectWRect;
    package.positions.subject.centerX=(subjectWRect(3)/2);
    package.positions.subject.centerY=(subjectWRect(4)/2);
    package.positions.subject.A1 = CenterRectOnPoint(featureRect,PointListL(1,1),PointListL(1,2));% A is on the left, B is on the right
    package.positions.subject.A2 = CenterRectOnPoint(featureRect,PointListL(3,1),PointListL(3,2));
    package.positions.subject.B1 = CenterRectOnPoint(featureRect,PointListR(1,1),PointListR(1,2));
    package.positions.subject.B2 = CenterRectOnPoint(featureRect,PointListR(3,1),PointListR(3,2));
    package.positions.subject.Pfeedback = CenterRectOnPoint(feedbackRect,xCenter,yCenter);
    package.positions.subject.Pcue = CenterRectOnPoint(cueRect,xCenter,yCenter);
    package.positions.subject.NoChoiceL = CenterRectOnPoint(NoCRect,PointListL(1,1),PointListL(3,2)+h/2);
    package.positions.subject.NoChoiceR = CenterRectOnPoint(NoCRect,PointListR(1,1),PointListR(3,2)+h/2);
    package.positions.subject.frameL = CenterRectOnPoint([0 0 featureRect(3) 3*featureRect(4)],xCenter-h,yCenter);
    package.positions.subject.frameR = CenterRectOnPoint([0 0 featureRect(3) 3*featureRect(4)],xCenter+h,yCenter);
end