#include "unity.h"
#include "Led_control.h"
#include "mock_Arduino.h"

void setUp(void) {}
void tearDown(void) {}

void test_led_init_should_set_pin_mode(void)
{
    pinMode_Expect(13, OUTPUT);
    led_init(13);
}

void test_led_on_should_set_high(void)
{
    pinMode_Expect(13, OUTPUT);
    digitalWrite_Expect(13, HIGH);
    led_init(13);
    led_on();
}

void test_led_off_should_set_low(void)
{
    pinMode_Expect(13, OUTPUT);
    digitalWrite_Expect(13, LOW);
    led_init(13);
    led_off();
}