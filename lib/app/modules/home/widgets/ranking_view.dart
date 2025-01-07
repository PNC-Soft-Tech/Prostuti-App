import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prostuti/app/constant/app_color.dart';
import 'package:prostuti/app/modules/contest-details/view/contest_details_view.dart'; // For responsive sizing

class RankingView extends StatelessWidget {
  const RankingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 19.w),
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: Column(
        children: [
          contestDetailsWidget(),
          SizedBox(height: 10.h),
          // Profile Section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RankProfileCard(
                    rank: '2',
                    name: 'Tarikul Islam',
                    city: 'Barishal',
                    imageUrl: 'https://picsum.photos/200',
                    rankIcon: 'assets/leaderboard/rank-2.svg'),
                RankProfileCard(
                    rank: '1',
                    name: 'Md Sayem',
                    city: 'Dhaka',
                    imageUrl: 'https://picsum.photos/200',
                    rankIcon: 'assets/leaderboard/rank-1.svg'),
                RankProfileCard(
                    rank: '3',
                    name: 'Md Solayman',
                    city: 'Khulna',
                    imageUrl: 'https://picsum.photos/200',
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
              DropdownButton<String>(
                value: 'Overall Top 10',
                icon: Icon(Icons.arrow_drop_down, size: 20.sp),
                underline: Container(),
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.sp,
                ),
                onChanged: (String? newValue) {
                  print('Selected: $newValue');
                },
                items: <String>[
                  'Overall Top 10',
                  'Overall Top 20',
                  'Top Weekly'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          const LeaderBoardEntry(
            position: '1',
            name: 'Md Sayem',
            city: 'Dhaka',
            score: 92,
            institution: 'University of Barishal',
            avatarUrl: 'https://picsum.photos/100',
          ),
          const LeaderBoardEntry(
              position: '2',
              name: 'Tarikul Islam',
              city: 'Barishal',
              score: 85,
              institution: 'University of Rajshahi',
              avatarUrl: 'https://picsum.photos/100'),
          const LeaderBoardEntry(
              position: '3',
              name: 'Md Solayman',
              city: 'Khulna',
              score: 84,
              institution: 'University of Dhaka',
              avatarUrl: 'https://picsum.photos/100'),
          const LeaderBoardEntry(
              position: '4',
              name: 'Mohammad Salah',
              city: 'Barishal',
              score: 70,
              institution: 'BM College',
              avatarUrl: 'https://picsum.photos/100'),
          SizedBox(height: 20.h),
          Center(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 16.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r)),
              ),
              child: Text('See My Position',
                  style: TextStyle(fontSize: 16.sp, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

Widget contestDetailsWidget() => Container(
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
                Text("বিসিএস কনটেস্ট-০১",
                    style: GoogleFonts.notoSansBengali(
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)))
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  contestInfoItem(
                      img: 'assets/participiants.png', title: '৩৬৫ জন'),
                  contestInfoItem(
                      img: 'assets/total-marks.png', title: '৫০ মার্কস'),
                  contestInfoItem(
                      img: 'assets/total-time.png', title: '৩০ মিনিট'),
                  contestInfoItem(
                      img: 'assets/contest-start.png', title: '২২ ডিসেম্বর'),
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
          clipBehavior: Clip.none, // To allow the star to overflow
          children: [
            CircleAvatar(
              radius: rank == '1' ? 65.w : 40.w,
              backgroundImage: NetworkImage(imageUrl),
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
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 16.w),
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
                radius: 20.w,
                backgroundImage: NetworkImage(avatarUrl),
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
