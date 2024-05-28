import processing.serial.*;

Serial myPort;          // Objeto Serial
ArrayList<Pincelada> pinceladas; // Lista para almacenar las pinceladas

void setup() {
  size(800, 800);
  colorMode(HSB, 360, 100, 100);
  pinceladas = new ArrayList<Pincelada>();
  println(Serial.list()); // Listar puertos disponibles
  myPort = new Serial(this, Serial.list()[0], 9600);
  myPort.bufferUntil('\n');
  frameRate(60);
}

void draw() {
  background(0, 0, 100); // Fondo claro
  
  // Revisar y actualizar pinceladas
  for (int i = pinceladas.size() - 1; i >= 0; i--) {
    Pincelada p = pinceladas.get(i);
    p.update();
    p.display();
    if (p.isFinished()) {
      pinceladas.remove(i); // Eliminar pinceladas viejas
    }
  }
}

void serialEvent(Serial p) {
  String string = p.readStringUntil('\n');
  if (string != null) {
    string = trim(string);
    int commaIndex = string.indexOf(',');
    int x = int(string.substring(0, commaIndex));
    int y = int(string.substring(commaIndex + 1));
    pinceladas.add(new Pincelada(x, y, int(random(3)))); // Añadir pincelada con forma aleatoria
  }
}

class Pincelada {
  PVector position;
  float startTime;
  float lifeSpan = 5000; // 5 segundos antes de desaparecer
  int forma; // Variable para la forma

  Pincelada(float x, float y, int formaTipo) {
    position = new PVector(x, y);
    startTime = millis();
    forma = formaTipo;
  }

  void update() {
    float timePassed = millis() - startTime;
    float alpha = map(timePassed, 0, lifeSpan, 100, 0);
    fill(random(360), 100, 100, alpha); // Más brillante y saturado
  }

  void display() {
    noStroke();
    switch (forma) {
      case 0:
        ellipse(position.x, position.y, 30, 30); // Círculo más grande
        break;
      case 1:
        rect(position.x, position.y, 30, 30); // Cuadrado
        break;
      case 2:
        triangle(position.x - 15, position.y + 15, position.x, position.y - 15, position.x + 15, position.y + 15); // Triángulo
        break;
    }
  }

  boolean isFinished() {
    return millis() - startTime > lifeSpan;
  }
}
