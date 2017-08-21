% Plotter to work with sensitivity explorer
path = '/home/cmoreno/work/smats_SD_400kA/';
%vfile0 = [path, 'dummy0.txt'];
vfile1 = [path, 'dummy1.txt'];
vfile5 = [path, 'dummy5.txt'];
vfile10 = [path, 'dummy10.txt'];
vfile15 = [path, 'dummy15.txt'];
vfile20 = [path, 'dummy20.txt'];
vfile25 = [path, 'dummy25.txt'];
vfile30 = [path, 'dummy30.txt'];
vfile35 = [path, 'dummy35.txt'];
vfile40 = [path, 'dummy40.txt'];
vfile45 = [path, 'dummy45.txt'];
vfile50 = [path, 'dummy50.txt'];
vfile55 = [path, 'dummy55.txt'];
vfile60 = [path, 'dummy60.txt'];
vfile65 = [path, 'dummy65.txt'];
vfile70 = [path, 'dummy70.txt'];
vfile75 = [path, 'dummy75.txt'];
vfile80 = [path, 'dummy80.txt'];

%vdata0 = importdata(vfile0, ' ', 0);
vdata1 = importdata(vfile1, ' ', 0);
vdata5 = importdata(vfile5, ' ', 0);
vdata10 = importdata(vfile10, ' ', 0);
vdata15 = importdata(vfile15, ' ', 0);
vdata20 = importdata(vfile20, ' ', 0);
vdata25 = importdata(vfile25, ' ', 0);
vdata30 = importdata(vfile30, ' ', 0);
vdata35 = importdata(vfile35, ' ', 0);
vdata40 = importdata(vfile40, ' ', 0);
vdata45 = importdata(vfile45, ' ', 0);
vdata50 = importdata(vfile50, ' ', 0);
vdata55 = importdata(vfile55, ' ', 0);
vdata60 = importdata(vfile60, ' ', 0);
vdata65 = importdata(vfile65, ' ', 0);
vdata70 = importdata(vfile70, ' ', 0);
vdata75 = importdata(vfile75, ' ', 0);
vdata80 = importdata(vfile80, ' ', 0);

delta = vdata1(:, 1);

%conn_len0 = vdata0(:, 2);
%fx0 = vdata0(:, 3);
%dosp0 = vdata0(:, 9);

conn_len1 = vdata1(:, 2);
fx1 = vdata1(:, 3);
dosp1 = vdata1(:, 9);

conn_len5 = vdata5(:, 2);
fx5 = vdata5(:, 3);
dosp5 = vdata5(:, 9);

conn_len10 = vdata10(:, 2);
fx10 = vdata10(:, 3);
dosp10 = vdata10(:, 9);

conn_len15 = vdata15(:, 2);
fx15 = vdata15(:, 3);
dosp15 = vdata15(:, 9);

conn_len20 = vdata20(:, 2);
fx20 = vdata20(:, 3);
dosp20 = vdata20(:, 9);

conn_len25 = vdata25(:, 2);
fx25 = vdata25(:, 3);
dosp25 = vdata25(:, 9);

conn_len30 = vdata30(:, 2);
fx30 = vdata30(:, 3);
dosp30 = vdata30(:, 9);

conn_len35 = vdata35(:, 2);
fx35 = vdata35(:, 3);
dosp35 = vdata35(:, 9);

conn_len40 = vdata40(:, 2);
fx40 = vdata40(:, 3);
dosp40 = vdata40(:, 9);

conn_len45 = vdata45(:, 2);
fx45 = vdata45(:, 3);
dosp45 = vdata45(:, 9);

conn_len50 = vdata50(:, 2);
fx50 = vdata50(:, 3);
dosp50 = vdata50(:, 9);

conn_len55 = vdata55(:, 2);
fx55 = vdata55(:, 3);
dosp55 = vdata55(:, 9);

conn_len60 = vdata60(:, 2);
fx60 = vdata60(:, 3);
dosp60 = vdata60(:, 9);

