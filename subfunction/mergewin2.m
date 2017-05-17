function newmat = mergewin2(mat)

% this function split columns from the initial matrix 'mat' into 'n'
% subcolumn. Values in subcolumns correspond to the initial column their
% come from.

mat1 = mat(:,1:2:end);
mat2 = mat(:,2:2:end);
if numel(mat2)<numel(mat1)
    newmat = or(mat1(:,1:end-1),mat2);
else
    newmat = or(mat1,mat2);
end
