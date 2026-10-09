void main() {
  var dev = Developer('Raghdaa', 15000);
  dev.work();
  var des = Designer('Razan', 12000);
  des.design();
}

class Employee {
  String name;
  double salary;
  Employee(this.name, this.salary);
  void work() {
    print('$name is working...');
  }
}

class Developer extends Employee {
  Developer(super.name, super.salary);
  void codeing() {
    print('$name is writing code ');
  }
}

class Designer extends Employee {
  Designer(super.name, super.salary);
  void design() {
    print('$name is designing UI ');
  }
}
