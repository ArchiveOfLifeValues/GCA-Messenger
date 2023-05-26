import 'package:flutter/material.dart';
import 'package:messenger/provider/provider.dart';
import 'package:messenger/widgets/app/app_data.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'dart:io';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  bool textFieldState = false;
  void _onAddAvatar() async {
    const params = OpenFileDialogParams(
      dialogType: OpenFileDialogType.image,
      sourceType: SourceType.photoLibrary,
    );

    final filePath = await FlutterFileDialog.pickFile(params: params);
    var file = File(filePath!);
    var image = await file.readAsBytes();
    Provider.read<AppData>(context)!.setAvatar(image);
    await Provider.read<AppData>(context)!.apiClient.setAvatar(filePath);
  }

  @override
  Widget build(BuildContext context) {
    var avatar = Provider.follow<AppData>(context)!.userAvatar;
    var username = Provider.follow<AppData>(context)!.username;
    var name = Provider.follow<AppData>(context)!.name;
    var biography = Provider.follow<AppData>(context)!.biography;
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
                      image: avatar != null
                          ? Image.memory(avatar).image
                          : const NetworkImage(
                              'https://sun9-52.userapi.com/impg/xbbrspqnMImAobXkRT2CTCEzdTyfOiek_hQrrA/8Lc-ADzH-lc.jpg?size=720x714&quality=95&sign=57b6d5010c7c13412261002fc675fdc2&type=album'),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 7,
                  right: 0,
                  left: 340,
                  child: FloatingActionButton(
                    // style: const ButtonStyle(
                    //   backgroundColor: MaterialStatePropertyAll(Colors.black87),
                    // ),
                    backgroundColor: const Color.fromARGB(255, 0, 187, 128),
                    onPressed: _onAddAvatar,
                    child: const Icon(
                      Icons.add_a_photo_outlined,
                      color: Colors.black87,
                      size: 27,
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
                'Account',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              textColor: Color(0xFF00DD98),
            ),
            const SizedBox(
              height: 7,
            ),
            MyTextWidget(
              onSubmitted: (value) {
                Provider.read<AppData>(context)!.setName(value);
              },
              title: name ?? "",
              subtitle: 'Tap on change name',
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
              subtitle: 'Tap on change username',
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
                subtitle: 'Tap on change biography',
                iconData: Icons.menu_book_outlined),
            const SizedBox(height: 40),
            // ElevatedButton(
            //   onPressed: () {
            //     Provider.read<AppData>(context)!.setUserInfo();
            //   }, //_saveEddits,
            //   style: ElevatedButton.styleFrom(
            //       textStyle: const TextStyle(
            //         color: Colors.black,
            //         fontWeight: FontWeight.bold,
            //         fontSize: 16,
            //       ),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(
            //             15), // Задаем радиус закругления углов
            //       ),
            //       fixedSize: const Size(310, 50),
            //       backgroundColor: const Color(0xFF00DD98)),
            //   child: const Text(
            //     "Save changes",
            //     style: TextStyle(color: Colors.black),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  // itemProfile(String title, String subtitle, IconData iconData) {
  //   return Padding(
  //     padding:
  //         const EdgeInsets.only(left: 8.0, top: 4.0, right: 8.0, bottom: 4.0),
  //     child: Container(
  //       height: 70,
  //       decoration: BoxDecoration(
  //         color: Colors.grey[900],
  //         borderRadius: BorderRadius.circular(15),
  //         boxShadow: const [
  //           BoxShadow(
  //               // offset: Offset(0, 5),
  //               color: Color.fromRGBO(13, 32, 22, 1),
  //               spreadRadius: 0.3,
  //               blurRadius: 10),
  //         ],
  //       ),
  //       child: ListTile(
  //         title: Text(
  //           title,
  //           style: TextStyle(color: Colors.grey.shade500, fontSize: 18),
  //         ),
  //         subtitle: Text(
  //           subtitle,
  //           style: TextStyle(color: Colors.grey.shade700),
  //         ),
  //         leading: Icon(
  //           iconData,
  //           color: Colors.grey,
  //         ),
  //         trailing: const Icon(
  //           Icons.arrow_forward_ios_outlined,
  //           color: Colors.grey,
  //         ),
  //         onTap: () => setState(
  //           () {
  //             textFieldState = !textFieldState;
  //           },
  //         ),
  //       ),
  //     ),
  //   );
  // }
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
