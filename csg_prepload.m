function csg_prepload

% load files to be preprocessed
filenames = spm_select(inf,'any','Select raw data file');
Nfiles = size(filenames,1);

for i = 1 : Nfiles 
    % load files in the SPM format
    try 
        handles.Dmeg{i} = spm_eeg_load(deblank(filenames(i,:)));
    catch 
        % check if there are spm compatible
        S = deblank(filenames(i,:)); 
        try 
            hanldes.Dmeg{i} = spm_eeg_convert(S);
        catch 
            error('Format incompatible with SPM')
        end
    end
end
handles.Nfiles = Nfiles;      
csg_prepromenu(handles);