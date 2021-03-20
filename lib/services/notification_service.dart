import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:razjo/core/const.dart';
import 'package:razjo/core/erros/exceptions.dart';
import 'package:razjo/core/erros/failures.dart';
import 'package:razjo/models/invitation.dart';
import 'package:razjo/models/user.dart';
import 'package:razjo/services/user_service.dart';

class InvitationService {
  /// Manages everything connected to sending, deleting, and geting list of invitations
  /// method [sendInvitation] sends new invitation
  /// method [getInvattions] gets all invitations send to user
  /// method [deleteInvitation] deletes invitation by [ObjectId]
  ///

  Db db = Db(MONGO);
  //TODO: handle errors

  Future<void> sendInviataion(String collection, Invitation invitation) async {
    try {
      await db.open();
      DbCollection coll = db.collection(collection);
      coll.insertOne(invitation.toJson());
      await db.close();
    } catch (_) {}
  }

  Future<Either<Failure, List<User>>> getInvitations(String collection) async {
    try {
      await db.open();
      DbCollection coll = db.collection(collection);
      var response = await coll.find().toList();

      List<User> invitations = [];
      UserService _userService = UserService();
      response.forEach((element) async {
        var data = await _userService.getUser(element["from"]);
        if (data.isRight()) {
          final User user = data.getOrElse(() => User());
          invitations.add(user);
        } else {}
      });
      return Right(invitations);
    } on SocketException {
      return Left(ConnectionFailure());
    } on DbException {
      return Left(
        DbFailure(message: "error getting invitations"),
      );
    }
  }

  Future<void> deleteInvitation(ObjectId id, String collection) async {
    //TODO: handle exceptions
    try {
      await db.open();
      DbCollection coll = db.collection(collection);
      coll.remove(where.id(id));
    } on SocketException {} on DbException {}
  }
}
