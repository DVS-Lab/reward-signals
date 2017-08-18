function [newcues] = genTest(filename,logicalSet)
% creats a whole examplars of 216 trials and logicalCB for 6 different
% combinations of orders for predictiveness of the cues

% based on the file of 
samples = xlsread(filename);
% 1)dim1A; 2)dim2A; 3)dim3A; 4)dim1B; 5)dim2B; 6)dim3B; 7)outcome; 8)pattern; 9)block;
% Generate outcomes for each pattern: randperm outcomes for each pattern,
% embedded into outcome
for i = 1: size(samples,1)
    win = execute_classicLot(.5,1000);
    if win
        pre = samples(i,1:3);
        samples(i,1:3) = samples(i,4:6);
        samples(i,4:6) = pre;
        if samples(i,7)==0
            samples(i,7)=1;
        elseif samples(i,7)==1
            samples(i,7)==0;
        end
    end
end
logicalSet = logicalSet(1);
if logicalSet==1
    samples = samples(:, [1 2 3 4 5 6 7 8 9]);
elseif logicalSet==2
    samples = samples(:, [1 3 2 4 6 5 7 8 9]);
elseif logicalSet==3
    samples = samples(:, [2 1 3 5 4 6 7 8 9]);
elseif logicalSet==4
    samples = samples(:, [3 1 2 6 4 5 7 8 9]);
elseif logicalSet==5
    samples = samples(:, [2 3 1 5 6 4 7 8 9]);
elseif logicalSet==6
    samples = samples(:, [3 2 1 6 5 4 7 8 9]);
end

for i = 1:10000
    index = randperm(size(samples,1));
end
samples = samples(index,:);
newcues = samples;
end