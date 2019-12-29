function [gr] = AddFrameToGrid(gr,fr)
% Adds single frame to the grid structure.

% only frames with data
if fr.pts ~= 0

    % limits of the grid (assumes that the positions start at [0 0])
    maxlim = gr(end,end).boxend;

    % transform fr.pos into grid indices
    grind = int32(ceil(fr.pos./maxlim.*size(gr)));

    % add data to grid boxes
    for i = 1:size(grind,1)

        % weighted addition
        % first grind indicates the column, second grind indicates the row
        gr(grind(i,1),grind(i,2)).vel =...
            (gr(grind(i,1),grind(i,2)).vel.*gr(grind(i,1),grind(i,2)).pts + fr.vel(i,:))/...
            (gr(grind(i,1),grind(i,2)).pts + 1);

        gr(grind(i,1),grind(i,2)).sqvel =...
            (gr(grind(i,1),grind(i,2)).sqvel.*gr(grind(i,1),grind(i,2)).pts + fr.vel(i,:).^2)/...
            (gr(grind(i,1),grind(i,2)).pts + 1);

        gr(grind(i,1),grind(i,2)).pts = gr(grind(i,1),grind(i,2)).pts + 1;

    end

end

end