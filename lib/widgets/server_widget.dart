import 'package:flutter/material.dart';
import 'package:pocket_ssh/ssh_core.dart';
import 'package:pocket_ssh/widgets/circle_diagram.dart';

class ServerWidget extends StatefulWidget {
  final bool online;
  final Server server;

  const ServerWidget({
    super.key,
    required this.online,
    required this.server,
  });

  @override
  State<ServerWidget> createState() => _ServerWidgetState();
}

class _ServerWidgetState extends State<ServerWidget> {
  static const Color green = Color(0xFF22C55E);
  static const Color orange = Color(0xFFE5A50A);
  static const Color red = Color(0xFFE9220C);

  Color _getTempColor(double temp) {
    if (temp < 70) {
      return green;
    } else if (temp < 90) {
      return orange;
    } else {
      return red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery
            .of(context)
            .size
            .width;
        final diagramHeight = (screenWidth * 0.25).clamp(105.0, 130.0);

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      widget.server.name,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.online ? "Online" : "Offline",
                        style: TextStyle(
                          color: widget.online ? green : red,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 6),
                      CircleAvatar(
                        radius: 5,
                        backgroundColor: widget.online ? green : red,
                      )
                    ],
                  )
                ],
              ),

              const Divider(
                color: Colors.white38,
                thickness: 1,
                height: 20,
              ),

              // Main content - ВСЕГДА горизонтальная компоновка
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 6,
                    child: _buildDiagramsSection(diagramHeight),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: _buildInfoSection(diagramHeight),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDiagramsSection(double height) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            flex: 1,
            child: CircleDiagram(
              diagval: widget.server.stat!.cpu.toInt(),
              label: "${widget.server.stat!.cpu.toInt()}%",
              title: "CPU",
            ),
          ),
          Flexible(
            flex: 1,
            child: CircleDiagram(
              diagval: widget.server.stat!.mem.toInt(),
              label: "${widget.server.stat!.mem.toInt()}%",
              alternativeLabel: "${widget.server.stat!.memUsed.toInt()} GB",
              title: "RAM",
            ),
          ),
          Flexible(
            flex: 1,
            child: CircleDiagram(
              diagval: widget.server.stat!.storage.toInt(),
              label: "${widget.server.stat!.storage.toInt()}%",
              alternativeLabel: "${widget.server.stat!.storageUsed.toInt()} GB",
              title: "Disk",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(double height) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: _buildInfoItem(
              "Temp",
              "${widget.server.stat?.temp ?? 0}°C",
              _getTempColor(widget.server.stat?.temp ?? 0),
            ),
          ),
          Flexible(
            child: _buildInfoItem(
              "Uptime",
              widget.server.stat?.uptime ?? "N/A",
              Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, Color valueColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}