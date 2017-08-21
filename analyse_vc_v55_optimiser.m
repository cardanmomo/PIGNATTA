%analyse the effect of a virtual circuit on different equilbria and control
%parameters
%caclulate the actual change in coordinate the of the control points
clear all
%close all
%first read back in the sensitivity matrix for a given config
displ = 80;

eval(sprintf('sfile=''/home/cmoreno/work/smats_SD_400kA/smat%d.txt'';', displ))
data=importdata(sfile, ' ', 1);

smatrix=data.data;
control_params=char(data.textdata(2:end));
ncontrol=size(control_params, 1);
coil_ind_s={'p4', 'p5', 'px', 'd1', 'd2', 'd3', ...
    'd5', 'd6', 'd7', 'dp', 'pc'};
%read in the equilbria

load Conventional_2014_P4_CATIA_400kA;
equil_orig=equil;
coilset = get(config,'coilset');
control = get(equil,'control');
control = set(control,'diagnose',0);
control = set(control,'quiet',1);

control_points=['mid_in ','mid_out ','xp_low ', 'xp_up ','sp_in_low ', ...
    'sp_out_low ','sp_in_up ','sp_out_up'];
[x_control, y_control, conn_len]=control_pointsV3(equil_orig);
delta=zeros(ncontrol,numel(x_control));
delta_vc=zeros(ncontrol,numel(x_control));
%==========================================================================
%plot the results of the control points
%plot(equil)
%plot(config)
%plotmastuoutline
%plot(x_control, y_control, 'ro')
%==========================================================================
%calculate a delta_psi using the virtual circuit at each control point
%convert to a distance using delta_psi=2piBdelta -> rearrange for delta
%need to do this for each control circuit
% Isoflux sensor
iso = fiesta_sensor_isoflux('fbz_iso', [0.9,  0.9], [1.3, -1.3]);
% v_circ: *equil*, *coilset*, *dI*, *control parameter*
control_p=6;  % Control parameter
tol=0.001;  % Tolerance 
%displ=25;  % Displacement in cm
[icoil_total]=v_circ(equil, coilset, smatrix, displ, control_p);

% Introduce feedback & calculate new equilibrium
feedback=fiesta_feedback2(get(config,'grid'), coilset, 'p6', iso);
equil_new=set(equil,config,'feedback',feedback,'control',control);
equil_new=set(equil_new,config,'icoil',icoil_total);
% Find the location of the control points in the new equil
[x_control_vc, y_control_vc, conn_len_vc]=control_pointsV3(equil_new);
% Calculate the change in the location of the control points
dz=y_control_vc-y_control;
dr=x_control_vc-x_control;

% This next bit is just to prove that the given matrix works
%[icoil_total, x_control_vc, y_control_vc, equil_new]=icoil_calc(tol,...
%    icoil_total, x_control_vc, x_con   trol, y_control_vc, y_control, iso,...
%    dr, dz, equil_new, coilset, smatrix, config, control, control_p);

% Use the function created to modify the smatrix values
[icoil_total, x_control_vc, y_control_vc, equil_new]=icoil_mod1(tol,...
    icoil_total, x_control_vc, x_control, y_control_vc, y_control, iso,...
    dr, dz, equil_new, coilset, smatrix, config, control, control_p, displ);

[x_control_vc, y_control_vc, conn_len_vc]=control_pointsV3(equil_new);
% Get absolute displacement
delta_x=x_control-x_control_vc;
delta_y=abs(y_control)-abs(y_control_vc); %kludge
delta_vc(1,:)=sqrt(delta_x.^2+delta_y.^2);
smat=icoil_total-get(equil, 'icoil')


%plot the result and check the location of the control points is correct
hold on
plot(equil_orig, 'psi_boundary', 'b')
plot(equil_new, 'psi_boundary', 'r') 
plotmastuoutline
plot(config)
plot(x_control, y_control, 'ob')
plot(x_control_vc, y_control_vc, 'xr')
%conn_len
%conn_len_vc
d_r=x_control_vc(control_p)-x_control(control_p)
%d_z=abs(y_control_vc(control_p)-y_control(control_p))
