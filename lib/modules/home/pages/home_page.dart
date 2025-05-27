import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tea_diary/application/services/cups_service.dart';
import 'package:tea_diary/modules/home/widgets/floating_action_button.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
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
        leading: const SizedBox(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Выпито чашек чая', style: titleTextStyle),
            Text('${ref.watch(cupsProvider)}', style: numberTextStyle),
          ],
        ),
      ),
      floatingActionButton: CustomFloatingActionButton(),
    );
  }
}
