import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key? key,
    required this.message,
    required this.isCurrentUser,
    required this.username,
    required this.userImage,
  }) : super(key: key);
  final String message;
  final bool isCurrentUser;
  final String username;
  final String userImage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: LayoutBuilder(builder: (context, constraints) {
        return Stack(
          children: [
            Row(
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
                      child: Column(
                        crossAxisAlignment: isCurrentUser
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            username,
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: isCurrentUser
                                          ? Colors.white
                                          : Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                          ),
                          Text(
                            message,
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: isCurrentUser
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (!isCurrentUser) const Spacer(),
              ],
            ),
            Positioned(
              top: -32,
              left: isCurrentUser ? null : 0,
              right: isCurrentUser ? 0 : null,
              child: CircleAvatar(
                backgroundImage: NetworkImage(userImage),
              ),
            ),
          ],
          clipBehavior: Clip.none,
        );
      }),
    );
  }
}
