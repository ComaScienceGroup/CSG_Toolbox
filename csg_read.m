function csg_read(varargin)

if isempty(varargin)
    D = spm_eeg_load;
else 
    D = varargin{1};
end 
if isfield(D,'CSG')
    if isfield(D.CSG,'preprocessing') && isfield(D.CSG.preprocessing,'artefact')
        csg_displayart(D.CSG.preprocessing.artefact);
        if ~isempty(D.CSG.preprocessing.info.Swin)
            disp('Artefacts have been detected with a method inspired by the one developed in http://hdl.handle.net/2268/172300')
            disp(['Obvious bad channels are detected and removed in every ', num2str(D.CSG.preprocessing.info.Lwin),'s time windows'])
            disp('Then, a finer detection consists of comparing channels.')
            disp(['For high density EEG, coherence analysis is used to remove bad channels in every ', num2str(D.CSG.preprocessing.info.Swin),'s time windows'])
        else 
            disp('Artefacts have been detected with a method inspired by the one developed in http://hdl.handle.net/2268/172300')
            disp(['Obvious bad channels are detected and removed in every ', num2str(D.CSG.preprocessing.info.Lwin),'s time windows'])
            disp('Then, a finer detection consists of comparing channels.')
        end
        if isfield(D.CSG.preprocessing.info,'interpolation ')
            if and(D.CSG.preprocessing.info.ILwin,D.CSG.preprocessing.info.ISwin)
                disp(['All bad channels have been interpolated with the configuration saved in the structure of your data: CSG.preprocessing.info.interpolation ',])
            elseif and(D.CSG.preprocessing.info.ILwin,~D.CSG.preprocessing.info.ISwin)
                disp(['Bad channels detected over ', num2str(D.CSG.preprocessing.info.Lwin),' have been interpolated with the configuration saved in the structure of your data: CSG.preprocessing.info.interpolation ',])
            elseif and(~D.CSG.preprocessing.info.ILwin,D.CSG.preprocessing.info.ISwin)
                disp(['Bad channels detected over ', num2str(D.CSG.preprocessing.info.Swin),' have been interpolated with the configuration saved in the structure of your data: CSG.preprocessing.info.interpolation ',])
            else
                disp(['No bad channel has been interpolated',])
            end
        end       
    end
    
else
    disp('No process from this Toolbox')
end
        