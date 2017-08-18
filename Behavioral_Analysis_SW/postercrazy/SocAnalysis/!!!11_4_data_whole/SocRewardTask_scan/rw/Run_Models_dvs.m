%% Run Model


maindir = pwd;

%exclude: 228, 231, 237
subs = [203 204 205 206 207 208 209 210 211 212 213 214 215 217 218 219 220 221 222 223 224 225 226 227 229 230 233 234 235 238];
%subs = [203 208 211 223 229 233 234 235];
%subs = 205;

fid = fopen('behavioral_Qlearning_optimization.csv','w');
fprintf(fid,'subnum,inf_pref,BG_acc,aff_alpha,aff_beta,aff_log,aff_bic,inf_alpha,inf_beta,inf_log,inf_bic\n');

for s = 1:length(subs)
    
    
    
    fprintf('working on %d...\n',subs(s));
    
    inf_pref = get_prefs(subs(s));
    BG_acc = get_BG_acc(subs(s));
    
    [~, ~, ~, ~, ~, ~, ~, ~, all_aff, all_inf] = get_pswitch_graded(subs(s));
    
    subid = subs(s);
    subnum = subs(s);
    
    
    % ST - two parameter standard q learning
    model = 'ST';
    min = [0 0.01];
    max = [1 1e5];
    
    
    dec = all_inf(:,1);
    out = all_inf(:,2);
    inf_stout = PAL_Models_dvs(subid, dec, out, min, max);
    inf_alpha = inf_stout.params(2);
    inf_beta = inf_stout.params(3);
    inf_log = inf_stout.params(4);
    inf_bic = inf_stout.params(7);
    
    
    dec = all_aff(:,1);
    out = all_aff(:,2);
    aff_stout = PAL_Models_dvs(subid, dec, out, min, max);
    aff_alpha = aff_stout.params(2);
    aff_beta = aff_stout.params(3);
    aff_log = aff_stout.params(4);
    aff_bic = aff_stout.params(7);
    
    %fprintf(fid,'subnum,inf_pref,BG_acc,aff_alpha,aff_beta,aff_log,aff_bic,inf_alpha,inf_beta,inf_log,inf_bic\n');
    fprintf(fid,'%d,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f\n',subnum,inf_pref,BG_acc,aff_alpha,aff_beta,aff_log,aff_bic,inf_alpha,inf_beta,inf_log,inf_bic);
    
end
fclose(fid);
