import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:scanner/auth/currentvehicle.dart';
import 'package:firebase_core/firebase_core.dart';
import 'qrupdate.dart';
import 'readCur.dart';

class Authentication {
  final DocumentReference guest = FirebaseFirestore.instance
      .collection("guestqr")
      .doc(DateTime.now().toString());
  CollectionReference cur = FirebaseFirestore.instance.collection("vehiclepop");
  Future<void> createGuest(Entry guest1) async {
    Map<String, dynamic> data = {
      "qrcode": guest1.qr,
      "state": guest1.state,
      "datetime": guest1.datetime,
    };
    var ref = await guest.set(data);

    return ref;
  }

  Stream<List<Cur>> getData() {
    return cur.snapshots().map((QuerySnapshot snapshot) {
      return snapshot.docs.map((doc) {
        return Cur(
          curre: doc.get('current'),
        );
      }).toList();
    });
  }
}
