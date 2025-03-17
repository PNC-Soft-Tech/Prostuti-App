import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/custom_simple_appbar.dart';
import '../controllers/model_test_details_controller.dart';

class ModelTestDetailsView extends GetView<ModelTestDetailsController> {
  const ModelTestDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomSimpleAppBar.appBar(title: "Model Details"),
      body: Stack(
        children: []));
  }
}


