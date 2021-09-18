import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key? key,
    required this.message,
    required this.isCurrentUser,
  }) : super(key: key);
  final String message;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: LayoutBuilder(builder: (context, constraints) {
        return Row(
          children: [
            if (isCurrentUser) const Spacer(),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: constraints.maxWidth,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: isCurrentUser ? Colors.blue : Colors.grey,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: !isCurrentUser
                        ? const Radius.circular(0)
                        : const Radius.circular(16),
                    bottomRight: isCurrentUser
                        ? const Radius.circular(0)
                        : const Radius.circular(16),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    message,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: isCurrentUser ? Colors.white : Colors.black87,
                        ),
                  ),
                ),
              ),
            ),
            if (!isCurrentUser) const Spacer(),
          ],
        );
      }),
    );
  }
}
