import 'package:flutter_test/flutter_test.dart';
import 'package:whatsapp/main.dart';

void main() {
  testWidgets('ChatsScreen displays Chats title and contacts', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Chats'), findsOneWidget);

    expect(find.text('Roqia'), findsOneWidget);
    expect(find.text('Ahmed'), findsOneWidget);
  });
}
