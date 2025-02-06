import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/main.dart';
import 'package:habit_app/providers/habit_providers.dart';
import 'package:habit_app/providers/notification_setting_providers.dart';
import 'package:habit_app/utils/rounded_button.dart';
import 'package:logger/logger.dart';

import '../utils/app_color.dart';

class CreateHabitScreen extends ConsumerStatefulWidget {
  const CreateHabitScreen({super.key});
  @override
  CreateHabitScreenState createState() => CreateHabitScreenState();
}

class CreateHabitScreenState extends ConsumerState<CreateHabitScreen> {
  @override
  Widget build(BuildContext context) {
    final goalController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final selectedHour = StateProvider<int>((ref) => TimeOfDay.now().hour);
    final selectedMinute = StateProvider<int>((ref) => TimeOfDay.now().minute);
    final isNotificationEnabled = StateProvider<bool>((ref) => false);
    final logger = Logger();

    Future<void> selectTime(BuildContext context, WidgetRef ref) async {
      await showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext builder) {
          return SizedBox(
            height: 250,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 32,
                    onSelectedItemChanged: (int hour) {
                      ref.read(selectedHour.notifier).state = hour;
                    },
                    children: List<Widget>.generate(24, (int hour) {
                      return Center(
                        child: Text(
                          hour.toString().padLeft(2, '0'),
                        ),
                      );
                    }),
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 32,
                    onSelectedItemChanged: (int minute) {
                      ref.read(selectedMinute.notifier).state = minute;
                    },
                    children: List<Widget>.generate(60, (int minute) {
                      return Center(
                        child: Text(
                          minute.toString().padLeft(2, '0'),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('目標を設定')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Center(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        maxLength: 20,
                        style: const TextStyle(color: AppColor.text),
                        controller: goalController,
                        decoration: InputDecoration(
                          hintText: '例)本を1ページ読む',
                          hintStyle: const TextStyle(color: AppColor.lightGray),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: Colors.grey.shade600),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '目標を入力してください';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '通知を設定しますか？',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Consumer(
                                builder: (context, ref, _) {
                                  final isEnabled =
                                      ref.watch(isNotificationEnabled);
                                  return CupertinoSlidingSegmentedControl<bool>(
                                    groupValue: isEnabled,
                                    children: {
                                      true: Container(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          'はい',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ),
                                      false: Container(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          'いいえ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ),
                                    },
                                    onValueChanged: (bool? value) {
                                      if (value != null) {
                                        ref
                                            .read(
                                              isNotificationEnabled.notifier,
                                            )
                                            .state = value;
                                      }
                                    },
                                  );
                                },
                              ),
                              const SizedBox(width: 30),
                              Consumer(
                                builder: (context, ref, _) {
                                  final isEnabled =
                                      ref.watch(isNotificationEnabled);
                                  final hour = ref.watch(selectedHour);
                                  final minute = ref.watch(selectedMinute);

                                  return GestureDetector(
                                    onTap: isEnabled
                                        ? () => selectTime(context, ref)
                                        : null, // 「はい」の場合のみタップ可能
                                    child: Container(
                                      width: 100,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: isEnabled
                                              ? Colors.grey.shade600
                                              : AppColor.text.withAlpha(
                                                  (AppColor.text.a * 0.3)
                                                      .toInt(),
                                                ),
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          isEnabled
                                              // 長い行であるが、可読性を保つためにこの形式を使用
                                              // ignore: lines_longer_than_80_chars
                                              ? '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}'
                                              : 'ー:ー', // 「いいえ」を選択した場合の表示
                                          style: TextStyle(
                                            fontSize: 24,
                                            color: isEnabled
                                                ? AppColor.text
                                                : AppColor.text.withAlpha(
                                                    (AppColor.text.a * 0.3)
                                                        .toInt(),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 32, bottom: 16),
                child: RoundedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final isEnabled = ref.read(isNotificationEnabled);
                      final hour = ref.read(selectedHour);
                      final minute = ref.read(selectedMinute);

                      if (isEnabled && (hour == null || minute == null)) {
                        await showDialog<void>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('時間を設定してください'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('はい'),
                              ),
                            ],
                          ),
                        );
                        return;
                      }

                      try {
                        await ref.read(
                          createHabitProvider(form: goalController.text).future,
                        );
                        await ref
                            .read(notificationSettingNotifierProvider.notifier)
                            .scheduleDailyNotification(
                              hour,
                              minute,
                              goalController.text,
                            );

                        // 成功時の処理
                        await Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute<MainScreen>(
                            builder: (BuildContext context) =>
                                const MainScreen(),
                          ),
                          (_) => false,
                        );
                      } on Exception catch (error) {
                        logger.e(error);
                        // エラー時の処理
                        await showDialog<void>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('目標の設定に失敗しました'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('はい'),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  },
                  title: '決定する',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
