import 'dart:math';

void main() {
  Shape c = Circle(5);
  print('Circle area: ${c.area()}');
  Shape r = Rectangle(4, 6);
  print('Rectangle area: ${r.area()}');
}

abstract class Shape {
  double area();
}

class Circle implements Shape {
  double r;
  Circle(this.r);
  @override
  double area() {
    return pi * r * r;
  }
}

class Rectangle implements Shape {
  double w, h;
  Rectangle(this.w, this.h);
  @override
  double area() {
    return w * h;
  }
}
