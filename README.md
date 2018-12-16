# Android Side Guesture Test
This is an app coded in Processing for testing side gestures on Android devices. Copper foil tapes extend the screen to the side.

### Prerequisites

Having Processing 3 and Android SDK installed on computer; Having an Android device (with foil tapes attached along an edge).

## Running the tests

Run the script and install the program on the Android device. Wait until it installed and opened.
A column of blocks with indexes stay on the right side of screen, also deepening in color. 
1. Touch the screen (foil tape) and check the number turns red in the block at the position of your finger.
2. Hold your finger and check the block changes to yellow.
3. Slide your finger up and down and check the blocks scrolling.
4. Hold on some block and move your finger up/down to check the dragging.

## Parametres for setting

To change [item], consider modifying [parametre(s)]
1. Enlarging the tapped block: zoomOption = true.
2. Time needed for holding: threshold.
3. Speed when scrolling: scrollSpeed.
4. Block width: B2W (blockWidth/width)
5. The data structure used is 2-directional circular linked list. To make it noncircular, consider modification in the classes.


## Author

Dong (Sheldon) Xu
