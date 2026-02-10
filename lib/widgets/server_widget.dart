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


  Color _getTempColor(double temp){
    if (temp < 70 ) {
      return green;
    } else if (temp < 90) {
      return orange;
    } else {
      return red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 60, left: 22, right: 22),
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
              Text(
                widget.server.name,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              Row(
                children: [
                  Text(
                    widget.online ? "Online" : "Offline" ,
                    style: TextStyle(

                      color: widget.online ? green : red ,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 6),
                   CircleAvatar(
                    radius: 6,
                    backgroundColor: widget.online ? green : red ,
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

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 6,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: CircleDiagram(
                            diagval: widget.server.stat!.cpu.toInt() ,
                            label: "${widget.server.stat!.cpu.toInt()}%",
                            title: "CPU"
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: CircleDiagram(
                            diagval: widget.server.stat!.mem.toInt(),
                            label: "${widget.server.stat!.mem.toInt()}%",
                            alternativeLabel: "${widget.server.stat!.memUsed} GB",
                            title: "RAM"
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: CircleDiagram(
                            diagval: widget.server.stat!.storage.toInt(),
                            label: "${widget.server.stat!.storage.toInt()}%",
                            title: "Disk"
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Temp",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "${widget.server.stat?.temp} C",
                            style: TextStyle(
                              color: _getTempColor(widget.server.stat!.temp),
                              fontSize: 16,
                              height: 0.8,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Uptime",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            widget.server.stat!.uptime,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              height: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

}
