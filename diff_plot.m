% Plotter to work with the files produced by variations_explorer
path='Var_data_single_coil/SXD_high_li/';
path2='Var_data_single_coil/SXD_low_li/';
vfile1 = [path, '6sxd_hli.txt'];
vfile2 = [path2, '6sxd.txt'];
figure();
vdata = importdata(vfile1, ' ', 0);
delta = vdata(:, 1);
mid_in = vdata(:, 2);
mid_out = vdata(:, 3);
xp_low = vdata(:, 4);
xp_up = vdata(:, 5);
sp_in_low = vdata(:, 6);
sp_out_low = vdata(:, 7);
sp_in_up = vdata(:, 8);
sp_out_up = vdata(:, 9);

vdata2 = importdata(vfile2, ' ', 0);
delta2 = vdata2(:, 1);
mid_in2 = vdata2(:, 2);
mid_out2 = vdata2(:, 3);
xp_low2 = vdata2(:, 4);
xp_up2 = vdata2(:, 5);
sp_in_low2 = vdata2(:, 6);
sp_out_low2 = vdata2(:, 7);
sp_in_up2 = vdata2(:, 8);
sp_out_up2 = vdata2(:, 9);

plot(delta, sp_out_low*100, 'r')
hold on
plot(delta2, sp_out_low2*100, 'b')
ylabel('Displacement (cm)')
legend('low inductance', 'high inductance')
xlabel('Current in coil d5 (A)')
