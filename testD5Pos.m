clc
close all
clear 
clear zame_mastuEq zame_equil zame_sMat zame_params zame_ctrlSeg zame_ctrlSegSet 
clear zame_gap
clear all
% profile on
generateData = 1;
if (generateData == 1)

%     scenario = '/work/lpang/Matfiles/ScenarioA1_Ip_1d0.mat'
%     scenario = '/work/lpang/Matfiles/sxdKNoGap01.mat'
%     scenario = './ScenarioA1_R07_simplified_eq2.mat'
    scenario = './tocchi/scenariSXD/High_li_Super_X.mat'
    equil = zame_mastuEq('scenario',scenario);
    equil = set(equil,'ctrlFunction',@gapCtrlSolSwingLoop);


    config = get(equil.zame_equil,'config')
%    divertorGrid = fiesta_grid( 0.86,  1.80, 2^7+1, ...
%        -2.30, -1.50, 2^7+1);
    divertorGrid = fiesta_grid( 0.865,  1.80, 2^8+1, ...
       -2.10,  -1.50, 2^8+1);
    divertorGrid = enfine(divertorGrid);
    divertorConfig = fiesta_extragrid('Divertor Extra Grid', config, divertorGrid);
%    load('/home/lpang/work/zMASTU/divertorConfig.mat')
    equil.divertorEquil  = fiesta_extra('Divertor Extra eq', ...
                                         divertorConfig, ...
                                         get(equil.zame_equil,'equil'));

    % paramList = {'rout','rin','rxpoint','zxpoint'};
    paramList = {'rxpoint','zxpoint'};
    coils     = {'p1','p4','p5','p6','pc','px','dp','d1','d2','d3','d5','d6','d7'};

%     load('temp.mat')
    p = zame_params('paramList',paramList)
    gapSet = zame_gapSet('gapSegmentConf3');
    activeGaps = [1, 8, 9];
    gapSet = set(gapSet,'activeGaps',activeGaps);
    p = add(p, 'gaps', gapSet);

    equil = set(equil,'params', p);
    p = get(equil,'params');
%     plot(equil,'psi_boundary')
%     hold on
%     c=getDivFluxCurve(equil,0.025);
%     plot(c(1,:), c(2,:), 'r')
%     c=getDivFluxCurve(equil,0.0001);
%     plot(c(1,:), c(2,:), 'r')
%     plot(gapSet)

    origEquil = equil;
    pOrig     = get(equil,'params');
    pOrigVal  = get(pOrig,'paramValues');

    paramList = get(p,'paramList')
    s = zame_sMat('paramList',paramList, 'coilList',coils);

    tic;
    s = fastGenerateSMatrix(s, equil)
    toc

    save([mfilename,'Data.mat'])
else
    load([mfilename,'Data.mat'])
end
% return
controlledParams = {'rxpoint','zxpoint','gaps'};
controlledCoils = coils;
controlledCoils(cellfind(controlledCoils, 'p1')) = [];
controlledCoils(cellfind(controlledCoils, 'p6')) = [];

delta = -50;
l = 30;

pval(1, l+1) = pOrig;
pval(end)    = [];
eqs(1, l+1)  = equil;
eqs(end)     = [];

for ii=1:l
    fprintf('ii = %d/%d \b\r',ii,l);
    equil = setCoilCurrentValue(equil, 'p1', ['d',num2str(delta)]);

    equil = ctrl(equil,'sMat',s, 'params', p, ...
                 'controlledParams',controlledParams, ...
                 'controlledCoils',controlledCoils, ...
                 'forcingCoil',{'p1'}, 'forcingValue', delta, ...
                 'params',pOrig);
     
    if (~converged(equil))
        l=ii-1;
        break
    end
    p = get(equil,'params');
    
    pval(ii) = p;
    currents(ii, :) = get(get(get(equil,'equil'),'icoil'), 'currents');
    eqs(ii) = equil;
end
get(get(equil,'equil'), 'ip')

figure(get(equil,'equil'))
hold on
for ii=1:l
    plot(eqs(ii), 'psi_boundary','color',num2grad(ii, l+1));
    hold on
    c=getDivFluxCurve(eqs(ii),0.025);
    plot(c(1,:), c(2,:), 'color',num2grad(ii, l+1))
end
plot(gapSet)

figure
hold on
for ii=1:l
    plot(pval(ii)-pOrig, '-o','color',num2grad(ii, l+1));
end

figure
hold on
for ii=1:l
    plot(currents(ii,:), '-o','color',num2grad(ii, l+1));
end