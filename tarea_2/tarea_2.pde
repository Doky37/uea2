int y=0; //varable que nos ayudara a poder mover el objeto

void setup() {
  size(600, 600); // Tamaño del lienzo
  frameRate(30); 
  fullScreen(); //pantalla completa
  
}

void draw() {
  // Aquí puedes agregar cualquier otra cosa que quieras dibujar en el lienzo
  background(173, 37, 168); // Fondo con el color especificado (RGB 173, 37, 168)
  
  
  
  PImage img; // declaro variable de imagen
  img = loadImage("/Users/Doky37/Documents/Processing/tarea_2/assets/kiosco.jpeg"); // ruta de la imagen
  image(img, 380, 70, 720, 788); // cargar la imagen en una posición xy y cambiar el tamaño
  
  
  fill(0,9,255);
  ellipse (40 + y % 1500,500,408,408); //crea una figura circular, tamaño y posicion, la primera parte determina hasta donde se mueve el objeto
  y=y+15; //cambia la velocidad a la que se mueve el objeto

  textSize(75);
  String s = "COLOR EN PIXELES";
fill(255,175,0);
text(s, -100 + y % 1500, 390, 280,280);
y=y+15;

textSize(25);
  String m = "Vision multicolor, Alexandra Krystal, 10 al 29 de septiembre de 2024";
fill(0,0,0);
text(m, 1150,800,280,280);
}
