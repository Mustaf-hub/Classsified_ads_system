import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:sellify/helper/c_widget.dart';

import '../api_config/store_data.dart';
import 'message.dart';

class ChatServices extends ChangeNotifier {
  final FirebaseFirestore _firebaseStorage = FirebaseFirestore.instance;

  String chatChipMsg = "";
  Future<void> deleteChat({required String userId, required String otherUserId}) async {
    
    try{
      List ids = [userId, otherUserId];
      ids.sort();
      String chatRoomId = ids.join("_");

      CollectionReference messagesRef = _firebaseStorage
          .collection("chat_sellify")
          .doc(chatRoomId)
          .collection("chat_message_sellify");

      QuerySnapshot snapshot = await messagesRef.get();

      for (DocumentSnapshot doc in snapshot.docs) {
        await doc.reference.delete(); // Delete each message
      }

    } catch(e) {
      print("Error deleting message: $e");
    }

  }

  Future<void> sendMessage(
  {required String receiverId, required String message, required String adTitle}) async {
    final String currentUserId = getData.read("UserLogin")["id"];
    final String currentUserName = getData.read("UserLogin")["name"];

    Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      message: message,
      reciverId: receiverId,
      senderId: currentUserId,
      senderName: currentUserName,
      adTitle: adTitle,
      timestamp: timestamp
    );

    List<String> ids = [currentUserId, receiverId];
    ids.sort();

    String chatRoomId = ids.join("_");

    await _firebaseStorage
        .collection("chat_sellify")
        .doc(chatRoomId)
        .collection("chat_message_sellify")
        .add(newMessage.toMap());
    await _firebaseStorage.collection("chat_sellify").doc(chatRoomId).set({"timeStamp": timestamp});

  }

  Stream<QuerySnapshot> getMessage(
  {required String userId, required String otherUserId}) {
    List ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firebaseStorage.collection("chat_sellify").doc(chatRoomId).collection("chat_message_sellify").orderBy("timestamp", descending: false).snapshots();
  }
}