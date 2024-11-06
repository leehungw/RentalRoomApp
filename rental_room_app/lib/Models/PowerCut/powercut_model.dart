import 'package:cloud_firestore/cloud_firestore.dart';

class PowerCut {
  static const String documentId = 'PowerCut';

  String provinceName;
  List<PowerCutSchedule> powerCuts;

  PowerCut({required this.provinceName, required this.powerCuts});

  factory PowerCut.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    List<PowerCutSchedule> powerCuts = [];
    for (Map<String, dynamic> item in data['powerCuts']) {
      powerCuts.add(PowerCutSchedule.fromFirestore(item));
    }

    return PowerCut(provinceName: data['provinceName'], powerCuts: powerCuts);
  }
}

class PowerCutSchedule {
  String date;
  List<PowerCutDetail> details;

  PowerCutSchedule({required this.date, required this.details});

  factory PowerCutSchedule.fromFirestore(Map<String, dynamic> doc) {
    Map<String, dynamic> data = doc;

    List<PowerCutDetail> details = [];
    for (Map<String, dynamic> item in data['details']) {
      details.add(PowerCutDetail.fromFirestore(item));
    }

    return PowerCutSchedule(date: data['date'], details: details);
  }
}

class PowerCutDetail {
  String startTime;
  String endTime;
  String location;
  String powerCompany;
  String reason;
  String status;

  PowerCutDetail(
      {required this.startTime,
      required this.endTime,
      required this.location,
      required this.powerCompany,
      required this.reason,
      required this.status});

  factory PowerCutDetail.fromFirestore(Map<String, dynamic> doc) {
    Map<String, dynamic> data = doc;

    return PowerCutDetail(
        startTime: data['startTime'],
        endTime: data['endTime'],
        location: data['location'],
        powerCompany: data['powerCompany'],
        reason: data['reason'],
        status: data['status']);
  }
}
