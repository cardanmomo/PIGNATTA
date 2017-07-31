A = [(smat.p4), (smat.p5), (smat.px), (smat.d1), (smat.d2), (smat.d3), ...
    (smat.d5), (smat.d6), (smat.d7), (smat.dp), (smat.pc)];
data=importdata(sfile, ' ', 1);
smatrix=data.data;
control_params=char('rin','rout','rxpoint','zxpoint','zsipoint','zsopoint');
fid=fopen(sfile, 'w');
ncontrol=size(control_params, 1);
fprintf(fid, 'Smatrix\n');
%for i=1:3
%	fprintf(fid, '%s', control_params(i,:));
%	for j=1:11
%		if j < 11
%			fprintf(fid, ' %f', smatrix(i,j));
%		end
%		if j == 11
%			fprintf(fid, ' %f\n', smatrix(i,j));
%		end
%	end
%end

fprintf(fid, '%s', control_params(1,:));
for j=1:11
    if j < 11
        fprintf(fid, ' %f', A(:, j));
	end
	if j == 11
		fprintf(fid, ' %f\n', A(:, j));
	end
end

for i=2:6
	fprintf(fid, '%s', control_params(i,:));
	for j=1:11
		if j < 11
			fprintf(fid, ' %f', smatrix(i,j));
		end
		if j == 11
			fprintf(fid, ' %f\n', smatrix(i,j));
		end
	end
end
fclose(fid);