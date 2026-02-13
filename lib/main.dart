import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// PAGES
import 'package:pocket_ssh/pages/template.dart';
import 'package:pocket_ssh/pages/shortcuts_page.dart';
import 'package:pocket_ssh/pages/settings.dart';

// MODELS
import 'package:pocket_ssh/models/shortcut_model.dart';
import 'package:pocket_ssh/models/private_key.dart';

// SERVICES / REPOS
import 'package:pocket_ssh/services/shortcuts_repository.dart';
import 'package:pocket_ssh/services/private_key_repo.dart';
import 'package:pocket_ssh/services/private_key_controller.dart';
import 'package:pocket_ssh/services/settings_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // =========================
  // HIVE INIT
  // =========================
  await Hive.initFlutter();

  // ADAPTERY
  Hive.registerAdapter(ShortcutModelAdapter());
  Hive.registerAdapter(PrivateKeyAdapter());

  // =========================
  // REPOZYTORIA
  // =========================
  final shortcutsRepo = ShortcutsRepository();
  await shortcutsRepo.init();

  final privateKeyRepo = PrivateKeyRepo();
  await privateKeyRepo.init();

  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        /// SETTINGS
        ChangeNotifierProvider(
          create: (_) => SettingsController(
            SettingsRepository(prefs),
          ),
        ),

        /// PRIVATE KEYS
        ChangeNotifierProvider(
          create: (_) => PrivateKeyController(privateKeyRepo),
        ),

        /// SHORTCUTS (Hive)
        Provider<ShortcutsRepository>.value(
          value: shortcutsRepo,
        ),
      ],
      child: Template(
        pages: const [
          /// PAGE 0 – placeholder
          Center(
            child: Text(
              'Page 0',
              style: TextStyle(color: Colors.white),
            ),
          ),

          /// PAGE 1 – placeholder
          Center(
            child: Text(
              'Page 1',
              style: TextStyle(color: Colors.white),
            ),
          ),

          /// PAGE 2 – SHORTCUTS
          ShortcutsPage(),

          /// PAGE 3 – SETTINGS
          SettingsPage(),
        ],
      ),
    ),
  );
}
