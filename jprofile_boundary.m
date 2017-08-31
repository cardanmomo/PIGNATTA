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
uno_a = [0.20732688478800  -1.81044829291000   5.18631892098000  -4.78976762426000] *1e7;
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
xpt=fiesta_point('Xpt', x_control(3), y_control(3));
xpt2=fiesta_point('Xpt2', x_control(4), y_control(4));
% And create B sensors on them
sensor_br=fiesta_sensor_br(xpt);
sensor_br2=fiesta_sensor_br(xpt2);
sensor_bz=fiesta_sensor_bz(xpt);
sensor_bz2=fiesta_sensor_bz(xpt2);
% Now create sensors in strike points
sensor_in_strike=fiesta_sensor_isoflux('st_in', [x_control(3), x_control(5)]', ...  % Change to 4 for High Li
										[y_control(3), y_control(5)]');
sensor_divertor=fiesta_sensor_isoflux('divertor', [1.3172, x_control(6)]', ...  % For Super-X
										[-1.9572, y_control(6)]');
%sensor_divertor=fiesta_sensor_isoflux('divertor', [x_control(3), x_control(6)]', ...  % For Conventional
%										[y_control(3), y_control(6)]');
sensor_nose=fiesta_sensor_isoflux('nose', [x_control(3), 0.70859]', [y_control(3),-1.6078]');  % For Super-X
%sensor_nose=fiesta_sensor_isoflux('nose', [0.8867, x_control(5)]', [-1.0172, y_control(5)]');  % For Conventional
%sensor_sol = fiesta_sensor_isoflux('sol', [x_control(2)+0.03, 1.05, 0.8125]', [0, -1.6734, -1.575]');
midsol = fiesta_point('solthing', x_control(2)+0.01, 0);
midsol2 = fiesta_point('solthing', x_control(2)+0.02, 0);
midsol3 = fiesta_point('solthing', x_control(2)+0.03, 0);
[len_3d_ol, length_2d, conn, phi, path_3d, path_2d]=connection_length2(equil, midsol, plate);
[len_3d_ol, length_2d, conn2, phi, path_3d, path_2d]=connection_length2(equil, midsol2, plate);
[len_3d_ol, length_2d, conn3, phi, path_3d, path_2d]=connection_length2(equil, midsol3, plate);

mids = fiesta_point('solthing', x_control(1)-0.001, 0);
mids2 = fiesta_point('solthing', x_control(1)-0.002, 0);
mids3 = fiesta_point('solthing', x_control(1)-0.003, 0);
[len_3d_ol, length_2d, con, phi, path_3d, path_2d]=connection_length2(equil, mids, plate);
[len_3d_ol, length_2d, con2, phi, path_3d, path_2d]=connection_length2(equil, mids2, plate);
[len_3d_ol, length_2d, con3, phi, path_3d, path_2d]=connection_length2(equil, mids3, plate);


r_sil=get(con, 'r');
z_sil=get(con, 'z');
[rsil,ncil]=sort(r_sil);
zsil=z_sil(ncil);
r_sil2=get(con2, 'r');
z_sil2=get(con2, 'z');
[rsil2,ncil2]=sort(r_sil2);
zsil2=z_sil2(ncil2);
r_sil3=get(con3, 'r');
z_sil3=get(con3, 'z');
[rsil3,ncil3]=sort(r_sil3);
zsil3=z_sil3(ncil3);

r_sol=get(conn, 'r');
z_sol=get(conn, 'z');
[rs,nc]=sort(r_sol);
zs=z_sol(nc);
r_sol2=get(conn2, 'r');
z_sol2=get(conn2, 'z');
[rs2,nc2]=sort(r_sol2);
zs2=z_sol2(nc2);
r_sol3=get(conn3, 'r');
z_sol3=get(conn3, 'z');
[rs3,nc3]=sort(r_sol3);
zs3=z_sol3(nc3);

sensor_sol = fiesta_sensor_isoflux('sol', [rs]', [zs]');
sensor_sol2 = fiesta_sensor_isoflux('sol', [rs2]', [zs2]');
sensor_sol3 = fiesta_sensor_isoflux('sol', [rs3]', [zs3]');

sensor_sil = fiesta_sensor_isoflux('sol', [rsil]', [zsil]');
sensor_sil2 = fiesta_sensor_isoflux('sol', [rsil2]', [zsil2]');
sensor_sil3 = fiesta_sensor_isoflux('sol', [rsil3]', [zsil3]');

%get the locations along the inner and outer divertor legs
psin=get(equil, 'Psi_n');
lcfs=contour(psin, [1.000:0.0001:1.0001]);
rv_leg=lcfs(1,:);
zv_leg=lcfs(2,:);
%now want lower outer leg w/modification to find the strike points
loc=(zv_leg < y_control(3) & rv_leg > x_control(3) & rv_leg < x_control(6) & zv_leg > -2);
rv_ol=rv_leg(loc);
zv_ol=zv_leg(loc);
loc2=(zv_leg < y_control(3) & rv_leg < x_control(4) & zv_leg > y_control(5));
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
divertor_flux = zeros(1,get(sensor_divertor, 'n'));
in_leg_flux = zeros(1,get(inner_lower_leg, 'n'));
in_strike_flux = zeros(1,get(sensor_in_strike, 'n'));
nose_flux = zeros(1, get(sensor_nose, 'n'));
sol_flux = zeros(1, get(sensor_sol, 'n'));
sol_flux2 = zeros(1, get(sensor_sol2, 'n'));
sol_flux3 = zeros(1, get(sensor_sol3, 'n'));

sil_flux = zeros(1, get(sensor_sil, 'n'));
sil_flux2 = zeros(1, get(sensor_sil2, 'n'));
sil_flux3 = zeros(1, get(sensor_sil3, 'n'));


% Arrange outputs and weights
outputs={sensor_bulkboundary, outer_lower_leg, inner_lower_leg, sensor_divertor, sensor_nose, ...
    sensor_in_strike, sensor_br, sensor_bz, sensor_sol, sensor_sol2, sensor_sol3};%, sensor_sil, sensor_sil2, sensor_sil3};
obs={boundary_flux, out_leg_flux, in_leg_flux, divertor_flux, nose_flux, in_strike_flux, br1, bz1, sol_flux, sol_flux2, sol_flux3};%, sil_flux, sil_flux2, sil_flux3};
%weights={200, 400, 240, 180, 200, 48, 60, 10, 100};  % For Conventional
weights={700, 500, 240, 320, 20, 48, 200, 100, 220, 220, 220};
%weights={250, 200, 200, 200, 200, 250, 250, 500, 500, 500, 2500, 2500, 2500};

% Get free coils
free_coils={,'p4','p5','px','d1','d2','d3','d5','d6','dp','pc'};
icoil=get(equil, 'icoil');
icoil.p1 = 0e3;

circuit_labels=get(config, 'circuit_labels');
free_coils_index=zeros(1,length(free_coils));
for j=1:length(free_coils)
	free_coils_index(j)=find(strcmp(free_coils{j}, circuit_labels));
end
free_inputs={free_coils_index};

relaxation_parameter=0.5;
control_efit = fiesta_control('boundary_method', 2);
control_efit = set(control_efit,'diagnose',0);
control_efit = set(control_efit,'quiet',1);
inputs={coilset};
initial_plasma=get(config, 'initial_plasma');
efit_config=fiesta_efit_configuration(grid, inputs, outputs, ...
    free_inputs, relaxation_parameter);
equil_new=fiesta_equilibrium('test', config, irod, jprofile, control_efit, ...
    efit_config, icoil, obs, weights);


dos_a =     [0.4,               -3,                 10,                 -9]                 *1e7;
tres_a =    [0.5,               -2.9,               9,                  -8]                 *1e7;
cuatro_a =  [0.6,               -2.8,               8,                  -7]                 *1e7;
cinco_a =   [0.7,               -2.7,               7,                  -6]                 *1e7;
seis_a =    [0.8,               -2.6,               6,                  -5]                 *1e7;
siete_a =   [0.9,               -2.5,               5,                  -4]                 *1e7;

dos_b =     [-2.65,         40,             -131,           155];
tres_b =    [-2.4,          35,             -120,           140];
cuatro_b=   [-2.1,          30,             -110,           135];
cinco_b =   [-1.9,          25,             -100,           130];
seis_b =    [-1.8,          20,             -90,            125];
siete_b =   [-1.7,          15,             -80,            120];

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
