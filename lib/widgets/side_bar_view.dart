import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:couleur/repository.dart';
import 'package:couleur/widgets/add_room_dialog.dart';

class SideBarView extends StatelessWidget {
  const SideBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      width: 250,
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.4),
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: GetBuilder<Repository>(
              builder: (c) {
                // Get starred rooms
                final starredRoomNames = c.starredRooms.toList();
                
                // Get popular rooms from repository
                final popularRoomNames = c.getPopularRooms();
                
                return ListView(
                  children: [
                    if (starredRoomNames.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Text(
                          'Starred',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      ...starredRoomNames.map(
                        (roomName) => RoomTileView(roomName: roomName),
                      ),
                    ],
                    if (popularRoomNames.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Text(
                          'Popular',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      ...popularRoomNames.map(
                        (roomName) => RoomTileView(roomName: roomName),
                      ),
                    ],
                    SizedBox(height: 32),
                  ],
                );
              },
            ),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: FloatingActionButton.small(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AddRoomDialog(),
                );
              },
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}

class RoomTileView extends StatelessWidget {
  final String roomName;

  const RoomTileView({super.key, required this.roomName});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelectedRoom = Repository.to.selectedRoom.value == roomName;
      return Opacity(
        opacity: 0.8,
        child: ListTile(
          title: Text("#$roomName"),
          selected: isSelectedRoom,
          trailing: Icon(
            Repository.to.isRoomStarred(roomName) ? Icons.star_rounded : null,
          ),
          onTap: isSelectedRoom
              ? null
              : () => Repository.to.selectedRoom.value = roomName,
        ),
      );
    });
  }
}
