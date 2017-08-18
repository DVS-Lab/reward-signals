sca;
run_time = GetSecs - startsecs;
if exist('data','var')
    save(outputname, 'data','run_time');
else
    save(outputname,'run_time');
end
return;