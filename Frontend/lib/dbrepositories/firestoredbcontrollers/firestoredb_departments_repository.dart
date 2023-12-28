import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ignite/dbrepositories/firestoredbrepository.dart';

import '../../models/department.dart';

class FirestoreDbDepartmentsRepository
    extends FirestoreDbRepository<Department> {
  @override
  Future<void> delete(String id) async {
    await this.db.collection('departments').doc(id).delete();
  }

  @override
  Future<void> deleteAll() async {
    this.db.collection('departments').get().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }

  @override
  Future<Department> get(String id) async {
    DocumentSnapshot ds = await this.db.collection('departments').doc(id).get();
    /* if (!ds.exists) {
      return null;
    }*/
    Map<String, dynamic> data = ds.data() as Map<String, dynamic>;
    GeoPoint geo = data['geopoint'];
    return new Department(
      id,
      data['cap'],
      data['city'],
      geo.latitude,
      geo.longitude,
      data['mail'],
      data['phone_number'],
      data['street'],
      data['number'],
    );
  }

  @override
  Future<List<Department>> getAll() async {
    QuerySnapshot qsDepartments = await this.db.collection('departments').get();
    List<Department> departments = new List<Department>.empty();
    for (DocumentSnapshot ds in qsDepartments.docs) {
      Department d = await this.get(ds.id);
      departments.add(d);
    }
    return departments;
  }

  @override
  Future<Department> insert(Department object) async {
    /* if (object == null) {
      return null;
    }*/
    DocumentReference ref = await this.db.collection('departments').add({
      'cap': object.getCap(),
      'city': object.getCity(),
      'geopoint': GeoPoint(object.getLat(), object.getLong()),
      'mail': object.getMail(),
      'phone_number': object.getPhoneNumber(),
      'street': object.getStreet(),
      'number': object.getNumber(),
    });
    return this.get(ref.id);
  }

  @override
  Future<Department> update(Department object) async {
    /*if (object == null) {
      return null;
    }*/
    await this.db.collection('departments').doc(object.getId()).update({
      'cap': object.getCap(),
      'city': object.getCity(),
      'geopoint': GeoPoint(object.getLat(), object.getLong()),
      'mail': object.getMail(),
      'phone_number': object.getPhoneNumber(),
      'street': object.getStreet(),
      'number': object.getNumber(),
    });
    return this.get(object.getId());
  }

  @override
  Future<bool> exists(String id) async {
    DocumentSnapshot ds = await this.db.collection('departments').doc(id).get();
    return ds.exists;
  }
}
