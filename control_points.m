function [xpt, xpt_up, mid_o, mid_i, sp_o_l, sp_i_l, sp_o_u, sp_i_u]=control_points(equil)
% Control points calculator for MAST-U geometry

plate=fiesta_line('lower_target', ...
				[0.2611,0.333,0.333,1.09,1.35,1.73,1.555,...
				0.8902,0.8548,0.8273,0.8197,0.8223,0.8398, 0.8694, ...
				1.19], ...
				[-0.502,-1.1,-1.303,-2.06,-2.06,-1.68,...
				-1.567,-1.589,-1.57,-1.532,-1.494,-1.445,-1.383,-1.331, ...
				-1.007]);
plate_up=fiesta_line('upper_target', ...
				[0.2611,0.333,0.333,1.09,1.35,1.73,1.555,...
				0.8902,0.8548,0.8273,0.8197,0.8223,0.8398, 0.8694, ...
				1.19], ...
				[0.502,1.1,1.303,2.06,2.06,1.68,...
				1.567,1.589,1.57,1.532,1.494,1.445,1.383,1.331, ...
				1.007]);
 
%get x point and boundary, extract the LCFS
xpt=get(equil, 'xpoint');
boundary=get(equil, 'boundary');
r_lcfs=get(boundary, 'r');
z_lcfs=get(boundary, 'z');
psin=get(equil, 'Psi_n');
xpt_up=fiesta_point('xpoint_up', get(xpt, 'r'), (-1.0)*get(xpt, 'z'));

% Plot the basics
%plot(config)
%plot(plate)
%plot(plate_up)
plot(boundary, 'r')

% Get midplane points
[r_out_mid,ind]=max(r_lcfs);
z_out_mid=z_lcfs(ind);
[r_in_mid,ind]=min(r_lcfs);
z_in_mid=z_lcfs(ind);

dr=0.005; %5 mm step
drsep=linspace(0.00, dr, 100);

mid_out_r=drsep+r_out_mid;
mid_in_r=r_in_mid-drsep;

mid_out_z=mid_out_r;
mid_in_z=mid_in_r;

mid_out_z(:)=z_out_mid;
mid_in_z(:)=z_in_mid;
% Generate a linear space from the midplane points to calculate the
% connection length and can be modified to start farther
psi_points_out=interp2(psin, mid_out_r, mid_out_z);
psi_points_in=interp2(psin, mid_in_r, mid_in_z);
mid_i=fiesta_point('inner_set', mid_in_r(15), mid_in_z(15));
mid_o=fiesta_point('outer_set', mid_out_r(5), mid_out_z(5));

% Modification June 22 (better intersection with the plate via connection length calculations)
%[length_3d, length_2d, conn_o_l, phi, path_3d, path_2d, seg1, seg2]=connection_length3(equil, psi_points_out(5), plate);
%[length_3d, length_2d, conn_o_u, phi, path_3d, path_2d, seg1, seg2]=connection_length3(equil, psi_points_out(5), plate_up);
[length_3d, length_2d, conn_o_u, phi, path_3d, path_2d]=connection_length2(equil, mid_o, plate_up);
[length_3d, length_2d, conn_o_l, phi, path_3d, path_2d]=connection_length2(equil, mid_o, plate);
[length_3d, length_2d, conn_i_u, phi, path_3d, path_2d]=connection_length2(equil, mid_i, plate_up);
[length_3d, length_2d, conn_i_l, phi, path_3d, path_2d]=connection_length2(equil, mid_i, plate);

% Get the strike points
rpath_o_l=get(conn_o_l, 'r');
zpath_o_l=get(conn_o_l, 'z');
sp_o_l=fiesta_point('sp_o_l', rpath_o_l(numel(rpath_o_l)), zpath_o_l(numel(zpath_o_l)));

rpath_o_u=get(conn_o_u, 'r');
zpath_o_u=get(conn_o_u, 'z');
sp_o_u=fiesta_point('sp_o_u', rpath_o_u(1), zpath_o_u(1));

rpath_i_l=get(conn_i_l, 'r');
zpath_i_l=get(conn_i_l, 'z');
sp_i_l=fiesta_point('sp_i_l', rpath_i_l(numel(rpath_i_l)), zpath_i_l(numel(zpath_i_l)));

rpath_i_u=get(conn_i_u, 'r');
zpath_i_u=get(conn_i_u, 'z');
sp_i_u=fiesta_point('sp_i_u', rpath_i_u(1), zpath_i_u(1));

%decimate the boundary to give some other control points
%select=linspace(1, numel(r_lcfs), 10);
%select=cast(select,'uint8');
%r_vals=r_lcfs(select);
%z_vals=z_lcfs(select);

%plot the results of the control points
%plot(equil)
%plotmastuoutline
%plot(sp_o_l, 'ro') % Outer botom
%plot(sp_o_u, 'ro') % Outer top
%plot(sp_i_l, 'ro') % Inner bottom
%plot(sp_i_u, 'ro') % Inner top
%plot(xpt, 'ro') % Bottom x-point
%plot(xpt_up, 'ro') % Top x-point
%plot(mid_o, 'ro') % Outer midplane
%plot(mid_i, 'ro') % Inner midplane
%plot(r_vals, z_vals, 'ro')