%Program to allow adjustment of equilblira for making plasmas in topic 25
%start using GF's scaling to null the solenoid field and change the flux
%through the nose

%converting the exiting from the old coilset to the new coilset works
%now change the plasma current, and irod to match what is expected in first
%plasma

%get the conventional equilibrium
equilibria='/projects/physics/MAST-U/Matfiles/2010/SXD/conventional.mat'
load(equilibria)

%reload the coilset to update to the new version
[coilset_14, vessel_14]=newvessel_mastu_11('mar2014');

icoil_14=fiesta_icoil(coilset_14);
icoil=get(equil, 'icoil');

scale=0.4;

icoil_14.p1=icoil.p1;
icoil_14.p4=icoil.p4;
icoil_14.p5=icoil.p5;
icoil_14.px=icoil.px*0.6 %*scale;
icoil_14.d1=icoil.d1*0.5 %*scale;
icoil_14.d2=icoil.d2*scale;
icoil_14.d3=icoil.d3*scale;
icoil_14.d5=icoil.d5;
icoil_14.d6=icoil.d6;
icoil_14.d7=icoil.d7;
icoil_14.dp=icoil.dp*0.3%scale;
icoil_14.pc=0.;
icoil_14.p6=icoil.p6;

%coilset=get(config, 'coilset');
circuit_labels=get(config, 'circuit_labels');
grid=get(equil, 'grid');
%irod=get(equil, 'irod');
irod=2.4e6 %100kA TF current
%set the plasma current
jprofile=get(equil, 'jprofile');
jprofile=set(jprofile, 'current', 400e3);
%jprofile=fiesta_jprofile_lao('jprof', 1000e3);

feedback=fiesta_feedback1(coilset_14, {'p4', 'p5'}, 1.43, {'p6'}, 0.0)
control=get(equil, 'control');

%remake the configuration with the new coils
%p=get(config, 'p');
%label=get(config, 'label');
%ident=get(config, 'ident');
%flux=get(config, 'flux');
grid=get(config, 'grid');
%limiter=get(config, 'limiter');
%coilcurrentarray=get(config, 'coilcurrentarray')
%gridcoil=get(config, 'gridcoil')
%gridplasma=get(config, 'gridplasma')
%coilset_label=get(config, 'coilset_label')
%coilset_labels=get(config, 'coilset_labels')
initial_plasma=get(config, 'initial_plasma')
config_14=fiesta_configuration('2014 coils', grid, coilset_14, initial_plasma);

%now recalculate the equilibrium with the new coil set
equil_14=fiesta_equilibrium('Conventional (2014 coils)', ...
						config_14, irod, jprofile, control, feedback, icoil_14);

close all
plot(equil_14)
plot(config_14)
plotmastuoutline;
parametersshow(equil_14)

%get the boundary
bnd=get(equil_14, 'boundary');
r_bnd=get(bnd, 'r');
z_bnd=get(bnd, 'z');
[rc,nc]=sort(r_bnd);
zc=z_bnd(nc);

% now what to change the jprofile, and remake the equilbrium using the 
%original boundary

jprofile_2=fiesta_jprofile_lao('jprof', 400e3);
sensor_bulkboundary=fiesta_sensor_isoflux('shape', ...
		[rc,0.333, 0.785]', [zc,-1.303, -1.755]');
r_xpt=0.466;
z_xpt=1.20;

