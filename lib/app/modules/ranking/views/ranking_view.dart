import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prostuti/app/common/custom_buttons.dart';
import 'package:prostuti/app/common/custom_styles.dart';
import 'package:prostuti/app/common/utils/prostuti_utils.dart';
import 'package:prostuti/app/constant/app_color.dart';
import 'package:prostuti/app/modules/ranking/controllers/ranking_controller.dart';
import 'package:prostuti/app/modules/ranking/models/ranking_info.dart';
import 'package:prostuti/app/modules/ranking/widgets/ranking_filter_bottom_sheet.dart';

class RankingView extends GetWidget<RankingController> {
  RankingView({super.key});
  @override
  final controller = Get.find<RankingController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isRankLoading.value == true) {
          return const Center(
            child: CupertinoActivityIndicator(color: AppColors.primary ,),
          );
        }

        ContestData? rankingData = controller.contestRankData.value;

        RankingInfo? rankingInfo = rankingData?.info;
        List<ContestResult>? firstThree = rankingInfo?.firstThreeResults;
        List<ContestResult>? results = rankingData?.results;

        if (rankingInfo == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "No Contest Found",
                style: CustomStyles.textStyle,
              ),
            ),
          );
        }

        return Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    contestDetailsWidget(rankingInfo),
                    SizedBox(height: 10.h),
                    // Profile Section
                    if (firstThree != null && firstThree.length > 2)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RankProfileCard(
                                rank: '2',
                                name: firstThree[1].userFullName,
                                city: 'Barishal',
                                imageUrl: '',
                                rankIcon: 'assets/leaderboard/rank-2.svg'),
                            RankProfileCard(
                                rank: '1',
                                name: firstThree[0].userFullName,
                                city: 'Dhaka',
                                imageUrl: '',
                                rankIcon: 'assets/leaderboard/rank-1.svg'),
                            RankProfileCard(
                                rank: '3',
                                name: firstThree[2].userFullName,
                                city: 'Khulna',
                                imageUrl: '',
                                rankIcon: 'assets/leaderboard/rank-3.svg'),
                          ],
                        ),
                      ),
                    SizedBox(height: 5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Leaderboard',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        CustomButton.button(
                            mainAxisSize: MainAxisSize.min,
                            text: controller.rankingTitle,
                            fontSize: 14,
                            padding: 10,
                            isImageLeft: false,
                            fontWeight: FontWeight.w500,
                            onPressed: () {
                              print(controller.selectedRankingType.value);
                              print(controller.selectedDistrict.value);
                              _showBottomSheet(context);
                            })
                      ],
                    ),
                    SizedBox(height: 5.h),

                    if (results != null && results.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          ContestResult result = results[index];
                          return LeaderBoardEntry(
                            position: '${index + 1}',
                            name: result.userFullName,
                            city: 'Dhaka',
                            score: result.points,
                            institution: 'University of Barishal',
                            avatarUrl: '',
                          );
                        },
                      ),

                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: CustomButton.button(
                        mainAxisSize: MainAxisSize.min,
                        text: "See My Position",
                        fontSize: 14,
                        padding: 10,
                        isImageLeft: false,
                        fontWeight: FontWeight.w500,
                        onPressed: () {}))),
          ],
        );
      }),
    );
  }

  void _showBottomSheet(BuildContext context) {
    Get.bottomSheet(
      RankingFilterBottomSheet(),
      isScrollControlled:
          false, // Optional, to allow for full-screen or scrollable content
      backgroundColor: Colors.white,
      ignoreSafeArea: false,
      isDismissible: true,
    );
  }
}

Widget contestDetailsWidget(RankingInfo? rankingData) => Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.primaryOpacity,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/govt-bd.png',
                  height: 28,
                  width: 28,
                ),
                SizedBox(
                  width: 9.w,
                ),
                HtmlWidget(rankingData?.contestTitle ?? '')
                // Text(rankingData?.contestTitle ?? '',
                //     style: GoogleFonts.notoSansBengali(
                //         textStyle: const TextStyle(
                //             fontSize: 16, fontWeight: FontWeight.w600)))
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  contestInfoItem(
                      img: 'assets/participiants.png',
                      title:
                          '${Utils.convertNumberToBengali(rankingData?.participants ?? 0)} জন'),
                  contestInfoItem(
                      img: 'assets/total-marks.png',
                      title:
                          '${Utils.convertNumberToBengali(rankingData?.contestMark ?? 0)} মার্কস'),
                  contestInfoItem(
                      img: 'assets/total-time.png',
                      title:
                          '${Utils.convertNumberToBengali(rankingData?.contestTime ?? 0)} মিনিট'),
                  contestInfoItem(
                      img: 'assets/contest-start.png',
                      title: Utils.formatDateToBanglaDDM(
                          rankingData?.contestDate ?? DateTime(2025)))
                ],
              ),
            )
          ],
        ),
      ),
    );

Widget contestInfoItem({required String img, required String title}) =>
    Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            img,
            scale: 1.5,
          ),
          SizedBox(
            width: 5.w,
          ),
          Text(title,
              style: GoogleFonts.notoSansBengali(
                  textStyle: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textPrimaryColor,
                      fontWeight: FontWeight.w600))),
        ],
      ),
    );

class RankProfileCard extends StatelessWidget {
  final String rank;
  final String name;
  final String city;
  final String imageUrl;
  final String rankIcon;

  const RankProfileCard({
    super.key,
    required this.rank,
    required this.name,
    required this.city,
    required this.imageUrl,
    required this.rankIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: rank == '1' ? 65.w : 40.w,
              backgroundColor: AppColors.primaryOpacity,
              child: SvgPicture.asset(
                "assets/default-male.svg",
                width: rank == '1' ? 65.w : 40.w,
              ),
            ),
            Positioned(
              bottom: rank == '1' ? -25.w : -20.h,
              left: rank == '1' ? 45.w : 25.w, //
              child: SvgPicture.asset(
                rankIcon,
                width: rank == '1' ? 50.w : 40.w,
                height: rank == '1' ? 50.w : 40.h,
              ),
            ),
          ],
        ),
        SizedBox(height: 25.h),
        Text(
          name,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
        ),
        Text(
          city,
          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
        ),
      ],
    );
  }
}

class LeaderBoardEntry extends StatelessWidget {
  final String name;
  final String institution;
  final String city;
  final int score;
  final String position;
  final String avatarUrl;

  const LeaderBoardEntry({
    super.key,
    required this.name,
    required this.institution,
    required this.city,
    required this.score,
    required this.position,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      margin: EdgeInsets.only(bottom: 15.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.lightGray),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(position,
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
              SizedBox(width: 15.w),
              CircleAvatar(
                  radius: 25.w,
                  backgroundColor: AppColors.primaryOpacity,
                  child: SvgPicture.asset(
                      "assets/default-male.svg") //Image.network(profilePicture)
                  ),
              SizedBox(width: 15.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w500)),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text('$city • $institution',
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
                ],
              ),
            ],
          ),
          Text('$score',
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blueGray)),
        ],
      ),
    );
  }
}
