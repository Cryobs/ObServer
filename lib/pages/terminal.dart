import 'dart:typed_data';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocket_ssh/services/server_controller.dart';
import 'package:pocket_ssh/ssh_core.dart';
import 'package:pocket_ssh/theme/app_theme.dart';
import 'package:pocket_ssh/widgets/extra_keyboard.dart';
import 'package:pocket_ssh/widgets/online_indicator.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:convert';
import 'package:xterm/xterm.dart';

class TerminalScreen extends StatefulWidget {
  const TerminalScreen({super.key});

  @override
  State<TerminalScreen> createState() => _TerminalScreenState();
}

class _TerminalScreenState extends State<TerminalScreen> {
  late final Terminal terminal = Terminal();
  SSHSession? session;
  bool _isConnected = false;
  Server? selectedServer;

  StreamSubscription? _stdoutSubscription;
  StreamSubscription? _stderrSubscription;

  bool _ctrlActive = false;
  bool _altActive = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkOnlineServers();
    });
    terminal.onOutput = _handleTerminalOutput;
    terminal.onResize = _handleTerminalResize;
  }

  @override
  void dispose() {
    _cleanupSession();
    super.dispose();
  }

  void _cleanupSession() {
    _stdoutSubscription?.cancel();
    _stderrSubscription?.cancel();
    _stdoutSubscription = null;
    _stderrSubscription = null;
    session?.close();
    session = null;
    _isConnected = false;
  }

  void _handleTerminalOutput(String data) {
    if (session == null || !_isConnected) return;

    if (_ctrlActive && data.length == 1) {
      final code = data.toUpperCase().codeUnitAt(0);
      if (code >= 64 && code <= 95) {
        session!.write(Uint8List.fromList([code - 64]));
        _setCtrl(false);
        return;
      }
    }

    if (_altActive && data.length == 1) {
      session!.write(Uint8List.fromList([0x1B, ...utf8.encode(data)]));
      _setAlt(false);
      return;
    }

    session!.write(utf8.encode(data));
  }

  void _handleTerminalResize(int width, int height, int pixelWidth, int pixelHeight) {
    session?.resizeTerminal(width, height, pixelWidth, pixelHeight);
  }

  void _setCtrl(bool value) {
    if (_ctrlActive == value) return;
    setState(() => _ctrlActive = value);
  }

  void _setAlt(bool value) {
    if (_altActive == value) return;
    setState(() => _altActive = value);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Consumer<ServerController>(
              builder: (context, controller, child) {
                final servers = controller.getAllServers();
                return DropdownButton<Server>(
                  value: selectedServer,
                  hint: const Text("Select a server"),
                  borderRadius: BorderRadius.circular(15),
                  padding: const EdgeInsets.all(12),
                  items: servers.map((option) {
                    return DropdownMenuItem(
                      value: option,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(option.name,
                              style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(width: 12),
                          Text(option.host,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                  color: AppColors.textSecondaryDark)),
                          const SizedBox(width: 12),
                          OnlineIndicator(online: option.online),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (v) {
                    if (v == selectedServer) return;
                    _cleanupSession();
                    setState(() => selectedServer = v);
                    if (v != null) _initTerminal();
                  },
                );
              },
            ),
            Expanded(
              child: TerminalView(
                padding: const EdgeInsets.all(5),
                terminal,
                theme: TerminalThemes.whiteOnBlack,
              ),
            ),
            ExtraKeyboard(
              sendRaw: _sendRaw,
              sendRawBytes: _sendRawBytes,
              ctrlActive: _ctrlActive,
              altActive: _altActive,
              onToggleCtrl: () => setState(() {
                _ctrlActive = !_ctrlActive;
                if (_ctrlActive) _altActive = false;
              }),
              onToggleAlt: () => setState(() {
                _altActive = !_altActive;
                if (_altActive) _ctrlActive = false;
              }),
            ),
          ],
        ),
      ),
    );
  }



  void _sendRawBytes(List<int> bytes) {
    if (session == null || !_isConnected) return;
    session!.write(Uint8List.fromList(bytes));
  }

  void _sendRaw(String value) {
    if (session == null || !_isConnected) return;

    if (_ctrlActive && value.length == 1) {
      final code = value.toUpperCase().codeUnitAt(0);
      session!.write(Uint8List.fromList([code - 64]));
      _setCtrl(false);
    } else if (_altActive) {
      session!.write(Uint8List.fromList([0x1B, ...utf8.encode(value)]));
      _setAlt(false);
    } else {
      session!.write(Uint8List.fromList(utf8.encode(value)));
    }
  }

  Future<void> _initTerminal() async {
    terminal.buffer.clear();
    terminal.buffer.setCursor(0, 0);
    terminal.write('Connecting to ${selectedServer?.host}...\r\n');

    await _connectToServer();

    /* foreground stat update */
    selectedServer?.updateStatsOptimized().catchError((_) {});
  }

  void _checkOnlineServers() {
    context.read<ServerController>().checkOnlineServers();
  }

  Future<void> _connectToServer() async {
    try {
      await selectedServer?.connect();

      if (selectedServer?.status != ServerStatus.connected) {
        terminal.write('\r\nFailed to connect\r\n');
        return;
      }

      session = await selectedServer?.openSession();
      if (session == null) {
        terminal.write('\r\nFailed to open session\r\n');
        return;
      }

      _isConnected = true;
      terminal.buffer.clear();
      terminal.buffer.setCursor(0, 0);

      _stdoutSubscription = const Utf8Decoder(allowMalformed: true)
          .bind(session!.stdout)
          .listen(
                (data) {
              if (mounted) terminal.write(data);
            },
            onError: (e) {
              if (mounted) terminal.write('\r\nSTDOUT Error: $e\r\n');
            },
            onDone: () {
              if (mounted) {
                terminal.write('\r\nConnection closed\r\n');
                setState(() => _isConnected = false);
              }
            },
          );

      _stderrSubscription = const Utf8Decoder(allowMalformed: true)
          .bind(session!.stderr)
          .listen(
                (data) {
              if (mounted) terminal.write(data);
            },
            onError: (e) {
              if (mounted) terminal.write('\r\nSTDERR Error: $e\r\n');
            },
          );

      if (mounted) terminal.write('Connected!\r\n');
    } catch (e) {
      terminal.write('\r\nConnection error: $e\r\n');
      if (mounted) setState(() => _isConnected = false);
    }
  }
}



