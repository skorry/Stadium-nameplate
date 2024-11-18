use <BOSL/shapes.scad>
$fn=256;

//
// modify for your number, name, and name length modifier here:
number="00"; name="YOUR NAME"; nlm=0;

// Note the Name Length Modifier (nlm). It is designed to add space on 
// each side of the name so letters of a short name aren't stretched out too much.  This 
// modifier can be negative for use with very long names, but beyond about -12 is too much.

// some other examples:
//number="10"; name="SMITH"; nlm=6;
//number="22"; name="HORVATH"; nlm=0;
//number="27"; name="GEORGE"; nlm=2;
//number="31"; name="JANOWICZ"; nlm=-6;
//number="40"; name="CASSADY"; nlm=0;
//number="45"; name="GRIFFIN"; nlm=0;
//number="47"; name="HARLEY"; nlm=2;
//number="99"; name="WILLIS"; nlm=2;

// The calling of the number, name, and stand modules - 
// when only creating one, comment out the other two:
number();
name();
stand();

// After printing the name and number, those plates are designed to fit together with the
// pegs and their holes.  It's a tight fit, so you might need to sand them down a bit.  
// Combined, the number and name plates should fit snugly into the stand.

//
// Most people won't have need to alter anything below here
//

// dimensions
ph=37;  // plate height
pd=6;  // plate depth
nw=45;  // number section width
nd=6;  // number depth
lw=118;  // letter section width
ld=6;  // letter depth
pw=nw+lw;  // plate width (number and name combined)
sw = pw+4;  // stand width (a little wider than the plate)

fontused="Rockwell";  //  font to use
fh=22;  // font size
offset=(nw+4);  // the x offset for positioning the letter plate next to the number plate


// number plate section

module nbase()  // creates the section the number will be printed on
{
    translate([0,0,0])
    cuboid([nw,ph,pd],center=false);
}

module numbers()  // creates the number to be printed
{
    translate([(nw/2),(ph/2) - (fh/2),pd])  // positions the number
    linear_extrude(nd)
    {
        text(number, font = fontused, size = fh, halign = "center");
    };    
}

module dowel1()  // the peg sticking out from the number plate
{
    translate([nw-2,(ph/3),3])
    rotate([0,90,0])
    cylinder(4,2,2);
}

module dowel2()  // the hole in the number plate to hold the peg from the name plate
{
    translate([nw-3,(ph/3*2),3])
    rotate([0,90,0])
    cylinder(5,2,2);
}


module number()  // completes the number plate section
{
    difference()  // creates the hole for the dowel from the letters plate to enter
    {
        union()  // combines the plate with the numbers and the extruding dowel
        {
            nbase();
            numbers();
            dowel1();
        };
        dowel2();
    }
}

// name plate section

module lbase()
{
    translate([0,0,0])
    cuboid([lw,ph,6],center=false);
}

module letters()
{
    translate([(lw/2),(ph/2) - (fh/2),6])
    resize([lw-fh+8-nlm,0,0])  
    linear_extrude(6)
    {
        text(name, font = fontused, size = fh, halign = "center");
    };    
}

module dowel3()  // the peg sticking out from the name plate
{
    translate([-2,(ph/3*2),3])
    rotate([0,90,0])
    cylinder(4,2,2);
}

module dowel4()  // the hole in the name plate to hold the peg from the number plate
{
    translate([-1,(ph/3),3])
    rotate([0,90,0])
    cylinder(5,2,2);
}

module name()  // completes the name plate section
{
    translate([offset,0,0])
    difference()  // creates the hole for the dowel from the numbers plate to enter
    {
        union()  // combines the plate with the letters and the extruding dowel
        {
            lbase();
            letters();
            dowel3();
        }
        dowel4();
    }
}

// stand section

module stand_tray()  // creates the part of the stand that holds the plates
{
    difference()
    {
        linear_extrude(9)
        square([sw,ph-16]);
        translate([1.8,1,4])
        linear_extrude(7)
        square([pw+.4,ph]);
    }
}

module stand_base()  // creates the bottom of the stand
{
    translate([0,-8,0])
    cuboid([sw,16,2.5],center=false);
}

module stand()
{
    translate([0,ph+15,0])  // move the stand behind the plates
    union()
    {
        translate([0,3,0.5])
        rotate([75,0,0])
        stand_tray();
        stand_base();
    }
}