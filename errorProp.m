% propagate error from different sources

del_length = (ci_length(1,2)-lnth(1))/lnth(1);
del_width = (ci_width(1,2)-width(1))/width(1);
del_baleen = (ci_baleen(1,2)-baleen(1))/baleen(1);

del_all = sqrt(del_width.^2 + del_baleen.^2 + del_length.^2);

