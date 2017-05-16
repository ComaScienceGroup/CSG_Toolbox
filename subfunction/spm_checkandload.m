function  D = spm_checkandload(filename)

D = [];
try 
    D = spm_eeg_load(filename);
catch 
    % check it is not a spm format
    try 
        %% Convert to the SPM format 
        D = spm_eeg_convert(filename);
    catch 
        error('Incompatible with SPM')
    end
end
