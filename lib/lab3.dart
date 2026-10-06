
import 'package:flutter/material.dart';

/// Lab 3 recipe category page.
/// StatelessWidget because the page content does not change.
class Lab3Page extends StatelessWidget {
  const Lab3Page({super.key});

  /// Creates a row of circular food images with text.
  /// The text can be centered or placed at the bottom.
  Widget makeRow(
      String title,
      List<String> images,
      List<String> words,
      bool centerText,
      ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(images.length, (index) {
        return Expanded(
          child: Semantics(
            label: '$title: ${words[index]}',
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double size =
                (constraints.maxWidth - 8).clamp(40.0, 110.0).toDouble();

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: size,
                      height: size,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: size / 2,
                            backgroundImage:
                            AssetImage(images[index]),
                          ),
                          if (centerText)
                            Text(
                              words[index].toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: size * 0.15,
                                shadows: const [
                                  Shadow(
                                    color: Colors.black,
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (!centerText)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          words[index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        );
      }),
    );
  }

  /// Creates a category heading.
  Widget heading(String title) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        letterSpacing: 3,
      ),
    );
  }

  /// Builds the page using a Column with 8 children.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 20,
                  ),
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      heading('BROWSE CATEGORIES'),

                      const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 25,
                        ),
                        child: Text(
                          "Not sure about exactly which recipe "
                              "you're looking for? Do a search, or "
                              "dive into our most popular categories.",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 17),
                        ),
                      ),

                      heading('BY MEAT'),

                      makeRow(
                        'Meat',
                        [
                          'images/beef.jpg',
                          'images/chicken.jpg',
                          'images/pork.jpg',
                          'images/seafood.jpg',
                        ],
                        [
                          'Beef',
                          'Chicken',
                          'Pork',
                          'Seafood',
                        ],
                        true,
                      ),

                      heading('BY COURSE'),

                      makeRow(
                        'Course',
                        [
                          'images/main.jpg',
                          'images/salad.jpg',
                          'images/side.jpg',
                          'images/crockpot.jpg',
                        ],
                        [
                          'Main Dishes',
                          'Salad Recipes',
                          'Side Dishes',
                          'Crockpot',
                        ],
                        false,
                      ),

                      heading('BY DESSERT'),

                      makeRow(
                        'Dessert',
                        [
                          'images/icecream.jpg',
                          'images/brownies.jpg',
                          'images/pies.jpg',
                          'images/cookies.jpg',
                        ],
                        [
                          'Ice Cream',
                          'Brownies',
                          'Pies',
                          'Cookies',
                        ],
                        false,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
