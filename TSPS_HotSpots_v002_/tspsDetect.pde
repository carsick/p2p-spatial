void tspsDetect() {

  /* this is just a shortcut to declutter your draw function
   * this is what it does:
   *
   * loops through all the people and through all the hotspots
   * it tells the hotspots to detect the position, and tells it's id
   * then after that's done, it loops throug all the hotspots and cleans
   * them if they have dropped unexpectedly 
   *
   * this sets up all the hitstates for your next draw command!
   */

  // get information from TSPS
  TSPSPerson[] people = tspsReceiver.getPeopleArray();

  // loop through all the people
  for (int i=0; i<people.length; i++) {
    // get person
    TSPSPerson person = people[i];
    float px = person.centroid.x * width;
    float py = person.centroid.y * height;
    float pz = person.depth;

    // draw out the ellipse to debug
//    fill(255);
//    ellipse( px, py, 5, 5 );

    // loop through all the hotspots
    for (HotSpot temp : hotSpots) {
      temp.detect(px, py, pz, person.id);
    };
  }

  // clean up unexpected dropped people
  for (HotSpot temp : hotSpots) {
    temp.clean();
  };
}