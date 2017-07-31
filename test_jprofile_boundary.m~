%Program to adjust current profile with a constrain in the boundary

%close all
%clear all

%load('/common/projects/physics/MAST-U/Matfiles/2016/conventional_400kA_high_li.mat')
%load('/projects/physics/MAST-U/Matfiles/2016/Super_X_2014_P4_CATIA.mat')
%load('/2016/Conventional_2014_P4_CATIA');
load 2016/Super_X_2014_P4_CATIA_400kA;
irod=2.4e6;
%irod=get(equil, 'irod');

control=get(equil, 'control');
control = set(control,'diagnose',0);  % Avoid animations
control = set(control,'quiet',1);

grid=get(equil, 'grid');
feedback=get(equil, 'feedback');
icoil=get(equil, 'icoil');
jprofile=get(equil, 'jprofile');

Ip = 1e6;

dos_a =     [0.5,   1,      2]  *0.4e6;
tres_a =    [0.25,  1.5,    3]  *0.33e6;
cuatro_a =  [1,     1,      1]  *0.65e6;
cinco_a =   [4,     2,      1]  *0.75e6;
seis_a =    [4,     2       ]   *1.0e6;
siete_a =   [0.1,   0.1     ]   *1.75e6;

dos_b =     [0.25,  0.5,    1];
tres_b =    [0.25,  0.5,    1.];
cuatro_b=   [0.5,   0.5,    0.5];
cinco_b =   [2,     1,      0.5];
seis_b =    [2,     1];
siete_b =   [0.1,   0.1];

jprofile2=fiesta_jprofile_lao('testj2', dos_a, dos_b, 1, Ip);
jprofile3=fiesta_jprofile_lao('testj3', tres_a, tres_b, 1, Ip);
jprofile4=fiesta_jprofile_lao('testj4', cuatro_a, cuatro_b, 1, Ip);
jprofile5=fiesta_jprofile_lao('testj5', cinco_a, cinco_b, 1, Ip);
jprofile6=fiesta_jprofile_lao('testj6', seis_a, seis_b, 1, Ip);
jprofile7=fiesta_jprofile_lao('testj7', siete_a, siete_b, 1, Ip);
coilset=get(config, 'coilset');

% Get boundary
bnd=get(equil, 'boundary');
r_bnd=get(bnd, 'r');
z_bnd=get(bnd, 'z');
[rc,nc]=sort(r_bnd);
zc=z_bnd(nc);
sensor_bulkboundary=fiesta_sensor_isoflux('shape', [rc]', [zc]');

% Get x-points
[x_control, y_control, conn_len] = control_pointsV3(equil);
xpt=fiesta_point('Xpt', x_control(4), y_control(4));
xpt2=fiesta_point('Xpt2', x_control(3), y_control(3));
% And create B sensors on them
sensor_br=fiesta_sensor_br(xpt);
sensor_br2=fiesta_sensor_br(xpt);
sensor_bz=fiesta_sensor_bz(xpt);
sensor_bz2=fiesta_sensor_bz(xpt);
% Now create sensors in strike points
sensor_in_strike=fiesta_sensor_isoflux('st_in', [x_control(3), x_control(5)]', ...
										[x_control(3), y_control(5)]');
sensor_out_strike=fiesta_sensor_isoflux('st_out', [x_control(3), 0.61, 0.7, x_control(6)]', ...
										[x_control(3), -1.424, -1.57, y_control(6)]');
sensor_fx=fiesta_sensor_isoflux('fx', [1.34,0.85]', [0.0,-1.905]');

%get the locations along the inner and outer divertor legs
psin=get(equil, 'Psi_n');
lcfs=contour(psin, [1.000:0.0001:1.0001]);
rv_leg=lcfs(1,:);
zv_leg=lcfs(2,:);
%now want lower outer leg w/modification to find the strike points
loc=(zv_leg < y_control(3) & rv_leg > x_control(3) & rv_leg < x_control(6) & zv_leg > -2);
rv_ol=rv_leg(loc);
zv_ol=zv_leg(loc);
loc2=(zv_leg < y_control(3) & rv_leg < x_control(3) & zv_leg > y_control(5));
rv_il=rv_leg(loc2);
zv_il=zv_leg(loc2);

%make the fiesta sensors for lower inner/outer legs
outer_lower_leg=fiesta_sensor_isoflux('outer_lower_leg', ...
				[rv_ol]', [zv_ol]');
inner_lower_leg=fiesta_sensor_isoflux('inner_lower_leg', ...
				[rv_il]', [zv_il]');

% Create placeholders
bulkboundaryflux=zeros(1,get(sensor_bulkboundary, 'n'));
in_flux=zeros(1,get(sensor_in_strike, 'n'));
out_flux=zeros(1,get(sensor_out_strike, 'n'));
outerlowerflux=zeros(1,get(outer_lower_leg, 'n'));
innerlowerflux=zeros(1,get(inner_lower_leg, 'n'));

outputs={sensor_bulkboundary, sensor_br, sensor_bz, sensor_br2, ...
    sensor_bz2, outer_lower_leg, inner_lower_leg};
obs={bulkboundaryflux, 0, 0, 0, 0, outerlowerflux, innerlowerflux};

weights={50, 10, 10, 10, 10, 20, 20};

free_coils={'p4','p5','px','d1','d2','d3','dp','d5','d6','d7','pc'};
icoil=get(equil, 'icoil');
circuit_labels=get(config, 'circuit_labels');
free_coils_index=zeros(1,length(free_coils));
for j=1:length(free_coils)
	free_coils_index(j)=find(strcmp(free_coils{j}, circuit_labels));
end

free_inputs={free_coils_index};

relaxation_parameter=0.2;
control_efit=fiesta_control('boundary_method', 2);
control_efit = set(control_efit,'diagnose',0);
control_efit = set(control_efit,'quiet',1);
inputs={coilset};
initial_plasma=get(config, 'initial_plasma');
efit_config=fiesta_efit_configuration(grid, inputs, outputs, ...
    free_inputs, relaxation_parameter);

equil_j2=fiesta_equilibrium(...
	'Conventional fx const.', config, irod, jprofile2, control_efit, ...
	efit_config, icoil, obs, weights);
j = get(equil, 'j');
j2 = get(equil_j2, 'j');
[r, V] = section(j);
[r, Vj2] = section(j2);

equil_j3=fiesta_equilibrium(...
	'Conventional fx const.', config, irod, jprofile3, control_efit, ...
	efit_config, icoil, obs, weights);
j3 = get(equil_j3, 'j');
[r, Vj3] = section(j3);

equil_j4=fiesta_equilibrium(...
	'Conventional fx const.', config, irod, jprofile4, control_efit, ...
	efit_config, icoil, obs, weights);
j4 = get(equil_j4, 'j');
[r, Vj4] = section(j4);

equil_j5=fiesta_equilibrium(...
	'Conventional fx const.', config, irod, jprofile5, control_efit, ...
	efit_config, icoil, obs, weights);
j5 = get(equil_j5, 'j');
[r, Vj5] = section(j5);

equil_j6=fiesta_equilibrium(...
	'Conventional fx const.', config, irod, jprofile6, control_efit, ...
	efit_config, icoil, obs, weights);
j6 = get(equil_j6, 'j');
[r, Vj6] = section(j6);

equil_j7=fiesta_equilibrium(...
	'Conventional fx const.', config, irod, jprofile7, control_efit, ...
	efit_config, icoil, obs, weights);
j7 = get(equil_j7, 'j');
[r, Vj7] = section(j7);
