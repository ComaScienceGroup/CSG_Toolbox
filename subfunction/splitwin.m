function newmat = splitwin(mat,n)

% this function split columns from the initial matrix 'mat' into 'n'
% subcolumn. Values in subcolumns correspond to the initial column their
% come from.

colm = reshape(mat,numel(mat),1);
repcolm = repmat(colm,1,n);
cuthor = repmat(size(mat,1),1,size(mat,2));
newmat = cell2mat(mat2cell(repcolm,cuthor,n)');