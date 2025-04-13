import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PreviewScreen extends StatelessWidget {
  final Map<String, List<Map<String, dynamic>>> subjectsData;

  const PreviewScreen({Key? key, required this.subjectsData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () => Get.back(),
        ),
        title: Text('Review Custom Exam',
            style: TextStyle(color: Colors.black, fontSize: 18.sp)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.grey[100],
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text('Subject',
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w500)),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Topic',
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w500)),
                ),
                Expanded(
                  child: Text('Questions',
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: subjectsData.length,
              itemBuilder: (context, index) {
                String subject = subjectsData.keys.elementAt(index);
                List<Map<String, dynamic>> topics = subjectsData[subject]!;
                int subjectTotal = topics.fold(
                    0, (sum, topic) => sum + (topic['questionCount'] as int));

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...topics.map((topic) => Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 8.h),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Text(subject,
                                      style: TextStyle(fontSize: 14.sp))),
                              Expanded(
                                  flex: 2,
                                  child: Text(topic['topicName'] as String,
                                      style: TextStyle(fontSize: 14.sp))),
                              Expanded(
                                  child: Text(
                                      topic['questionCount'].toString(),
                                      style: TextStyle(fontSize: 14.sp))),
                            ],
                          ),
                        )),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                      child: Row(
                        children: [
                          const Spacer(flex: 3),
                          Expanded(
                              child: Text(subjectTotal.toString(),
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ),
                    Divider(),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Questions',
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w600)),
                    Text(
                        '${subjectsData.values.fold(0, (sum, topics) => sum + topics.fold(0, (sum, topic) => sum + (topic['questionCount'] as int)))}',
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w600)),
                  ],
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle continue action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text('Continue',
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
