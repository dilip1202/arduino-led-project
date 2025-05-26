#include "src/Led_control.h"

void setup() {
  led_init(13); // Built-in LED
}

void loop() {
  led_on();
  delay(1000);
  led_off();
  delay(1000);
}