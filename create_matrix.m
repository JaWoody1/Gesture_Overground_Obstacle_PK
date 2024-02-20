function [result] = create_matrix(table, size)
%Create an empty matrix
    result = zeros(length(table(:, 1)), size);
end