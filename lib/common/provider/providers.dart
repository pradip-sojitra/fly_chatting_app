import 'package:fly_chatting_app/common/provider/theme_provider.dart';
import 'package:fly_chatting_app/home/tab_bar/calls_pages/provider/calls_provider.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/group_chats/provider/group_chat_provider.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/provider/chat_provider.dart';
import 'package:fly_chatting_app/home/tab_bar/chats_pages/provider/contact_service_provider.dart';
import 'package:fly_chatting_app/home/tab_bar/status_pages/provider/status_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers (){
  return [
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => ContactProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => CallProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => ChatProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => StatusProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => GroupChatProvider(),
    )
  ];
}