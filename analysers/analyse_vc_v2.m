%analyse the effect of a virtual circuit on different equilbria and control
%parameters

%caclulate the actual change in coordinate the of the control points
clear all
%close all

%first read back in the sensitivity matrix for a given config
sfile='smatrix_400kA_conv_low_li.txt';
%sfile='smatrix_400kA_conv_highli.txt';
data=importdata(sfile, ' ', 1);

smatrix=data.data;
control_params=char(data.textdata(2:end));
ncontrol=size(control_params, 1);
coil_ind_s={'p4', 'p5', 'px', 'd1', 'd2', 'd3', 'd5', 'd6', 'd7', 'dp', 'pc'};

%read in the equilbria
%equilibria='/projects/physics/MAST-U/Matfiles/2016/conventional_400kA.mat'
%equilibria='/projects/physics/MAST-U/Matfiles/2016/conventional_400kA_high_li.mat'
equilibria='/projects/physics/MAST-U/Matfiles/2016/Super_X_2014_P4_CATIA.mat';
%equilibria='/projects/physics/MAST-U/Matfiles/2016/high_li_sxd_2014coils.mat'
%equilibria='/projects/physics/MAST-U/Matfiles/2016/Conventional_2014_P4_CATIA.mat'
load(equilibria)
equil_orig=equil;
irod=get(equil, 'irod');

%define limiter
plate=fiesta_line('plate', [0.2611,0.333,0.333,1.09,1.35,1.73], [-0.502,-1.1,-1.303,-2.06,-2.06,-1.68]);
xplate=[0.2611,0.333,0.333,1.09,1.35,1.73];
yplate=[-0.502,-1.1,-1.303,-2.06,-2.06,-1.68];
plt=cat(1,xplate,yplate);

%=============================================================================
%define control points
%get x point and boundary, extract the LCFS
xpt=get(equil, 'xpoint');
r_xpt=get(xpt, 'r');
z_xpt=get(xpt, 'z');
boundary=get(equil, 'boundary');
r_lcfs=get(boundary, 'r');
z_lcfs=get(boundary, 'z');
psin=get(equil, 'Psi_n');
psi_equil=get(equil, 'Psi');

[xy,cc]=contour(psin, [0.999]);
r_bnd=xy(1,:);
z_bnd=xy(2,:);
r_bnd_cut=r_bnd(r_bnd>0 & r_bnd<2.0 & z_bnd>-2.1 & z_bnd<2.1);
z_bnd_cut=z_bnd(r_bnd>0 & r_bnd<2.0 & z_bnd>-2.1 & z_bnd<2.1);
% make row matrix of the values
separatrix=cat(1,r_bnd_cut, z_bnd_cut);
%find the intersections
[x_btm,y_btm,c,d]=intersections(r_bnd_cut, z_bnd_cut, xplate, yplate);
[x_top,y_top,c1,d1]=intersections(r_bnd_cut, z_bnd_cut, xplate, (-1.0)*yplate);
% - this gives some stry points where the ends of the contour are joined
% - calculate the psi on the points and then filter them
eqgrid=get(equil, 'grid');
r_grid=get(eqgrid, 'r');
z_grid=get(eqgrid, 'z');
low_div_psi=interp2(psin, x_btm, y_btm);
upp_div_psi=interp2(psin, x_top, y_top);
limit=0.0004;
x_btm=x_btm(abs(low_div_psi-0.999) < limit);
y_btm=y_btm(abs(low_div_psi-0.999) < limit);
x_top=x_top(abs(upp_div_psi-0.999) < limit);
y_top=y_top(abs(upp_div_psi-0.999) < limit);

% find the midplane intersections
xmid=[0,2];
zmid=[0,0];
[x_mid,y_mid,c,d]=intersections(r_lcfs, z_lcfs, xmid, zmid);

%make array of all control points
control_points=['Rin ','Rout ','RXpt_up ', ...
				'RXpt_low ','RSIL ','RSOL ','RSIU ','RSOU'];
