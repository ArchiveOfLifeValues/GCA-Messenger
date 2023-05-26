import 'package:flutter/material.dart';
import 'package:messenger/navigator/navigator.dart';
import 'package:messenger/widgets/app/app_data.dart';
import 'package:messenger/provider/provider.dart';

class SetUserInfoWidget extends StatefulWidget {
  const SetUserInfoWidget({super.key});

  @override
  State<SetUserInfoWidget> createState() => _SetUserInfoWidgetState();
}

class _SetUserInfoWidgetState extends State<SetUserInfoWidget> {
  @override
  Widget build(BuildContext context) {
    //var avatar = Provider.follow<AppData>(context)!.userAvatar;
    var username = Provider.follow<AppData>(context)!.username;
    var name = Provider.follow<AppData>(context)!.name;
    var biography = Provider.follow<AppData>(context)!.biography;
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 200),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Good to see you on GCA Messenger',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFF00DD98),
                    fontWeight: FontWeight.w300,
                    fontSize: 40),
              ),
              const SizedBox(
                height: 100.0,
              ),
              const Text(
                'Please enter your details',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color(0xFF00DD98),
                    fontWeight: FontWeight.w300,
                    fontSize: 22),
              ),
              const SizedBox(
                height: 7,
              ),
              MyTextWidget(
                onSubmitted: (value) {
                  Provider.read<AppData>(context)!.setName(value);
                },
                title: name ?? "",
                subtitle: 'Tap on set name',
                iconData: Icons.person_sharp,
              ),
              const SizedBox(
                height: 7,
              ),
              MyTextWidget(
                onSubmitted: (value) {
                  Provider.read<AppData>(context)!.setUsername(value);
                },
                title: username ?? "",
                subtitle: 'Tap on set username',
                iconData: Icons.alternate_email_outlined,
              ),
              const SizedBox(
                height: 7,
              ),
              MyTextWidget(
                  onSubmitted: (value) {
                    Provider.read<AppData>(context)!.setBiography(value);
                  },
                  title: biography ?? "",
                  subtitle: 'Tap on set biography',
                  iconData: Icons.menu_book_outlined),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(AppNavigationRoutes.chatsWidget);
                },
                style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(
                      color: Color(0xFF00DD98),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10), // Задаем радиус закругления углов
                    ),
                    fixedSize: const Size(300, 50),
                    backgroundColor: const Color(0xFF00DD98)),
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyTextWidget extends StatefulWidget {
  const MyTextWidget(
      {super.key,
      required this.onSubmitted,
      required this.title,
      required this.subtitle,
      required this.iconData});
  final Function onSubmitted;
  final String title;
  final String subtitle;
  final IconData iconData;
  @override
  State<MyTextWidget> createState() => _MyTextWidgetState();
}

class _MyTextWidgetState extends State<MyTextWidget> {
  bool isEditing = false;
  TextEditingController textEditingController = TextEditingController();
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
          title: isEditing
              ? TextField(
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 18),
                  cursorColor: Colors.grey,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: const InputDecoration(border: InputBorder.none),
                  controller: textEditingController,
                  onSubmitted: (value) {
                    setState(
                      () {
                        Provider.read<AppData>(context)!.setUserInfo();
                        isEditing = false;
                        widget.onSubmitted(textEditingController.text);
                      },
                    );
                  },
                )
              : Text(
                  widget.title,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 18),
                ),
          subtitle: isEditing
              ? null
              : Text(
                  widget.subtitle,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
          leading: Icon(
            widget.iconData,
            color: Colors.grey,
          ),
          onTap: () {
            setState(() {
              isEditing = !isEditing;
              if (isEditing) {
                textEditingController.text = widget.title;
                FocusScope.of(context).requestFocus(FocusScopeNode());
              }
            });
          },
        ),
      ),
    );
  }
}
