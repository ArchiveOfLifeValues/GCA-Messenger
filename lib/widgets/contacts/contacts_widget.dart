import 'package:flutter/material.dart';
import 'dart:async';
import 'package:messenger/provider/provider.dart';
import 'package:messenger/widgets/app/app_data.dart';

import 'package:messenger/widgets/friend/user_info_widget.dart';

class ContactsWidget extends StatefulWidget {
  const ContactsWidget({super.key});

  @override
  State<ContactsWidget> createState() => _ContactsWidgetState();
}

class _ContactsWidgetState extends State<ContactsWidget> {
  bool searchState = false;
  List<UserInfo> contacts = [];
  Timer? _timer;
  @override
  void initState() {
    _timer = Timer.periodic(
      const Duration(seconds: 2),
      (timer) async {
        await Provider.read<AppData>(context)!.getUserFriends();
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
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 15, 15, 15),
        title: const Text(
          "Contacts",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color.fromRGBO(32, 96, 64, 1.0),
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Widget getBody() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          getContactLists(),
        ],
      ),
    );
  }

  Widget getContactLists() {
    final friendsIds = Provider.follow<AppData>(context)!.friends;
    final List<UserInfo> friends = [];
    for (var itemId in friendsIds) {
      for (var item in Provider.read<AppData>(context)!.users) {
        if (item.id == itemId) {
          friends.add(item);
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        children: List.generate(
          contacts.length,
          (index) {
            var avatar = friends[index].image == null
                ? const NetworkImage(
                    'https://sun9-52.userapi.com/impg/xbbrspqnMImAobXkRT2CTCEzdTyfOiek_hQrrA/8Lc-ADzH-lc.jpg?size=720x714&quality=95&sign=57b6d5010c7c13412261002fc675fdc2&type=album')
                : Image.memory(friends[index].image!).image;
            return SizedBox(
              height: 70,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 5, left: 10, right: 10, top: 5),
                    child: Row(
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(40)),
                            image: DecorationImage(
                              image: avatar,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          friends[index].username ?? '',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UserInfoWidget(
                            name: friends[index].name,
                            biography: friends[index].biography,
                            username: friends[index].username,
                            userAvatar: friends[index].image,
                            id: friends[index].id,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            );
          },
          // return const Column(
          // children: [
          //   Row(
          //     children: [
          //       CircleAvatar(
          //         backgroundImage: NetworkImage(
          //             'https://sun9-52.userapi.com/impg/xbbrspqnMImAobXkRT2CTCEzdTyfOiek_hQrrA/8Lc-ADzH-lc.jpg?size=720x714&quality=95&sign=57b6d5010c7c13412261002fc675fdc2&type=album'),
          //       ),
          //       SizedBox(
          //         width: 12,
          //       ),
          //       Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text(
          //             'name',
          //             style: TextStyle(
          //               fontSize: 17,
          //               color: Color(0xCCCCCCCC),
          //               fontWeight: FontWeight.w500,
          //             ),
          //           ),
          //         ],
        ),
      ),
    );
  }
}
