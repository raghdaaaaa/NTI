void main() {
  print("""
extends: take the parent’s code and use it directly و can extend only one class.
  (يهني بيرث من الأب الكود الجاهز، وتستخدمه على طول من غير ما تكتبه تاني)
implements: take only the rules (method names) and write own imp , can implement many classes.
(تاخد القواعد بس (أسماء الميثودز)، ونكتب الكود بنفسنا كله من الأول)

When to use:
extends → classes share code.
implements → different classes, same rules.

class Developer extends Employee {}          
class Wallet implements PaymentMethod {}  

 """);
}
