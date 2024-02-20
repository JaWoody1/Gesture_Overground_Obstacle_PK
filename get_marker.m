function [result] = get_marker(data_name,xyz,column_length,Trajstart,trial_txt)
%get_marker
%Replaces the infinite amount of if statments that were used to get the
%data from each marker
    for ii = column_length
            category = strmatch(data_name,trial_txt(Trajstart+2,ii));
            if category == 1
                if xyz == 'x'
                    result = ii;
                elseif xyz == 'y'
                    result = ii+1;
                elseif xyz == 'z'
                    result = ii+2;
                end
                
                
                break
            end
    end



end