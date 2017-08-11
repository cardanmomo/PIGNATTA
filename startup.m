
% modify this so that 'home' points to the root directory of the Fiesta installation


home='~gcunning/Fiesta_V8.10/';
%home='~gcunning/Fiesta_V8/development/'

% all the code lives in the following 2 directories
addpath([home 'Source'], '-end');
addpath([home 'Source/Pde'], '-end');
addpath([home 'Source/Gui'], '-end');

% these contain MAST and CTF specific functions, eg newcoils_mast.  For other machines they will be replaced by equivalents
addpath([home 'Source/Mast'], '-end');
addpath([home 'Source/CTF'], '-end');
addpath([home 'Source/DIIID'], '-end');
addpath([home 'Source/TCV'], '-end');
addpath([home 'Data/mast'], '-end');
addpath([home 'Data/mast/vessel'], '-end');
addpath([home 'Data/mastu'], '-end');
addpath([home 'Data/mastu/vessel'], '-end');
addpath([home 'Data/ctf'], '-end');
addpath([home 'Data/diiid'], '-end');
addpath([home 'Data/tcv'], '-end');
addpath('~gcunning/matlab/utility', '-end'); %add to make newvessel_mastu_16 work with dev. V8.

addpath('/home/gcunning/Fiesta_V8/development/Source/Tokamak/', '-end');

% this contains Gui functions but they are still under development so not normally needed
% addpath([home 'Source/Gui'], '-end');
% This contains functions for reading/writing data to pass to other codes, not needed otherwise
addpath([home 'Source/Readwrite'], '-end');
addpath('~jrh/FIESTA/regu','-end');
addpath('~jrh/FIESTA/model3d','-end');
% addpath('~jrh/FIESTA/Optometrika', '-end'); %permission denied on this

addpath('/home/athorn/FIESTA', '-end');

%add LP routines for S matrix
addpath('/home/lpang/work/zameDEV', '-end');
addpath('/home/cmoreno/work/2016/', '-end');  % Equilibria folder
addpath('/home/cmoreno/work/smatrices/', '-end');  % Sensitivity matrices location 
set(0, 'DefaultFigureWindowStyle', 'docked')
beep on

