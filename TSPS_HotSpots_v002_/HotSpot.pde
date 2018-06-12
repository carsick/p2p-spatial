class HotSpot {

  /* the HotSpot class
   * it's created to simplify your tasks
   * it digests all the information and let's you know what's up
   * things you can ask it are: isHit, isBeginHit, isEndHit, getNormalPosition
   *
   * isBeginHit          : only fires once, good for audio triggers
   * isHit               : is either true or false, and runs every frame
   * isEndHit            : only fires once, after the person leaves or time has passed
   * getNormalPosition() : it's a vector that returns the relative position percentage of the person in the hotspot, good for scrubbing videos
   * 
   * age                 : how long the person has been in the hotspot
   *
   * isVisible           : set it to false, if you don't want to see it in your sketch, otherwise it's good for debug
   */

  String  name;
  int     pid, age, life = 2;                       // life is used to clean hotspot if person drops unexpectedly
  float   x, y, w, h, cx, cy;                       // location of hotspot
  float   px, py, pz, nx, ny;                       // location of person

  boolean isHit, isBeginHit, isEndHit;              // logic for hit events
  boolean isVisible = false;                         // visibility to see the events

  color   hitColorCurrent;                          // colors to visually see what's going on
  color   hitColorTrue    = color(0, 255, 0, 50);     
  color   hitColorFalse   = color(255, 0, 0, 50);

  color   beginHitColor   = color(0, 255, 0);       // colors to visually see when it enters or leaves
  color   endHitColor     = color(255, 0, 0);

  HotSpot(String name, float x, float y, float w, float h) { 

    /*  setup for the hotspot
     * Sets name, location, size and center position
     * Also sets current color to false red
     * and says hello in your console :)
     */

    this.x = x;                                    
    this.y = y;
    this.w = w;
    this.h = h;
    this.name = name;
    cx = x+w/2;                             
    cy = y+h/2;                                 
    hitColorCurrent = hitColorFalse;
    println("hotspot created "+ name);
  }

  void detect(float px, float py, float pz, int id) {
    noFill();
    noStroke();

    // if it's already hit, and your not the same person, don't detect anymore
    if (isHit && pid != id) {
      return;
    } 

    // checks if position is in boundaries
    if (px>x && px < x+w && py > y && py < y+h) { 
      // saves position for other functions
      this.px = px;                                  
      this.py = py;
      this.pz = pz;

      // sets hit color to green!
      hitColorCurrent = hitColorTrue;               

      /**  if (!isHit) checks if it was hit before, 
       * if it wasn't, isBeginHit is true
       * locks it to the same person id so it doesn't endHit next time around
       * sets a life in case person drops out
       * if person drops out isBeginHit is true
       **/
      if (!isHit) {                                 
        isBeginHit = true;
        isHit = true;
        pid = id;
        life = 100;
        strokeWeight(5);
        stroke(beginHitColor);
      } else {
        age++;
        life = 5;
        isHit = true;                              
        isBeginHit = false;
      }
    } else if (isHit) {                             
      hitColorCurrent = hitColorFalse;
      isEndHit = true;
      isHit = false;
      strokeWeight(5);
      stroke(endHitColor);
    } else {
      age = 0;
      isHit = false;
      isEndHit = false;
    }


    if (isVisible) {
      /** if you want to see your hotspot **/
      fill(hitColorCurrent);
      rect(x, y, w, h);
      fill(255);
      textAlign(CENTER, CENTER);
      text(name, cx, cy);
    }

    // resets fill and strokes
    noFill();
    noStroke();
  }


  void clean() {

    /** this function gets rid of persond id if they drop out **/

    life--;
    if (life < 0) {
      life = 0;
      isHit = false;
      isEndHit = false;
      isBeginHit = false;
    }
  }


  PVector getNormalPosition() {

    /** this fuction returns the relative position percentage
     * for example if a person is in the middle of your hotspot
     * it will return a PVector of .5, .5
     * to access it use:
     * hotSpots[number].getNormalPosition().x;
     * then you can multiply that to whatever, movie duration or width or height
     */

    if (isHit) {
      nx = map(px, x, x+w, 0, 1);
      nx = map(px, x, x+w, 0, 1);

      println(nx);
      return new PVector(nx, ny, pz);
    } else {
      return new PVector(0, 0, 0);
    }
  }
}