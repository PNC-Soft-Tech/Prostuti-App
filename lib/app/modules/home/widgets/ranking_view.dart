import 'package:flutter/material.dart';

class RankingView extends StatefulWidget {
  const RankingView({super.key});

  @override
  State<RankingView> createState() => _RankingViewState();
}

class _RankingViewState extends State<RankingView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Hello Ranking'),
    );
  }
}
