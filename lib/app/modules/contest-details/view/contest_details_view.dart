import 'package:flutter/material.dart';
import 'package:prostuti/app/common/custom_appbar.dart';

class ContestDetailsView extends StatelessWidget {
  const ContestDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.appBar(
          title: "Contest Details",
          actions: null,
          centerTitle: true,
          leadingWidget: const Icon(Icons.arrow_back)),
    );
  }
}
