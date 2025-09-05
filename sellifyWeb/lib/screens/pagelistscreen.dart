import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sellify/controller/pagelist_controller.dart';

import '../helper/appbar_screen.dart';
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          backgroundColor: notifier.getBgColor,
          appBar: kIsWeb ? PreferredSize(
              preferredSize: const Size.fromHeight(125),
              child: CommonAppbar(title: pageListCont.pagelistdata!.pagelist![index].title ?? "", fun: () {
                Get.back();
              },)) : AppBar(
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 1550 < constraints.maxWidth ? 500 : 1050 < constraints.maxWidth ? 300 : 750 < constraints.maxWidth ? 150 : 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: notifier.getWhiteblackColor,
                        borderRadius: BorderRadius.circular(14)
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                  kIsWeb ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 1550 < constraints.maxWidth ? 200 : 1200 < constraints.maxWidth ? 100 : 20, vertical: 8),
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
}
