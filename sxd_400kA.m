%% Routine to make a 400 kA SXD configuration from the 1MA one
%close all
clear all

%load the original sxd 1MA
load('/projects/physics/MAST-U/Matfiles/2016/Super_X_2014_P4_CATIA.mat')

%extract the grid, coilset, jprofile and Irod
irod=2.4e6
grid=get(config, 'grid')
jprofile=get(equil, 'jprofile')
coilset=get(config, 'coilset')

%get the boundary
bnd=get(equil, 'boundary');
r_bnd=get(bnd, 'r');
z_bnd=get(bnd, 'z');
[rc,nc]=sort(r_bnd);
zc=z_bnd(nc);
sensor_bulkboundary=fiesta_sensor_isoflux('shape', [rc]', [zc]');

%set xpoints - read location off equil plot
r_xpt=0.5;
z_xpt=-1.3135;

xpt=fiesta_point('Xpt2', r_xpt, (-1.0)*(z_xpt));
xpt2=fiesta_point('Xpt', r_xpt, z_xpt);

%get the locations along the inner and outer divertor legs
psin=get(equil, 'Psi_n');
lcfs=contour(psin, [1.000:0.0001:1.0001]);
rv_leg=lcfs(1,:);
zv_leg=lcfs(2,:);
%now want lower outer leg
loc=(zv_leg < z_xpt & rv_leg > r_xpt & zv_leg > -2);
rv_ol=rv_leg(loc);
zv_ol=zv_leg(loc);
loc2=(zv_leg < z_xpt & rv_leg < r_xpt & zv_leg > -2);
rv_il=rv_leg(loc2);
zv_il=zv_leg(loc2);

%make the fiesta sensors for these
outer_lower_leg=fiesta_sensor_isoflux('outer_lower_leg', ...
				[rv_ol]', [zv_ol]')
inner_lower_leg=fiesta_sensor_isoflux('inner_lower_leg', ...
				[rv_il]', [zv_il]')

bulkboundaryflux=zeros(1,get(sensor_bulkboundary, 'n'));
outerlowerflux=zeros(1,get(outer_lower_leg, 'n'));
innerlowerflux=zeros(1,get(inner_lower_leg, 'n'));

outputs={sensor_bulkboundary, outer_lower_leg, inner_lower_leg};
obs={bulkboundaryflux, outerlowerflux, innerlowerflux};
weights={10,10,10};

free_coils={'p4','p5','px','d1','d2','d3','dp','d5','d6','d7','pc'};
icoil=get(equil, 'icoil');
circuit_labels=get(config, 'circuit_labels');
free_coils_index=zeros(1,length(free_coils));
for j=1:length(free_coils)
	free_coils_index(j)=find(strcmp(free_coils{j}, circuit_labels));
end

free_inputs={free_coils_index};

relaxation_parameter=0.1;
control_efit=fiesta_control('boundary_method', 2);
control_efit = set(control_efit,'diagnose',0);
control_efit = set(control_efit,'quiet',1);
inputs={coilset};
efit_config=fiesta_efit_configuration(grid, inputs, outputs, ...
			free_inputs, relaxation_parameter);

equil_1ma=fiesta_equilibrium(...
	'SXD 1MA check', config, irod, jprofile, control_efit, ...
	efit_config, icoil, obs, weights);

%plot that we have back what went in
figure(config)
plot(get(equil, 'Psi_n'), [1.000:0.0001:1.0001], 'b')
plot(get(equil_1ma, 'Psi_n'), [1.000:0.0001:1.0001], 'xr')

%now remake the current profile with the current reduced to 400kA
%then repeat with the same set of contraints on the boundary

%copy and paste these params from the existing j profile
pp=[2073268.84788,-18104482.9291, 51863189.2098, -47897676.2426];
ffp=[-1.39852, 20.0825, -65.737, 77.5454];
flat_edge=[1,1];
jprofile_400=fiesta_jprofile_lao('400', pp, ffp, flat_edge, 400e3);

%recalculate with 400kA plasma current
equil_400=fiesta_equilibrium(...
	'SXD 400 kA', config, irod, jprofile_400, control_efit, ...
	efit_config, icoil, obs, weights);

figure(config)
plot(get(equil, 'Psi_n'), [1.000:0.0001:1.0001], 'b')
plot(get(equil_400, 'Psi_n'), [1.000:0.0001:1.0001], 'xr')
legend('1 MA','400 kA')

%now need to rename the equil and save the output
equil_1000=equil;
equil=equil_400;

%if exist('/projects/physics/MAST-U/Matfiles/2016/Super_X_2014_P4_CATIA_400kA.mat') == 0
%	'Writing save file'
%	save('/projects/physics/MAST-U/Matfiles/2016/Super_X_2014_P4_CATIA_400kA.mat', 'equil', 'config');
%end

