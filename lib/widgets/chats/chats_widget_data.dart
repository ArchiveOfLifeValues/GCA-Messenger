import 'package:flutter/material.dart';
import 'package:messenger/provider/provider.dart';
import 'package:messenger/widgets/app/app_data.dart';
import 'dart:convert';

class ChatsWidgetData extends ChangeNotifier {
  List<dynamic> users = [];

  ChatsWidgetData(BuildContext context) {
    getUsers(context);
  }

  Future<void> getUsers(BuildContext context) async {
    var response =
        await Provider.read<AppData>(context)!.apiClient.getAllUsers();
    users = jsonDecode(response.body);
    notifyListeners();
  }
}
