import 'package:flutter/material.dart';
import 'package:my_flutter_app/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_flutter_app/util/color_mode.dart';
import 'package:my_flutter_app/util/theme_manager.dart';

final ValueNotifier<ColorMode> _colorMode = ValueNotifier(ColorMode.arcticWhite);

Future<void> initTheme() async {
  final box = await Hive.openBox('settings');
  int index = box.get('themeIndex', defaultValue: 0);
  _colorMode.value = ColorMode.values[index];
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 

  await Hive.initFlutter();

  await Hive.openBox('todo_box');

  await initTheme();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ColorMode>(
      valueListenable: _colorMode,
      builder: (context, mode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: HomePage(colorModeNotifier: _colorMode),
          theme: getTheme(mode),
          darkTheme: getTheme(ColorMode.deepOcean),
        );
      },
    );
  }
}
