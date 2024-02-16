// Target class (position and width)
class Target {
  constructor(x, y, w, l, id, my_color, my_darker_color) {
    this.x = x;
    this.y = y;
    this.width = w;
    this.label = l;
    this.my_color = my_color;
    this.my_darker_color = my_darker_color;
    this.id = id;
  }

  // Checks if a mouse click took place
  // within the target
  clicked(mouse_x, mouse_y) {
    return dist(this.x, this.y, mouse_x, mouse_y) < this.width / 2;
  }

  // Draws the target (i.e., a circle)
  // and its label
  draw(grey) {
    // Draw target
    if (!grey) {
      fill("#ff1493");
      circle(this.x, this.y, this.width+this.width/6);
    }
    fill(this.my_color);
    circle(this.x, this.y, this.width);
    // Draw label
    if (!grey) {
      textFont("Arial", 70);
      fill(this.my_darker_color);
      textAlign(CENTER, CENTER);
      text(this.label[0], this.x, this.y+5);
      
    }
    textFont("Arial", 18);
    fill(color(255, 255, 255));
    textAlign(CENTER, CENTER);
    text(this.label, this.x, this.y);

  }

  showLabel() {
    return this.label;
  }
  getMeasures() {
    return { x: this.x, y: this.y, width: this.width };
  }
}
