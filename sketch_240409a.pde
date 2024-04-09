//bucle for
int y=0;


void setup (){
size (600,700);
fullScreen();
frameRate(30);
}

void draw (){
background (255,0,34);
noCursor();

for(int i = 0; i < 10 ; i++){
rect(60, 60 * i + 50, 50 * i + 50, 50);
};
ellipse(40 + y % 100,40,40,40);
y=y+1;

}
