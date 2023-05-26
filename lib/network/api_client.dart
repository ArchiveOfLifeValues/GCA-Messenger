import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static const _host = 'https://42af-46-56-241-89.ngrok-free.app';
  String? _accessToken;
  String? _userId;

  String? get userId => _userId;

  void setAccessToken(String accessToken) {
    _accessToken = accessToken;
  }

  void setUserId(String userId) {
    _userId = userId;
  }

  bool accessTokenIsEmpty() {
    return _accessToken?.isEmpty ?? true;
  }

  Future<http.Response> logout() async {
    const String authPath = '/auth/jwt/logout';
    Map<String, String> headers = {'Authorization': 'Bearer $_accessToken'};

    final response = await http.post(
      Uri.parse(_host + authPath),
      headers: headers,
    );

    return response;
  }

  Future<http.Response> login(String username, String password) async {
    const String authPath = '/auth/jwt/login';
    Map<String, String> headers = {
      'content-type': 'application/x-www-form-urlencoded'
    };
    String body =
        "grant_type=&username=$username&password=$password&scope=&client_id=&client_secret=";

    final response = await http.post(
      Uri.parse(_host + authPath),
      headers: headers,
      body: body,
    );

    return response;
  }

  Future<http.Response> register(String username, String password) async {
    const String registerPath = '/auth/register';

    Map<String, String> headers = {'Content-Type': 'application/json'};

    var body = jsonEncode({
      'email': username,
      'password': password,
      'is_active': true,
      'is_superuser': false,
      'is_verified': false,
    });

    final response = http.post(
      Uri.parse(_host + registerPath),
      headers: headers,
      body: body,
    );

    return response;
  }

  Future<http.StreamedResponse> setAvatar(String imagePath) async {
    const String setAvatarPath = '/user/photo/set';

    Map<String, String> headers = {
      'Authorization': 'Bearer $_accessToken',
      'Content-Type': 'multipart/form-data'
    };

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(_host + setAvatarPath),
    );

    request.headers.addAll(headers);
    request.files.add(
      await http.MultipartFile.fromPath(
        'photo',
        imagePath,
        //contentType: Media('image', 'png'),
      ),
    );

    request.fields['user'] = _userId!;
    final response = await request.send();
    return response;
  }

  Future<http.Response> getUserAvatar(String userId) async {
    const String getPhotoPath = '/user/photo/get';
    final response =
        await http.get(Uri.parse('$_host$getPhotoPath?user_id=$userId'));
    return response;
  }

  Future<http.Response> getMe() async {
    const String getMePath = '/users/me';
    Map<String, String> headers = {'Authorization': 'Bearer $_accessToken'};
    final response = http.get(
      Uri.parse(_host + getMePath),
      headers: headers,
    );
    return response;
  }

  Future<http.Response> getAllUsers() async {
    const String getAllUsersPath = '/user/all';
    final response = await http.get(Uri.parse(_host + getAllUsersPath));
    return response;
  }

  Future<http.Response> getUserInfo(String userId) async {
    const String getUserInfoPath = '/user/info/get';
    final response =
        await http.get(Uri.parse('$_host$getUserInfoPath?user_id=$userId'));
    return response;
  }

  Future<http.Response> updateUserInfo(
      String name, String username, String biography) async {
    const String getUpdateUserInfoPath = '/user/info/update';
    Map<String, String> headers = {
      'Authorization': 'Bearer $_accessToken',
      'Content-Type': 'application/json',
    };

    final body =
        jsonEncode({"username": username, "name": name, "bio": biography});
    final response = await http.patch(Uri.parse(_host + getUpdateUserInfoPath),
        headers: headers, body: body);
    return response;
  }

  Future<http.Response> setUserInfo(
      String name, String username, String biography) async {
    const String setUserInfoPath = '/user/info/set';
    Map<String, String> headers = {
      'Authorization': 'Bearer $_accessToken',
      'Content-Type': 'application/json',
    };

    final body =
        jsonEncode({"username": username, "name": name, "bio": biography});
    final response = await http.post(Uri.parse(_host + setUserInfoPath),
        headers: headers, body: body);
    return response;
  }

  Future<http.Response> createChat(String secondUserId) async {
    const String createChatPath = '/chat/create';
    Map<String, String> headers = {
      'Authorization': 'Bearer $_accessToken',
      'Content-Type': 'application/json',
    };
    final response = await http.get(
        Uri.parse('$_host$createChatPath?second_user=$secondUserId'),
        headers: headers);
    return response;
  }

  Future<http.Response> getChats() async {
    const String getChatsPath = '/chat/get';
    Map<String, String> headers = {
      'Authorization': 'Bearer $_accessToken',
      'Content-Type': 'application/json',
    };
    final response =
        await http.get(Uri.parse(_host + getChatsPath), headers: headers);
    return response;
  }

  Future<http.Response> getChatMembers(int chatId) async {
    final String getChatPath = '/chat/$chatId/members';
    Map<String, String> headers = {
      'Authorization': 'Bearer $_accessToken',
      'Content-Type': 'application/json',
    };
    final response =
        await http.get(Uri.parse(_host + getChatPath), headers: headers);
    return response;
  }

  Future<http.Response> getChatMessages(int chatId) async {
    final String getChatPath = '/chat/$chatId/messages';
    Map<String, String> headers = {
      'Authorization': 'Bearer $_accessToken',
      'Content-Type': 'application/json',
    };
    final response =
        await http.get(Uri.parse(_host + getChatPath), headers: headers);
    return response;
  }

  Future<http.Response> addFriend(String friendId) async {
    const String addFriendPath = '/friends/add';
    Map<String, String> headers = {
      'Authorization': 'Bearer $_accessToken',
      'Content-Type': 'application/json',
    };
    final response = await http.post(
        Uri.parse('$_host$addFriendPath?friend_id=$friendId'),
        headers: headers);
    return response;
  }

  Future<http.Response> getFriends() async {
    const String getFriendsPath = '/friends/add';
    Map<String, String> headers = {
      'Authorization': 'Bearer $_accessToken',
      'Content-Type': 'application/json',
    };
    final response =
        await http.get(Uri.parse(_host + getFriendsPath), headers: headers);
    return response;
  }

  Future<http.Response> deleteFriend(String friendId) async {
    const String deleteFriendPath = '/friends/add';
    Map<String, String> headers = {
      'Authorization': 'Bearer $_accessToken',
      'Content-Type': 'application/json',
    };
    final response = await http.delete(
        Uri.parse('$_host$deleteFriendPath?user_id=$friendId'),
        headers: headers);
    return response;
  }

  Future<http.Response> sendMessage(int chatId, String message) async {
    const String sendMessagePath = '/chat/send';
    var body = jsonEncode(
      {
        'message': message,
        'chat_id': chatId,
        'sent_at': DateTime.now().toString(),
      },
    );
    Map<String, String> headers = {
      'Authorization': 'Bearer $_accessToken',
      'Content-Type': 'application/json',
    };
    var response = await http.post(
      Uri.parse(_host + sendMessagePath),
      headers: headers,
      body: body,
    );
    return response;
  }
}
