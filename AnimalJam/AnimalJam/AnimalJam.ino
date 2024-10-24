#define BUTTON_PIN 2
#define POT_PIN 15

int xyzPins[] = {39, 32, 33};   //x, y, z(switch) pins
void setup() {
  Serial.begin(9600);
  pinMode(xyzPins[2], INPUT_PULLUP);  // pullup resistor for switch
  pinMode(BUTTON_PIN, INPUT_PULLUP); // use internal pullup resistor
  pinMode(POT_PIN, INPUT_PULLUP);
}

void loop() {
  int xVal = analogRead(xyzPins[0]);
  int yVal = analogRead(xyzPins[1]);
  int zVal = digitalRead(xyzPins[2]);
  int buttonState = digitalRead(BUTTON_PIN);
  int potState = analogRead(POT_PIN);


  Serial.printf("%d,%d,%d,%d,%d", xVal, yVal, zVal, buttonState, potState);
  Serial.println();
  delay(100);
}