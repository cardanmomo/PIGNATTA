function ret = cellfind(cell, cell2find)
%

    if ~iscell(cell2find)
        cell2find = {cell2find};
    end
    ret = zeros(1, length(cell2find));
    for ii=1:length(cell2find)
        for jj=1:length(cell)
            if (strcmp(char(cell2find{ii}), char(cell{jj})))
                ret(ii) = jj;
            end
        end
    end


end