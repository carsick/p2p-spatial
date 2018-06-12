#include "FastLED.h"
#define NUM_LEDS 540
#define DATA_PIN 2
#define FRAMES_PER_SECOND  120

int BRIGHTNESS = 220;

int col = 0; // columns

boolean allLit = false;

unsigned long pMillis = 0;
unsigned long interval = 20000; // time after printer

// 30, 60, 90, 120, 150, 180, 210, 240, 270, 300, 330, 360, 390, 420, 450, 480, 510, 540

CRGB leds[NUM_LEDS]; // Define array of LEDs

char val; // data from serial port

int x = leds[x];
int totalLit = 0;

void setup() {
  delay(3000);
  Serial.begin(9600);
  FastLED.addLeds<WS2812B, DATA_PIN, GRB>(leds, NUM_LEDS);
  FastLED.setBrightness(BRIGHTNESS);
}

void loop() {
  //  Serial.println("q"); // is it working?
  FastLED.show();
  FastLED.delay(1000 / FRAMES_PER_SECOND);
  unsigned long cMillis = millis();

  if (Serial.available() > 0) {
    val = Serial.read();

    if (val == 'a') {
      allLit = true;
    }

    if (val == 'e') {
      allLit = false;
    }

    //    for (int e = 0; e < 540; e++) {
    //          if (val == '0') {
    //      leds[e]++;
    //          }
    //    }

    for (int r = 0; r < 18; r++) {
      if (val == r + '0') {
        for (int i = (r * 30); i < ((r * 30) + 30); i++) {
          //        leds[i] = CRGB(0, 0, 0);

          if (leds[i] == CRGB(0, 0, 150)) {
            leds[i] = CHSV(85, 255, 200);
            totalLit++;
          }
          if (leds[i] == CHSV(85, 255, 200)) {
            leds[i] += 0;
          } else {
            leds[i] += CRGB(0, 0, 5);
          }
        }
      }
    }
  }

  if (totalLit == NUM_LEDS) {
    allLit = true;
    totalLit = 0; // reset so it doesn't loop in order for pMillis to work
    pMillis = cMillis; // grab pMillis at cMillis time
    Serial.println("p"); // tell processing begin print

  }

  if (allLit == true) {
    Serial.println("o");
    fill_solid(leds, NUM_LEDS, CHSV(85, 255, 100));

    // left to right loading bar
    col++;
    if (col == 18) {
      col = 0;
    }

    for (int i = (col * 30); i < ((col * 30) + 30); i++) {
      leds[i] = CHSV(85, 255, 255);
    }

    if (cMillis - pMillis >= interval) {
      Serial.println("d"); // tell processing it's done
      allLit = false;
      fill_solid( leds, NUM_LEDS, CRGB(0, 0, 0));
    }

  }

}

