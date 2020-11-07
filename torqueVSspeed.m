p=250;
w=400;%rpm
l=input('enter the load in kg: ');
load=l*9.81;
efficiency=0.85;
v=input('enter the target speed in km/h: ');%km/h
d=input('enter the tire dia in iches: ');
tireDia=d*0.0254;


v=v/3.6;
w=w/9.55
Wwheel=v/(tireDia/2)
te=p/w

noOfWheel=2;
frictionalTorque=0.6*(load/noOfWheel)*(tireDia/2)