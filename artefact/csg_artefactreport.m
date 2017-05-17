function csg_artefactreport(D)

% D is the meeg object for the one the artefact report has to be display

% Check if the artefact detection has been processed
if isfield(D,'CSG') && isfield(D.CSG,'preprocessing')
    if isfield(D.CSG.preprocessing,'artefact')
            % display of a binary matrix to show how artefacted is the signal
        artefact    =   D.CSG.preprocessing.artefact;
        Lwin        =   D.CSG.preprocessing.info.Lwin;
        Swin        =   D.CSG.preprocessing.info.Swin;
        interpol    =   D.CSG.preprocessing.info.interpolation;
        display_art =   csg_displayart(artefact);
        
        % report format
        report buildreportpreprocessing -fpdf
        
        
    else 
        disp('The Artefact detection method has not been used!!!!')
        return;
    end
else 
    disp('No preprocessing in this file!!!!!!!!!')
    return;
end