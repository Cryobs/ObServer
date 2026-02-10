import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pocket_ssh/models/private_key.dart';
import 'package:pocket_ssh/pages/private_key_page.dart';
import 'package:pocket_ssh/pages/settings.dart';
import 'package:pocket_ssh/pages/template.dart';
import 'package:pocket_ssh/services/private_key_controller.dart';
import 'package:pocket_ssh/services/private_key_repo.dart';
import 'package:pocket_ssh/services/settings_storage.dart';
import 'package:pocket_ssh/ssh_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pocket_ssh/widgets/server_widget.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(PrivateKeyAdapter());

  final privateKeyRepo = PrivateKeyRepo();
  await privateKeyRepo.init();

  final prefs = await SharedPreferences.getInstance();

  Server server = Server(id: "1", name: "Server 2", host: "123", port: 2, username: "test",
  stat: Statistics(cpu: 20, mem: 70, storage: 90, temp: 90, uptime: "1 d", memUsed: 123, memTotal: 200, storageTotal: 200, storageUsed: 123));

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => SettingsController(SettingsRepository(prefs)),
          ),
          ChangeNotifierProvider(
            create: (_) => PrivateKeyController(privateKeyRepo),
          ),
        ],
        child: Template(pages: [
          ServerWidget(server:server ,online: false,),
          Center(child: Text("Page 1", style: TextStyle(color: Colors.white),)),
          Center(child: Text("Page 2", style: TextStyle(color: Colors.white),)),
          SettingsPage(),
      ],),
      ),
  );

}

