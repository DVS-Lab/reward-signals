% Create Experiment Indices
DimWeight = [ 1 2; 2 1]';

One_Set = [1:2,1:2;ones(1,2),2*ones(1,2)];


logicalCB = repmat(One_Set,1,5);
for i=1:100000
    indices = randperm(size(logicalCB,2));
end
logicalCB = logicalCB(:,indices);

inputfile=['Learning and attention/' 'logicalCB' '.mat'];
save(inputfile,'logicalCB');