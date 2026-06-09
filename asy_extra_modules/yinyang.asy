size(0,25cm);
path center=(0,1){W}..(0,0){dir(-5)}..{W}(0,-1);

path lefthalf = (0,1)..(-1,0)..(0,-1);
draw(lefthalf);

path righthalf = center{E}..{N}(1,0)..{W}cycle;
filldraw(righthalf);

unfill(circle((0,0.5),0.125));
fill(circle((0,-0.5),0.125));
