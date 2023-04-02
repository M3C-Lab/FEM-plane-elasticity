//+
SetFactory("OpenCASCADE");
//+
Mesh.MshFileVersion = 2;
//+
Circle(1) = {0, 0, 0, 2, 0, 2*Pi};
//+
Circle(2) = {0, 0, 0, 4, 0, 2*Pi};
//+//+
Curve Loop(1) = {2};
//+
Curve Loop(2) = {1};
//+
Plane Surface(1) = {1, 2};
//+
Physical Curve("Neum-1") = {1};
//+
Physical Curve("Neum-2") = {2};
//+
Physical Surface("tunnel") = {1};