if numel(r_xpt)==1
x_control=[x_mid', r_xpt, r_xpt, x_btm', x_top'];
y_control=[y_mid', z_xpt, (-1.0)*z_xpt, y_btm', y_top'];
end
if numel(r_xpt)==2
x_control=[x_mid', r_xpt, x_btm', x_top'];			%assume both have same R...
y_control=[y_mid', (-1.0)*z_xpt, y_btm', y_top']; %-1 as z pt in numeric order
end
%==============================================================================
%plot the results of the control points
plot(equil)
plot(config)
plotmastuoutline
plot(x_btm, y_btm, 'ro')
plot(x_top, y_top, 'ro')
plot(xpt, 'ro')
plot(x_mid, y_mid, 'ro')
plot(get(xpt, 'r'), (-1.0)*get(xpt, 'z'), 'ro')
%==============================================================================
%calculate a delta_psi using the virtual circuit at each control point
%convert to a distance using delta_psi=2piBdelta -> rearrange for delta
%need to do this for each control circuit

icoil_orig=get(equil, 'icoil');
icoil_flux=icoil_orig;
%icoil_flux.pc=0;
%first make the icoil structure
dI=2.0; %parameter to multiply the S matrix values

%need to loop this over all the other control parameters
delta=zeros(ncontrol,numel(x_control));
delta_vc=zeros(ncontrol,numel(x_control));
icoil_total=icoil_orig;

for i=1:ncontrol

	for ii=1:11
		icoil_total.(char(coil_ind_s{ii}))=icoil_orig.(char(coil_ind_s{ii}))+... 
											smatrix(i,ii)*dI;
	end
	control = get(equil,'control');
	control = set(control,'diagnose',0);
	control = set(control,'quiet',1);
	coilset = get(config,'coilset');

	refRX=[0.9,  0.9];
	refZX=[1.3, -1.3];  
	iso = fiesta_sensor_isoflux('fbz_iso', refRX, refZX);
	feedback=fiesta_feedback2(get(config,'grid'), get(config,'coilset'), ...
							'p6', iso);
	equil_new=set(equil,config,'feedback',feedback,'control',control);
	equil_new=set(equil_new,config,'icoil',icoil_total);

	%now find the location of the control points in the new equil
	%define control points
	%get x point and boundary, extract the LCFS
	xpt_vc=get(equil_new, 'xpoint');
	r_xpt_vc=get(xpt_vc, 'r');
	z_xpt_vc=get(xpt_vc, 'z');
	boundary_vc=get(equil_new, 'boundary');
	r_lcfs_vc=get(boundary_vc, 'r');
	z_lcfs_vc=get(boundary_vc, 'z');
	psin_vc=get(equil_new, 'Psi_n');
	psi_equil_vc=get(equil_new, 'Psi');

	[xy_vc,cc_vc]=contour(psin_vc, [0.999]);
	r_bnd_vc=xy_vc(1,:);
	z_bnd_vc=xy_vc(2,:);
	r_bnd_cut_vc=r_bnd_vc(r_bnd_vc>0 & r_bnd_vc<2.0 & z_bnd_vc>-2.1 & z_bnd_vc<2.1);
	z_bnd_cut_vc=z_bnd_vc(r_bnd_vc>0 & r_bnd_vc<2.0 & z_bnd_vc>-2.1 & z_bnd_vc<2.1);
	% make row matrix of the values
	separatrix=cat(1,r_bnd_cut_vc, z_bnd_cut_vc);
	%find the intersections
	[x_btm_vc,y_btm_vc,c_vc,d_vc]=intersections(r_bnd_cut_vc, z_bnd_cut_vc,...
															xplate, yplate);
	[x_top_vc,y_top_vc,c1_vc,d1_vc]=intersections(r_bnd_cut_vc,z_bnd_cut_vc,...
													xplate, (-1.0)*yplate);
	% - this gives some stry points where the ends of the contour are joined
	% - calculate the psi on the points and then filter them
	eqgrid_vc=get(equil, 'grid');
	r_grid_vc=get(eqgrid, 'r');
	z_grid_vc=get(eqgrid, 'z');
	low_div_psi_vc=interp2(psin_vc, x_btm_vc, y_btm_vc);
	upp_div_psi_vc=interp2(psin_vc, x_top_vc, y_top_vc);
	x_btm_vc=x_btm_vc(abs(low_div_psi_vc-0.999) < limit);
	y_btm_vc=y_btm_vc(abs(low_div_psi_vc-0.999) < limit);
	x_top_vc=x_top_vc(abs(upp_div_psi_vc-0.999) < limit);
	y_top_vc=y_top_vc(abs(upp_div_psi_vc-0.999) < limit);

	% find the midplane intersections
	[x_mid_vc,y_mid_vc,c_vc,d_vc]=intersections(r_lcfs_vc, z_lcfs_vc,...
														 xmid, zmid);

	%make array of all control points
	if numel(r_xpt_vc) == 1
		x_control_vc=[x_mid_vc', r_xpt_vc, r_xpt_vc, x_btm_vc', x_top_vc'];
		y_control_vc=[y_mid_vc', z_xpt_vc, (-1.0)*z_xpt_vc, ...
						y_btm_vc', y_top_vc'];
	end
	if numel(r_xpt_vc) ==2
		x_control_vc=[x_mid_vc', r_xpt_vc, x_btm_vc', x_top_vc'];
		y_control_vc=[y_mid_vc', (-1.0)*z_xpt_vc, ...
						y_btm_vc', y_top_vc'];
	end
	%calculate the change in the location of the control points
	delta_x=x_control-x_control_vc;
	delta_y=abs(y_control)-abs(y_control_vc); %kludge for when the xpts are
											%other way up

	delta_vc(i,:)=sqrt(delta_x.^2+delta_y.^2);
end

%write the result in delta_vc to a file
fid=fopen('analyse_vc_out.txt', 'w');

fprintf(fid, '%s\n', equilibria);
fprintf(fid, '%s\n', sfile);
fprintf(fid, '%s', 'delta_pos(m) ');
fprintf(fid, '%s', control_points);
fprintf(fid, '%s\n', ' ');

for i=1:ncontrol
	fprintf(fid, '%s', control_params(i,:));
	for j=1:numel(x_control)
		if j < numel(x_control)
			fprintf(fid, ' %f', delta_vc(i,j));
		end
		if j == numel(x_control)
			fprintf(fid, ' %f\n', delta_vc(i,j));
		end
	end
end
fclose(fid);

%plot the result and check the location of the control points is correct
figure(config)
hold on
plotmastuoutline
plot(config)
plot(equil_orig, 'psi_boundary', 'b')
plot(equil_new, 'psi_boundary', 'r') 

plot(x_control, y_control, 'ob')
plot(x_control_vc, y_control_vc, 'xr')

%reculate the equilbrium with the extra VC circuit current added
icoil_total=icoil_orig;
for ii=1:11
	icoil_total.(char(coil_ind_s{ii}))=icoil_orig.(char(coil_ind_s{ii}))+... 
											smatrix(i,ii)*dI;
end
