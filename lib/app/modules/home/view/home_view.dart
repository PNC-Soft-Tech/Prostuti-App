import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../common/custom_appbar.dart';
import '../../../common/custom_loading.dart';
import '../../contests/widgets/contest_card_home_page_widget.dart';
import '../controller/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar.appBar(
          title: '',
          backgroundColor: Colors.white,
          // leadingWidth: 100,
         
          name: "Rahat"
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Column(
            children: [
              ContestHomeCardWidget(),
            ],
          ),
        ));
  }
}
