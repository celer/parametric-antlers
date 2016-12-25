//This software is released under an MIT license.
// See https://github.com/celer/parametric-antlers


$fn=20;
//x_start - where to start the parabolic curve
//x_end - where to end the parabolic curve
//wx2 - weight for x^2 
//wz1 - weight for z^1
//wz2 - weight for z^2
//wz3 - weight for z^3
//ar - array of attachment points for tines given the value of x
//sf - linear scaling factor for each part of the antler
module parabolic(x_start,x_end,wx2,wz1,wz2,wz3,ar,sf){
   
    
    for (x=[x_start:1:x_end]){  
        current=[x,wx2*x*x,x*wz1+x*x*wz2+x*x*x*wz3];
        k=x-1;
        last=[k,wx2*k*k,k*wz1+k*k*wz2+k*k*k*wz3];
  
      
        if (x!=x_start){ 
            hull(){ 
                translate(current) sphere(r=(sf*abs(x))+1);
                translate(last) sphere(r=(sf*(abs(x-1)))+1);
            }
        }
    }
    
    if (len(ar)>0){
        for (c=[0:1:len(ar)-1]){
            v=ar[c];
            for (x=[x_start:1:x_end]){
                if (x==v){
                    ss=(sf*abs(x))+1;
                    current=[x,wx2*x*x,x*wz1+x*x*wz2+x*x*x*wz3]; 
                    translate(current) scale(ss) children(c);
                }       
            }
        }
    } 
}


module antlers(){
    rotate([90,0,0]) {
        parabolic(-5,0,0.05,-0.03,0,0,0,-0.10);
            rotate([0,-10,0]) parabolic(0,11,0.08,0.20,0.01,-0.0035, [11, 9,5],-0.033){
            rotate([-10,-0,10]) parabolic(-3,3,0.7,0.5,0.01,0.0,0,-0.16);
            rotate([0,-32,0])  parabolic(-3.5,0,0.3,0.01,0.12,0.04,0,-0.16);
            rotate([0,-35,0])  parabolic(-4,0,0.3,0.01,0.12,0.04,0,-0.15);
        }
    }
}

translate([0,-6,0]) antlers();
translate([0,6,0]) mirror([0,1,0]) antlers();