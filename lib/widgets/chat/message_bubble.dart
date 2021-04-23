import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String userName;
  final String userImage;
  final bool isMe;
  final Key key;

  MessageBubble(this.message, this.userName, this.userImage, this.isMe,
      {this.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [buildMessageContainer(context)],
      ),
      Positioned(
        top: 0,
          left:!isMe ? 120 : null ,
          right: isMe ? 120 : null,
          child: CircleAvatar(backgroundImage: NetworkImage(userImage),)),
    ]);
  }

  Container buildMessageContainer(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: isMe ? Colors.grey[300] : Theme.of(context).accentColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
            bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(14),
            bottomRight: isMe ? Radius.circular(0) : Radius.circular(14),
          )),
      width: 140,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          buildUserNameText(context),
          buildMessageText(context),
        ],
      ),
    );
  }

  Text buildMessageText(BuildContext context) {
    return Text(
      message,
      style: TextStyle(
        color: isMe
            ? Colors.black
            : Theme.of(context).accentTextTheme.headline6.color,
      ),
      textAlign: isMe ? TextAlign.end : TextAlign.start,
    );
  }

  Text buildUserNameText(BuildContext context) {
    return Text(
      userName,
      style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isMe
              ? Colors.black
              : Theme.of(context).accentTextTheme.headline6.color),
    );
  }
}
