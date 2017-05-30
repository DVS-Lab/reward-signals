clear;
maindir = pwd;
sublist = [1002 1003 1005:1028];

fid = fopen(fullfile(maindir,['Behavior_' date '_Summary.csv']),'w');
fprintf(fid,'subj,tot,cursoc,curnonsoc,presoc,prenonsoc,win,nowin\n');

for s = 1:length(sublist)
    
    subj = sublist(s);
    [tot, cursoc, curnonsoc, presoc, prenonsoc, win, nowin] = make_3col_files_m05(subj);
    fprintf(fid,'%d,%3.3f,%3.3f,%3.3f,%3.3f,%3.3f,%3.3f,%3.3f\n',subj,tot, cursoc, curnonsoc, presoc, prenonsoc, win, nowin);
    
end
fclose(fid);
