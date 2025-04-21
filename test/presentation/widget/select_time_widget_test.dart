import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_app/presentation/screens/create_habit_screen.dart';
import 'package:habit_app/presentation/widgets/select_time_widget.dart';

void main() {
  group('SelectTimeWidget Tests ⏰', () {
    testWidgets('renders time pickers correctly', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SelectTimeWidget(),
            ),
          ),
        ),
      );

      // 時間と分のピッカーが存在することを確認
      expect(find.byType(CupertinoPicker), findsNWidgets(2));

      // 時間のピッカーを取得
      final hourPicker = find.byType(CupertinoPicker).first;
      final minutePicker = find.byType(CupertinoPicker).last;

      // 時間のピッカーの設定を確認
      final hourPickerWidget = tester.widget<CupertinoPicker>(hourPicker);
      expect(hourPickerWidget.itemExtent, 32.0);

      // 分のピッカーの設定を確認
      final minutePickerWidget = tester.widget<CupertinoPicker>(minutePicker);
      expect(minutePickerWidget.itemExtent, 32.0);
    });

    testWidgets('updates selected time when scrolled', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            selectedHour.overrideWith((ref) => 0),
            selectedMinute.overrideWith((ref) => 0),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SelectTimeWidget(),
            ),
          ),
        ),
      );

      // 時間を変更
      final hourPicker = find.byType(CupertinoPicker).first;
      await tester.drag(hourPicker, const Offset(0, -352));
      await tester.pumpAndSettle();

      // 分を変更
      final minutePicker = find.byType(CupertinoPicker).last;
      await tester.drag(minutePicker, const Offset(0, -960));
      await tester.pumpAndSettle();
    });
  });
}
