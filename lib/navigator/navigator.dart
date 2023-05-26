// import 'package:messenger/widgets/chats/chats_widget_data_loader.dart';
import 'package:messenger/widgets/chats/chats_widget.dart';
import 'package:messenger/widgets/contacts/contacts_widget.dart';
import 'package:messenger/widgets/login/login_widget.dart';
import 'package:messenger/widgets/profile/profile_widget.dart';
import 'package:messenger/widgets/register/register_widget.dart';
import 'package:messenger/widgets/set_user_info/set_user_info_widget.dart';

abstract class AppNavigationRoutes {
  static const loginWidget = '/login';
  static const registerWidget = '/register';
  static const chatsWidget = '/chats';
  static const profileWidget = '/profile';
  static const createNewChatWidget = '$chatsWidget/createNewChat';
  static const setUserInfoWidget = '/setUserInfo';
  static const contactsWidget = '/contacts';
  // static const userInfoWidget = ''
  // static const chatDetailWidget = '$chatsWidget/chatDetail';
}

abstract class AppNavigation {
  //static const initialRoute = AppNavigationRoutes.loginWidget;
  static final routes = {
    AppNavigationRoutes.loginWidget: (context) => const LoginWidget(),
    AppNavigationRoutes.registerWidget: (context) => const RegisterWidget(),
    AppNavigationRoutes.chatsWidget: (context) => const ChatsWidget(),
    AppNavigationRoutes.profileWidget: (context) => const ProfileWidget(),
    AppNavigationRoutes.contactsWidget: (context) => const ContactsWidget(),
    AppNavigationRoutes.createNewChatWidget: (context) => const CreateNewChat(),
    AppNavigationRoutes.setUserInfoWidget: (context) =>
        const SetUserInfoWidget(),
    //AppNavigationRoutes.chatDetailWidget: (context) => const ChatDetailWidget(),
  };
}