r_in=0.333;
z_in=-1.303;
r_out=0.785;
z_out=-1.755;
xpt=fiesta_point('Xpt', r_xpt, (-1.0)*(z_xpt));
xpt2=fiesta_point('Xpt', r_xpt, z_xpt);
sensor_br=fiesta_sensor_br(xpt);
sensor_br2=fiesta_sensor_br(xpt);
sensor_bz=fiesta_sensor_bz(xpt);
sensor_bz2=fiesta_sensor_bz(xpt);
sensor_in_strike=fiesta_sensor_isoflux('st_in', [r_xpt, r_in]', ...
										[(-1.0)*z_xpt, z_in]');
sensor_out_strike=fiesta_sensor_isoflux('st_out', [r_xpt, 0.61, 0.7, r_out]', ...
										[(-1.0)*z_xpt, -1.424, -1.57, z_out]');
sensor_fx=fiesta_sensor_isoflux('fx', [1.34,0.85]', [0.0,-1.905]');
fx_flux=zeros(1,get(sensor_fx, 'n'));
bulkboundaryflux=zeros(1, get(sensor_bulkboundary, 'n'));
in_flux=zeros(1,get(sensor_in_strike, 'n'));
out_flux=zeros(1,get(sensor_out_strike, 'n'));
outputs={sensor_bulkboundary,sensor_fx, ...
					sensor_br,sensor_bz, ...
					sensor_br2, sensor_bz2, ...
					sensor_in_strike, sensor_out_strike};
obs={bulkboundaryflux, fx_flux, 0, 0, 0, 0, in_flux, out_flux};
weights={50, 100, 10, 10, 10, 10, 200, 200};

%free_coils={'d1','d2','d3','dp','d5','px','p4','p5'};
%free_coils={'p4','p5','p6','px','dp','d1','d2','d3'};
free_coils={'p4','p5','d2','px','dp'};
icoil_14.dp=300;
icoil_14.d3=950;
circuit_labels=get(config_14, 'circuit_labels');
free_coils_index=zeros(1,length(free_coils));
for j=1:length(free_coils)
	free_coils_index(j)=find(strcmp(free_coils{j}, circuit_labels));
end

free_inputs={free_coils_index};

relaxation_parameter=0.5;
control_efit=fiesta_control('boundary_method', 2);
inputs={coilset_14};
efit_config=fiesta_efit_configuration(grid, inputs, outputs, ...
			free_inputs, relaxation_parameter);
equil_new=fiesta_equilibrium(...
	'Conventional fx const.', config_14, irod, jprofile, control_efit, ...
	efit_config, icoil_14, obs, weights);

figure(config)
plot(equil_new)
plot(config_14)
plotmastuoutline
parametersshow(equil_new)

sensor_fx_wide=fiesta_sensor_isoflux('fx', [1.34,1.15]', [0.0,-1.905]');
outputs={sensor_bulkboundary,sensor_fx_wide, ...
					sensor_br,sensor_bz, ...
					sensor_br2, sensor_bz2, ...
					sensor_in_strike, sensor_out_strike};

free_coils={'p4','p5','d2','px','dp'};
icoil_14.dp=300;
%icoil_14.d3=950;
circuit_labels=get(config_14, 'circuit_labels');
free_coils_index=zeros(1,length(free_coils));
for j=1:length(free_coils)
	free_coils_index(j)=find(strcmp(free_coils{j}, circuit_labels));
end

free_inputs={free_coils_index};

relaxation_parameter=0.5;
control_efit=fiesta_control('boundary_method', 2);
inputs={coilset_14};
efit_config=fiesta_efit_configuration(grid, inputs, outputs, ...
			free_inputs, relaxation_parameter);
equil_wide=fiesta_equilibrium(...
	'Conventional fx const.', config_14, irod, jprofile, control_efit, ...
	efit_config, icoil_14, obs, weights);

figure(config)
plot(equil_wide)
plot(config_14)
plotmastuoutline
parametersshow(equil_wide)

figure()
plot(equil_14, 'Psi_n', [1.0:0.05:1.2], 'b', 'Linewidth', 2)
hold on
plot(equil_new, 'Psi_n', [1.0:0.05:1.2], 'r', 'Linewidth', 2)
plot(equil_wide, 'Psi_n', [1.0:0.05:1.2], 'g', 'Linewidth', 2)

xlim([0.15,2.0]);
ylim([-2.2,-0.5]);
plot(config)
plotmastuoutline
