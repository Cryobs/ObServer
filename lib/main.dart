import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pocket_ssh/models/private_key.dart';
import 'package:pocket_ssh/models/shortcut_model.dart';
import 'package:pocket_ssh/pages/shortcuts_page.dart';
import 'package:pocket_ssh/pages/settings.dart';
import 'package:pocket_ssh/pages/template.dart';
import 'package:pocket_ssh/services/private_key_repo.dart';
import 'package:pocket_ssh/services/private_key_controller.dart';
import 'package:pocket_ssh/services/settings_storage.dart';
import 'package:pocket_ssh/services/ssh_controller.dart';
import 'package:pocket_ssh/services/shortcuts_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await Hive.initFlutter();

  Hive.registerAdapter(PrivateKeyAdapter());
  Hive.registerAdapter(ShortcutModelAdapter());


  final privateKeyRepo = PrivateKeyRepo();
  await privateKeyRepo.init();

  final shortcutsRepo = ShortcutsRepository();
  await shortcutsRepo.init();

  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        /// SETTINGS
        ChangeNotifierProvider(
          create: (_) =>
              SettingsController(SettingsRepository(prefs)),
        ),

        /// PRIVATE KEYS
        ChangeNotifierProvider(
          create: (_) =>
              PrivateKeyController(privateKeyRepo),
        ),

        /// SSH (COMMAND EXECUTION)
        ChangeNotifierProvider(
          create: (_) => SshController(),
        ),

        /// SHORTCUTS (Hive)
        Provider<ShortcutsRepository>.value(
          value: shortcutsRepo,
        ),
      ],
      child: const AppRoot(),
    ),
  );
}


class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return Template(
      pages: const [
        Center(
          child: Text(
            'Home',
            style: TextStyle(color: Colors.white),
          ),
        ),
        ShortcutsPage(), // 🔥 TU SĄ KAFELKI
        SettingsPage(),
      ],
    );
  }
}
