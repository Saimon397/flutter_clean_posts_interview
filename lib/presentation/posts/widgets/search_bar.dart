import 'package:flutter/material.dart';

class PostSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String query) onSearch;
  final VoidCallback onClear;
  final bool isLoading;

  const PostSearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
    required this.onClear,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: colorScheme.surfaceContainerHighest.withOpacity(0.7),
        borderRadius: BorderRadius.circular(999),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Icon(Icons.search, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Cerca post...',
                border: InputBorder.none,
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: onSearch,
            ),
          ),
          if (controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: () {
                controller.clear();
                onClear();
              },
            )
          else if (isLoading)
            const SizedBox(
              width: 18,
              height: 18,
              child: Padding(
                padding: EdgeInsets.all(2.0),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
    );
  }
}
