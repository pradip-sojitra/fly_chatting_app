import 'package:flutter/material.dart';
import 'package:fly_chatting_app/home/tab_bar/status_pages/provider/status_provider.dart';
import 'package:fly_chatting_app/models/status_model.dart';
import 'package:fly_chatting_app/splash_welocome/screens/status_screen.dart';
import 'package:provider/provider.dart';

class StatusContactsScreen extends StatelessWidget {
  const StatusContactsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<StatusModel>>(
      future: context.read<StatusProvider>().getStatus(context: context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            var statusData = snapshot.data![index];
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              StatusScreen(status: statusData),
                        ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      title: Text(
                        statusData.userName,
                        style: const TextStyle(
                          fontFamily: 'Rounded ExtraBold',
                        ),
                      ),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          statusData.profilePic,
                        ),
                        radius: 26,
                      ),
                    ),
                  ),
                ),
                const Divider(
                  indent: 85,
                  height: 4,
                  color: Color(0x0F7ca6fe),
                  thickness: 3,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
