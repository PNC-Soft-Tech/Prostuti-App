import 'package:flutter/material.dart';

import 'package:get/get.dart';


class TeXPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Render HTML + LaTeX with TeXView"),
      ),
      body: Center(
        child: 
        // Obx(() {  return 
        Column(
          children: [
       
            // TeXView(
            //     child: TeXViewDocument(
            //        """
            //   <div>
            //     <p>This is a simple HTML paragraph.</p>
        
            //     <p>Another LaTeX example: 
            //       \\(\\int_{0}^{\\infty} e^{-x^2} dx\\)
            //     </p>
            //     <p>Here is more HTML content.</p>
            //   </div>
            //   """,
            //       style: const TeXViewStyle(
            //         textAlign: TeXViewTextAlign.left,
            //       ),
            //     ),
            //     loadingWidgetBuilder: (_) => const CircularProgressIndicator(),
            //   ),
            // TeXView(
            //     child: TeXViewDocument(
            //        """
            //   <div>
            //     <p>This is a simple HTML paragraph.</p>
        
            //     <p>Another LaTeX example: 
            //       \\(\\int_{0}^{\\infty} e^{-x^2} dx\\)
            //     </p>
            //     <p>Here is more HTML content.</p>
            //   </div>
            //   """,
            //       style: const TeXViewStyle(
            //         textAlign: TeXViewTextAlign.left,
            //       ),
            //     ),
            //     loadingWidgetBuilder: (_) => const CircularProgressIndicator(),
            //   ),
               
          ],
        )
        // }),
      ),
    );
  }
}
