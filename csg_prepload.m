function csg_prepload

% load files to be preprocessed
filenames = spm_select(inf,'any','Select raw data file');
Nfiles = size(filenames,1);

for i = 1 : Nfiles 
    % load files in the SPM format
    handles.Dmeg{i} = spm_checkandload(deblank(filenames(i,:)));
end
handles.Nfiles = Nfiles;      
CSG_prepromenu(handles);