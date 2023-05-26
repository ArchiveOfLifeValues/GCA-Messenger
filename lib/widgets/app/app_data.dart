import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:messenger/network/api_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppData extends ChangeNotifier {
  late ApiClient apiClient;
  Uint8List? _userAvatar;
  String? _userId;
  final _storage = const FlutterSecureStorage();
  String? _name;
  String? _username;
  String? _biography;
  List<UserInfo> users = [];
  bool _shouldPath = false;
  Uint8List? get userAvatar => _userAvatar;
  List<ChatInfo> chatsInfo = [];
  Map<int, List<ChatMessage>> chatMessage = {};
  List<String> friends = [];

  AppData() {
    apiClient = ApiClient();
    getUsers();
  }

  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  void setUsername(String username) {
    _username = username;
    notifyListeners();
  }

  void setBiography(String biography) {
    _biography = biography;
    notifyListeners();
  }

  void setAvatar(Uint8List avatar) {
    _userAvatar = avatar;
    notifyListeners();
  }

  String? get name => _name;
  String? get username => _username;
  String? get biography => _biography;

  Future<void> setAccessToken(String accessToken) async {
    apiClient.setAccessToken(accessToken);
    await _storage.write(key: 'access_token', value: accessToken);
  }

  Future<void> setUserId(String userId) async {
    apiClient.setUserId(userId);
    await _storage.write(key: 'user_id', value: userId);
    _userId = userId;
  }

  Future<void> loadUserdata() async {
    String? accessToken = await _storage.read(key: 'access_token');
    apiClient.setAccessToken(accessToken ?? '');

    String? userId = await _storage.read(key: 'user_id');
    apiClient.setUserId(userId ?? '');
    _userId = userId;

    if (_userId != null) {
      var response = await apiClient.getUserAvatar(userId!);
      _userAvatar = response.bodyBytes;
      await getUserAvatar();
      if (_biography == null && _name == null && _username == null) {
        _shouldPath = false;
      }
      await getUserData();

      response = await apiClient.getChats();
      var decodedResponse = jsonDecode(response.body);
      chatsInfo = [];
      chatMessage = {};
      for (var chatId in decodedResponse) {
        await updateChatMessages(chatId['id']);
        var chatMessages = chatMessage[chatId['id']] ?? [];

        var chatMembersResponse = await apiClient.getChatMembers(chatId['id']);
        var decodedChatMembersResponse = jsonDecode(chatMembersResponse.body);
        List<Uint8List> userAvatars = [];
        List<String> names = [];
        List<String> usernames = [];
        List<String> biographies = [];
        List<String> userIds = [];
        for (var memberId in decodedChatMembersResponse) {
          if (memberId['user_id'] != apiClient.userId) {
            var memberInfoResponse =
                await apiClient.getUserInfo(memberId['user_id']);
            var decodedMemberInfoResponse = jsonDecode(memberInfoResponse.body);
            var image = await apiClient.getUserAvatar(memberId['user_id']);
            userAvatars.add(image.bodyBytes);
            names.add(
              decodedMemberInfoResponse['name'],
            );
            usernames.add(
              decodedMemberInfoResponse['username'],
            );
            biographies.add(
              decodedMemberInfoResponse['bio'],
            );
            userIds.add(memberId['user_id']);
          }
        }

        chatsInfo.add(
          ChatInfo(
            chatId: chatId['id'],
            lastMessage: chatMessages.isNotEmpty
                ? chatMessages.last.message
                : 'No messages',
            lastMessageTime:
                chatMessages.isNotEmpty ? chatMessages.last.messageTime : '',
            userAvatar: userAvatars,
            name: names,
            username: usernames,
            biography: biographies,
            userId: userIds,
          ),
        );
      }
    }
    notifyListeners();
  }

  Future<void> getUserAvatar() async {
    var response = await apiClient.getUserAvatar(_userId!);
    _userAvatar = response.bodyBytes;

    notifyListeners();
  }

  Future<void> getUsers() async {
    var response = await apiClient.getAllUsers();
    var decodedResponse = jsonDecode(response.body);
    // users = [];
    users.clear();
    for (var item in decodedResponse) {
      var userId = item['id'];
      var userResponse = await apiClient.getUserInfo(userId);
      var decodedUserResponse = jsonDecode(userResponse.body);
      var userAvatarResponse = await apiClient.getUserAvatar(userId);
      var userAvatar = userAvatarResponse.bodyBytes;
      var newUser = UserInfo(
          id: decodedResponse['id'],
          name: decodedUserResponse['name'],
          username: decodedUserResponse['username'],
          biography: decodedUserResponse['bio'],
          image: userAvatar);
      if (!users.contains(newUser)) {
        users.add(newUser);
      }
    }
    notifyListeners();
  }

  Future<void> getUserFriends() async {
    var response = await apiClient.getAllUsers();
    var decodedResponse = jsonDecode(response.body);
    friends.clear();
    for (var item in decodedResponse) {
      friends.add(
          item['user_1_id'] == _userId ? item['user_2_id'] : item['user_1_id']);
    }
  }

  Future<void> getUserData() async {
    var response = await apiClient.getUserInfo(_userId!);
    var userData = jsonDecode(response.body);
    _username = userData['username'];
    _name = userData['name'];
    _biography = userData['bio'];
  }

  Future<void> setUserInfo() async {
    if (_shouldPath) {
      await apiClient.updateUserInfo(
          _name ?? '', _username ?? '', _biography ?? '');
    } else {
      _shouldPath = true;
      await apiClient.setUserInfo(
          _name ?? '', _username ?? '', _biography ?? '');
    }
  }

  String _dateToString(DateTime dateTime) {
    var minute = dateTime.minute < 10
        ? '0${dateTime.minute.toString()}'
        : dateTime.minute.toString();
    return "${dateTime.hour}:$minute";
  }

  Future<void> updateUserChats() async {
    var response = await apiClient.getChats();
    var decodedResponse = jsonDecode(response.body);
    //chatsInfo = [];
    chatsInfo.clear();

    ///chatMessage = {};
    for (var chatId in decodedResponse) {
      var chatMessages = chatMessage[chatId['id']] ?? [];

      var chatMembersResponse = await apiClient.getChatMembers(chatId['id']);
      var decodedChatMembersResponse = jsonDecode(chatMembersResponse.body);
      List<Uint8List> userAvatars = [];
      List<String> names = [];
      List<String> usernames = [];
      List<String> biographies = [];
      List<String> userIds = [];
      for (var memberId in decodedChatMembersResponse) {
        if (memberId['user_id'] != apiClient.userId) {
          var memberInfoResponse =
              await apiClient.getUserInfo(memberId['user_id']);
          var decodedMemberInfoResponse = jsonDecode(memberInfoResponse.body);
          var image = await apiClient.getUserAvatar(memberId['user_id']);
          userAvatars.add(image.bodyBytes);
          names.add(
            decodedMemberInfoResponse['name'],
          );
          usernames.add(
            decodedMemberInfoResponse['username'],
          );
          biographies.add(
            decodedMemberInfoResponse['bio'],
          );
          userIds.add(memberId['user_id']);
        }
      }
      var newChatInfo = ChatInfo(
        chatId: chatId['id'],
        userId: userIds,
        lastMessage:
            chatMessages.isNotEmpty ? chatMessages.last.message : 'No messages',
        lastMessageTime:
            chatMessages.isNotEmpty ? chatMessages.last.messageTime : '',
        userAvatar: userAvatars,
        name: names,
        username: usernames,
        biography: biographies,
      );
      if (!chatsInfo.contains(newChatInfo)) {
        chatsInfo.add(newChatInfo);
      }
    }
    notifyListeners();
  }

  Future<void> updateChatMessages(int chatId) async {
    var chatMessagesResponse = await apiClient.getChatMessages(chatId);
    var decodedChatMessagesResponse = jsonDecode(chatMessagesResponse.body);
    chatMessage.clear();
    for (var messageItem in decodedChatMessagesResponse) {
      final dateTimeString = messageItem['sent_at'];
      DateTime dateTime = DateTime.parse(dateTimeString);
      String timeString = _dateToString(dateTime);
      var newChatMessages = ChatMessage(
          message: messageItem['message'],
          messageTime: timeString,
          senderId: messageItem['sender_id']);
      if (chatMessage[chatId] == null) {
        chatMessage[chatId] = [];
      }
      if (!chatMessage[chatId]!.contains(newChatMessages)) {
        chatMessage[chatId]!.add(newChatMessages);
      }
    }
    notifyListeners();
  }

  Future<void> logout() async {
    await apiClient.logout();
    _shouldPath = false;
    _userId = "";
    _userAvatar = null;
    users = [];
    chatsInfo = [];
    chatMessage = {};
    apiClient.setUserId(_userId!);
    notifyListeners();
  }
}

class ChatInfo {
  final int chatId;
  final List<Uint8List?> userAvatar;
  final List<String> name;
  final String lastMessage;
  final String lastMessageTime;
  final List<String> username;
  final List<String> biography;
  final List<String> userId;
  ChatInfo({
    required this.chatId,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.userAvatar,
    required this.name,
    required this.username,
    required this.biography,
    required this.userId,
  });
}

class ChatMessage {
  final String messageTime;
  final String senderId;
  final String message;
  ChatMessage({
    required this.message,
    required this.messageTime,
    required this.senderId,
  });
}

class UserInfo {
  final String? id;
  final String? name;
  final String? username;
  final String? biography;
  final Uint8List? image;
  UserInfo({
    required this.id,
    required this.name,
    required this.username,
    required this.biography,
    required this.image,
  });
}
