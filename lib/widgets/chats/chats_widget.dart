import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:messenger/navigator/navigator.dart';
import 'package:messenger/provider/provider.dart';
import 'package:messenger/widgets/app/app_data.dart';
import 'package:flutter/material.dart';
import 'package:messenger/widgets/chat_detail/chat_detail_widget.dart';

class ChatsWidget extends StatelessWidget {
  const ChatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: UserChatPage(),
    );
  }
}

class UserChatPage extends StatefulWidget {
  const UserChatPage({super.key});

  @override
  State<UserChatPage> createState() => _UserChatPageState();
}

class _UserChatPageState extends State<UserChatPage> {
  List<int> chats = [];
  List<HomeElement> dataList = [];
  List<bool> favList = [];
  bool searchState = false;
  void _getChats() async {
    try {
      var response =
          await Provider.read<AppData>(context)!.apiClient.getChats();
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseJson = jsonDecode(response.body);
        chats = [];
        for (var item in responseJson) {
          chats.add(item['id']);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${jsonDecode(response.body)['detail']}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } on SocketException {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No internet connection"),
          duration: Duration(seconds: 3),
        ),
      );
    } on TimeoutException {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Reponse time too long"),
          duration: Duration(seconds: 3),
        ),
      );
    } on HttpException {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Http request exception"),
          duration: Duration(seconds: 3),
        ),
      );
    } on FormatException {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Server could not be found'),
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unknwon exception'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _onLogout() async {
    Provider.read<AppData>(context)!.logout();

    Provider.read<AppData>(context)!.setAccessToken('');
    // Provider.read<AppData>(context)!.setUserId('');

    Navigator.of(context).pushReplacementNamed(AppNavigationRoutes.loginWidget);
  }

  @override
  Widget build(BuildContext context) {
    // _getChats();

    var avatar = Provider.follow<AppData>(context)!.userAvatar;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 15, 15, 15),
        title: !searchState
            ? const Text(
                "Messages",
                style: TextStyle(
                  color: Color.fromRGBO(32, 96, 64, 1.0),
                  fontSize: 20,
                ),
              )
            : const TextField(
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 20,
                ),
                cursorColor: Colors.grey,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(
                    Icons.search_outlined,
                    color: Colors.grey,
                  ),
                  hintText: "Search...",
                  hintStyle: TextStyle(
                    color: Colors.white70,
                    fontSize: 20,
                  ),
                ),
              ),
      ),
      backgroundColor: Colors.black,
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 15, 15, 15),
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 200,
              child: Stack(
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text(
                      Provider.follow<AppData>(context)!.name ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                    accountEmail: Text(
                      '@${Provider.follow<AppData>(context)!.username ?? ''}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      image: DecorationImage(
                        image: avatar != null
                            ? Image.memory(avatar).image
                            : const NetworkImage(
                                'https://sun9-52.userapi.com/impg/xbbrspqnMImAobXkRT2CTCEzdTyfOiek_hQrrA/8Lc-ADzH-lc.jpg?size=720x714&quality=95&sign=57b6d5010c7c13412261002fc675fdc2&type=album'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Navigator.of(context)
                          .pushNamed(AppNavigationRoutes.profileWidget),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              iconColor: Colors.white70,
              title: const Text(
                "Profile",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              onTap: () => Navigator.of(context)
                  .pushNamed(AppNavigationRoutes.profileWidget),
            ),
            ListTile(
              leading: const Icon(Icons.group_outlined),
              iconColor: Colors.white70,
              title: const Text(
                "Contacts",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              onTap: () => Navigator.of(context).pushNamed(
                AppNavigationRoutes.contactsWidget,
              ),
            ),
            const Divider(
              height: 10,
              thickness: 3,
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              iconColor: Colors.white70,
              title: const Text(
                "Log out",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              onTap: _onLogout,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .pushNamed(AppNavigationRoutes.createNewChatWidget),
        backgroundColor: const Color.fromARGB(255, 15, 15, 15),
        child: const Icon(Icons.edit),
      ),
      body: const ABOBUS(),
    );
  }

  void SearchMethod(String text) {}
}

/*class CustomSearch extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back_ios_outlined),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const ListTile(
      title: Text(""),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const ListTile(
      title: Text('hui'),
    );
  }
}*/

class HomeElement {
  final String name;
  final Uint8List? image;
  final String message;
  final String messageTime;
  final int chatId;
  final String username;
  final String biography;
  final String userId;
  HomeElement({
    required this.name,
    required this.chatId,
    required this.image,
    required this.message,
    required this.messageTime,
    required this.biography,
    required this.username,
    required this.userId,
  });
}

class ABOBUS extends StatefulWidget {
  const ABOBUS({super.key});

  @override
  State<ABOBUS> createState() => _ABOBUSState();
}

class _ABOBUSState extends State<ABOBUS> {
  late ScrollController _scrollController;
  Set<int> chatsId = {};
  Timer? _timer;
  @override
  void initState() {
    _timer = Timer.periodic(
      const Duration(seconds: 10),
      (timer) async {
        await Provider.read<AppData>(context)!.updateUserChats();
      },
    );
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var userChats = Provider.follow<AppData>(context)!.chatsInfo;
    List<HomeElement> elements = [];
    for (var item in userChats) {
      elements.add(
        HomeElement(
          username: item.username.first,
          biography: item.biography.first,
          chatId: item.chatId,
          name: item.name.first,
          image: item.userAvatar.first,
          message: item.lastMessage,
          messageTime: item.lastMessageTime,
          userId: item.userId.first,
        ),
      );
    }
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 0),
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      itemCount: elements.length,
      itemBuilder: (BuildContext context, int index) {
        var avatar = elements[index].image == null
            ? const NetworkImage(
                'https://sun9-52.userapi.com/impg/xbbrspqnMImAobXkRT2CTCEzdTyfOiek_hQrrA/8Lc-ADzH-lc.jpg?size=720x714&quality=95&sign=57b6d5010c7c13412261002fc675fdc2&type=album')
            : Image.memory(elements[index].image!).image;
        return SizedBox(
          height: 77,
          child: Stack(
            children: [
              Center(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.black87,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage: avatar,
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          elements[index].name,
                          style: const TextStyle(
                              fontSize: 17, color: Color(0xCCCCCCCC)),
                        ),
                        Text(
                          elements[index].messageTime,
                          style: const TextStyle(
                              fontSize: 15, color: Color(0x80808080)),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      elements[index].message,
                      style: const TextStyle(
                          fontSize: 15, color: Color(0x80808080)),
                    ),
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ChatDetailWidget(
                          chatId: elements[index].chatId,
                          name: elements[index].name,
                          image: elements[index].image,
                          username: elements[index].username,
                          biography: elements[index].biography,
                          userId: elements[index].userId,
                        ),
                      ),
                    ),
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CreateNewChat extends StatefulWidget {
  const CreateNewChat({super.key});

  @override
  State<CreateNewChat> createState() => _CreateNewChatState();
}

class _CreateNewChatState extends State<CreateNewChat> {
  bool searchState = false;

  Timer? _timer;
  @override
  void initState() {
    _timer = Timer.periodic(
      const Duration(seconds: 10),
      (timer) async {
        await Provider.read<AppData>(context)!.getUsers();
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onCreateChat(UserInfo user) async {
    if (user.id == Provider.read<AppData>(context)!.apiClient.userId) {
      return;
    }

    try {
      var response = await Provider.read<AppData>(context)!
          .apiClient
          .createChat(user.id ?? '');
      var decodedResponse = jsonDecode(response.body);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ChatDetailWidget(
            chatId: decodedResponse['chat_id'],
            name: user.name ?? '',
            image: user.image,
            username: user.username ?? '',
            biography: user.biography ?? '',
            userId: user.id ?? '',
          ),
        ),
      );
    } on SocketException {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No internet connection"),
          duration: Duration(seconds: 3),
        ),
      );
    } on TimeoutException {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Reponse time too long"),
          duration: Duration(seconds: 3),
        ),
      );
    } on HttpException {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Http request exception"),
          duration: Duration(seconds: 3),
        ),
      );
    } on FormatException {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Server could not be found'),
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unknwon exception'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final users = Provider.follow<AppData>(context)!.users;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 15, 15, 15),
        title: const Text(
          "Users",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color.fromRGBO(32, 96, 64, 1.0),
            fontSize: 20,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(height: 1),
        physics: const BouncingScrollPhysics(),
        itemCount: users.length,
        itemBuilder: (BuildContext context, int index) {
          var avatar = users[index].image == null
              ? const NetworkImage(
                  'https://sun9-52.userapi.com/impg/xbbrspqnMImAobXkRT2CTCEzdTyfOiek_hQrrA/8Lc-ADzH-lc.jpg?size=720x714&quality=95&sign=57b6d5010c7c13412261002fc675fdc2&type=album')
              : Image.memory(users[index].image!).image;
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
                        users[index].username ?? '',
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
                    _onCreateChat(users[index]);
                  }),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
