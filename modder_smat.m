%A = [(smat.p4), (smat.p5), (smat.px), (smat.d1), (smat.d2), (smat.d3), ...
%    (smat.d5), (smat.d6), (smat.d7), (smat.dp), (smat.pc)];
vfile = 'THE_sxd_1MA_lowli.txt';
vdata2 = importdata(vfile, ' ', 0);
vdata = vdata2.data;
A = vdata(12,:);
sfile = 'smat1.txt';
data=importdata(sfile, ' ', 1);
smatrix=data.data;
sfile2 = 'smat50.txt';
control_params=char('rin','rout','rxpoint','zxpoint','zsipoint','rsopoint');
fid=fopen(sfile2, 'w');
ncontrol=size(control_params, 1);
fprintf(fid, 'Smatrix\n');
for i=1:5
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

fprintf(fid, '%s', control_params(6,:));
for j=1:11
    if j < 11
        fprintf(fid, ' %f', A(:, j));
	end
	if j == 11
		fprintf(fid, ' %f\n', A(:, j));
	end
end

%for i=5:6
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
fclose(fid);