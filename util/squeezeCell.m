function cell_out = squeezeCell(cell_in)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

L = length(cell_in)
cell_out = {};

for i=1:L
    cell_out{end+1} = num2str(cell_in{i})
end
end

