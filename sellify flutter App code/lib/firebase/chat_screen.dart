import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sellify/controller/login_controller.dart';
import 'package:sellify/firebase/chat_bubble.dart';
import 'package:sellify/firebase/chat_service.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/helper/font_family.dart';
import 'package:sellify/utils/Colors.dart';
import 'package:sellify/utils/dark_lightMode.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api_config/config.dart';
import '../api_config/store_data.dart';

class ChatScreen extends StatefulWidget {
  final String resiverUserId;
  final String profilePic;
  final String adImage;
  final String title;
  final String mobile;
  final String adPrice;
  final int initialTab;
  final String resiverUsername;
  const ChatScreen({super.key, required this.resiverUserId, required this.resiverUsername, required this.adImage, required this.title, required this.adPrice, required this.initialTab, required this.profilePic, required this.mobile});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  @override
  void initState() {
    super.initState();
    selectedTab = widget.initialTab;
    priceText.text = addCommas(widget.adPrice);
    setState(() {});
    isMsgAvalable(widget.resiverUserId);

  }

  String fmctoken = "";
  TextEditingController msgText = TextEditingController();
  ChatServices chatServices = ChatServices();

  int selectedTab = 1;

  final ScrollController scrollCont = ScrollController();

  void _scrollDown() {
    scrollCont.animateTo(scrollCont.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    // _controller.jumpTo(_controller.position.maxScrollExtent);
  }

   void sendMsg(){
    CollectionReference collRef = FirebaseFirestore.instance.collection("chat_sellify");

    if(msgText.text.isNotEmpty && selectedTab == 0){
      collRef.doc(widget.resiverUserId).get().then((value) async {
        var fields;

        fields = value.data();
        sendPushMsg(
            msgText.text, getData.read("UserLogin")["name"], fmctoken);
        await chatServices.sendMessage(receiverId: widget.resiverUserId, message: msgText.text, adTitle: widget.title);

        msgText.clear();

        scrollCont.jumpTo(scrollCont.position.maxScrollExtent);
      },);
    } else if(chatServices.chatChipMsg.isNotEmpty && selectedTab == 0) {

      collRef.doc(widget.resiverUserId).get().then((value) async {
        var fields;

        fields = value.data();
        sendPushMsg(
            chatServices.chatChipMsg, getData.read("UserLogin")["name"], fmctoken);
        await chatServices.sendMessage(receiverId: widget.resiverUserId, message: chatServices.chatChipMsg, adTitle: widget.title);

        chatServices.chatChipMsg = "";

        scrollCont.jumpTo(scrollCont.position.maxScrollExtent);
      },);

    } else if(priceText.text.isNotEmpty && selectedTab == 1){
      collRef.doc(widget.resiverUserId).get().then((value) async {
        var fields;

        fields = value.data();
        sendPushMsg(
            "$currency${priceText.text}", getData.read("UserLogin")["name"], fmctoken);
        await chatServices.sendMessage(receiverId: widget.resiverUserId, message: "$currency${priceText.text}", adTitle: widget.title);

        scrollCont.jumpTo(scrollCont.position.maxScrollExtent);
      },);
    }
  }

  Future<dynamic> isMsgAvalable(String uid) async {
    CollectionReference colRef = FirebaseFirestore.instance.collection("sellify_user");
    print("MASSAGE DATA $colRef");
    colRef.doc(uid).get().then((value) {
      var fields;
      fields = value.data();
      print("MASSAGE DATA ? > $fields");
      setState(() {
        fmctoken = fields["token"];
        print("TOKEN ID > <> <> <> <> ${fmctoken}");
      });
    });
  }

  void scrollDown(){
    scrollCont.animateTo(scrollCont.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  late ColorNotifire notifier;

  DraggableScrollableController sheetController = DraggableScrollableController();

  List preChatMsg = [
    "Is this still available?".tr,
    "What’s the final price?".tr,
    "Can you share more details?".tr,
    "Is the price negotiable?".tr,
    "Any defects or issues?".tr,
    "Can you hold it for me?".tr,
    "Where can I pick it up?".tr,
    "Can I see more pictures?".tr,
    "What’s the reason for selling?".tr,
    "Can we meet today?".tr,
  ];

  bool isMsgDelete = false;

  double layoutConstraints = 292.3;

  double bottomSheetHeight = 293.3;

  updateVAl(constHeight) {
    setState(() {
      layoutConstraints = constHeight;
      bottomSheetHeight = constHeight;
    });
  }
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifier.getBgColor,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: notifier.getWhiteblackColor,
        elevation: 0,
        leadingWidth: 50,
        leading: BackButton(
          color: notifier.iconColor,
          onPressed: () {
            Get.back();
          },
        ),
        title: Row(
          children: [
            widget.title.isEmpty ? Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(fit: BoxFit.fitHeight, image: NetworkImage(Config.imageUrl + widget.profilePic))
              ),
            ) : Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(image: NetworkImage("${Config.imageUrl}${widget.adImage}"), fit: BoxFit.cover)
                  ),
                ),
                Positioned(
                  bottom: -2,
                  right: -10,
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(fit: BoxFit.fitHeight, image: NetworkImage(Config.imageUrl + widget.profilePic),)
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: widget.title.isEmpty ? 10 : 20,),
            if (widget.title.isEmpty) StreamBuilder(
              stream: FirebaseFirestore.instance.collection("chat_sellify").doc(widget.resiverUserId).snapshots(),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Text(
                    widget.resiverUsername,
                    style: TextStyle(
                      fontFamily: FontFamily.gilroyBold,
                      fontSize: 20,
                      color: notifier.getTextColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  );
                } else {
                  return Text(
                    widget.resiverUsername,
                    style: TextStyle(
                      fontFamily: FontFamily.gilroyBold,
                      fontSize: 20,
                      color: notifier.getTextColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  );
                }
              },
            ) else Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("chat_sellify").doc(widget.resiverUserId).snapshots(),
                      builder: (context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return Text(
                            widget.resiverUsername,
                            style: TextStyle(
                              fontFamily: FontFamily.gilroyBold,
                              fontSize: 18,
                              color: notifier.getTextColor,
                            ),
                          );
                        } else {
                          return Text(
                            widget.resiverUsername,
                            style: TextStyle(
                              fontFamily: FontFamily.gilroyBold,
                              fontSize: 18,
                              color: notifier.getTextColor,
                            ),
                          );
                        }
                      },
                  ),
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontFamily: FontFamily.gilroyMedium,
                      fontSize: 14,
                      color: notifier.getTextColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
          ],
        ),
        actions: [
          widget.mobile.isEmpty ? InkWell(
            onTap: () {
              deleteChat();
            },
            child: Image.asset("assets/3dots.png", scale: 2.8, color: notifier.getTextColor,),
          ) : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  var permission = await Permission.phone.request();

                  if(permission.isGranted){
                    var url = Uri.parse(
                        "tel:${widget.mobile}");
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  } else {
                    showToastMessage("Please give phone call permission!");
                  }

                },
                  child: Image.asset("assets/phone.png", scale: 2.8, color: notifier.getTextColor),
              ),
              SizedBox(width: 20,),
              InkWell(
                onTap: () {
                  deleteChat();
                },
                  child: Image.asset("assets/3dots.png", scale: 2.8, color: notifier.getTextColor,),
              ),
              SizedBox(width: 20,)
            ],
          ),
        ],
      ),
      body: (widget.adPrice == "0" || widget.title.isEmpty) ? Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: buildMsgList(),
          )),
          SizedBox(height: 10,),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: inputMsg(),
          )
        ],
      ) : Column(
        children: [
          Expanded(
            flex: 2,
            child: LayoutBuilder(
              builder: (context, constraints) {
                double availableHeight = constraints.maxHeight ;
                return SizedBox(
                  height: availableHeight, // Dynamically adjust height
                  child: buildMsgList(), // Your chat messages list
                );
              },
            ),
          ),
          Expanded(
            child: DraggableScrollableSheet(
              initialChildSize: 1.0,
              minChildSize: 1.0,
              maxChildSize: 1.0,
              controller: sheetController,
              builder: (BuildContext context, scrollController) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      controller: scrollController,
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: notifier.getWhiteblackColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: notifier.getTextColor,
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                ),
                                height: 4,
                                width: 40,
                                margin: const EdgeInsets.symmetric(vertical: 10),
                              ),
                            ),
                            DefaultTabController(
                              length: 2,
                              initialIndex: selectedTab,
                              child: Container(
                                color: notifier.getWhiteblackColor,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  children: [
                                    TabBar(
                                      onTap: (value) {
                                          selectedTab = value;
                                          sheetController.animateTo(1.0, duration: Duration(microseconds: 300), curve: Curves.bounceIn);
                                      },
                                      indicatorColor: PurpleColor,
                                      dividerColor: notifier.iconColor,
                                      dividerHeight: 2,
                                      labelPadding: EdgeInsets.symmetric(vertical: 10),
                                      tabs: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset("assets/chatdots.svg", height: 30, colorFilter: ColorFilter.mode(notifier.getTextColor, BlendMode.srcIn,),),
                                            SizedBox(width: 6),
                                            Text("Chat".tr, style: TextStyle(fontFamily: FontFamily.gilroyBold, fontSize: 18, color: notifier.getTextColor),),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset("assets/makeoffer.svg", height: 30, colorFilter: ColorFilter.mode(notifier.getTextColor, BlendMode.srcIn,)),
                                            SizedBox(width: 6),
                                            Text("Make Offer".tr, style: TextStyle(fontFamily: FontFamily.gilroyBold, fontSize: 18, color: notifier.getTextColor),),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: MediaQuery.of(context).size.height / 5,
                                      color: notifier.getWhiteblackColor,
                                      child: TabBarView(
                                          children: [
                                            chatMsg(),
                                            makeOffer()
                                          ]),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                );
              },
            ),
          )
        ],
      ),
    );
  }

  String selectedPrice = "";
  TextEditingController priceText = TextEditingController();

  String msgChat = "";
  Widget chatMsg(){
    return Column(
      children: [
        Spacer(),
        Wrap(
          children: [
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: GestureDetector(
                      onTap: () {
                        chatServices.chatChipMsg = preChatMsg[index];
                        sendMsg();
                      },
                      child: Chip(
                        padding: EdgeInsets.zero,
                        backgroundColor: PurpleColor,
                        labelPadding: EdgeInsets.symmetric(horizontal: 10),
                        label: Text(preChatMsg[index], style: TextStyle(fontSize: MediaQuery.of(context).size.height / 75, fontFamily: FontFamily.gilroyBold, color: WhiteColor,),),
                      ),
                    ),
                  );
                },),
            ),
          ],
        ),
        Spacer(),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: msgText,
                style: TextStyle(fontSize: 24, fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor,),
                onChanged: (p0) {
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: notifier.textfield,
                  hintText: "Send message",
                  hintStyle: TextStyle(color: lightGreyColor, fontFamily: FontFamily.gilroyMedium, fontSize: 16),
                  helperStyle: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 12,),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: PurpleColor),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  disabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: notifier.borderColor),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: notifier.borderColor),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: PurpleColor,
              ),
              padding: EdgeInsets.all(5),
              child: IconButton(
                  onPressed: sendMsg,
                  icon: Icon(
                    Icons.send,
                    size: 20,
                    color: WhiteColor,
                  )),
            ),
          ],
        ),
        Spacer(),
      ],
    );
  }

  Widget makeOffer(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Spacer(),
        Wrap(
          children: [
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                itemBuilder: (context, index) {
                 return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: GestureDetector(
                      onTap: () {
                          priceText.text = addCommas(generatePercentageValues(int.parse(widget.adPrice), count: 4)[index].toString());
                      },
                      child: Chip(
                        padding: EdgeInsets.zero,
                        backgroundColor: PurpleColor,
                        labelPadding: EdgeInsets.symmetric(horizontal: 10),
                        label: Text(currency+" ${addCommas(generatePercentageValues(int.parse(widget.adPrice), count: 6)[index].toString())}", style: TextStyle(fontSize: MediaQuery.of(context).size.height / 75, fontFamily: FontFamily.gilroyBold, color: WhiteColor,),),
                      ),
                    ),
                  );
              },),
            ),
          ],
        ),
        Spacer(),
        Row(
          children: [
            Text(currency, style: TextStyle(fontSize: 30, fontFamily: FontFamily.gilroyBold, color: notifier.getTextColor,),),
            SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: priceText,
                inputFormatters: [
                  TextFormat(),
                ],
                style: TextStyle(fontSize: 30, fontFamily: FontFamily.gilroyBold, color: notifier.getTextColor,),
                onChanged: (p0) {
               },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: notifier.textfield,
                  hintText: "Enter your price offer",
                  hintStyle: TextStyle(color: lightGreyColor, fontFamily: FontFamily.gilroyMedium, fontSize: 16),
                  helperStyle: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 12,),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: PurpleColor),
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                  ),
                  disabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: notifier.borderColor),
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: notifier.borderColor),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: PurpleColor,
              ),
              padding: EdgeInsets.all(5),
              child: IconButton(
                  onPressed: sendMsg,
                  icon: Icon(
                    Icons.send,
                    size: 20,
                    color: WhiteColor,
                  )),
            ),
          ],
        ),
        Spacer(),
      ],
    );
  }

  Future deleteChat(){
    return Get.bottomSheet(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10,),
            Center(
              child: Container(
                width: 40,
                height: 8,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: lightGreyColor
                ),
              ),
            ),
            SizedBox(height: 20,),
            Text("Are you really want to delete chat?".tr,
              style: TextStyle(
                fontFamily: FontFamily.gilroyBold,
                fontSize: 20,
                color: notifier.getTextColor,
              ),
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                Expanded(
                  child: mainButton(
                    selected: true,
                    containcolor: notifier.getWhiteblackColor,
                    context: context,
                    txt1: "Back".tr,
                    onPressed1: () {
                      Get.back();
                    },),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: mainButton(context: context, selected: false, containcolor: PurpleColor, txt1: "Yes".tr, onPressed1: () {
                    ChatServices chatServices = ChatServices();
                    Get.back();
                    popup();
                    chatServices.deleteChat(userId: widget.resiverUserId, otherUserId: getData.read("UserLogin")["id"]).then((value) {
                      isMsgDelete = false;
                      Get.back();
                      setState(() {});
                    },);
                  },),
                )
              ],
            ),
            SizedBox(height: 20,),
          ],
        ),
      ),
    backgroundColor: notifier.getWhiteblackColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)))
    );
  }
  String msgDate = "";
  String dateFormat = "";
  bool showDate = false;

  Future popup(){
    isMsgDelete = true;
    return showDialog(
      barrierDismissible: false,
      context: context, builder: (BuildContext context) {
      return Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
          size: 40,
          color: WhiteColor,
        ),
      );
    },
    );
  }

  Widget buildMsgList(){
    return StreamBuilder(
        stream: chatServices.getMessage(userId: widget.resiverUserId, otherUserId: getData.read("UserLogin")["id"]),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error${snapshot.error}");
          }
           if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: LoadingAnimationWidget.staggeredDotsWave(
              size: 30,
              color: PurpleColor,
            ),);
          } else if (snapshot.data!.docs.isEmpty || isMsgDelete) {
             return Center(
                 child: Image.asset("assets/emptychat.png", height: 200));
           } else {
            return ListView(
              controller: scrollCont,
              children: snapshot.data!.docs
                  .map((document) => buildMsgItem(document, snapshot.data!.docs.length))
                  .toList(),
            );
          }
        },
    );
  }

    List displayedDates = [];

  Widget buildMsgItem(DocumentSnapshot document, int length){
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollDown();
    });
    var alignment = (data["senderid"] == getData.read("UserLogin")["id"])
    ? Alignment.centerRight
        : Alignment.centerLeft;
    // var date = DateFormat('yyyy-MM-dd').format(DateTime.fromMicrosecondsSinceEpoch(data["timestamp"].microsecondsSinceEpoch));
    // DateTime messageDate = DateTime.parse(date);
    String formattedDate = formatChatDate(DateTime.fromMicrosecondsSinceEpoch(data["timestamp"].microsecondsSinceEpoch));
    bool showDateHeader = !displayedDates.contains(formattedDate);

    print("BOOL VAL $showDateHeader");
    if (showDateHeader) {
      displayedDates.add(formattedDate);
    }
      print("VALID DATE  EE E $displayedDates");

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        showDateHeader ? Text(
            formattedDate,
            style: TextStyle(
              fontSize: 10,
              color: notifier.getTextColor,
              fontFamily: FontFamily.gilroyLight,
            )
        ) : SizedBox(),
        Container(
          alignment: alignment,
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment:
            (data["senderid"] == getData.read("UserLogin")["id"])
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              ChatBubble(
                adTitle: data["adTitle"],
                  message: data["message"],
                  alingment: (data["senderid"] == getData.read("UserLogin")["id"])
                      ? false
                      : true,
                  chatColor: (data["senderid"] == getData.read("UserLogin")["id"])
                   ? PurpleColor
                   : notifier.getWhiteblackColor,
                  titleBgColor: (data["senderid"] == getData.read("UserLogin")["id"]) ? Colors.deepPurpleAccent : notifier.borderColor,
                  textColor: (data["senderid"] == getData.read("UserLogin")["id"]) || notifier.isDark
                      ? WhiteColor
                      : BlackColor),
              SizedBox(height: 10,),
              Text(
                  DateFormat('hh:mm a')
                      .format(DateTime.fromMicrosecondsSinceEpoch(
                      data["timestamp"]
                          .microsecondsSinceEpoch))
                      .toString(),
                  style: TextStyle(
                    fontSize: 10,
                    color: notifier.getTextColor,
                    fontFamily: FontFamily.gilroyLight,
                  ))
            ],
          ),
        ),
      ],
    );
  }

  Widget inputMsg(){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: msgText,
              style: TextStyle(fontFamily: FontFamily.gilroyMedium, color: notifier.getTextColor, fontSize: 18),
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: sendMsg,
                      icon: Icon(
                        Icons.send,
                        size: 20,
                        color: GreyColor,
                      )),
                  hintStyle: TextStyle(fontFamily: FontFamily.gilroyMedium, color: GreyColor, fontSize: 16),
                  hintText: "Send message",
                  filled: true,
                  fillColor: notifier.getWhiteblackColor,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: PurpleColor),
                  ),
                  enabledBorder:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.transparent, width: 2),
                  )
              ),
            ),
          ),
        ],
      ),
    );
  }


  void sendPushMsg(String body, String title, String token) async {
    final dio = Dio();

    try{
      final response = await dio.post('https://fcm.googleapis.com/v1/projects/${Config.projectID}/messages:send',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${Config.firebaseKey}',
          },
        ),
        data: jsonEncode({
          'message': {
            'token': token,
            'notification': {
              'title': title,
              'body': body,
            },
            'data': {
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': getData.read("UserLogin")["id"],
              'name': getData.read("UserLogin")["name"],
              'mobile_number': widget.mobile,
              'pro_pic': widget.profilePic,
              'status': 'done'
            },
          }
        })
      );
      if (response.statusCode == 200) {
        print('done');
      } else {
        print('Failed to send push notification: ${response.data}');
      }

    } catch(e){
      print("Error push notificatioDDn: $e");
    }
  }
}

void requestPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }
}
