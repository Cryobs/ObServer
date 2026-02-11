import 'package:flutter/foundation.dart';
import 'package:pocket_ssh/models/server.dart';
import 'package:pocket_ssh/services/server_repo.dart';
import 'package:pocket_ssh/models/server.dart';
import 'package:pocket_ssh/services/private_key_repo.dart';

import '../ssh_core.dart';

class ServerController extends ChangeNotifier {
  final ServerRepo repo;
  final PrivateKeyRepo privateKeyRepo;

  List<ServerModel> get servers => repo.getAll();

  ServerController(this.repo, this.privateKeyRepo);

  Future<void> addServer(ServerModel server) async {
    await repo.save(server);
    notifyListeners();
  }

  Future<void> updateServer(ServerModel server) async {
    await repo.save(server);
    notifyListeners();
  }

  Future<void> deleteServer(String id) async {
    await repo.delete(id);
    notifyListeners();
  }

  ServerModel? getServer(String id) {
    return repo.getById(id);
  }

  Server? toServer(String id) {
    final serverModel = repo.getById(id);
    if (serverModel == null) return null;

    String? sshKey;
    if (serverModel.authType == 1 && serverModel.sshKeyId != null) {
      final privateKey = privateKeyRepo.getById(serverModel.sshKeyId!);
      sshKey = privateKey?.key;
    }

    return Server(
      id: serverModel.id,
      name: serverModel.name,
      host: serverModel.host,
      port: serverModel.port,
      username: serverModel.username,
      authType: serverModel.authType == 0 ? AuthType.password : AuthType.sshKey,
      passwordKey: serverModel.passwordKey,
      sshKey: sshKey,
      stat: Statistics(),
    );
  }

  List<Server> getAllServers() {
    return servers.map((model) {
      String? sshKey;
      if (model.authType == 1 && model.sshKeyId != null) {
        final privateKey = privateKeyRepo.getById(model.sshKeyId!);
        sshKey = privateKey?.key;
      }

      return Server(
        id: model.id,
        name: model.name,
        host: model.host,
        port: model.port,
        username: model.username,
        authType: model.authType == 0 ? AuthType.password : AuthType.sshKey,
        passwordKey: model.passwordKey,
        sshKey: sshKey,
        stat: Statistics(),
      );
    }).toList();
  }
}