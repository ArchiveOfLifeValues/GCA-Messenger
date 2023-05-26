import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:messenger/provider/provider.dart';
import 'package:messenger/widgets/app/app_data.dart';
import 'package:messenger/widgets/friend/user_info_widget.dart';

class UserInfoWidget extends StatefulWidget {
  const UserInfoWidget({
    super.key,
    required this.name,
    required this.biography,
    required this.username,
    required this.userAvatar,
    required this.id,
  });
  final String? id;
  final Uint8List? userAvatar;
  final String? name;
  final String? username;
  final String? biography;
  @override
  State<UserInfoWidget> createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends State<UserInfoWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x33333333),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: const Color.fromARGB(255, 15, 15, 15),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Color.fromRGBO(32, 96, 64, 1.0),
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 350,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    image: DecorationImage(
                      image: widget.userAvatar != null
                          ? Image.memory(widget.userAvatar!).image
                          : const NetworkImage(
                              'https://sun9-52.userapi.com/impg/xbbrspqnMImAobXkRT2CTCEzdTyfOiek_hQrrA/8Lc-ADzH-lc.jpg?size=720x714&quality=95&sign=57b6d5010c7c13412261002fc675fdc2&type=album'),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const ListTile(
              title: Text(
                'Info',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              textColor: Color(0xFF00DD98),
            ),
            const SizedBox(
              height: 7,
            ),
            MyTextWidget(
              title: widget.name ?? "",
              iconData: Icons.person_sharp,
            ),
            const SizedBox(
              height: 7,
            ),
            MyTextWidget(
              title: widget.username ?? "",
              iconData: Icons.alternate_email_outlined,
            ),
            const SizedBox(
              height: 7,
            ),
            MyTextWidget(
                title: widget.biography ?? "",
                iconData: Icons.menu_book_outlined),
            const SizedBox(height: 40),
            FriendButtonWidget(userId: widget.id!),
          ],
        ),
      ),
    );
  }
}

class MyTextWidget extends StatefulWidget {
  const MyTextWidget({super.key, required this.title, required this.iconData});
  final String title;
  final IconData iconData;
  @override
  State<MyTextWidget> createState() => _MyTextWidgetState();
}

class _MyTextWidgetState extends State<MyTextWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 8.0, top: 4.0, right: 8.0, bottom: 4.0),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(13, 32, 22, 1),
              spreadRadius: 0.3,
              blurRadius: 10,
            ),
          ],
        ),
        child: ListTile(
          title: Text(
            widget.title,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 18),
          ),
          leading: Icon(
            widget.iconData,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}

class FriendButtonWidget extends StatefulWidget {
  const FriendButtonWidget({super.key, required this.userId});

  final String userId;
  @override
  State<FriendButtonWidget> createState() => _FriendButtonWidgetState();
}

class _FriendButtonWidgetState extends State<FriendButtonWidget> {
  bool _isFriend = false;
  Color _buttonColor = const Color(0xFF00DD98);

  void _toggleFriendship() async {
    if (_isFriend) {
      await Provider.read<AppData>(context)!
          .apiClient
          .deleteFriend(widget.userId);
    } else {
      await Provider.read<AppData>(context)!.apiClient.addFriend(widget.userId);
    }

    setState(() {
      _isFriend = !_isFriend;
      _buttonColor =
          _isFriend ? const Color(0xFFff0000) : const Color(0xFF00DD98);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _toggleFriendship,
      style: ElevatedButton.styleFrom(
        backgroundColor: _buttonColor,
        textStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(15), // Задаем радиус закругления углов
        ),
        fixedSize: const Size(310, 50),
      ),
      child: Text(
        _isFriend ? 'Remove contact' : 'Add contact',
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
    );
  }
}
