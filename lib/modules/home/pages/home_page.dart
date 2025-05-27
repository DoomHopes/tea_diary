import 'package:flutter/material.dart';
import 'package:tea_diary/modules/home/widgets/floating_action_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextStyle titleTextStyle = TextStyle(
    fontSize: 25,
  );

  TextStyle numberTextStyle = TextStyle(
    fontSize: 25,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tea Diary'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Выпито чашек чая', style: titleTextStyle),
            Text('0', style: numberTextStyle),
          ],
        ),
      ),
      floatingActionButton: CustomFloatingActionButton(),
    );
  }
}
