function [newOrder] = randomOrder(catStruct)
% generate random trial orderings 

blockSize=size(catStruct,1);
% generate a new random ordering
for i = 1:10000
    randomOrder=randperm(blockSize);
end
for i=1:length(randomOrder)
    temp_trial=randomOrder(i);
    newOrder(i,:)=catStruct(temp_trial,:);% new random ordering
end