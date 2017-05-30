clear;
maindir = pwd;
datadir = '/Volumes/mnt/diskstation/dvs/socreward';
sublist = [1002 1003 1005:1028];

fid1 = fopen(fullfile(maindir,['QA_' date 'runs.csv']),'w');
fid2 = fopen(fullfile(maindir,['QA_' date 'subs.csv']),'w');

fprintf(fid1,'subj,run,abs_mean,abs_max,rel_mean,rel_max,ICs_removed\n');
fprintf(fid2,'subj,abs_mean,abs_max,rel_mean,rel_max\n');
for s = 1:length(sublist)
    
    subj = sublist(s);
    
    if subj == 1026
        Nruns = 4;
    elseif subj > 1003
        Nruns = 5;
    else
        Nruns = 4;
    end
    
    for r = 1:Nruns
        
        icfile = fullfile(datadir,'fsl',num2str(subj),['prestats' num2str(r) '.feat'],'ICA_AROMA','classified_motion_ICs.txt');
        icfile = load(icfile);
        absfile = fullfile(datadir,'nii',num2str(subj),['run' num2str(r)],['run' num2str(r) '_mcf_abs.rms']);
        absfile = load(absfile);
        relfile = fullfile(datadir,'nii',num2str(subj),['run' num2str(r)],['run' num2str(r) '_mcf_rel.rms']);
        relfile = load(relfile);
        
        %fprintf(fid1,'subj,run,abs_mean,abs_max,rel_mean,rel_max,ICs_removed\n');
        fprintf(fid1,'%d,%d,%3.3f,%3.3f,%3.3f,%3.3f,%d\n',subj,r,mean(absfile),max(absfile),mean(relfile),max(relfile),length(icfile));
    end
    
    
    absfile = fullfile(datadir,'nii',num2str(subj),'concat_runs_mcf_abs.rms');
    absfile = load(absfile);
    relfile = fullfile(datadir,'nii',num2str(subj),'concat_runs_mcf_rel.rms');
    relfile = load(relfile);
    
    %fprintf(fid2,'subj,abs_mean,abs_max,rel_mean,rel_max,ICs_removed\n');
    fprintf(fid2,'%d,%3.3f,%3.3f,%3.3f,%3.3f\n',subj,mean(absfile),max(absfile),mean(relfile),max(relfile));
    
end
fclose(fid1);
fclose(fid2);
