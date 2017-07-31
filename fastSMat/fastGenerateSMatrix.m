function ret = fastGenerateSMatrix(sMat, equil)
% Calculate the values of the sensitivity matrix elements.
% This function calculates the values of the sensitivity matrix s for a
% given equilibrium equil. 
% This function is very time and cpu consuming. For a zame_mastEq in which
% paramList contains some param and fluxes the time needed is of the order 
% of 2 or 3 minutes. For a zame_mastuEq in which paramList contains 6 gaps
% it could need also 20 minutes. 
% In order to speed up its execultion, generateSMatrix starts an
% independent matlab process for each coil and in the end merges all the
% results. To do this uses /tmp/$USER/ directory as temporary storing
% place.
%
% SYNOPSIS:
% ret = generateSMatrix(sMat, equil)

    disp('fastGenerateSMatrix start')

    ret = sMat;
%     ret.equil = equil;
    ret = set(ret,'equil',equil);
    %% TODO: add check if params are available or not
    paramList = get(sMat,'paramList');
    params    = get(equil,'params');
    params    = set(params,'paramList',paramList);
    equil     = set(equil,'params',params);

    llExists = system('command -v llsubmit');
    if (llExists == 0)
        s = fastLLCalcSensitivityMatrix(sMat, equil);
    else
        warning('fastGenerateSMatrix: llsubmit is not available. Using local PC.')
        s = fastParallelCalcSensitivityMatrix(sMat, equil); 
    end
    
    paramMult = get(params, 'paramMult');
    
    s = mat2cell(s, paramMult, ones(1, size(s, 2)));
    
    ret = set(ret,'s',s);
    disp('fastGenerateSMatrix end')
end
