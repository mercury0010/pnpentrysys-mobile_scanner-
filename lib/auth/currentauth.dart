import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:scanner/auth/currentvehicle.dart';
import 'package:firebase_core/firebase_core.dart';
import 'qrupdate.dart';

class CurrAuthentication {
  Future updateGuestCountAdd() async {
    /*Map<String, dynamic> data = {
      "current": currents.,
    };
    var ref = await guest.updateData(data);
    print(ref);*/
    final DocumentReference docRef = FirebaseFirestore.instance
        .collection("vehiclepop")
        .doc("FasHtoBch9eiIVi6nYK0");
    docRef.update({
      "current": FieldValue.increment(1),
      "entered": FieldValue.increment(1)
    });

    return print(docRef);
  }

  Future updateGuestCountMinus() async {
    /*Map<String, dynamic> data = {
      "current": currents.,
    };
    var ref = await guest.updateData(data);
    print(ref);*/
    final DocumentReference docRef = FirebaseFirestore.instance
        .collection("vehiclepop")
        .doc("FasHtoBch9eiIVi6nYK0");
    docRef.update({
      "current": FieldValue.increment(-1),
      "exited": FieldValue.increment(1)
    });

    return print(docRef);
  }

  
}
