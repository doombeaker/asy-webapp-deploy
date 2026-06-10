size(25cm, 25cm);
int np = 100;
pair[] points;

real r() { return 1.2 * (rand() / randMax * 2 - 1); }

for (int i = 0; i < np; ++i)
points.push((r(), r()));

int[][] trn = triangulate(points);
pen[] mypens = { blue, yellow, green, red, cyan, orange, springgreen, purple, fuchsia };

for (int i = 0; i < trn.length; ++i) {
    fill(points[trn[i][0]]--points[trn[i][1]]--points[trn[i][2]]--cycle, 
        mypens[i % mypens.length]);
}
