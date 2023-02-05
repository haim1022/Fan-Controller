#define echoPin 2
#define trigPin 3 

long duration; // variable for the duration of sound wave travel
uint16_t distance, currentDistance; // variable for the distance measurement
byte incomingByte = 0;
uint16_t minVal = 300, maxVal = 0;

void setup() {
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  Serial.begin(115200);
}
void loop() {
  if(Serial.available()) {
    incomingByte = Serial.read();
    incomingByte = incomingByte-48;
    if(incomingByte == 0 || incomingByte == 1)
      digitalWrite(LED_BUILTIN, incomingByte);
  }
  /*currentDistance = getDistance();
  if(currentDistance > 20 && currentDistance > 80)
    digitalWrite(LED_BUILTIN, HIGH);
  else
    digitalWrite(LED_BUILTIN, LOW);*/
}

uint16_t getDistance() {
  // Clears the trigPin condition
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  // Sets the trigPin HIGH (ACTIVE) for 10 microseconds
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  // Reads the echoPin, returns the sound wave travel time in microseconds
  duration = pulseIn(echoPin, HIGH);
  // Calculating the distance
  distance = duration * 0.034 / 2; // Speed of sound wave divided by 2 (go and back)
  return distance;
}