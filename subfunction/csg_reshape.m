function rdata = csg_reshape(data,Nchan,Nepo,Lepo,Ltot)


% this function reshape the matrix data(N,M) composed of N channels and M
% samples in a matrix opf three dimensions(N,M,L), composed of N channels,M
% epochs and L samples by epochs. In the last epoch, samples disable are
% filled with zeros to complete the matrix

rdata = zeros(Nchan,Nepo,Lepo);
rdata(:,1:Nepo-1,1:Lepo) = reshape(data(:,1:(Nepo-1)*Lepo),Nchan,Nepo-1,Lepo);
rdata(:,Nepo,1:Ltot-(Nepo-1)*Lepo) = data(:,(Nepo-1)*Lepo+1:Ltot);