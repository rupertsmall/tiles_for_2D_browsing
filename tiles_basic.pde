// pre-build user-defined variables.
int window_w = 600; // window width (in pixels)
int window_h = 600; // window height (in pixels)
int start_x = 0; // initial x coordinate of bottom left window corner
int start_y = window_h; // initial y coordinate of bottom left window corner
int x_width = 100; // x width of a cell (in pixels)
int y_width = 125; // y width of a cell (in pixels)
int x_gap = 55; // x space between cells (in pixels)
int y_gap = 15; // y space between cells (in pixels)
int x_tiles = 10; // number of tiles in the x direction
int y_tiles = 10; // number of tiles in the y direction
int opac = 100; // opacity of the counter's background circle
color background_colour = #ffffff; // colour of the background of the entire grid
color text_colour = #000000; // colour of the text of the counter digit
color tint_onmouseover = #ffffff; // colour to tint cell on mouseover
color tint_onclick = #faf623; // colour to tint cell on mouse click
color tint_onclicked = #351be0; // colour to tint cell if has ever been clicked before
float speed_scale=.25;

// program variables
int xpos=start_x; 
int ypos=start_y; // location of the bottom left corner of the device's screen on the grid
int motion=0; // indicator variable. motion y = 1, motion n = 0
int xdiff, ydiff; // speed of the motion
int x_unit = x_width + x_gap; // total x width of a unit of the grid
int y_unit = y_width + y_gap; // total y width of a unit of the grid
int num_x = window_w/x_unit + 2; // number of cells to draw in x
int num_y = window_h/y_unit + 2; // number of cells to draw in y
PFont font;
int x_index, y_index; // x and y indices of tile to place at bottom left of window
int x_primed, y_primed; // x and y position shift/displacement of the cells drawn to canvas
int x_bounce=1; 
int y_bounce=1;

void setup() {

  size(window_w, window_h);
  font = loadFont("Courier10PitchBT-Bold-20.vlw");
  textFont(font);
  smooth();
}

void draw() {
  frameRate(120);

  background(background_colour);
  x_index = xpos/x_unit + 1; // x cell index of bottom left cell to draw
  y_index = y_tiles - (ypos/y_unit + 1); // y cell index of bottom left cell to draw
  x_primed = xpos % x_unit; // relative x position
  y_primed = y_gap + y_unit - (ypos % y_unit); // relative y position

  // control mousePressed behaviour such as grid motion

  if ((mousePressed) && (mouseButton==RIGHT)) {
    // grid motion
    xdiff =  ceil(speed_scale*(pmouseX - mouseX));
    ydiff =  ceil(speed_scale*(pmouseY - mouseY));
    xpos += xdiff;
    xpos = abs(xpos); // lower bound for xpos is zero
    xpos = min(xpos, x_tiles*x_unit + x_gap - window_w); // upper bound for xpos
    ypos += ydiff;
    ypos = max(ypos, window_h);
    ypos = min(ypos, y_tiles*y_unit + y_gap);
    motion = 1;
  }

  if ((mousePressed) && (mouseButton==LEFT)) {
    motion=0;
  }

  if (!(mousePressed) && (motion==1)) {
    if ((xpos > x_tiles*x_unit + x_gap - window_w) || (xpos <= 0)) {
      x_bounce *= -1;
    }
    if ((ypos >= y_tiles*y_unit + y_gap) || (ypos < window_h)) {
      y_bounce *= -1;
    }
    xpos += x_bounce*xdiff;
    ypos += y_bounce*ydiff;
  }

  translate(-x_primed, y_primed); // translate the coordinate system for grid motion effect

  // draw cells. >>>>> NOT GENERAL ENOUGH - CHANGE LATER <<<<<<
  for (int yy=0; yy <= num_y-1; yy++) {
    for (int xx=0; xx <= num_x-1; xx++) {
      int x_cell = x_index + xx; // current index of x cell
      int y_cell = y_index + yy; // current index of y cell
      int array_index = (y_cell - 1) * x_tiles + x_cell; // cell element index on 1-D line
      int x_coord = x_gap + xx * x_unit;
      int y_coord = window_h - y_gap - yy * y_unit;
      noStroke();
      // draw image
      PImage current_image = loadImage(get_data(array_index, 1));
      image(current_image, x_coord, y_coord - y_width);
    }
  }

  //fill(text_colour);
  //String position = "x = " + nf(xpos,5) + "\ny = " + nf(ypos,5);
  //text(position,400,400);
}

String get_data(int array_index, int item_number) {
  //tiles_x, tiles_y
  String[] pretend_db = {
    "pid_210634", "green_tile.jpg", "word_1", "£ 3.99"
  };
  String returnstring = pretend_db[item_number];
  return returnstring;
}
