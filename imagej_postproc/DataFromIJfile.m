function [ tr ] = DataFromIJfile(fname,scale)
% Loads data into traj structure from ImageJ result xls file
% Data are scaled to physical units.
%   fname = file name of the input file
%   scale = conversion from px to um; use 1 if the input data are already in physical units
%
%   traj structure contains:
%   traj.length = length of the trajectory (integer)
%   traj.pos = vector of particle positions (traj.length rows, 2 columns)

% omit 1st row with header
data = dlmread(fname,',',1,0);


% trim data to contain only traj index, frames and positions
data = data(:,1:4);

% add +1 so that frames are numbered from 1
data(:,2) = data(:,2) + 1;

trInd = 1;
trStart = 1;

for i = 1:length(data)
    
    % arrived at a new trajectory, save into struct
    if data(i,1) ~= trInd
        
        tr(trInd).pos = data(trStart:(i-1),3:4).*scale;
        tr(trInd).fr = data(trStart:(i-1),2);
        tr(trInd).length = size(tr(trInd).pos,1);
        
        trInd = trInd + 1;
        trStart = i;
    
    end

end

end