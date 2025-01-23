import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prostuti/app/common/custom_appbar.dart';

import '../../../common/custom_simple_appbar.dart';
import '../controllers/package_details_controller.dart';
import '../widgets/package_card_widget.dart';

class PackageDetailsView extends GetView<PackageDetailsController> {
  const PackageDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomSimpleAppBar.appBar(
          title: "Package Details",
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                PackageCardWidget(
                    isCurrentPackage: true,
                    name: "STARTER PLAN",
                    period: "1 Month",
                    price: "৳15",
                    services: [
                      '১ মাস সকল কোয়েশ্চন ব্যাংক উত্তরের ব্যাখ্যা ও বিশ্লেষণ',
                      '১ মাস সকল কন্টেস্টের উত্তরের ব্যাখ্যা ও বিশ্লেষণ',
                      '১ মাস সকল মডেল টেস্টের উত্তরের ব্যাখ্যা ও বিশ্লেষণ'
                    ]),
                PackageCardWidget(
                  isCurrentPackage: false,
                  name: "GROWTH PLAN",
                  period: "3 Months",
                  price: "৳90",
                  services: [
                    '৩ মাস সকল কোয়েশ্চন ব্যাংক উত্তরের ব্যাখ্যা ও বিশ্লেষণ',
                    '৩ মাস সকল কন্টেস্টের উত্তরের ব্যাখ্যা ও বিশ্লেষণ',
                    '৩ মাস সকল মডেল টেস্টের উত্তরের ব্যাখ্যা ও বিশ্লেষণ'
                  ],
                ),
                PackageCardWidget(
                  isCurrentPackage: false,
                  name: "GROWTH PLAN",
                  period: "3 Months",
                  price: "৳90",
                  services: [
                    '৩ মাস সকল কোয়েশ্চন ব্যাংক উত্তরের ব্যাখ্যা ও বিশ্লেষণ',
                    '৩ মাস সকল কন্টেস্টের উত্তরের ব্যাখ্যা ও বিশ্লেষণ',
                    '৩ মাস সকল মডেল টেস্টের উত্তরের ব্যাখ্যা ও বিশ্লেষণ'
                  ],
                ),
                PackageCardWidget(
                  isCurrentPackage: false,
                  name: "GROWTH PLAN",
                  period: "3 Months",
                  price: "৳90",
                  services: [
                    '৩ মাস সকল কোয়েশ্চন ব্যাংক উত্তরের ব্যাখ্যা ও বিশ্লেষণ',
                    '৩ মাস সকল কন্টেস্টের উত্তরের ব্যাখ্যা ও বিশ্লেষণ',
                    '৩ মাস সকল মডেল টেস্টের উত্তরের ব্যাখ্যা ও বিশ্লেষণ'
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
