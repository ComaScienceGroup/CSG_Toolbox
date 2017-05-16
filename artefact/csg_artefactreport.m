function csg_artefactreport(D)

% D is the meeg object for the one the artefact report has to be display

% Check if the artefact detection has been processed
if isfield(D,'CSG') && isfield(D.CSG,'preprocessing')
    if isfield(D.CSG.preprocessing,'artefact')
            % display of a binary matrix to show how artefacted is the signal
        artefact = D.CSG.preprocessing.artefact;
        Lwin = D.CSG.preprocessing.info.Lwin;
        display_art = splitwin(artefact,Lwin);
        
        % report format
        report testrpt -fpdf
        
        
        [r, c] = size(mat);                          % Get the matrix size
        imagesc((1:c)+0.5, (1:r)+0.5, mat);          % Plot the image
        colormap(gray);                              % Use a gray colormap
        axis equal                                   % Make axes grid sizes equal
        set(gca, 'XTick', 1:(c+1), 'YTick', 1:(r+1), ...  % Change some axes properties
                 'XLim', [1 c+1], 'YLim', [1 r+1], ...
                 'GridLineStyle', '-', 'XGrid', 'on', 'YGrid', 'on');
             [r, c] = size(new);                          % Get the matrix size
        figure
        imagesc((1:c)+0.5, (1:r)+0.5, new);          % Plot the image
        colormap(gray);                              % Use a gray colormap
        axis equal                                   % Make axes grid sizes equal
        set(gca, 'XTick', 1:(c+1), 'YTick', 1:(r+1), ...  % Change some axes properties
                 'XLim', [1 c+1], 'YLim', [1 r+1], ...
                 'GridLineStyle', '-', 'XGrid', 'on', 'YGrid', 'on');
    else 
        disp('The Artefact detection method has not been used!!!!')
        return;
    end
else 
    disp('No preprocessing in this file!!!!!!!!!')
    return;
end