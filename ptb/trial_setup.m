ntrials = 40;
fix1_list = [repmat(1.75,1,20) repmat(2.75,1,12) repmat(4.75,1,8)];
fix2_list = [repmat(1.75,1,20) repmat(2.75,1,12) repmat(4.75,1,8)];
fix3_list = [repmat(1.75,1,20) repmat(2.75,1,12) repmat(4.75,1,8)];
fix4_list = [repmat(1.75,1,20) repmat(2.50,1,12) repmat(3.25,1,8)];

partner_dec1 = 0.75;
partner_dec2 = 2.25;
self_dec = 3.00;
infodur = 1.75;
affdur = 1.75;
slidertime = 3;

words = {'interested','distressed','excited','upset','attentive', ...
    'strong','guilty','scared','hostile','jittery', ...
    'enthusiastic','proud','irritable','alert','active',...
    'ashamed','inspired','nervous','determined','afraid'};

words = Shuffle(words);

soc_win = [ones(1,ntrials/2) zeros(1,ntrials/2)];
partner = [ones(1,ntrials/2) zeros(1,ntrials/2)];
is_catch = [1 1 1 2 2 2 zeros(1,34)];

point_total = 0;
randblocks = 1:4; %not random
Vwalks = load('Vwalk_all_v1.mat');
clear data;