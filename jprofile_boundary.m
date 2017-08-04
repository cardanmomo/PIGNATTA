%Program to adjust current profile with a constrain in the boundary

%close all
%clear all

%load Conventional_2014_P4_CATIA;       % 1MA, Li: 0.69
%uno_a = [2079756.1196, -18161131.974, 52025469.4664, -48047548.3834];
%uno_b = [-1.4029, 20.1454, -65.9427, 77.788];

%load conventional_400kA                % 400kA, Li: 0.7
%uno_a = [812001.214947, -7090668.51095, 20312354.9039, -18759251.2866];
%uno_b = [-0.547736, 7.86537, -25.7461,30.3709];

%load conventional_400kA_high_li.mat     % 400kA, Li: 1.08
%uno_a = [363864.2337, 0];
%uno_b = [0.18193, 0];

%load Super_X_2014_P4_CATIA_400kA;      % 400kA, Li:0.68
%uno_a = [829256.113274, -7241344.10353, 20743989.2564, -19157882.4311];
%uno_b = [-0.559373, 8.0325, -26.2932, 31.0162];

load Super_X_2014_P4_CATIA.mat         % 1MA, Li: 0.68
uno_a = [2073268.84788, -18104482.9291, 51863189.2098, -47897676.2426];
uno_b = [-1.39852, 20.0825, -65.737, 77.5454];

%load high_li_sxd_2014coils              % 1MA, Li: 1.08
%uno_a = [892469.9684, 0];
%uno_b = [0.44623, 0];

irod=2.4e6;
%irod=get(equil, 'irod');

