import 'package:flutter/material.dart';
import 'package:messenger/widgets/app/app.dart';
import 'package:messenger/provider/provider.dart';
import 'package:messenger/widgets/app/app_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('');
  var appData = AppData();
  await appData.loadUserdata();

  runApp(
    Provider(
      notifier: appData,
      child: Builder(
        builder: (BuildContext context) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: const App(),
          );
        },
      ),
    ),
  );
}
