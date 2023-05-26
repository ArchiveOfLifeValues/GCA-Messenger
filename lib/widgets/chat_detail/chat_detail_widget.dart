import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:messenger/provider/provider.dart';
import 'package:messenger/widgets/app/app_data.dart';
import 'dart:async';

import 'package:messenger/widgets/friend/user_info_widget.dart';

class ChatDetailWidget extends StatefulWidget {
  final String name;
  final String username;
  final String biography;
  final Uint8List? image;
  final int chatId;
  final String userId;
  const ChatDetailWidget({
    Key? key,
    required this.biography,
    required this.username,
    required this.chatId,
    required this.name,
    required this.image,
    required this.userId,
  }) : super(key: key);

  @override
  State<ChatDetailWidget> createState() => _ChatDetailWidgetState();
}

class _ChatDetailWidgetState extends State<ChatDetailWidget> {
  final _sendMessageController = TextEditingController();
  final _messagesScrollController = ScrollController();
  Timer? _timer;
  @override
  void initState() {
    Provider.read<AppData>(context)!.updateUserChats();
    _timer = Timer.periodic(
      const Duration(seconds: 2),
      (timer) async {
        await Provider.read<AppData>(context)!
            .updateChatMessages(widget.chatId);
      },
    );
    // _messagesScrollController.animateTo(
    //   _messagesScrollController.position.maxScrollExtent,
    //   duration: const Duration(milliseconds: 300),
    //   curve: Curves.easeOut,
    // );
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: getAppBar(),
      ),
      //bottomNavigationBar: getBottomBar(),
      body: Column(
        children: [
          Expanded(child: getBody()),
          getBottomBar(),
        ],
      ),
    );
  }

  void _onSend() async {
    final message = _sendMessageController.text;
    _sendMessageController.text = '';
    await Provider.read<AppData>(context)!.apiClient.sendMessage(
          widget.chatId,
          message.trim(),
        );
  }

  Widget getBottomBar() {
    return
        // var size = MediaQuery.of(context).size;
        // decoration: InputDecoration(),
        // padding: EdgeInsets.only(bottom: 0),
        Padding(
      padding: const EdgeInsets.all(0.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _sendMessageController,
              maxLines: 4,
              minLines: 1,
              mouseCursor: MaterialStateMouseCursor.clickable,
              textAlignVertical: TextAlignVertical.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w300),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                hintText: 'Message',
                hintStyle: TextStyle(color: Colors.grey.shade800),
                fillColor: Colors.grey.shade900,
                filled: true,
                isCollapsed: false,
                border: InputBorder.none,
                suffixIcon: IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  padding: const EdgeInsets.only(bottom: 0, right: 4.0),
                  icon: const Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Colors.grey,
                    size: 25,
                  ),
                  onPressed: () {
                    _onSend();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getAppBar() {
    var avatar = widget.image == null
        ? const NetworkImage(
            'https://sun9-52.userapi.com/impg/xbbrspqnMImAobXkRT2CTCEzdTyfOiek_hQrrA/8Lc-ADzH-lc.jpg?size=720x714&quality=95&sign=57b6d5010c7c13412261002fc675fdc2&type=album')
        : Image.memory(widget.image!).image;
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.grey[900],
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.name,
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.arrow_back_ios_new_outlined,
          color: Colors.white,
        ),
      ),
      actions: [
        // child: Stack(
        //   alignment: Alignment.centerRight,
        //   children: [
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.grey[900]),
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            foregroundColor: MaterialStateProperty.all(Colors.transparent),
          ),
          onPressed: () => {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UserInfoWidget(
                  name: widget.name,
                  biography: widget.biography,
                  username: widget.username,
                  userAvatar: widget.image,
                  id: widget.userId,
                ),
              ),
            ),
          },
          child: CircleAvatar(
            maxRadius: 24,
            backgroundImage: avatar,
          ),
        ),
        // Material(
        //   color: Colors.transparent,
        //   child: InkWell(
        //     onTap: () => {
        //       Navigator.of(context).push(
        //         MaterialPageRoute(
        //           builder: (context) => UserInfoWidget(
        //             name: widget.name,
        //             biography: widget.biography,
        //             username: widget.username,
        //             userAvatar: widget.image,
        //           ),
        //         ),
        //       ),
        //     },
        //   ),
        // ),
        //   ],
        // ),
      ],
    );
  }

  Widget getBody() {
    try {
      var chatList =
          Provider.follow<AppData>(context)!.chatMessage[widget.chatId];
      // _messagesScrollController.animateTo(
      //   _messagesScrollController.position.maxScrollExtent,
      //   duration: Duration(milliseconds: 300),
      //   curve: Curves.easeOut,
      // );
      return ListView(
        physics: const BouncingScrollPhysics(),
        controller: _messagesScrollController,
        padding: const EdgeInsets.only(top: 20, bottom: 10),
        children: List.generate(
          chatList!.length,
          (index) {
            return CustomChat(
              isMe: chatList[index].senderId ==
                  Provider.read<AppData>(context)!.apiClient.userId,
              message: chatList[index].message,
              time: chatList[index].messageTime,
              isLast: false,
            );
          },
        ),
      );
    } catch (e) {
      // Handle the exception
      return const Center(
        child: Text(
          'Error loading chat messages',
          style: TextStyle(fontSize: 16),
        ),
      );
    }
  }
}

class CustomChat extends StatelessWidget {
  final bool isMe;
  final String message;
  final String time;
  final bool isLast;

  const CustomChat(
      {Key? key,
      required this.isMe,
      required this.message,
      required this.time,
      required this.isLast})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (isMe) {
      if (!isLast) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 2),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(6)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, top: 5, bottom: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          message,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          time,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.1)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      } else {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
                child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 14, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    time,
                    style: TextStyle(
                        fontSize: 12,
                        color: const Color(0xFFFFFFFF).withOpacity(0.4)),
                  ),
                ],
              ),
            )),
            // )
          ],
        );
      }
    } else {
      if (!isLast) {
        return Row(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 2),
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFF161616),
                      borderRadius: BorderRadius.circular(6)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, top: 5, bottom: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message,
                          style: const TextStyle(
                              fontSize: 16, color: Color(0xFFFFFFFF)),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 12,
                            color: const Color(0xFFFFFFFF).withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      } else {
        return Row(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(right: 20, left: 14, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      style: const TextStyle(
                          fontSize: 16, color: Color(0xFFFFFFFF)),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      time,
                      style: TextStyle(
                          fontSize: 12,
                          color: const Color(0xFFFFFFFF).withOpacity(0.4)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }
    }
  }
}