grid=get(equil, 'grid');
feedback=get(equil, 'feedback');
%icoil=get(equil, 'icoil');
jprofile=get(equil, 'jprofile'); 
coilset=get(config, 'coilset');
Ip = 1e6;

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
sensor_br2=fiesta_sensor_br(xpt2);
sensor_bz=fiesta_sensor_bz(xpt);
sensor_bz2=fiesta_sensor_bz(xpt2);
% Now create sensors in strike points
sensor_in_strike=fiesta_sensor_isoflux('st_in', [x_control(3), x_control(5)]', ...
										[y_control(3), y_control(5)]');
sensor_out_strike=fiesta_sensor_isoflux('st_out', [x_control(3), x_control(6)]', ...
										[y_control(3), y_control(6)]');
sensor_fx=fiesta_sensor_isoflux('fx', [x_control(2),0.85]', [y_control(2),-1.905]');

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
outer_lower_leg=fiesta_sensor_isoflux('outer_lower_leg', [rv_ol]', [zv_ol]');
inner_lower_leg=fiesta_sensor_isoflux('inner_lower_leg', [rv_il]', [zv_il]');

% Create placeholders
br1 = zeros(1, get(sensor_br, 'n'));
bz1 = zeros(1, get(sensor_bz, 'n'));

boundary_flux = zeros(1,get(sensor_bulkboundary, 'n'));
out_leg_flux = zeros(1,get(outer_lower_leg, 'n'));
out_strike_flux = zeros(1,get(sensor_out_strike, 'n'));
in_leg_flux = zeros(1,get(inner_lower_leg, 'n'));
in_strike_flux = zeros(1,get(sensor_in_strike, 'n'));


% Arrange outputs and weights
outputs={sensor_bulkboundary, outer_lower_leg, sensor_out_strike, ...
    inner_lower_leg, sensor_in_strike, sensor_br, sensor_bz};
obs={boundary_flux, out_leg_flux, out_strike_flux, in_leg_flux, in_strike_flux, 0, 0};
weights={100, 100, 50, 50, 40, 10, 10};

% Get free coils
free_coils={,'p4','p5','px','d1','d2','d3','d5','dp','d6','d7','pc'};
icoil=get(equil, 'icoil');
%icoil.p1 = -20e3;

circuit_labels=get(config, 'circuit_labels');
free_coils_index=zeros(1,length(free_coils));
for j=1:length(free_coils)
	free_coils_index(j)=find(strcmp(free_coils{j}, circuit_labels));
end
free_inputs={free_coils_index};

relaxation_parameter=0.2;
control_efit = fiesta_control('boundary_method', 2);
control_efit = set(control_efit,'diagnose',0);
control_efit = set(control_efit,'quiet',1);
inputs={coilset};
initial_plasma=get(config, 'initial_plasma');
efit_config=fiesta_efit_configuration(grid, inputs, outputs, ...
    free_inputs, relaxation_parameter);
equil_new=fiesta_equilibrium('test', config, irod, jprofile, control_efit, ...
    efit_config, icoil, obs, weights);


dos_a =     [0.5,   1,      2]  *0.4e6;
tres_a =    [0.25,  1.5,    3]  *0.33e6;
cuatro_a =  [1,     1,      1]  *0.65e6;
cinco_a =   [4,     2,      1]  *0.75e6;
seis_a =    [4,     2,      3]   *1.0e6;
siete_a =   [0.1,   0.1,    0.2]   *1.75e6;

dos_b =     [0.25,  0.5,    1];
tres_b =    [0.25,  0.5,    1.];
cuatro_b=   [0.5,   0.5,    0.5];
cinco_b =   [2,     1,      0.5];
seis_b =    [2,     1,      1];
siete_b =   [0.1,   0.1,    0.1];

jprofile2=fiesta_jprofile_lao('testj2', dos_a, dos_b, 1, Ip);  % Create the profile according to coefficients
equil_j2=fiesta_equilibrium(...
	'Conventional fx const.', config, irod, jprofile2, control_efit, ...
	efit_config, icoil, obs, weights);  % Calculate equil
j = get(equil, 'j');  % Original jprofile at the midplane
j2 = get(equil_j2, 'j');
[r, V] = section(j);  % Get J profile at the midplane
[r, Vj2] = section(j2);

jprofile3=fiesta_jprofile_lao('testj3', tres_a, tres_b, 1, Ip);
equil_j3=fiesta_equilibrium(...
	'Conventional fx const.', config, irod, jprofile3, control_efit, ...
	efit_config, icoil, obs, weights);
j3 = get(equil_j3, 'j');
[r, Vj3] = section(j3);

jprofile4=fiesta_jprofile_lao('testj4', cuatro_a, cuatro_b, 1, Ip);
equil_j4=fiesta_equilibrium(...
	'Conventional fx const.', config, irod, jprofile4, control_efit, ...
	efit_config, icoil, obs, weights);
j4 = get(equil_j4, 'j');
[r, Vj4] = section(j4);

jprofile5=fiesta_jprofile_lao('testj5', cinco_a, cinco_b, 1, Ip);
equil_j5=fiesta_equilibrium(...
	'Conventional fx const.', config, irod, jprofile5, control_efit, ...
	efit_config, icoil, obs, weights);
j5 = get(equil_j5, 'j');
[r, Vj5] = section(j5);

jprofile6=fiesta_jprofile_lao('testj6', seis_a, seis_b, 1, Ip);
equil_j6=fiesta_equilibrium(...
	'Conventional fx const.', config, irod, jprofile6, control_efit, ...
	efit_config, icoil, obs, weights);
j6 = get(equil_j6, 'j');
[r, Vj6] = section(j6);

jprofile7=fiesta_jprofile_lao('testj7', siete_a, siete_b, 1, Ip);
equil_j7=fiesta_equilibrium(...
	'Conventional fx const.', config, irod, jprofile7, control_efit, ...
	efit_config, icoil, obs, weights);
j7 = get(equil_j7, 'j');
[r, Vj7] = section(j7);

% For the jprofile vs psi_n plots
psi_j=linspace(0, 1,100);
sens_j=fiesta_sensor_j('jsensor', 'psi_n', psi_j);
j_prof=interp2(equil, sens_j);
j_prof2=interp2(equil_j2, sens_j);
j_prof3=interp2(equil_j3, sens_j);
j_prof4=interp2(equil_j4, sens_j);
j_prof5=interp2(equil_j5, sens_j);
j_prof6=interp2(equil_j6, sens_j);
j_prof7=interp2(equil_j7, sens_j);