conn_len65 = vdata75(:, 2);
fx65 = vdata65(:, 3);
dosp65 = vdata65(:, 9);

conn_len70 = vdata70(:, 2);
fx70 = vdata70(:, 3);
dosp70 = vdata70(:, 9);

conn_len75 = vdata75(:, 2);
fx75 = vdata75(:, 3);
dosp75 = vdata75(:, 9);

conn_len80 = vdata80(:, 2);
fx80 = vdata80(:, 3);
dosp80 = vdata80(:, 9);

%delta2 = [delta', linspace(-36, -55, 20)]';
figure('Units','normalized','PaperPositionMode','auto')
plot(-[dosp1, dosp5, dosp10, dosp15, dosp20, dosp25, dosp30, ...
    dosp35, dosp40, dosp45, dosp50, dosp55, dosp60, dosp65, ...
    dosp70, dosp75, dosp80]*100, [conn_len1, conn_len5, ...
    conn_len10, conn_len15, conn_len20, conn_len25, conn_len30, ...
    conn_len35, conn_len40, conn_len45, conn_len50, conn_len55, ...
    conn_len60, conn_len65, conn_len70, conn_len75, conn_len80])

hold on
plot(-dosp1*100, conn_len1, 'b.')
%plot(-dosp0*100, conn_len0, 'LineWidth', 2, 'color', 'r')
ylabel('Connection length(m)')
title('Connection length variation SD to SXD')
xlabel('Real Displacement (cm)')
legend('1 cm', '5 cm', '10 cm', '15 cm', '20cm', '25cm', '30cm', ...
    '35cm', '40cm', '45cm', '50cm', '55cm', '60cm', '65cm', '70cm', ...
    '75cm', '80cm', 'location', 'nw')


figure('Units','normalized','PaperPositionMode','auto')
plot(-[dosp1, dosp5, dosp10, dosp15, dosp20, dosp25, dosp30, dosp35, ...
    dosp40, dosp45, dosp50, dosp55, dosp60, dosp65, dosp70, dosp75, ...
    dosp80]*100, [fx1, fx5, fx10, fx15, fx20, fx25, fx30, fx35, fx40, ...
    fx45, fx50, fx55, fx60, fx65, fx70, fx75, fx80])

hold on
%plot(-delta2, fx0, 'LineWidth', 2, 'color', 'r')
ylabel('Flux expansion (a.u.)')
xlabel('Real Displacement (cm)')
title('Flux expansion SD to SXD')
legend('1 cm', '5 cm', '10 cm', '15 cm', '20cm', '25cm', '30cm', ...
    '35cm', '40cm', '45cm', '50cm', '55cm', '60cm', '65cm', '70cm', ...
    '75cm', '80cm', 'location', 'nw')

figure('Units','normalized','PaperPositionMode','auto')
plot(delta, -[dosp1, dosp5, dosp10, dosp15, dosp20, dosp25, dosp30, ...
    dosp35, dosp40, dosp45, dosp50, dosp55, dosp60, dosp65, dosp70, ...
    dosp75, dosp80]*100)
hold on
%plot(delta2(1:23), -dosp0(1:23)*100, 'LineWidth', 2, 'color', 'r')
ylabel('Obtained displacement (cm)')
title('Obtained displacement vs. applied displacement SD to SXD')
xlabel('Displacement (cm)')
grid on
x=[1, linspace(5, 80, 16)];
%x=[-1, linspace(-5, -15, 3), -17, -22, linspace(-25, -50, 6)];
plot(x, x, '. b')
%legend('1 cm', '5 cm', '10 cm', '15 cm', '20cm', '25cm', '30cm', ...
%    '35cm', '40cm', '45cm', '50cm', '55cm', 'location', 'se')
legend('1 cm', '5 cm', '10 cm', '15 cm', '20cm', '25cm', '30cm', ...
    '35cm', '40cm', '45cm', '50cm', '55cm', '60cm', '65cm', '70cm', ...
    '75cm', '80cm', 'location', 'se')