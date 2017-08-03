%this is from GF and was called divertor_geometry_2015_11_18_for_HMplots

%function result=divertor_geometry_2015_11_18_for_HMplots
function result=plotmastuoutline_2016;
% result=divertor_geometry

data=[         ...
1440.00,810;
1420.00,810;
1420.00,820;
1291.37,820;
1190.43,1007;
892.96,1303.96;
869.38,1331.21;
839.81,1382.58;
822.29,1445.1;
819.74,1481.24;
819.74,1493.6;
827.34,1531.85;
854.8,1569.64;
890.17,1589.13;
919.74,1593.6;
940.66,1593.58;
1721.01,1559.43;
1897.34,1682.89;
1915.44,1682.89;
1915.44,1795.2;
1970,1795.2;
1970,2035;
2000,2035;
2000,    2169; ...
1318.8,  2169; ...
1768.9,  1718.9; ...
1730.071,1680; ...
1350,    2060; ...
1090,    2060; ...
905.756, 1878.584;...
878.886, 1905.454;...
878.886, 1905.454;...
907.17,  1877.17;...
539.48,  1509.48;...
511.196, 1537.764;...
509.0,   1535.6;...
539.512, 1505.20; ...
507.4,   1473.756; ...
478.8,   1445.754; ...
333,     1303; ...
333,	 1100; ...
275,	 1100; ...
335,	 1100; ...
303.57,   854.83; ...
305.32,   853.41; ...
269.43,   572; ...
271.31,   571; ...
261,	  502; ...
261,	  348; ...
241,	  348; ...
261,	  348; ...
261,	  146; ...
241,	  146; ...
261,	  146; ...
261,	    0];

r1=data(:, 1)'/1e3;
z1=data(:, 2)'/1e3;


if nargout == 0
	line(r1, z1,0*z1,'Color','k', 'Linewidth', 2);
	line(r1, -z1,0*z1,'Color','k', 'Linewidth', 2);
end

target=struct('r', r1, 'z', z1);

result=target;
