import 'package:flutter/material.dart';
import 'package:flutter_clean_posts_interview/domain/entities/post.dart';
import 'package:flutter_clean_posts_interview/utilities/auth_service.dart';
import 'package:flutter_clean_posts_interview/di/injection.dart';
import 'package:go_router/go_router.dart';

class PostCard extends StatelessWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  Future<bool> _showPinDialog(BuildContext context) async {
    final controller = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Inserisci PIN'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            obscureText: true,
            decoration: const InputDecoration(hintText: 'Es. 1234'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Annulla'),
            ),
            ElevatedButton(
              onPressed: () {
                final ok = controller.text == '1234';
                Navigator.of(ctx).pop(ok);
              },
              child: const Text('Conferma'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0.5,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          final authService = sl<AuthService>();
          final messenger = ScaffoldMessenger.of(context);
          final router = GoRouter.of(context);

          // Tenta biometria
          final biometricOk = await authService.authenticateBiometrics();
          if (!context.mounted) return;

          bool ok = biometricOk;

          // Se biometria fallisce fallback PIN
          if (!biometricOk) {
            ok = await _showPinDialog(context);
            if (!context.mounted) return;
          }

          // Se fallisce anche il PIN esce snackbar
          if (!ok) {
            messenger.showSnackBar(
              const SnackBar(content: Text('Autenticazione fallita')),
            );
            return;
          }

          // Auth ok vai al dettaglio
          router.pushNamed(
            'postDetail',
            pathParameters: {'id': post.id.toString()},
            extra: post,
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: colorScheme.primary.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  post.id.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      post.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.lock_outline,
                          size: 14,
                          // ignore: deprecated_member_use
                          color: colorScheme.primary.withOpacity(0.8),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Protected details',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                // ignore: deprecated_member_use
                                color: colorScheme.primary.withOpacity(0.9),
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
