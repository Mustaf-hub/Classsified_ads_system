// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:sellify/firebase/chat_service.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/helper/font_family.dart';
import 'package:sellify/model/routes_helper.dart';
import 'package:sellify/utils/Colors.dart';
import 'package:sellify/utils/dark_lightMode.dart';

import '../api_config/config.dart';
import '../api_config/store_data.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {

  List searchList = [];
  List searchIndexList = [];


  @override
  void dispose() {
    super.dispose();
  }

  TextEditingController searchText = TextEditingController();
  late ColorNotifire notifier;
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifier.getBgColor,
      appBar: AppBar(
        backgroundColor: notifier.getWhiteblackColor,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text("Message".tr, style: TextStyle(fontFamily: FontFamily.gilroyBold, color: notifier.getTextColor, fontSize: 18,),),
      ),
      body: ScrollConfiguration(
        behavior: CustomBehavior(),
        child: Padding(
          padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
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
                      borderSide: BorderSide(color: Colors.transparent, width: 2),
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
                      print("ID S S  $ids $searchiteams");
                      searchiteams.retainWhere((Map x) {
                        return ids.remove(x['uid']);
                      });

                      setState(() {});
                      searchIndexList.add(i);
                    } else {
                      setState(() {});
                    }
                  }
                },
              ),
              SizedBox(height: 20,),
              Expanded(child: _buildUserList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserList() {
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
          print("CHAT LIST ${snapshot.data!.docs}");
          return snapshot.data!.docs.isEmpty ? Center(
              child: Image.asset("assets/emptychat.png", height: 200)) : searchText.text.isEmpty ? ListView(
            children: snapshot.data!.docs.map<Widget>((doc) {
              return _buildUserListIteam(doc, snapshot.data!.docs.length);
            },).toList(),
          )
          : searchIndexList.isEmpty
              ? Center(child: Image.asset("assets/emptychat.png", height: 200)) : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: searchIndexList.length,
                itemBuilder: (context, index) {
                  var result = searchIndexList[index];
                  return ListTile(
                    tileColor: notifier.getWhiteblackColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    onTap: () {
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
              );
        },
    );
  }

  ChatServices chatservices = ChatServices();

  int chatPersonLength = 0;

  Widget _buildUserListIteam(DocumentSnapshot document, int length) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

   if(getData.read("UserLogin")["name"] != data["name"]) {
     return StreamBuilder(
         stream: chatservices.getMessage(userId: data["uid"], otherUserId: getData.read("UserLogin")["id"]),
         builder: (context, snapshot) {
           print("USER CHAT DATA > > ${data["mobile_number"]}");
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
             data["uid"], length, snapshot, data["pro_pic"], data["mobile_number"]);
           }
         },);
   } else {
     return Container();
   }
  }

  List<Map> searchiteams = [];

  Widget _buildMessageitem(DocumentSnapshot document, String name, String uid,
      int length, var snapshot, String profilePic, String mobile) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    print("CHAT DATA > > > > ${data["message"]}");
    if(searchiteams.length < length - 1){
      if (snapshot.data!.docs.isNotEmpty) {
        searchiteams.add({
          "name": name,
          "uid": uid,
          "pro_pic": profilePic,
          "message": data["message"],
          "timestamp": data["timestamp"]
        });
      }
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: notifier.getWhiteblackColor,
        onTap: () {
          Navigator.push(context, ScreenTransDown(
              routes: ChatScreen(
                adImage: "",
                adPrice: "",
                mobile: mobile,
                profilePic: profilePic,
                title: "",
                initialTab: 0,
                resiverUserId: uid,
                resiverUsername: name,
              ),
              context: context));
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
      ),
    );
  }
}
