import 'package:get/get.dart';
import 'package:rooster/Models/Handbook.dart';

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

      await Future.delayed(const Duration(seconds: 1));

      handbooks.assignAll([
        Handbook(
          id: '1',
          title: 'Perfecting Crispy Fried Chicken',
          description: 'Master golden, crispy fried chicken every time.',
          thumbnailUrl: 'assets/images/chicken.jpg',
          contentBlocks: [
        
            HandbookContent(
              type: ContentType.image,
              data: 'assets/images/Hygine.jpg',
            ),
                        HandbookContent(
              type: ContentType.text,
              data:
                  'Start by marinating chicken pieces overnight in buttermilk with spices like paprika, garlic powder, and cayenne. This ensures tenderness and flavor deep inside.',
            ),
            HandbookContent(
              type: ContentType.image,
              data: 'assets/images/summer.jpg',
            ),
            HandbookContent(
              type: ContentType.text,
              data:
                  'Prepare seasoned flour coating. Heat oil to 350°F. Fry chicken pieces for 10–12 minutes until golden and crisp.',
            ),
            HandbookContent(
              type: ContentType.video,
              data: 'assets/videos/frying_tutorial.mp4',
            ),
            HandbookContent(
              type: ContentType.text,
              data:
                  'Let fried chicken rest on a wire rack for 5 minutes before serving to retain crispiness.',
            ),
          ],
        ),
        Handbook(
          id: '2',
          title: 'Burger Building Secrets',
          description: 'Stack the perfect burger with sauces, buns, and patties.',
          thumbnailUrl: 'https://source.unsplash.com/300x200/?burger',
          contentBlocks: [
            HandbookContent(
              type: ContentType.text,
              data:
                  'Toast your buns for texture. Start stacking with sauce, lettuce, tomato, and well-seasoned patties.',
            ),
            HandbookContent(
              type: ContentType.image,
              data: 'assets/images/burger_layers.jpg',
            ),
            HandbookContent(
              type: ContentType.text,
              data:
                  'Use a mix of sauces — like ketchup, mustard, and mayo — and press lightly before serving.',
            ),
          ],
        ),
        Handbook(
          id: '3',
          title: 'Essential Kitchen Hygiene',
          description: 'Best practices for a clean and safe kitchen.',
          thumbnailUrl: 'https://source.unsplash.com/300x200/?kitchen-cleaning',
          contentBlocks: [
            HandbookContent(
              type: ContentType.text,
              data:
                  'Always sanitize surfaces before and after food prep. Use separate cutting boards for meats and vegetables.',
            ),
            HandbookContent(
              type: ContentType.image,
              data: 'assets/images/kitchen_hygiene.jpg',
            ),
            HandbookContent(
              type: ContentType.text,
              data:
                  'Wash hands thoroughly, and store ingredients at the correct temperature to avoid contamination.',
            ),
          ],
        ),
        Handbook(
          id: '4',
          title: 'Crafting Signature Sauces',
          description: 'Create unforgettable sauces with flavor layering.',
          thumbnailUrl: 'https://source.unsplash.com/300x200/?sauce',
          contentBlocks: [
            HandbookContent(
              type: ContentType.text,
              data:
                  'Start with a base like mayo, yogurt, or oil. Add flavor boosters — garlic, herbs, chili paste, or vinegar.',
            ),
            HandbookContent(
              type: ContentType.image,
              data: 'assets/images/sauce_making.jpg',
            ),
            HandbookContent(
              type: ContentType.text,
              data:
                  'Balance acidity, sweetness, and spice. Refrigerate sauces before use for better flavor fusion.',
            ),
          ],
        ),
        Handbook(
          id: '5',
          title: 'Grill Mastery 101',
          description: 'Tips for juicy grilled meats and veggies.',
          thumbnailUrl: 'https://source.unsplash.com/300x200/?grilling',
          contentBlocks: [
            HandbookContent(
              type: ContentType.text,
              data:
                  'Preheat grill and clean grates. Use direct heat for searing and indirect heat for slow cooking.',
            ),
            HandbookContent(
              type: ContentType.image,
              data: 'assets/images/grill_tips.jpg',
            ),
            HandbookContent(
              type: ContentType.text,
              data:
                  'Let meat rest after grilling. Use wood chips to infuse smoky flavors.',
            ),
          ],
        ),
        Handbook(
          id: '6',
          title: 'Kitchen Tools & Equipment',
          description: 'A guide to must-have tools for efficiency.',
          thumbnailUrl: 'https://source.unsplash.com/300x200/?kitchen-tools',
          contentBlocks: [
            HandbookContent(
              type: ContentType.text,
              data:
                  'Essential tools include chef’s knife, thermometer, tongs, and non-stick pans. Keep everything clean and sharp.',
            ),
            HandbookContent(
              type: ContentType.image,
              data: 'assets/images/tools.jpg',
            ),
          ],
        ),
        Handbook(
          id: '7',
          title: 'Food Presentation Tips',
          description: 'Serve food that’s camera-ready and clean.',
          thumbnailUrl: 'https://source.unsplash.com/300x200/?food-presentation',
          contentBlocks: [
            HandbookContent(
              type: ContentType.text,
              data:
                  'Use white plates for color contrast. Place the main item off-center and garnish thoughtfully.',
            ),
            HandbookContent(
              type: ContentType.image,
              data: 'assets/images/plating.jpg',
            ),
          ],
        ),
        Handbook(
          id: '8',
          title: 'Burger Sauce Combos That Work',
          description: 'Bold, creamy, sweet, and tangy pairings.',
          thumbnailUrl: 'https://source.unsplash.com/300x200/?burger-sauce',
          contentBlocks: [
            HandbookContent(
              type: ContentType.text,
              data:
                  'Mix mayo with sriracha for heat. Try honey mustard with pickles for tang. Blend ketchup and BBQ for smoky-sweet flavor.',
            ),
          ],
        ),
      ]);
    } finally {
      loading(false);
    }
  }

  void toggleLayout() => isGrid.value = !isGrid.value;
}
