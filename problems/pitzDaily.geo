lc = 10;

Point(1) = {-20.6, 0, 0, lc};
Point(2) = {-20.6, 25.4, 0, lc};
Point(3) = {0, -25.4, 0, lc};
Point(4) = {0, 0, 0, lc};
Point(5) = {0, 25.4, 0, lc};
Point(6) = {206, -25.4, 0, lc};
Point(7) = {206, 0, 0, lc};
Point(8) = {206, 25.4, 0, lc};
Point(9) = {290, -16.6, 0, lc};
Point(10) = {290, 0, 0, lc};
Point(11) = {290, 16.6, 0, lc};
//+
Line(1) = {2, 5};
//+
Line(2) = {5, 8};
//+
Line(3) = {8, 11};
//+
Line(4) = {11, 10};
//+
Line(5) = {10, 9};
//+
Line(6) = {9, 6};
//+
Line(7) = {6, 3};
//+
Line(8) = {3, 4};
//+
Line(9) = {4, 1};
//+
Line(10) = {1, 2};
//+
Line Loop(11) = {2, 3, 4, 5, 6, 7, 8, 9, 10, 1};
//+
Plane Surface(12) = {11};
//+
Physical Surface("interior") = {12};
//+
Physical Line("walls") = {1, 2, 3, 6, 7, 8, 9};
//+
Physical Line("inlet") = {10};
//+
Physical Line("outlet") = {4};
