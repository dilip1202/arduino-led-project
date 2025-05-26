#include<Arduino.h>
#include "Led_control.h"

static int led_pin;

void led_init(int pin) {
    led_pin = pin;
    pinMode(led_pin, OUTPUT);
}

void led_on() {
    digitalWrite(led_pin, HIGH);
}

void led_off() {
    digitalWrite(led_pin, LOW);
}