import 'package:rooster/Models/Handbook.dart';
import 'package:get/get.dart';

class HandbookController extends GetxController {
  final handbooks = <Handbook>[].obs;
  final isGrid = false.obs;
  final loading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHandbooks();
  }

  Future<void> fetchHandbooks() async {
    try {
      loading(true);

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // Realistic hardcoded data for restaurant chef handbook
      handbooks.assignAll([
        Handbook(
          id: '1',
          title: 'Perfecting Crispy Fried Chicken',
          description: 'Master golden, crispy, and juicy fried chicken every time.',
          content: 'Full recipe with marination tips, oil temperature, and frying hacks.',
          thumbnailUrl: 'assets/images/chicken.jpg',
        ),
        Handbook(
          id: '2',
          title: 'Burger Building Secrets',
          description: 'Stack the perfect burger with sauces, buns, and grilled patties.',
          content: 'Discover texture balance, patty seasoning, and bun toasting tips.',
          thumbnailUrl: 'https://source.unsplash.com/300x200/?burger',
        ),
        Handbook(
          id: '3',
          title: 'Essential Kitchen Hygiene',
          description: 'Keep your kitchen safe and clean with these best practices.',
          content: 'Cleaning routines, storage guidelines, and safety protocols.',
          thumbnailUrl: 'https://source.unsplash.com/300x200/?kitchen-cleaning',
        ),
        Handbook(
          id: '4',
          title: 'Crafting Signature Sauces',
          description: 'Make unique sauces like spicy BBQ, garlic mayo, and more.',
          content: 'Learn emulsification, flavor balancing, and sauce preservation.',
          thumbnailUrl: 'https://source.unsplash.com/300x200/?sauce',
        ),
        Handbook(
          id: '5',
          title: 'Grill Mastery 101',
          description: 'Tips for juicy grilled chicken, patties, and veggies.',
          content: 'Direct vs indirect heat, smoke flavor, and grill maintenance.',
          thumbnailUrl: 'https://source.unsplash.com/300x200/?grilling',
        ),
        Handbook(
          id: '6',
          title: 'Kitchen Tools & Equipment',
          description: 'A guide to must-have tools in a restaurant kitchen.',
          content: 'Knives, fryers, thermometers, and how to use them effectively.',
          thumbnailUrl: 'https://source.unsplash.com/300x200/?kitchen-tools',
        ),
        Handbook(
          id: '7',
          title: 'Food Presentation Tips',
          description: 'Make your dishes Instagram-worthy and customer-ready.',
          content: 'Plating techniques, garnish tricks, and serving styles.',
          thumbnailUrl: 'https://source.unsplash.com/300x200/?food-presentation',
        ),
        Handbook(
          id: '8',
          title: 'Burger Sauce Combos That Work',
          description: 'Mayo, mustard, pickles — here’s what blends beautifully.',
          content: 'Explore bold, sweet, tangy profiles that boost flavor.',
          thumbnailUrl: 'https://source.unsplash.com/300x200/?burger-sauce',
        ),
      ]);
    } finally {
      loading(false);
    }
  }

  void toggleLayout() => isGrid.value = !isGrid.value;
}
