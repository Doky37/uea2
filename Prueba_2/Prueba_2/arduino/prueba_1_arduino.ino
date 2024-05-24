// Definir los pines para los ejes X e Y del joystick
const int pinX = A0; // Pin analógico para el eje X
const int pinY = A1; // Pin analógico para el eje Y

void setup() {
  Serial.begin(9600); // Iniciar la comunicación serie
  pinMode(pinX, INPUT); // Configurar el pin X como entrada
  pinMode(pinY, INPUT); // Configurar el pin Y como entrada
}

void loop() {
  int xValue = analogRead(pinX); // Leer el valor del eje X
  int yValue = analogRead(pinY); // Leer el valor del eje Y

  // Mapear los valores del joystick a un rango adecuado
  int mappedX = map(xValue, 0, 1023, 0, 800); // Ajustar a los límites de la pantalla en Processing
  int mappedY = map(yValue, 0, 1023, 0, 800);

  // Enviar los valores mapeados a Processing
  Serial.print(mappedX);
  Serial.print(",");
  Serial.println(mappedY);

  delay(10); // Pequeña pausa para estabilidad
}
