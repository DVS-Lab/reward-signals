function InitializeCCL(samplesize)
if getYN(['\nInitialize subject list for the CombineCue Learning experiment? \n Doing so will delete any data already stored.']);
    condition_incomplete = zeros(samplesize/2,1);
    condition_complete = ones(samplesize/2,1);
    condition =[condition_incomplete;condition_complete];
    thinkANumber = 100000;
    for i = 1:thinkANumber
        randperm(samplesize);
    end
    condition = condition(index);
    save condition condition
    mkdir('CCLdata');
    fprintf('\nExperiment successfully initialized\n');
else
    fprintf('\nExperiment NOT initialized\n');
end

