% get pop data
    maindir = pwd;
    blocks = 1:4;
    subjects = 1007:1008;
    
    %col1: inf_hi (hi PE), col2: inf_low (low PE), col3: aff_hi, col4: aff_low
    sub_data = zeros(length(subjects),4);
    out = nan;
    dec = nan;
   
    for s = 1:length(subjects)
        subject = subjects(s);
        % clear bigdata big_pe
        for r = 1:length(blocks)
            datadir = fullfile(maindir,'data',num2str(subject));
            load(fullfile(datadir,sprintf('%s_feedback_%d.mat',num2str(subject),r)));
            
            choicedata = [data.Npoints; data.deckchoice]';
            out = [out;choicedata(:,1)];
            dec = [dec;choicedata(:,2)];
            
        end
        out = out(2:end);
        dec = dec(2:end);
        load(fullfile(datadir,sprintf('%s_feedback_prac.mat',num2str(subject))));
        choicedata = [data.Npoints; data.deckchoice]';
        pracout = choicedata(:,1);
        pracdec = choicedata(:,2);
    
        out = [pracout;out];
        dec = [pracdec;dec];
        Data(s).c = dec;
        Data(s).r = out;
        Data(s).N = size(Data(s).c,1);
    end
clear data
data = Data;