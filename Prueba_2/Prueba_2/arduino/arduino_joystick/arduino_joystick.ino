// Definir los pines para los ejes X e Y del joystick
const int pinX = A0; // Pin analógico para el eje X
const int pinY = A1; // Pin analógico para el eje Y
const int deadZone = 50; // Zona muerta para evitar movimientos mínimos

void setup() {
  Serial.begin(9600); // Iniciar la comunicación serie
  pinMode(pinX, INPUT); // Configurar el pin X como entrada
  pinMode(pinY, INPUT); // Configurar el pin Y como entrada
}

void loop() {
  int xValue = analogRead(pinX); // Leer el valor del eje X
  int yValue = analogRead(pinY); // Leer el valor del eje Y
  int centerX = 512; // Valor central para el eje X
  int centerY = 512; // Valor central para el eje Y

  // Aplicar zona muerta para mejorar la precisión
  xValue = (abs(xValue - centerX) < deadZone) ? centerX : xValue;
  yValue = (abs(yValue - centerY) < deadZone) ? centerY : yValue;

  // Mapear los valores a las dimensiones de la pantalla completa
  int mappedX = map(xValue, 0, 1023, 0, 1900);  // Ajustar estos valores si la resolución es diferente
  int mappedY = map(yValue, 0, 1023, 0, 1536);

  // Enviar los valores mapeados a Processing
  Serial.print(mappedX);
  Serial.print(",");
  Serial.println(mappedY);

  delay(10);
}
