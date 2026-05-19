import 'package:flutter_test/flutter_test.dart';
import 'package:fintrak_pocket/main.dart';
import 'package:provider/provider.dart';
import 'package:fintrak_pocket/services/transaction_service.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => TransactionService()),
        ],
        child: const FinanceApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('FinTrak Pocket'), findsOneWidget);
  });
}
