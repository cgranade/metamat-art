/*flat_sier(4) {
    //linear_extrude(height=0.2)
    /*polygon([
        [0, sqrt(3) / 2],
        [-0.5, 0],
        [0.5, 0]
    ]);* /
    torus(0.54, 0.56);
} */

S = 1;
R = 1.8;
H = 0.05;
EPS = 0.0001;

scale(2)
union() {
    difference() {
        translate([0, 0, -H / 2])
        linear_extrude(height=H)
        polygon([
            [0, sqrt(3) / 2],
            [-0.5, 0],
            [0.5, 0]
        ]);
        
        for (theta = [0, 120, 240]) {
            translate([
                0, +1 / (S * 2 * sqrt(3))
            ])
            rotate(a=theta, v=[0, 0, 1])
            translate([
                0, -chord_y(S, R) - 1 / (S * 2 * sqrt(3))
            ])
            translate([0, 0, -H / 2 - EPS])
            linear_extrude(height=H + 2 * EPS)
            circle(r=R, $fn=60);
        }
        
        
        translate([0, 0, -H - EPS])
        flat_sier(2, z_scale=0.8, also_children=true)
        /*
            linear_extrude(height=2 * (H + EPS))
            translate([0, 1 / (2 * sqrt(3))])
            circle(0.165, $fn=100);
        */
        translate([0, 1 / (2 * sqrt(3)), 0.18])
        sphere(r=0.18, $fn=30);
    }
    
    for (theta = [0, 120, 240]) {
        translate([0, 1 / (S * 2 * sqrt(3))])
        rotate(a=theta, v=[0, 0, 1])
        translate([S / 2, -1 / (S * 2 * sqrt(3))])
        rotate(a=-30, v=[0, 0, 1])
        rotate(a=90, v=[1, 0, 0])
        torus(0.8 * H / 2, H / 2);
    }
}

function chord_y(side_len, circle_r) =
    sqrt(pow(circle_r, 2) - pow(side_len / 2, 2));

module flat_sier(n, side_len=1, z_scale=0.5, also_children=false) {
    sl = side_len;
    
    if (n == 1 || also_children) {
        children();
    }
    
    if (n > 1) {
        for (offset = [
            [0, sl * sqrt(3) / 2],
           [-0.5 * sl, 0],
            [0.5 * sl, 0]
        ]) {
            scale([0.5, 0.5, z_scale])
            translate(offset)
            flat_sier(n - 1,
                      side_len=side_len,
                      z_scale=z_scale,
                      also_children=also_children
            ) {
                children();
            }
        }
    }
}

module torus(inner_r, outer_r) {
    rotate_extrude($fn=30)
        translate([inner_r, 0, 0])
        circle(r = outer_r - inner_r);
}