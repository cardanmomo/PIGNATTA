vfile = 'dummy.txt';
figure();
vdata = importdata(vfile, ' ', 0);
delta = vdata(:, 1);
mid_in = vdata(:, 2);
mid_out = vdata(:, 3);
xp_low = vdata(:, 4);
xp_up = vdata(:, 5);
sp_in_low = vdata(:, 6);
sp_out_low = vdata(:, 7);
sp_in_up = vdata(:, 8);
sp_out_up = vdata(:, 9);
semilogy(delta, [mid_in, mid_out, xp_low, sp_in_low, sp_out_low]*100)
ylabel('$\Delta$ (cm)', 'interpreter', 'latex')
legend('midplane in', 'midplane out', 'x points', 'inner strike points', ...
    'outer strike points', 'Location', 'southeast')
xlabel('dI (cm)')
