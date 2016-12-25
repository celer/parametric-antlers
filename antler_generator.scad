//This software is released under an MIT license.
// See https://github.com/celer/parametric-antlers


$fn=10;
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

function rnd(n) = rands(-n,n,1)[0];

module random_elk_antlers(){
   rotate([90,0,0]) {
        //Forward facing tine
        rotate([rnd(2),0+rnd(10),rnd(2)]) parabolic(-5+rnd(2),0,0.05+rnd(0.07),-0.03+rnd(0.10),0,0,0,-0.10);
        
            main_l=round(10+rnd(3));
            tine_1=round(main_l*0.3+rnd(main_l*0.10));
            tine_2=round(main_l*0.7+rnd(main_l*0.10));
            //Main reward facing tine, the 
            rotate([0,-10+rnd(10),0]) 
                parabolic(0,main_l,0.08+rnd(0.04),0.20+rand(0.10),0.01+rand(0.05),-0.0035, [tine_1,tine_2,main_l],-0.033){
            
            //First lower tine at position 5
            rotate([0,-35+rnd(20),0])  parabolic(-4+rnd(1),0,0.3+rnd(0.20),0.01+rnd(0.10),0.12+rnd(0.15),0.04,0,-0.15);
            
            //Next tine at position 9
            rotate([0,-32+rnd(20),0])  parabolic(-3.5+rnd(1),0,0.3+rnd(0.30),0.01+rnd(0.05),0.12+rnd(0.15),0.04,0,-0.16);
            
            //Top u-shaped tine at position 11   
            if (main_l>10) {
                //If our antlers are already pretty long let's not include any branching
                rotate([-10+rnd(5),-0+rnd(5),10+rnd(5)]) parabolic(-3,3,0.7,0.5,0.01,0.0,0,-0.16);    
            } else {
                //Branch if the antlers aren't long
                s_l=round(4+rnd(1));
                stine_1=round(s_l*0.5+rnd(s_l*0.10));
                stine_2=round(s_l*0.8+rnd(s_l*0.10));
                echo(stine_1);
                rotate([-10+rnd(5),-0+rnd(5),10+rnd(5)]) parabolic(-s_l,s_l,0.7,0.5,0.01,0,[stine_1,stine_2],-0.16) {           
                    //First lower tine at position 5
                    rotate([0,-35+rnd(20),0])  parabolic(-4+rnd(1),0,0.3+rnd(0.20),0.01+rnd(0.10),0.12+rnd(0.15),0.04,0,-0.15);
            
                    //Next tine at position 9
                    rotate([0,-32+rnd(20),0])  parabolic(-4.5+rnd(1),0,0.3+rnd(0.30),0.01+rnd(0.05),0.12+rnd(0.15),0.04,0,-0.16);
                    
                }
                
            }
        }
    } 
}

module antlers(){
    rotate([90,0,0]) {
        //Forward facing tine
        parabolic(-5,0,0.05,-0.03,0,0,0,-0.10);
        
            //Main reward facing tine, the 
            rotate([0,-10,0]) parabolic(0,11,0.08,0.20,0.01,-0.0035, [5,9,11],-0.033){
            
            //First lower tine at position 5
            rotate([0,-35,0])  parabolic(-4,0,0.3,0.01,0.12,0.04,0,-0.15);
            
            //Next tine at position 9
            rotate([0,-32,0])  parabolic(-3.5,0,0.3,0.01,0.12,0.04,0,-0.16);
            
            //Top u-shaped tine at position 11   
            rotate([-10,-0,10]) parabolic(-3,3,0.7,0.5,0.01,0.0,0,-0.16);
        }
    }
}

translate([0,-6,0]) random_elk_antlers();
translate([0,6,0]) mirror([0,1,0]) random_elk_antlers();