import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_task_manager/models/user.dart';

class AuthorisationRepository {
  static final AuthorisationRepository _authorisationRepository =
      AuthorisationRepository._internal();

  AuthorisationRepository._internal();

  factory AuthorisationRepository() {
    return _authorisationRepository;
  }

  CollectionReference collection =
      FirebaseFirestore.instance.collection("users");

  Future<QuerySnapshot> getStream() {
    return collection.get();
  }

  Future<DocumentReference> addUser(User user) {
    return collection.add(user.toJson());
  }

  Future<DocumentReference> deleteUser(User user) {
    return collection.where("id", isEqualTo: user.id).get().then((value) {
      if (value.docs.length == 0) {
        throw Exception("Ошибка: Пользователь не найден.");
      } else {
        value.docs.forEach((element) {
          collection.doc(element.id).delete();
        });
      }
    });
  }

  Future<DocumentReference> editUser(User user) {
    return collection.where("id", isEqualTo: user.id).get().then((value) {
      if (value.docs.length == 0) {
        throw Exception("Ошибка: Пользователь не найден.");
      } else {
        value.docs.forEach((element) {
          collection.doc(element.id).update(user.toJson());
        });
      }
    });
  }

  Future<bool> checkUser(User user) async {
    List<User> users = [];
    Future<QuerySnapshot> collection = AuthorisationRepository().getStream();
    bool res;
    await collection.asStream().first.then((value) {
      value.docs.forEach((element) {
        users.add(User.fromJson(element.data()));
      });
      print(users);
      for (int i = 0; i < users.length; i++) {
        if (users[i].login == user.login) {
          print("login: true");
          if (users[i].password == user.password) {
            print("pass: true");
            res = true;
            return res;
          } else {
            print("pass: false");
            res = false;
          }
        } else {
          print("login: false");
          res = false;
        }
      }
    });
    return res;
  }

  Future<List<int>> getIdList() async {
    List<User> users = [];
    List<int> ids = [];
    QuerySnapshot collection = await AuthorisationRepository().getStream();
    if(collection.docs.isNotEmpty) {
      collection.docs.forEach((element) {
        users.add(User.fromJson(element.data()));
      });
      users.forEach((element) {
        ids.add(element.id);
      });
      print(ids);
      return ids;
    }else{
      ids.add(0);
      return ids;
    }
  }

  Future<bool> checkLogin(User user) async {
    List<User> users = [];
  QuerySnapshot collection = await AuthorisationRepository().getStream();

    if (collection.docs.isNotEmpty) {
      collection.docs.forEach((element) {
          users.add(User.fromJson(element.data()));
        });
        print(users);
        for (int i = 0; i < users.length; i++) {
          if (users[i].login == user.login) {
            print("login: true");
            return true;
          } else {
            print("login: false");
            return false;
          }
        }
    }else{
      return false;
    }
  }
}