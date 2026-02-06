import 'dart:async';
import 'dart:convert';
import 'package:dartssh2/dartssh2.dart';
import 'services/secure_storage.dart';

enum AuthType {
  password,
  sshKey,
}

enum ServerStatus {
  disconnected,
  connecting,
  connected,
  error,
}

class Server {
  final String id;
  final String name;
  final String host;
  final int port;
  final String username;

  final AuthType authType;
  String? _passwordKey;
  final String? sshKey;

  ServerStatus status;

  SSHClient? _client;

  Server({
    required this.id,
    required this.name,
    required this.host,
    required this.port,
    required this.username,
    this.authType = AuthType.password,
    String? passwordKey,
    this.sshKey,
    this.status = ServerStatus.disconnected,
  }) : _passwordKey = passwordKey;

  String? get passwordKey => _passwordKey;
  set passwordKey(String? key) => _passwordKey = key;

  Future<void> connect() async {
    try {
      status = ServerStatus.connecting;

      String? password;
      if (authType == AuthType.password && _passwordKey != null) {
        password = await getPasswordFromStorage(_passwordKey!);
      }

      final socket = await SSHSocket.connect(host, port);

      _client = SSHClient(
        socket,
        username: username,
        onPasswordRequest: password != null ? () => password : null,
        identities: authType == AuthType.sshKey && sshKey != null
            ? SSHKeyPair.fromPem(sshKey!)
            : null,
      );


      status = ServerStatus.connected;
    } catch (e) {
      status = ServerStatus.error;
      print("SSH ERROR: $e");
    }
  }

  Future<void> disconnect() async {
    _client!.close();
    status = ServerStatus.disconnected;
  }

  Future<String> exec(String command) async {
    final result = await _client!.run(command);
    return utf8.decode(result);
  }

  Future<SSHSession?> openSession() async {
    if (_client == null) return null;

    final session = await _client!.shell(
      pty: const SSHPtyConfig(
        width: 80,
        height: 25,
      ),
    );

    return session;
  }
}
