import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooster/widgets/custom_bottom_nav.dart';

class MainScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? drawer;
  final int? currentIndex;
  final Widget? floatingActionButton;
  final PreferredSizeWidget? customAppBar; 

  const MainScaffold({
    super.key,
    required this.title,
    required this.body,
    this.drawer,
    this.currentIndex,
    this.floatingActionButton,
    this.customAppBar,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: customAppBar ?? AppBar( 
        title: Text(title.tr),
        backgroundColor: theme.primaryColor,
      ),
      drawer: drawer,
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: CustomBottomNavBar(currentIndex: currentIndex),
    );
  }
}
