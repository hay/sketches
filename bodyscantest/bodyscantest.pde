import SimpleOpenNI.*;
import java.util.*;

SimpleOpenNI context;
String[] sampletext = {
  "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k"
}; // sample random text

void setup() {
  size(640, 480, P3D); // if you don't have graphics card then use this
  // size(640, 480, P3D); // if you r system have any grpshics card other than intel Graphics then use this // it will simply improve the speed of the processing
  context = new SimpleOpenNI(this);
  context.setMirror(true);
  context.enableDepth();
  context.enableUser();
}

void draw() {
  background(0, 0, 0);
  context.update();
  int[] userMap =null;

  //  this part is necesasry when I have used old simpleopenNI library but I dont have any idea what would ahappen if you modify the code according to new version
  //  if (userCount > 0) {
  //    userMap = context.getUsersPixels(SimpleOpenNI.USERS_ALL);
  //  }

  int userCount = context.getNumberOfUsers();
  if (userCount > 0) {
    userMap = context.userMap();
  }

  println("userCount: " + userCount);


  loadPixels(); // keep this part it is necessary because it loads the depth pixles and ready them for any further modification
  for (int y=0; y<context.depthHeight(); y++) {
    for (int x=0; x<context.depthWidth(); x++) {
      int index = x + y * context.depthWidth(); // it call the pixels index // so there two methods for calling pixles, either you call them by index or pixel coordinate (x,y);
      if (userMap != null && userMap[index] > 0) {  // match with the user's pixle with the kinect pixel
        fill(#43E505);// text color set to green
        text(sampletext[int(random(0, 10))], x, y); // call sample random text from array
      }
    }
  }
  updatePixels(); // first try with this if doesn't work then comment it back // it will show the modified pixles which is not nessary for you
}


//---------------------------------------------------------------------------
// This part is important so don't comment it//
void onNewUser(int userId) {
  println("detected" + userId);
}

void onLostUser(int userId) {
  println("lost: " + userId);
}