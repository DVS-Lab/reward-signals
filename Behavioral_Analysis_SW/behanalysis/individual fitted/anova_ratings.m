% anova for ratings
y = [rating_pwin;rating_nwin;rating_ploss;rating_nloss];
    g1 = [repmat({'win'},length(sign_win),1);repmat({'loss'},length(sign_loss),1);];
    g2 = [repmat({'pos'},length(pos_win),1);repmat({'neg'},length(neg_win),1);...
        repmat({'pos'},length(pos_loss),1);repmat({'neg'},length(neg_loss),1)];
    p = anovan(y,{g1,g2},'model','interaction',...
    'varnames',{'soc_win','RPE_sign'});