function varargout = csg_get_defaults(defstr, varargin)
% Get/set the defaults values associated with an identifier
% FORMAT defaults = csg_get_defaults
% Return the global "defaults" variable defined in csg_defaults.m.
%
% FORMAT defval = csg_get_defaults(defstr)
% Return the defaults value associated with identifier "defstr". 
% Currently, this is a '.' subscript reference into the global  
% "csg_def" variable defined in csg_defaults.m.
%
% FORMAT csg_get_defaults(defstr, defval)
% Sets the defaults value associated with identifier "defstr". The new
% defaults value applies immediately to:
% * new modules in batch jobs
% * modules in batch jobs that have not been saved yet
% This value will not be saved for future sessions of FASST. To make
% persistent changes, edit csg_defaults.m.
%__________________________________________________________________________
% Copyright (C) 2008 Wellcome Trust Centre for Neuroimaging
% Copyright (C) 2010 Cyclotron Research Centre
% Copyright (C) 2017 Coma Science Group

% Volkmar Glauche
% Then modified for use with the FASST toolbox by Christophe Phillips
% Then modified for use with the CSG toolbox by Dorothée Coppieters
% $Id$

global csg_def;
if isempty(csg_def)
    csg_defaults;
end

if nargin == 0
    varargout{1} = csg_def;
    return
end

% construct subscript reference struct from dot delimited tag string
tags = textscan(defstr,'%s', 'delimiter','.');
subs = struct('type','.','subs',tags{1}');

if nargin == 1
    varargout{1} = subsref(csg_def, subs);
else
    csg_def = subsasgn(csg_def, subs, varargin{1});
end
