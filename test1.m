%From Luigi 12/01/17

clc
close all
clear 
clear zame_mastuEq zame_equil zame_sMat zame_params zame_ctrlSeg zame_ctrlSegSet 
clear zame_gap
clear classes
clear all


usedCoils = {'p4', 'p5', 'px', 'd1', 'd2', 'd3', ...
             'd5', 'd6', 'd7', 'dp', 'pc'}
p1Idx = 1;
p6Idx = 13;

paramList = {'rout', 'rin', 'rxpoint', 'zxpoint', 'zsipoint', ...
             'zsopoint', 'gapsNose', 'gapsStkout'}
nParams = length(paramList)

dummy = load('/scratch/lpang/MorphConventional2/equil_B.mat');
equilInitial = dummy.equil;
config = dummy.config;
icoilInitial = get(equilInitial,'icoil');
control = get(equilInitial,'control');
control = set(control,'diagnose',0);
control = set(control,'quiet',1);
coilset = get(config,'coilset');
refRX=[0.9,  0.9];
refZX=[1.3, -1.3];  
iso = fiesta_sensor_isoflux('fbz_iso', refRX, refZX);
feedback = fiesta_feedback2(get(config,'grid'), get(config,'coilset'), 'p6', iso);
equilInitial = set(equilInitial,config,'feedback',feedback,'control',control);

sA = load('/scratch/lpang/MorphConventional2/sMatrix_B.mat');
m  = getMatrix(sA.s); m(:,p6Idx) = []; m(:,p1Idx) = [];
m(7:8,:) = [];
mi = pinv(m);
% routIdx = 1;
% vcrout = mi(:,routIdx);
% dicoil = vcrout * 0.01
pError = zeros(6,1);
%pError(1) = 0.01;
pError(1) = 0.01;
dicoil = mi*pError
dicoil_norm=dicoil/max(dicoil)

%write the normalised coefficients out to a file for use later
fid=fopen('test.txt', 'w');
fprintf(fid, '%s\n', 'Smatrix');
%fprintf(fid, ' %s', char(usedCoils));
for i=1:6
	pError_loop=zeros(6,1);
	pError_loop(i)=0.01;
	dicoil_loop=mi*pError_loop;
	dicoil_norm=dicoil_loop;%/max(abs(dicoil_loop));
	fprintf(fid, '%s', paramList{i});
	for j=1:11
		if j < 11 
			fprintf(fid, ' %f', dicoil_norm(j));
		end
		if j == 11
			fprintf(fid, ' %f\n', dicoil_norm(j));
		end
	end
end
fclose(fid)

circuitLabels = get(icoilInitial,'circuit_labels');
circuitLabels(13) = [];
circuitLabels(1) = [];
icoilFinal = icoilInitial;
for ii=1:11
	%char(circuitLabels{ii});
    icoilFinal.(char(circuitLabels{ii})) = icoilFinal.(char(circuitLabels{ii})) + dicoil(ii);
end
equilFinal = set(equilInitial,config,'icoil',icoilFinal);

figure(equilInitial)
plot(equilInitial,'psi_boundary','r')
plot(equilFinal,'psi_boundary','b')

pI = parameters(equilInitial);
pF = parameters(equilFinal);
pF.rout - pI.rout
pF.rin  - pI.rin
