import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
            padding: EdgeInsets.only(top: 10.sp),
            color: Colors.white,
            child: Column(
              children: [
                PackageCardWidget(
                    isCurrentPackage: true,
                    name: "STARTER PLAN",
                    period: "1 Month",
                    price: "৳15",
                    packageId: "starter_plan",
                    services: const [
                      '১ মাস সকল কোয়েশ্চন ব্যাংক উত্তরের ব্যাখ্যা ও বিশ্লেষণ',
                      '১ মাস সকল কন্টেস্টের উত্তরের ব্যাখ্যা ও বিশ্লেষণ',
                      '১ মাস সকল মডেল টেস্টের উত্তরের ব্যাখ্যা ও বিশ্লেষণ'
                    ]),
                PackageCardWidget(
                  isCurrentPackage: false,
                  name: "GROWTH PLAN",
                  period: "3 Months",
                  price: "৳90",
                  packageId: "growth_plan_3m",
                  services: const [
                    '৩ মাস সকল কোয়েশ্চন ব্যাংক উত্তরের ব্যাখ্যা ও বিশ্লেষণ',
                    '৩ মাস সকল কন্টেস্টের উত্তরের ব্যাখ্যা ও বিশ্লেষণ',
                    '৩ মাস সকল মডেল টেস্টের উত্তরের ব্যাখ্যা ও বিশ্লেষণ'
                  ],
                ),
                PackageCardWidget(
                  isCurrentPackage: false,
                  name: "PREMIUM PLAN",
                  period: "6 Months",
                  price: "৳150",
                  packageId: "premium_plan_6m",
                  services: const [
                    '৬ মাস সকল কোয়েশ্চন ব্যাংক উত্তরের ব্যাখ্যা ও বিশ্লেষণ',
                    '৬ মাস সকল কন্টেস্টের উত্তরের ব্যাখ্যা ও বিশ্লেষণ',
                    '৬ মাস সকল মডেল টেস্টের উত্তরের ব্যাখ্যা ও বিশ্লেষণ',
                    'প্রাইভেট টিউটর সাপোর্ট',
                    'লাইভ ক্লাস এক্সেস'
                  ],
                ),
                PackageCardWidget(
                  isCurrentPackage: false,
                  name: "ULTIMATE PLAN",
                  period: "12 Months",
                  price: "৳250",
                  packageId: "ultimate_plan_12m",
                  services: const [
                    '১২ মাস সকল কোয়েশ্চন ব্যাংক উত্তরের ব্যাখ্যা ও বিশ্লেষণ',
                    '১২ মাস সকল কন্টেস্টের উত্তরের ব্যাখ্যা ও বিশ্লেষণ',
                    '১২ মাস সকল মডেল টেস্টের উত্তরের ব্যাখ্যা ও বিশ্লেষণ',
                    'প্রাইভেট টিউটর সাপোর্ট',
                    'লাইভ ক্লাস এক্সেস',
                    'ক্যারিয়ার গাইডেন্স',
                    'জব প্রিপারেশন সাপোর্ট'
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
