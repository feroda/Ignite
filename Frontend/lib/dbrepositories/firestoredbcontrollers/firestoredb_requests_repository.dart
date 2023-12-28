import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ignite/dbrepositories/firestoredbrepository.dart';

import '../../models/request.dart';

class FirestoreDbRequestRepository extends FirestoreDbRepository<Request> {
  @override
  Future<void> delete(String id) async {
    await this.db.collection('requests').doc(id).delete();
  }

  @override
  Future<void> deleteAll() async {
    this.db.collection('requests').get().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }

  @override
  Future<Request> get(String id) async {
    DocumentSnapshot ds = await this.db.collection('requests').doc(id).get();
    /* if (ds == null) {
      return null;
    }*/
    Map<String, dynamic> data = ds.data() as Map<String, dynamic>;
    return new Request.complete(
      id,
      data['approved'],
      data["open"],
      (data['approved_by'] == null) ? null : data['approved_by'].id,
      (data['hydrant'] == null) ? null : data['hydrant'].id,
      (data['requested_by'] == null) ? null : data['requested_by'].id,
    );
  }

  @override
  Future<List<Request>> getAll() async {
    QuerySnapshot qsRequests = await this.db.collection('requests').get();
    List<Request> requests = new List<Request>.empty();
    for (DocumentSnapshot ds in qsRequests.docs) {
      Request r = await this.get(ds.id);
      requests.add(r);
    }
    return requests;
  }

  @override
  Future<Request> insert(Request object) async {
    /* if (object == null) {
      return null;
    }*/
    DocumentReference<Map<String, dynamic>>? userApBy =
        (object.getApprovedByUserId() == null)
            ? null
            : this.db.collection('users').doc(object.getApprovedByUserId());
    DocumentReference<Map<String, dynamic>>? userReqBy =
        (object.getRequestedByUserId() == null)
            ? null
            : this.db.collection('users').doc(object.getRequestedByUserId());
    DocumentReference<Map<String, dynamic>>? hydrant =
        (object.getHydrantId() == null)
            ? null
            : this.db.collection('hydrants').doc(object.getHydrantId());

    DocumentReference ref = await this.db.collection('requests').add({
      'approved': object.getApproved(),
      'approved_by': userApBy,
      'hydrant': hydrant,
      'open': object.isOpen(),
      'requested_by': userReqBy,
    });
    return this.get(ref.id);
  }

  @override
  Future<Request> update(Request object) async {
    /*if (object == null) {
      return null;
    }*/
    DocumentReference<Map<String, dynamic>>? userApBy =
        (object.getApprovedByUserId() == null)
            ? null
            : this.db.collection('users').doc(object.getApprovedByUserId());
    DocumentReference<Map<String, dynamic>>? userReqBy =
        (object.getRequestedByUserId() == null)
            ? null
            : this.db.collection('users').doc(object.getRequestedByUserId());
    DocumentReference<Map<String, dynamic>>? hydrant =
        (object.getHydrantId() == null)
            ? null
            : this.db.collection('hydrants').doc(object.getHydrantId());
    this.db.collection('requests').doc(object.getId()).update({
      'approved': object.getApproved(),
      'approved_by': userApBy,
      'hydrant': hydrant,
      'open': object.isOpen(),
      'requested_by': userReqBy,
    });
    return this.get(object.getId()!);
  }

  @override
  Future<bool> exists(String id) async {
    DocumentSnapshot ds = await this.db.collection('requests').doc(id).get();
    return ds.exists;
  }
}
