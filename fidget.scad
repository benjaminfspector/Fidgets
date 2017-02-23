res = 40;

wall = 2.7;
height = 7;

b_ir = 4;
b_or = 10.925;

trans = 40+b_or*2+wall;
c_r = b_or*.5;

num_sides = 12;

alpha = 180/num_sides;
beta = 180-alpha;
l1 = b_or/sin(alpha);
l2 = c_r/sin(alpha);
l3 = c_r/tan(alpha);

module bearing_slot_2d() {
    difference() {
        circle(b_or+wall, $fn=res);
        circle(b_or, $fn=res);
    }
}
module fidget_in_2d() {
    c_u_r = sqrt(l1*l1+l3*l3-2*l1*l3*cos(beta));
    c_d_r = l1+l2;
    difference() {
        union() {
            for(i=[1:num_sides]) hull() {
                circle(b_or, $fn=res);
                rotate([0,0,360/num_sides*i]) translate([trans,0]) circle(b_or, $fn=res);
            }
            circle(c_u_r, $fn=res);
        }
        for(i=[1:num_sides]) rotate([0,0,360/num_sides*(i-.5)]) translate([c_d_r,0]) circle(c_r, $fn=res);
    }
}
module fidget_2d() {
    union() {
        difference() {
            minkowski() {
                fidget_in_2d();
                circle(wall, $fn=res);
            }
            fidget_in_2d();
        }
        bearing_slot_2d();
        for(i=[1:num_sides]) rotate([0,0,360*i/num_sides]) translate([trans,0]) bearing_slot_2d();
        for(i=[1:num_sides]) rotate([0,0,360*i/num_sides]) translate([l1+l2/2,0]) square([l2,wall], center=true);
    }
}
fidget_2d();