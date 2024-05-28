import processing.serial.*;
import java.util.ArrayList;
import java.util.HashMap;

Serial myPort;
PImage img;
PVector lastPosition;
PGraphics buffer;
int fadeSpeed = 5;  // Velocidad del desvanecimiento
int pixelSize = 10;  // Tamaño de los píxeles para dibujar la imagen poco a poco
ArrayList<PVector> revealedPixels = new ArrayList<PVector>();  // Lista para almacenar las posiciones reveladas
PImage[] logos;  // Array para almacenar las imágenes de los logotipos
HashMap<PVector, Integer> logoTimers = new HashMap<PVector, Integer>();  // Tiempos de desvanecimiento de logotipos
int logoDisplayTime = 3000;  // Tiempo que los logotipos permanecen visibles en milisegundos

void setup() {
  fullScreen();
  noCursor();
  img = loadImage("marca.jpeg");  
  img.resize(width, height);
  background(0);
  println(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 9600);
  myPort.bufferUntil('\n');
  lastPosition = new PVector(width / 2, height / 2);

  // Crear el buffer
  buffer = createGraphics(width, height);
  buffer.beginDraw();
  buffer.background(0);  // Inicialmente negro
  buffer.endDraw();

  // Cargar los logotipos
  logos = new PImage[4];
  logos[0] = loadImage("mac.png");  
  logos[1] = loadImage("nike.png");
  logos[2] = loadImage("apple.png");
  logos[3] = loadImage("coca.png");
  // Redimensionar los logotipos
  for (int i = 0; i < logos.length; i++) {
    logos[i].resize(30, 30);  // Tamaño de los logotipos
  }
}

void draw() {
  // Desvanecer el buffer gradualmente
  buffer.beginDraw();
  buffer.noStroke();
  buffer.fill(0, fadeSpeed);  // Negro semi-transparente
  buffer.rect(0, 0, width, height);
  buffer.endDraw();

  // Utiliza la posición del joystick para dibujar píxeles de la imagen
  int x = constrain(int(lastPosition.x / pixelSize) * pixelSize, 0, width - pixelSize);
  int y = constrain(int(lastPosition.y / pixelSize) * pixelSize, 0, height - pixelSize);

  buffer.beginDraw();
  for (int i = -1; i <= 1; i++) {
    for (int j = -1; j <= 1; j++) {
      int px = x + i * pixelSize;
      int py = y + j * pixelSize;
      if (px >= 0 && px < width && py >= 0 && py < height) {
        color c = img.get(px, py);
        buffer.fill(c);
        buffer.rect(px, py, pixelSize, pixelSize);
        revealedPixels.add(new PVector(px, py));
      }
    }
  }
  buffer.endDraw();

  // Mostrar el buffer
  image(buffer, 0, 0);

  // Dibujar elementos gráficos adicionales relacionados con el consumismo
  drawConsumerismElements();
}

void drawConsumerismElements() {
  // Lógica para dibujar elementos gráficos adicionales relacionados con el consumismo
  int currentTime = millis();
  ArrayList<PVector> toRemove = new ArrayList<PVector>();

  for (PVector pos : revealedPixels) {
    if (random(1) > 0.99) {  // Pequeña probabilidad de dibujar un logotipo
      if (!logoTimers.containsKey(pos)) {
        buffer.beginDraw();
        PImage logo = logos[int(random(logos.length))];
        buffer.image(logo, pos.x - 15, pos.y - 15);  // Dibujar el logotipo centrado en la posición
        buffer.endDraw();
        logoTimers.put(pos, currentTime + logoDisplayTime);
      }
    }
  }

  for (PVector pos : logoTimers.keySet()) {
    if (currentTime > logoTimers.get(pos)) {
      toRemove.add(pos);
    }
  }

  for (PVector pos : toRemove) {
    logoTimers.remove(pos);
  }
}

void serialEvent(Serial p) {
  String string = p.readStringUntil('\n');
  if (string != null) {
    string = trim(string);
    int commaIndex = string.indexOf(',');
    if (commaIndex != -1) {
      int x = int(string.substring(0, commaIndex));
      int y = int(string.substring(commaIndex + 1));
      lastPosition.set(x, y);
    }
  }
}
