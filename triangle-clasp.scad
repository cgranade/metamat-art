for (w = [
    [0, 0],
    [4, 4],
    [4, -4],
    [-4, -4],
    [-4, 4]
]) {
    
    translate(w) {

        for (v = [
            [0, 0]//,
            //[0, 4],
            //[0, -4],
            //[-4, 0],
            //[4, 0]
        ]) {
            translate(v)
            primal_tile();
        }
        for (v = [
            [0, 0, 0],
            [-4, 0, 180],
            [-2, 2, 90],
            [-2, -2, 270]
        ]) {
            translate([v[0] + 2, v[1] + 2])
            rotate(a=v[2], v=[0, 0, 1])
            translate([-2, -2])
            dual_tile();
        }
        
    }

}

module dual_tile() {
    union() {
        difference() {
            translate([2, 4, 0.4])
            rotate(a=180, v=[0, 0, 1])
            linear_extrude(height=0.2)
            polygon([
                [-1.5, 2],
                [0, 3.5],
                [1.5, 2],
                [0, 0.5]
            ]);
            
            
            translate([0.9, 2])
            linear_extrude(height=1)
            circle(r=0.12, $fn=100);
            
            translate([2, 2])
            linear_extrude(height=1)
            circle(r=0.85, $fn=100);
            
        }
        
        translate([3.5, 2, 0.5])
        rotate(v=[0, 0, 1], a=180)
        torus(0.25, 0.3);
    }
}

module primal_tile() {
    difference() {
        union() {
            for (v = [
                [-0.1, 0],
                [-1.9, 0],
                [-1, -0.9],
                [-1, 0.9]
            ]) {
                    translate([1 + v[0], 2 + v[1]])
                    linear_extrude(height=1)
                    circle(r=0.08, $fn=100);
            }

            for (z = [0, 1]) {
                translate([0, 0, z])
                linear_extrude(height=0.1)
                polygon([
                    [-2, 2],
                    [0, 4],
                    [2, 2],
                    [0, 0]
                ]);
            }
        }
        
        translate([0, 2, -0.5])
        linear_extrude(height=2)
        circle(r=0.8, $fn=100);
    }
}

module torus(inner_r, outer_r) {
    rotate(a=90, v=[1, 0, 0]) 
    rotate_extrude($fn=20)
        translate([inner_r, 0, 0])
        circle(r = outer_r - inner_r);
}