function [result] = get_data_from_rows(data_set,rows,column)
%Replaces the large block of code and gets the column data into a matrix
    result = create_matrix(data_set, 1);

    for ii = 1:rows
        result(ii,1) = data_set(ii, column);
    
    

    end
end