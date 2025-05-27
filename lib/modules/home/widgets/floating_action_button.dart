import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tea_diary/application/services/cups_service.dart';

class CustomFloatingActionButton extends ConsumerStatefulWidget {
  const CustomFloatingActionButton({super.key});

  @override
  ConsumerState<CustomFloatingActionButton> createState() => _FloatingActionButtonState();
}

class _FloatingActionButtonState extends ConsumerState<CustomFloatingActionButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        ref.read(cupsService).add(1);
      },
      child: Icon(
        Icons.add,
      ),
    );
  }
}
