void setup() {
  size(600, 600); // Tamaño del lienzo
  background(0, 0, 255); // color del fondo utilizando los parametros RGB
}

void draw() {
  fill(55,3,10); //indica el color de la figura
  ellipse(100, 100, 80,80); //crea una elipse o un circulo segun sus medidas
  fill(0,255,80);
  rect(30, 240,50,50); //Crea una figura rectangular
  fill(0,0,200);
  line(20,2,38,180); //crea lineas, define su grosor y longitud
  fill(40,0,54);
  triangle(100,90,54,154,190,139); //Crea un triangulo
  text("Hola, mundo", width/2, height/2);
}
