import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:razjo/core/const.dart';
import 'package:razjo/core/erros/exceptions.dart';
import 'package:razjo/core/erros/failures.dart';
import 'package:razjo/models/contact.dart';
import 'package:razjo/models/user.dart';
import 'package:razjo/services/user_service.dart';
import 'package:uuid/uuid.dart';

class ContactService {
  ///Manages to add, delete and read data from "contacts"

  Db db = Db(MONGO);
  Future<Either<Failure, bool>> addContact(
      ObjectId psychologist, ObjectId patient) async {
    try {
      final String contactCollection = "contact-${Uuid().v4()}";
      Contact contact = Contact(
        patientId: patient,
        psyId: psychologist,
        notes: [],
        psyPrivate: [],
        appointments: [],
      );
      await db.open();
      DbCollection coll = db.collection(contactCollection);
      var response = await coll.insertOne(contact.toJson());
      if (response["\$err"] == null) {
        UserService service = UserService();
        final psy = await service.editArray(
            psychologist, "contatcts", contactCollection);
        final usr =
            await service.editArray(patient, "contatcts", contactCollection);
        if (psy.isRight() && usr.isRight()) {
          return Right(true);
        } else
          throw DbException();
      } else
        throw DbException();
    } on DbException {
      return Left(DbFailure(message: "cannot add to contacts"));
    } on SocketException {
      return Left(ConnectionFailure());
    }
  }
}
