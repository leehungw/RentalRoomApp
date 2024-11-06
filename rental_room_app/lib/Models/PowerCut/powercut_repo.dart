import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rental_room_app/Models/PowerCut/powercut_model.dart';

abstract class PowerCutRepository {
  Future<List<PowerCut>> getAllPowerCuts();
}

class PowerCutRepositoryIml implements PowerCutRepository {
  static final PowerCutRepositoryIml _instance =
      PowerCutRepositoryIml._internal();

  PowerCutRepositoryIml._internal();

  factory PowerCutRepositoryIml() {
    return _instance;
  }

  @override
  Future<List<PowerCut>> getAllPowerCuts() async {
    List<PowerCut> powerCuts = [];
    await FirebaseFirestore.instance.collection(PowerCut.documentId).get().then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          powerCuts.add(PowerCut.fromFirestore(docSnapshot));
        }
      },
      onError: (e) => print("Error get all power cuts: $e"),
    );

    return powerCuts;
  }
}
