// import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:sellify/firebase/chat_service.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/helper/font_family.dart';
import 'package:sellify/utils/Colors.dart';
import 'package:sellify/utils/dark_lightMode.dart';

import '../api_config/config.dart';
import '../api_config/store_data.dart';
import '../helper/appbar_screen.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {

  List searchList = [];
  List searchIndexList = [];

  int selected = 0;
  
  String uidResiver = "";
  String usernameResiver = "";
  String mobileNumber = "";
  String proPic = "";
  
  TextEditingController searchText = TextEditingController();
  late ColorNotifire notifier;

  List chatData = [];

  StreamController<Map<dynamic, dynamic>> chatStream = StreamController<Map<dynamic, dynamic>>.broadcast();

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          backgroundColor: notifier.getBgColor,
          appBar: kIsWeb ? PreferredSize(
              preferredSize: const Size.fromHeight(125),
              child: CommonAppbar(title: "Message".tr, fun: () {
                Get.back();
              },)) : AppBar(
            backgroundColor: notifier.getWhiteblackColor,
            elevation: 0,
            centerTitle: true,
            automaticallyImplyLeading: kIsWeb ? true : false,
            iconTheme: IconThemeData(color: notifier.iconColor),
            leading: kIsWeb ? Padding(
              padding: const EdgeInsets.only(left: 10),
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Image.asset("assets/arrowLeftIcon.png", scale: 3, color: notifier.iconColor,),
              ),
            ) : const SizedBox(),
            title: Text("Message".tr, style: TextStyle(fontFamily: FontFamily.gilroyBold, color: notifier.getTextColor, fontSize: 18,),),
          ),
          body: ScrollConfiguration(
            behavior: CustomBehavior(),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: Get.height/1.3,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 750 < constraints.maxWidth ? 0 : 20, horizontal: 1550 < constraints.maxWidth ? 200 : 1200 < constraints.maxWidth ? 100 : 20),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  TextField(
                                    controller: searchText,
                                    style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 18),
                                    decoration: InputDecoration(
                                        suffixIcon: Padding(
                                          padding: const EdgeInsets.only(left: 8),
                                          child: Image.asset("assets/searchIcon.png", scale: 2.8,),
                                        ),
                                        hintStyle: TextStyle(fontFamily: FontFamily.gilroyMedium, color: GreyColor, fontSize: 16),
                                        hintText: "Search message".tr,
                                        filled: true,
                                        fillColor: notifier.getWhiteblackColor,
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                          borderSide: BorderSide(color: PurpleColor),
                                        ),
                                        enabledBorder:  OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                          borderSide: const BorderSide(color: Colors.transparent, width: 2),
                                        ),
                                    ),
                                    onChanged: (s) {
                                      searchIndexList = [];

                                      for(int i = 0;i < searchiteams.length; i++){
                                        if(searchiteams[i]["name"]
                                            .toLowerCase()
                                            .contains(s.toLowerCase())){
                                          final ids =
                                          searchiteams.map<String>((e) => e['uid']!).toSet();
                                          searchiteams.retainWhere((Map x) {
                                            return ids.remove(x['uid']);
                                          });

                                          searchIndexList.add(i);
                                          setState(() {});
                                        } else {
                                          setState(() {});
                                        }
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 10,),
                                  Expanded(child: searchText.text.isEmpty ? _buildUserList(constraints) : searchIndexList.isEmpty
                                      ? Center(child: Image.asset("assets/emptychat.png", height: 200)) : ListView.separated(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    itemCount: searchIndexList.length,
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(height: 10,);
                                    },
                                    itemBuilder: (context, index) {
                                      var result = searchIndexList[index];
                                      return ListTile(
                                        tileColor: notifier.getWhiteblackColor,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        onTap: () {
                                          mobileNumber = searchiteams[result]["mobileNumber"];
                                          proPic = searchiteams[result]["pro_pic"];
                                          uidResiver = searchiteams[result]["uid"];
                                          usernameResiver = searchiteams[result]["name"];
                                          chatDataMap = {
                                            "mobileNumber" : mobileNumber,
                                            "proPic" : proPic,
                                            "uidResiver" : uidResiver,
                                            "usernameResiver" : usernameResiver,
                                          };

                                          // chatStream.sink.add(chatDataMap);

                                          if (!kIsWeb) {
                                            Get.to(
                                                ChatScreen(
                                                  initialTab: 0,
                                                  adImage: "",
                                                  mobile: searchiteams[result]["mobile_number"],
                                                  profilePic: searchiteams[result]["pro_pic"],
                                                  adPrice: "",
                                                  title: "",
                                                  resiverUserId: searchiteams[result]["uid"],
                                                  resiverUsername: searchiteams[result]["name"],
                                                ));
                                          }
                                        },
                                        subtitle: Text(searchiteams[result]["message"],
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: notifier.getTextColor,
                                              fontFamily: FontFamily.gilroyLight,
                                            )),
                                        trailing: Text(
                                            DateFormat('hh:mm a')
                                                .format(DateTime.fromMicrosecondsSinceEpoch(
                                                searchiteams[result]["timestamp"]
                                                    .microsecondsSinceEpoch))
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: notifier.getTextColor,
                                              fontFamily: FontFamily.gilroyLight,
                                            )),
                                        leading: Container(
                                          height: 50,
                                          width: 50,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(width: 3, color: WhiteColor),
                                              image: DecorationImage(fit: BoxFit.fitHeight, image: NetworkImage(Config.imageUrl + searchiteams[result]["pro_pic"], scale: 20))
                                          ),
                                        ),
                                        title: Text(
                                          searchiteams[result]["name"].toString(),
                                          style:
                                          TextStyle(color: notifier.getTextColor, fontFamily: FontFamily.gilroyMedium,),
                                        ),
                                      );
                                    },
                                  ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width:  kIsWeb ? 10 : 0,),
                            constraints.maxWidth < 850 ? const SizedBox() :
                            kIsWeb ? Container(child: webChatPage()) : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  kIsWeb ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 1550 < constraints.maxWidth ? 200 : 1200 < constraints.maxWidth ? 100 : 20,),
                    child: footer(context),
                  ) : const SizedBox(),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  Widget webChatPage(){
    return StreamBuilder(
        stream: chatStream.stream,
        builder: (context, snapshot) {
          if(snapshot.hasError) {
            return const Text("Something went wrong!");
          }
          return Expanded(
            flex: 2,
            child: uidResiver.isEmpty ? Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                size: 30,
                color: PurpleColor,
              ),
            ) : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: notifier.borderColor,
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                child: ChatScreen(resiverUserId: snapshot.data!["uidResiver"], resiverUsername: snapshot.data!["usernameResiver"], mobile: snapshot.data!["mobileNumber"],
                  profilePic: snapshot.data!["proPic"], title: "", adPrice: "", initialTab: 0, adImage: "",),
              ),
            ),
          );
        }
    );
  }

  Widget _buildUserList(constraints) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("sellify_user").snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasError) {
            return const Text("Error");
          }
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: LoadingAnimationWidget.staggeredDotsWave(
              size: 30,
              color: PurpleColor,
            ),);
          }

            mobileNumber = snapshot.data!.docs[0]["mobile_number"];
            proPic = snapshot.data!.docs[0]["pro_pic"];
            uidResiver = snapshot.data!.docs[0]["uid"];
            usernameResiver = snapshot.data!.docs[0]["name"];
            chatDataMap = {
              "mobileNumber" : mobileNumber,
              "proPic" : proPic,
              "uidResiver" : uidResiver,
              "usernameResiver" : usernameResiver,
            };
               if (850 < constraints.maxWidth) {
                 chatStream.sink.add(chatDataMap);
               }

          return snapshot.data!.docs.isEmpty ? Center(
              child: Image.asset("assets/emptychat.png", height: 200)) : ListView(
            children: snapshot.data!.docs.map<Widget>((doc) {
              return _buildUserListIteam(doc, snapshot.data!.docs.length, constraints);
            },).toList(),
          );
        },
    );
  }

  ChatServices chatservices = ChatServices();

  int chatPersonLength = 0;

  Widget _buildUserListIteam(DocumentSnapshot document, int length, constraints) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

   if(getData.read("UserLogin")["name"] != data["name"]) {
     return StreamBuilder(
         stream: chatservices.getMessage(userId: data["uid"], otherUserId: getData.read("UserLogin")["id"]),
         builder: (context, snapshot) {
           if (snapshot.hasError) {
             return Text("Error${snapshot.error}");
           }

           if(snapshot.connectionState == ConnectionState.waiting) {
             return Padding(
               padding: const EdgeInsets.only(bottom: 10),
               child: shimmer(baseColor: notifier.shimmerbase, context: context, height: 70),
             );
           } else {
             return snapshot.data!.docs.isEmpty
                 ? const SizedBox()
                 : _buildMessageitem(snapshot.data!.docs.last, data["name"],
             data["uid"], length, snapshot, data["pro_pic"], data["mobile_number"], constraints);
           }
         },);
   } else {
     return Container();
   }
  }

  List<Map> searchiteams = [];

  Map chatDataMap = {};

  Widget _buildMessageitem(DocumentSnapshot document, String name, String uid,
      int length, var snapshot, String profilePic, String mobile, constraints) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    if(searchiteams.length < length - 1){
      if (snapshot.data!.docs.isNotEmpty) {
        searchiteams.add({
          "name": name,
          "uid": uid,
          "pro_pic": profilePic,
          "mobileNumber" : mobile,
          "message": data["message"],
          "timestamp": data["timestamp"]
        });
      }
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: StatefulBuilder(
        builder: (context, setState) {
          return ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            tileColor: notifier.getWhiteblackColor,
            onTap: () {
              mobileNumber = mobile;
              proPic = profilePic;
              uidResiver = uid;
              usernameResiver = name;
              chatDataMap = {
              "mobileNumber" : mobile,
              "proPic" : profilePic,
              "uidResiver" : uid,
              "usernameResiver" : name,
              };
              if (850 < constraints.maxWidth) {
                chatStream.sink.add(chatDataMap);
              }
              if (!kIsWeb) {
                Get.to(ChatScreen(
                  adImage: "",
                  adPrice: "",
                  mobile: mobile,
                  profilePic: profilePic,
                  title: "",
                  initialTab: 0,
                  resiverUserId: uid,
                  resiverUsername: name,
                ));
              }
            },
            leading: Container(
              height: 50,
              width: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 3, color: WhiteColor),
                image: DecorationImage(fit: BoxFit.fitHeight, image: NetworkImage(Config.imageUrl + profilePic, scale: 20))
              ),
            ),
            title: Text(
              name,
              style: TextStyle(
                fontSize: 18,
                color: notifier.getTextColor,
                fontFamily: FontFamily.gilroyMedium,
              ),
            ),
            subtitle: Text(
              data["message"],
              style: TextStyle(
                fontSize: 14,
                color: notifier.getTextColor,
                fontFamily: FontFamily.gilroyLight,
              ),
            ),
             trailing: Text(
                  DateFormat('hh:mm a')
                      .format(DateTime.fromMicrosecondsSinceEpoch(
                      data["timestamp"].microsecondsSinceEpoch))
                      .toString(),
                  style: TextStyle(
                    fontSize: 10,
                    color: notifier.getTextColor,
                    fontFamily: FontFamily.gilroyRegular,
                  ))
          );
        }
      ),
    );
  }
}
