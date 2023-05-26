import 'package:flutter/material.dart';
import 'package:messenger/navigator/navigator.dart';
import 'package:messenger/provider/provider.dart';
import 'package:messenger/widgets/app/app_data.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Messenger',
      routes: AppNavigation.routes,
      initialRoute:
          Provider.read<AppData>(context)!.apiClient.accessTokenIsEmpty()
              ? AppNavigationRoutes.loginWidget
              : AppNavigationRoutes.chatsWidget,
    );
  }
}
