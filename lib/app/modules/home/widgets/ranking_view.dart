import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // For responsive sizing

class RankingView extends StatelessWidget {
  const RankingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   title: const Row(
      //     children: [
      //       Icon(Icons.account_circle, color: Colors.blue),
      //       SizedBox(width: 10),
      //       Text('Prostuti', style: TextStyle(color: Colors.blue)),
      //     ],
      //   ),
      // ),
      body: Padding(
        padding: EdgeInsets.all(16.w), // Padding around the entire body
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting and Notification Section
            // Container(
            //   padding: EdgeInsets.all(16.w),
            //   decoration: BoxDecoration(
            //     color: Colors.blue.withOpacity(0.1),
            //     borderRadius: BorderRadius.circular(10),
            //   ),
            //   child: Row(
            //     children: [
            //       Icon(Icons.notifications, color: Colors.red, size: 30.sp),
            //       SizedBox(width: 10.w),
            //       Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text('Hi Rahat!',
            //               style: TextStyle(
            //                   fontSize: 18.sp, fontWeight: FontWeight.bold)),
            //           SizedBox(height: 5.h),
            //           Row(
            //             children: [
            //               Text('বিসিপিএস কনটেস্ট-০১',
            //                   style: TextStyle(
            //                       fontSize: 14.sp, color: Colors.grey)),
            //               SizedBox(width: 10.w),
            //               Icon(Icons.arrow_forward_ios,
            //                   size: 15.sp, color: Colors.grey),
            //             ],
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            // SizedBox(height: 20.h),
            // // Profile Section
            // // ListView(
            // //   shrinkWrap: true,
            // //   scrollDirection: Axis.horizontal,
            // //   children: const [
            // //     ProfileCard(
            // //       rank: '2',
            // //       name: 'Tarikul Islam',
            // //       city: 'Barishal',
            // //       imageUrl: 'https://picsum.photos/200',
            // //     ),
            // //     ProfileCard(
            // //       rank: '1',
            // //       name: 'Md Sayem',
            // //       city: 'Dhaka',
            // //       imageUrl: 'https://picsum.photos/200',
            // //     ),
            // //     ProfileCard(
            // //       rank: '3',
            // //       name: 'Md Solayman',
            // //       city: 'Khulna',
            // //       imageUrl: 'https://picsum.photos/200',
            // //     ),
            // //   ],
            // // ),
            // SizedBox(height: 20.h),
            // // Leaderboard Section
            // Text('Leader Board',
            //     style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
            // SizedBox(height: 10.h),
            // const LeaderBoardEntry(
            //     position: '1', name: 'Md Sayem', city: 'Dhaka', score: 92),
            // const LeaderBoardEntry(
            //     position: '2',
            //     name: 'Tarikul Islam',
            //     city: 'Barishal',
            //     score: 85),
            // const LeaderBoardEntry(
            //     position: '3', name: 'Md Solayman', city: 'Khulna', score: 84),
            // const LeaderBoardEntry(
            //     position: '4',
            //     name: 'Mohammad Salah',
            //     city: 'Barishal',
            //     score: 70),
            // SizedBox(height: 20.h),
            // // Button Section
            // Center(
            //   child: ElevatedButton(
            //     onPressed: () {
            //       // Navigate to the user's position screen or relevant page
            //     },
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.blue,
            //       padding:
            //           EdgeInsets.symmetric(horizontal: 60.w, vertical: 16.h),
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(25.r)),
            //     ),
            //     child: Text('See My Position',
            //         style: TextStyle(fontSize: 16.sp, color: Colors.white)),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final String rank;
  final String name;
  final String city;
  final String imageUrl;

  const ProfileCard({
    super.key,
    required this.rank,
    required this.name,
    required this.city,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30.w,
          backgroundImage: NetworkImage(imageUrl),
        ),
        SizedBox(height: 10.h),
        Text(name,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
        Text(city, style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
        SizedBox(height: 5.h),
        Text('Rank: $rank',
            style: TextStyle(fontSize: 12.sp, color: Colors.blue)),
      ],
    );
  }
}

class LeaderBoardEntry extends StatelessWidget {
  final String position;
  final String name;
  final String city;
  final int score;

  const LeaderBoardEntry({
    super.key,
    required this.position,
    required this.name,
    required this.city,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 4)
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(position,
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontSize: 16.sp)),
                  Text(city,
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                ],
              ),
            ],
          ),
          Text('$score',
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue)),
        ],
      ),
    );
  }
}
