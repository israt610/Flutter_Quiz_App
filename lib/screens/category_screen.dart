import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/routes.dart';
import '../app/theme.dart';
import '../providers/category_provider.dart';
import '../providers/quiz_provider.dart';
import '../widgets/category_card.dart';
import '../widgets/loading_skeleton.dart';
import '../widgets/retry_banner.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProvider>().fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Consumer<CategoryProvider>(
          builder: (context, categoryProvider, child) {
            if (categoryProvider.isLoading && !categoryProvider.hasCategories) {
              return const LoadingSkeleton(message: 'Loading categories from OpenTDB...');
            }

            if (categoryProvider.error != null && !categoryProvider.hasCategories) {
              return RetryBanner(
                title: 'Unable to Load Categories',
                errorMessage: categoryProvider.error!,
                onRetry: () {
                  categoryProvider.retryFetch();
                },
              );
            }

            final categories = categoryProvider.categories;

            if (categories.isEmpty) {
              return const Center(
                child: Text(
                  'No categories available.',
                  style: TextStyle(fontSize: 16, color: AppTheme.textSecondary),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                
                // Header Area matching Figma Image 2
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.arrow_back_ios, color: AppTheme.textDark, size: 22),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Quizzical",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.textDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "choose a category to focus on:",
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'serif',
                          color: AppTheme.textLight,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Responsive Grid View
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      int crossAxisCount = 2;
                      if (width > 800) {
                        crossAxisCount = 4;
                      } else if (width > 550) {
                        crossAxisCount = 3;
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 18,
                          mainAxisSpacing: 18,
                          childAspectRatio: 0.95,
                        ),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return CategoryCard(
                            category: category,
                            index: index,
                            onTap: () {
                              context.read<QuizProvider>().updateConfig(
                                    categoryId: category.id,
                                    categoryName: category.name,
                                  );
                              Navigator.pushNamed(context, AppRoutes.quizConfig);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
