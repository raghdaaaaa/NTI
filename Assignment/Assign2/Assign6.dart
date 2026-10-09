//* Abstraction: define what something does and hide how it does it.
//* Benefits : code is simple , easy add new features ,Changing the inside doesn’t break the outside
void main() {
  var checkout = Checkout();
  checkout.process(Wallet(), 200);
  checkout.process(Card(), 500);
  checkout.process(Fawry(), 300);
}

abstract class PaymentMethod {
  void pay(double amount);
}

class Wallet implements PaymentMethod {
  @override
  void pay(double amount) {
    print("Paid $amount using Wallet ");
  }
}

class Card implements PaymentMethod {
  @override
  void pay(double amount) {
    print("Paid $amount using Card ");
  }
}

class Fawry implements PaymentMethod {
  @override
  void pay(double amount) {
    print('Paid $amount using Fawry ');
  }
}

class Checkout {
  void process(PaymentMethod method, double amount) {
    method.pay(amount);
  }
}
