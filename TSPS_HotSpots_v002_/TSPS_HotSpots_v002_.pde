// THE PIRATE BAY - P2P INSTALLATION
// CARSONCHANG.CC

// 18 LED BARS + PRINTER
// Each LED bar increases in brightness until max as person stands in front
// When all LED bars are maxed, initiate printer, and reset

// import libraries
import   codeanticode.syphon.*;
import   processing.video.*;                               
import   tsps.*;
import   ddf.minim.*;
import processing.serial.*; // arduino 

Serial myPort;  // Create object from Serial class
String val;     // Data received from the serial port

// create objects
Minim    minim;                                           
TSPS     tspsReceiver;
SyphonServer server;

// set global variables                              
float    activeWidth;
float    activeHeight;  

/* Setup your hotSpots 
 * Constructor: HotSpot(name, x, y, width, height);
 * Your hotspot is independent object, you have ask it if they are hit
 */
HotSpot[] hotSpots = {                  
  new HotSpot("E1", 1*1280/20, 0, (1280/20), 720), 
  new HotSpot("E2", 2*1280/20, 0, (1280/20), 720), 
  new HotSpot("E3", 3*1280/20, 0, (1280/20), 720), 
  new HotSpot("E4", 4*1280/20, 0, (1280/20), 720), 
  new HotSpot("E5", 5*1280/20, 0, (1280/20), 720), 
  new HotSpot("E6", 6*1280/20, 0, (1280/20), 720), 
  new HotSpot("E7", 7*1280/20, 0, (1280/20), 720), 
  new HotSpot("E8", 8*1280/20, 0, (1280/20), 720), 
  new HotSpot("E9", 9*1280/20, 0, (1280/20), 720), 
  new HotSpot("E10", 10*1280/20, 0, (1280/20), 720), 
  new HotSpot("E11", 11*1280/20, 0, (1280/20), 720), 
  new HotSpot("E12", 12*1280/20, 0, (1280/20), 720), 
  new HotSpot("E13", 13*1280/20, 0, (1280/20), 720), 
  new HotSpot("E14", 14*1280/20, 0, (1280/20), 720), 
  new HotSpot("E15", 15*1280/20, 0, (1280/20), 720), 
  new HotSpot("E16", 16*1280/20, 0, (1280/20), 720), 
  new HotSpot("E17", 17*1280/20, 0, (1280/20), 720), 
  new HotSpot("E18", 18*1280/20, 0, (1280/20), 720), 
};                       

// create your movies
// Movie m0, m1, m2;

// soundfx samples
AudioSample inBeebSFX;
AudioSample outBeebSFX;

AudioSample inDropSFX;
AudioSample outDropSFX;
AudioSample insaneDropSFX;

PImage roquo, pring;
int rotq = 0;
boolean showroquo = true;
boolean showpring = false;

void settings() {
  //fullScreen();
  size(1280, 720, P3D);
  PJOGL.profile=1;
}

void setup() {
  /**
   * active width is the area you want to detect
   * if you have a really wide aspect ratio, 
   * change this to something smaller
   * your hotspots will also have to be in this area
   */
  activeWidth = width;
  activeHeight = height;
  roquo = loadImage("rotatingquotes.png");
  pring = loadImage("printing.png");

  /** initialize minim for audio playback
   * here we initialize and load up your AudioSample
   * you can create more if you like
   */
  minim = new Minim(this);
  inBeebSFX  = minim.loadSample("beep_piano_on.mp3", 512);
  outBeebSFX = minim.loadSample("beep_piano_off.mp3", 512);

  inDropSFX  = minim.loadSample("pop_drip_squeak.mp3", 512);
  outDropSFX = minim.loadSample("pop_drip_up.mp3", 512);
  insaneDropSFX = minim.loadSample("pop_lo_2.mp3", 512);

  // Load up your Movie Setup
  //m0 = new Movie(this, "movie_00.mov");
  //m1 = new Movie(this, "movie_01.mov");
  //m2 = new Movie(this, "movie_02.mov");
  //m0.loop();

  //all you need to do to start TSPS
  tspsReceiver= new TSPS(this, 12000);

  // Create syhpon server to send frames out.
  server = new SyphonServer(this, "Processing Syphon");

  String portName = Serial.list()[3];
  println(Serial.list());
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n');


  //  pir8 = createFont("pir8bit.ttf", 32, true);
}

//this is absolutely necessary for video playback, don't delete/comment out
//void movieEvent(Movie m) {
//  m.read();
//}

void draw() {
  //  myPort.write(stringOut);
  clear();
  background(0);

  if (showroquo == true) {
    image(roquo, rotq+width, height/3);
    rotq+=(-5);
    if (rotq <= (-3785-width)) {
      rotq = 0;
    }
  } 
  //  fill(255);
  //  textFont(pir8);
  //  text("PLEASE SEED", 10, 50);

  /* these functions are shortcuts look below the draw fuction
   * with these functions you can make your if statemens 
   * look at the HotSpot for more info
   */



  if ( myPort.available() > 0 ) {  // If data is available,
    val = myPort.readStringUntil('\n');         // read it and store it in val
    val=val.trim(); // fix the damn line break
    println(val);
    if (val.equals("p")) {
      println("this actually freaking works");
      printImage();
    }

    if (val.equals("o")) {
      showroquo = false;
      showpring = true;
      if (showpring == true) {
        image(pring, (width/2)-117, height/3);
      }
    }

    if (val.equals("d")) {
      showroquo = true;
      showpring = false;
    }
  }

  for (int i = 0; i < hotSpots.length; i++) {
    //println("kasjd;fa "+ hotSpots[i].name);

    // when person enters
    if (hotSpots[i].isBeginHit) {                                 
      inBeebSFX.trigger();
      myPort.write(i+'0');
    }

    // happens every frame that the person is inside
    if (hotSpots[i].isHit) {
      myPort.write(i+'0');
      println(i);
      if (hotSpots[i].age<100) {
        int value = int(map(hotSpots[i].age, 0, 100, 0, 255));
        value = constrain(value, 0, 255);

        //        fill(value);
        //      rect(hotSpots[i].x, hotSpots[i].y, hotSpots[i].w, hotSpots[i].h);
      }
      if (hotSpots[i].age==100) {
        outBeebSFX.trigger();
        // turn led red?
      }
    }
    if (hotSpots[i].isEndHit) {
      outBeebSFX.trigger();
    }
  }
  println(myPort.available());
  if (keyPressed == true) {
    println("pressin works");
    myPort.write(key);
  }

  delay(50);

  /* look at the tspsDetect tab for more
   * this is where all the position data arrives
   * and gets analyzed by your hotspots
   */
  server.sendScreen();
  tspsDetect();
}
