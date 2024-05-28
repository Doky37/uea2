import processing.serial.*;
import ddf.minim.*;

Serial myPort;
PImage img;
PVector lastPosition;
float zoomFactor = 1.0;  // Factor de zoom normal
float zoomInFactor = 2.2;  // Factor de zoom al presionar el botón
boolean isZoomedIn = false;  // Estado del zoom
Minim minim;
AudioPlayer player;

void setup() {
  fullScreen();
  noCursor();
  img = loadImage("cara.jpg");  
  img.resize(width, height);
  background(0);
   
  
  println(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 9600);
  myPort.bufferUntil('\n');
  lastPosition = new PVector(width / 2, height / 2);
  
  // Inicializar Minim y cargar el archivo de sonido
  minim = new Minim(this);
  player = minim.loadFile("consumo.mp3");  // Asegúrate de que el archivo esté en la carpeta data
  player.loop();  // Reproducir el sonido en loop
}

void draw() {
  background(0);  // Fondo negro
  float currentZoom = isZoomedIn ? zoomInFactor : zoomFactor;

  // Calcular las dimensiones de la imagen con el zoom aplicado
  int zoomedWidth = int(img.width * currentZoom);
  int zoomedHeight = int(img.height * currentZoom);

  // Calcular la posición de dibujo centrada en el joystick
  int offsetX = int(lastPosition.x - (lastPosition.x * currentZoom));
  int offsetY = int(lastPosition.y - (lastPosition.y * currentZoom));

  PImage zoomedImage = img.get(0, 0, img.width, img.height);
  zoomedImage.resize(zoomedWidth, zoomedHeight);

  // Dibujar la imagen con el zoom aplicado
  image(zoomedImage, offsetX, offsetY);

  loadPixels();
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      int imgX = int(map(x, offsetX, offsetX + zoomedWidth, 0, img.width));
      int imgY = int(map(y, offsetY, offsetY + zoomedHeight, 0, img.height));
      if (imgX >= 0 && imgX < img.width && imgY >= 0 && imgY < img.height) {
        int loc = imgX + imgY * img.width;
        float r = red(img.pixels[loc]);
        float g = green(img.pixels[loc]);
        float b = blue(img.pixels[loc]);
        float maxdist = 100;
        float d = dist(x, y, lastPosition.x, lastPosition.y);
        float adjustbrightness = 255 * (maxdist - d) / maxdist * 0.5;  // Reducir brillo del círculo
        r += adjustbrightness;
        g += adjustbrightness;
        b += adjustbrightness;
        r = constrain(r, 0, 255);
        g = constrain(g, 0, 255);
        b = constrain(b, 0, 255);
        pixels[y * width + x] = color(r, g, b);
      }
    }
  }
  updatePixels();
}

void serialEvent(Serial p) {
  String string = p.readStringUntil('\n');
  if (string != null) {
    string = trim(string);
    String[] parts = split(string, ',');
    if (parts.length == 3) {
      int x = int(parts[0]);
      int y = int(parts[1]);
      int buttonState = int(parts[2]);
      lastPosition.set(x, y);
      
      // Ajustar el zoom según el estado del botón
      isZoomedIn = (buttonState == 1);
    }
  }
}

void stop() {
  player.close();
  minim.stop();
  super.stop();
}
