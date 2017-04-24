// polygon_areas.scad: Another recursion example 

// Draw all geometry
unit_cell();
translate([13.5, 0]) unit_cell();
translate([0, 13.5]) unit_cell();
translate([13.5, 13.5]) unit_cell();

module unit_cell() {
    primal_tile();
    dual_tile();
}

module basic_tile() {
    translate([0, 0, -1]) linear_extrude(height=2) polygon([
        [0, 0],
        [10, 0],
        [0, 10]
    ]);
}

module primal_tile() {
    union() {
        basic_tile();
        translate([-0.9, 8.5]) torus(1, 1.1);
        translate([-0.9, 2.5]) torus(1, 1.1);
        
        rotate(a=90, v=[0, 0, 1]) {
            translate([-0.9, -8.5]) torus(1, 1.1);
            translate([-0.9, -2.5]) torus(1, 1.1);
        }
        
        translate([1, -1])
        rotate(a=45, v=[0, 0, 1]) {
            translate([-4.75, -4.75])
                // FIXME: there is a definite placement error here.
                cross_bar(10, 1);
        }
    }
}

module cross_bar(height=10, shear=1) {
    union () {
        translate([height + 2.5 * shear, height]) bar(0.4, height - shear);
        translate([height + shear, (height / 2) + shear])
        rotate(a=90, v=[0, 0, 1])
            bar(0.4, 1.5);
    }
}

module dual_tile() {
    union () {
        rotate(a=180, v=[0, 0, 1])
        translate([-11, -11])
            basic_tile();
        cross_bar();
        
        translate([11.5, 0])
        rotate(a=90, v=[0, 0, 1])        
            cross_bar();
        
        translate([8.25, 2.25])
            rotate(a=45, v=[0, 0, 1])
            torus(1, 1.1);
        
        translate([2.25, 8.25])
            rotate(a=45, v=[0, 0, 1])
            torus(1, 1.1);
    }
}

module torus(inner_r, outer_r) {
    rotate(a=90, v=[1, 0, 0]) 
    rotate_extrude($fn=20)
        translate([inner_r, 0, 0])
        circle(r = outer_r - inner_r);
}

module bar(r, h) {
    rotate(a=90, v=[1, 0, 0])
    linear_extrude(height=h)
        circle(r=r, $fn=100);
}    


// One shape with corresponding text
module shapeWithArea(num, r) {
    polygon(ngon(num, r));
    translate([0,-20]) 
        color("Cyan") 
            text(str(round(area(ngon(num, r)))), halign="center", size=8);
}

// Simple list comprehension for creating N-gon vertices
function ngon(num, r) = 
  [for (i=[0:num-1], a=i*360/num) [ r*cos(a), r*sin(a) ]];

// Area of a triangle with the 3rd vertex in the origin
function triarea(v0, v1) = cross(v0, v1) / 2;

// Area of a polygon using the Shoelace formula
function area(vertices) =
  let (areas = [let (num=len(vertices))
                  for (i=[0:num-1]) 
                    triarea(vertices[i], vertices[(i+1)%num])
               ])
      sum(areas);

// Recursive helper function: Sums all values in a list.
// In this case, sum all partial areas into the final area.
function sum(values,s=0) =
  s == len(values) - 1 ? values[s] : values[s] + sum(values,s+1);


echo(version=version());
// Written in 2015 by Marius Kintel <marius@kintel.net>
//
// To the extent possible under law, the author(s) have dedicated all
// copyright and related and neighboring rights to this software to the
// public domain worldwide. This software is distributed without any
// warranty.
//
// You should have received a copy of the CC0 Public Domain
// Dedication along with this software.
// If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.
