size(25cm, 25cm);

draw((-10, 0)--(10,0), Arrow);
draw((0, -10)--(0, 10), Arrow);
label("$O$", (0,0), SW);

for(int i = -9; i <= 9; ++i){
    if(i != 0){
        // x axis
        draw((i,0)--(i,0.1));
        label(string(i), (i,0), S);
        // y axis
        draw((0, i)--(0.1,i));
        label(string(i), (0,i), W);
    }
}

