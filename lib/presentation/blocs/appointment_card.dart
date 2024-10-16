import 'package:flutter/material.dart';

class AppointmentCard extends StatelessWidget {
  final String name;
  final String type;
  final String doneBy;
  final String startTime;
  final String endTime;
  final String total;
  final bool isCompleted;
  final Color colorBar;
  final String? additionalInfo;

  const AppointmentCard({
    Key? key,
    required this.name,
    required this.type,
    required this.doneBy,
    required this.startTime,
    required this.endTime,
    required this.total,
    required this.isCompleted,
    required this.colorBar,
    this.additionalInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 6,
              decoration: BoxDecoration(
                color: colorBar,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text('$startTime - $endTime'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(type),
                        Text('Total: $total'),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text('With $doneBy', style: TextStyle(color: Colors.grey)),
                    if (additionalInfo != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(additionalInfo!,
                            style: TextStyle(color: Colors.grey)),
                      ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: isCompleted ? Colors.green : Colors.orange,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            isCompleted ? 'COMPLETED' : 'PENDING',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.note, color: Colors.indigo),
                            SizedBox(width: 12),
                            Icon(Icons.play_arrow, color: Colors.indigo),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}