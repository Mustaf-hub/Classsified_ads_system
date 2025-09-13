import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:provider/provider.dart';
import 'package:sellify/controller/pagelist_controller.dart';
import 'package:sellify/helper/font_family.dart';

import '../helper/c_widget.dart';
import '../utils/dark_lightMode.dart';

class Pagelistscreen extends StatelessWidget {
  final int index;
  Pagelistscreen({super.key, required this.index});

  PageListController pageListCont = Get.find();

  late ColorNotifire notifier;
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifier.getBgColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: notifier.getWhiteblackColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: notifier.getTextColor,
          ),
        ),
        title: Text(
          pageListCont.pagelistdata!.pagelist![index].title ?? "",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            fontFamily: 'Gilroy Medium',
            color: notifier.getTextColor,
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: CustomBehavior(),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Container(
            decoration: BoxDecoration(
              color: notifier.getWhiteblackColor,
              borderRadius: BorderRadius.circular(14)
            ),
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: pageListCont.pagelistdata!.pagelist![index].description!.isNotEmpty ?
              HtmlWidget(
                pageListCont.pagelistdata!.pagelist![index].description ?? "",
                textStyle: TextStyle(
                    color: notifier.getTextColor,
                    fontSize: Get.height / 50,
                    fontFamily: 'Gilroy Normal'),
              )
                         : Image.asset("assets/emptyOrder.png"),
            ),
          ),
        ),
      ),
    );
  }
}
