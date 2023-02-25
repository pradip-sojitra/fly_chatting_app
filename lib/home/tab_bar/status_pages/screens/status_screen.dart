import 'package:flutter/material.dart';
import 'package:fly_chatting_app/models/status_model.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/utils.dart';
import 'package:story_view/widgets/story_view.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({Key? key, required this.status}) : super(key: key);

  final StatusModel status;

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  StoryController controller = StoryController();
  List<StoryItem> storyItems = [];

  @override
  void initState() {
    super.initState();
    initStoryPageItem();
  }

  void initStoryPageItem() {
    for (var statusPhotoUrl in widget.status.photoUrl) {
      storyItems.add(
        StoryItem.pageImage(url: statusPhotoUrl, controller: controller),
      );
    }
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   controller.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: storyItems.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : StoryView(
              storyItems: storyItems,
              controller: controller,
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down) {
                  Navigator.pop(context);
                }
              },
              onComplete: () {
                Navigator.pop(context);
              },
            ),
    );
  }
}
