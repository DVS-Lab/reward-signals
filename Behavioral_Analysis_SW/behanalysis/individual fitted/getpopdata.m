% get pop data
    maindir = pwd;
    
    subjects = [1001:1004,1006:1028];
    numSub = length(subjects);
    blockindx = [ones(numSub,1),4*ones(numSub,1),true(numSub,1)];
    
    %
    blockindx(1,2) = 2;
    blockindx([1,2,3,5],3) = false;
    
    %col1: inf_hi (hi PE), col2: inf_low (low PE), col3: aff_hi, col4: aff_low
    sub_data = zeros(length(subjects),4);

   %numSub = 2;%%%%%%%%%
    for s = 1:numSub
        subject = subjects(s);
        blocks = blockindx(s,1):blockindx(s,2);
        out = nan;
        dec = nan;
        % clear bigdata big_pe
        for r = 1:length(blocks)
            datadir = fullfile(maindir,'raw data',num2str(subject));
            load(fullfile(datadir,sprintf('%s_feedback_%d.mat',num2str(subject),r)));
            
            choicedata = [data.Npoints; data.deckchoice]';
            out = [out;choicedata(:,1)];
            dec = [dec;choicedata(:,2)];
            
        end
        out = out(2:end);
        dec = dec(2:end);
        if blockindx(s,3) == true
            
            load(fullfile(datadir,sprintf('%s_feedback_prac.mat',num2str(subject))));
            choicedata = [data.Npoints; data.deckchoice]';
            pracout = choicedata(:,1);
            pracdec = choicedata(:,2);
    
            out = [pracout;out];
            dec = [pracdec;dec];
        end
        Data(s).c = dec;
        Data(s).r = out;
        Data(s).N = size(Data(s).c,1);
    end
clear data
data = Data;