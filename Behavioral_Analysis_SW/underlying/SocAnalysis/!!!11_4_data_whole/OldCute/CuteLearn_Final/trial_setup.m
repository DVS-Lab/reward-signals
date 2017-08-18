ntrials = 48;
ISI1_list = [repmat(1.75,1,23) repmat(3,1,14) repmat(4.25,1,8) repmat(5.5,1,3)];
ISI2_list = [repmat(1.75,1,25) repmat(2.75,1,13) repmat(3.75,1,7) repmat(4.75,1,3)];
ITI_list = [repmat(2.25,1,23) repmat(3.25,1,12) repmat(4.25,1,7) repmat(5.25,1,4) 6.5 6.5];
% change this to be smaller or change ITI to be larger

cuedur = 0.75;
self_dec = 3.00;
infodur = 0.75;

soc_win = [ones(1,ntrials/2) zeros(1,ntrials/2)];
partner = [ones(1,ntrials/2) zeros(1,ntrials/2)];