// Gmsh project created on Tue Mar 21 09:38:02 2023
SetFactory("OpenCASCADE");
//+
Mesh.MshFileVersion = 2;
//+
Point(1) = {0, 0, 0, 1.0};
//+
Point(2) = {1, 0, 0, 1.0};
//+
Point(3) = {1, 1, 0, 1.0};
//+
Point(4) = {0, 1, 0, 1.0};
//+
Line(1) = {1, 2};
//+
Line(2) = {2, 3};
//+
Line(3) = {3, 4};
//+
Line(4) = {4, 1};
//+
Curve Loop(1) = {4, 1, 2, 3};
//+
Plane Surface(1) = {1};
//+
Physical Curve("Diri-1") = {4};
//+
Physical Curve("Diri-2") = {1};
//+
Physical Curve("Neum-1") = {2};
//+
Physical Curve("Neum-2") = {3};
//+
Physical Surface("Surf") = {1};
