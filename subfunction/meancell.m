function meanX = meancell(X)


% This function computes the average matrix from all matrices contained in
% cells X. All matrices have to have same dimensions.

dimcell = size(X{1});
matX = cell2mat(X);
matX2 = reshape(matX,dimcell(1),dimcell(2),max(size(X)));
meanX = mean(matX2,3);
