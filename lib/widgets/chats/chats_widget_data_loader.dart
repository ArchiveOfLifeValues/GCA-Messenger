import 'package:flutter/material.dart';
import 'package:messenger/widgets/chats/chats_widget_data.dart';
import 'package:messenger/widgets/chats/chats_widget.dart';
import 'package:messenger/provider/provider.dart';

class ChatsWidgetDataLoader extends StatefulWidget {
  const ChatsWidgetDataLoader({super.key});

  @override
  State<ChatsWidgetDataLoader> createState() => _ChatsWidgetDataLoaderState();
}

class _ChatsWidgetDataLoaderState extends State<ChatsWidgetDataLoader> {
  @override
  Widget build(BuildContext context) {
    var chatWidgetData = ChatsWidgetData(context);

    return Provider(
      notifier: chatWidgetData,
      child: const ChatsWidget(),
    );
  }
}
