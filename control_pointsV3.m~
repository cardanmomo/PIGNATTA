function [x_control, y_control, conn_len]=control_pointsV3(equil);
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
%boundary=get(equil, 'boundary');
psin=get(equil, 'Psi_n');
psi_equil=get(equil, 'Psi');
r_xpt=get(xpt, 'r');
z_xpt=get(xpt, 'z');

% Get midplane points

psib=get(equil, 'psi_boundary');
midplane=fiesta_line('midplane', [0.261, 1.88], [0.0, 0.0]);
[x_mid, y_mid]=intersect(psi_equil, psib, midplane);

% Generate a linear space from the midplane points to calculate the
% connection length and can be modified to start farther
%[psi_points]=interp2(psi_equil, x_mid+0.01, y_mid);
%psi_points_in=interp2(psi_equil, mid_in_r, mid_in_z);
mid_i=fiesta_point('in_midplane', x_mid(1)-0.000079, 0);
mid_o=fiesta_point('out_midplane', x_mid(2)+0.000082, 0);
mid_ox=fiesta_point('out_midplane_x', x_mid(2)+0.01, 0);

% Modification June 22 (better intersection with the plate via connection length calculations)
%[len_3d_ol_psi, length_2d, conn_o_l, phi, path_3d, path_2d, seg1, seg2]=connection_length3(equil, psib, plate);
%[len_3d_ou, length_2d, conn_o_u, phi, path_3d, path_2d, seg1, seg2]=connection_length3(equil, psi_points_out(), plate_up);
%[len_3d_iu, length_2d, conn_o_l, phi, path_3d, path_2d, seg1, seg2]=connection_length3(equil, psi_points(1), plate);
%[len_3d_il, length_2d, conn_o_u, phi, path_3d, path_2d, seg1, seg2]=connection_length3(equil, psi_points_out(5), plate_up);
[len_3d_ou, length_2d, conn_o_u, phi, path_3d, path_2d]=connection_length2(equil, mid_o, plate_up);
%[len_3d_iu, length_2d, conn_i_u, phi, path_3d, path_2d]=connection_length2(equil, mid_i, plate_up);
%[len_3d_il, length_2d, conn_i_l, phi, path_3d, path_2d]=connection_length2(equil, mid_i, plate);  % These to be commented ^ when using other method
[len_3d_ol, length_2d, conn_o_l, phi, path_3d, path_2d]=connection_length2(equil, mid_o, plate);
[len_3d_olx, length_2d, conn_o_lx, phi, path_3d, path_2d]=connection_length2(equil, mid_ox, plate);

%r_il=get(conn_i_l, 'r');
%z_il=get(conn_i_l, 'z');
r_ol=get(conn_o_l, 'r');
z_ol=get(conn_o_l, 'z');
r_olx=get(conn_o_lx, 'r');
z_olx=get(conn_o_lx, 'z');
% Get strike points via connection length
%r_iu=get(conn_i_u, 'r');
%z_iu=get(conn_i_u, 'z');
r_ou=get(conn_o_u, 'r');
z_ou=get(conn_o_u, 'z');
%x_btm=[r_il(numel(r_il)), r_ol(numel(r_ol))]';
%y_btm=[z_il(numel(z_il)), z_ol(numel(z_ol))]';
%x_top=[r_iu(1), r_ou(1)]';
%y_top=[z_iu(1), z_ou(1)]';
x_exp=(r_olx(numel(r_olx))-r_ol(numel(r_ol)));
y_exp=(z_olx(numel(z_olx))-z_ol(numel(z_ol)));
d=(x_exp^2 + y_exp^2)^0.5;
fx=d/0.01;

conn_len=[len_3d_ol, len_3d_olx, fx];

% Get the strike points via intersections
[x_btm, y_btm]=intersect(psi_equil, psib, plate);
[x_top, y_top]=intersect(psi_equil, psib, plate_up);
limit=0.0005;
low_div_psi=interp2(psin, x_btm, y_btm);
upp_div_psi=interp2(psin, x_top, y_top);
x_btm=x_btm(abs(low_div_psi-0.9999) < limit);
y_btm=y_btm(abs(low_div_psi-0.9999) < limit);
x_top=x_top(abs(upp_div_psi-0.9999) < limit);
y_top=y_top(abs(upp_div_psi-0.9999) < limit);

%decimate the boundary to give some other control points
%select=linspace(1, numel(r_lcfs), 10);
%select=cast(select,'uint8');
%r_vals=r_lcfs(select);
%z_vals=z_lcfs(select);

% Make an array of the control points with 
if numel(r_xpt)==1
x_control=[x_mid', r_xpt, r_xpt, x_btm', x_top'];
y_control=[y_mid', z_xpt, (-1.0)*z_xpt, y_btm', y_top'];
end
if numel(r_xpt)==2
x_control=[x_mid', r_xpt, x_btm', x_top'];  % Assume both have same R...
y_control=[y_mid', (-1.0)*z_xpt, y_btm', y_top'];  % -1 as z pt in numeric order
end

%plot the results of the control points
%plot(config);
%plot(plate);
%plot(plate_up);
%plot(boundary, 'r');
%plot(equil);
%plotmastuoutline;
%plot(x_control, y_control, 'ro');
%plot(r_vals, z_vals, 'ro')