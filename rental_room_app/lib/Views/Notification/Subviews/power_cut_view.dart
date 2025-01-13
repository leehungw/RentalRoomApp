import 'package:flutter/material.dart';
import 'package:rental_room_app/Models/PowerCut/powercut_model.dart';
import 'package:rental_room_app/Models/PowerCut/powercut_repo.dart';
import 'package:rental_room_app/Views/Notification/Subviews/power_cut_info_text.dart';

class PowerCutScheduleView extends StatefulWidget {
  const PowerCutScheduleView({super.key});

  @override
  State<PowerCutScheduleView> createState() => _PowerCutScheduleViewState();
}

class _PowerCutScheduleViewState extends State<PowerCutScheduleView> {
  final PowerCutRepository _powerCutRepository = PowerCutRepositoryIml();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<PowerCut>>(
        future: _powerCutRepository.getAllPowerCuts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data found'));
          }

          final cities = snapshot.data!;
          return ListView.builder(
            itemCount: cities.length,
            itemBuilder: (context, index) {
              return PowerCutItem(city: cities[index]);
            },
          );
        },
      ),
    );
  }
}

class PowerCutItem extends StatefulWidget {
  final PowerCut city;

  const PowerCutItem({super.key, required this.city});

  @override
  _PowerCutItemState createState() => _PowerCutItemState();
}

class _PowerCutItemState extends State<PowerCutItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xFF50C878), width: 1),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(widget.city.provinceName,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.city.powerCuts.length,
                itemBuilder: (context, subIndex) {
                  return PowerCutScheduleItem(
                      powerCut: widget.city.powerCuts[subIndex]);
                },
              ),
            ),
        ],
      ),
    );
  }
}

class PowerCutScheduleItem extends StatefulWidget {
  final PowerCutSchedule powerCut;

  const PowerCutScheduleItem({super.key, required this.powerCut});

  @override
  _PowerCutScheduleItemState createState() => _PowerCutScheduleItemState();
}

class _PowerCutScheduleItemState extends State<PowerCutScheduleItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 2,
      child: Column(
        children: [
          ListTile(
            title: Text(widget.powerCut.date,
                style: TextStyle(fontSize: 16, color: Color(0xFF50C878))),
            trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.powerCut.details.length,
                itemBuilder: (context, labelIndex) {
                  Color getStatusColor(String status) {
                    switch (status) {
                      case "Kế hoạch":
                        return Colors.orange;
                      case "Đã duyệt":
                        return Colors.green;
                      default:
                        return Colors.black;
                    }
                  }

                  PowerCutDetail detail = widget.powerCut.details[labelIndex];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blueAccent, width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PowerCutInfoText(
                            label: "Location: ",
                            value: detail.location,
                          ),
                          const SizedBox(height: 4),
                          PowerCutInfoText(
                            label: "Start Time: ",
                            value: detail.startTime,
                            valueStyle: const TextStyle(color: Colors.red),
                          ),
                          PowerCutInfoText(
                            label: "End Time: ",
                            value: detail.endTime,
                            valueStyle: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 4),
                          PowerCutInfoText(
                            label: "Power Company: ",
                            value: detail.powerCompany,
                          ),
                          PowerCutInfoText(
                            label: "Reason: ",
                            value: detail.reason,
                          ),
                          PowerCutInfoText(
                            label: "Status: ",
                            value: detail.status,
                            valueStyle: TextStyle(
                              color: getStatusColor(detail.status),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
