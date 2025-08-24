import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ndk/ndk.dart';
import 'package:couleur/repository.dart';
import 'package:couleur/l10n/app_localizations.dart';

class AddRoomDialog extends StatefulWidget {
  const AddRoomDialog({super.key});

  @override
  State<AddRoomDialog> createState() => _AddRoomDialogState();
}

class _AddRoomDialogState extends State<AddRoomDialog> {
  final TextEditingController _roomNameController = TextEditingController();
  bool _isValidRoomName = false;

  @override
  void initState() {
    super.initState();
    _roomNameController.addListener(_validateRoomName);
  }

  void _validateRoomName() {
    final roomName = _roomNameController.text.trim();
    setState(() {
      _isValidRoomName = roomName.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _roomNameController.removeListener(_validateRoomName);
    _roomNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)?.addRoom ?? 'Add Room'),
      content: TextField(
        controller: _roomNameController,
        autofocus: true,
        decoration: InputDecoration(
          labelText: 'Room Name',
          hintText:
              AppLocalizations.of(context)?.enterRoomName ?? 'Enter room name',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel'),
        ),
        FilledButton(
          onPressed: _isValidRoomName
              ? () {
                  final roomName = _roomNameController.text.trim();
                  // Add room if it doesn't exist
                  if (!Repository.to.rooms.containsKey(roomName)) {
                    Repository.to.rooms[roomName] = <Nip01Event>[].obs;
                    Repository.to.update();
                  }
                  // Switch to the room (whether new or existing)
                  Repository.to.selectedRoom.value = roomName;
                  Navigator.of(context).pop();
                }
              : null,
          child: Text(AppLocalizations.of(context)?.join ?? 'Join'),
        ),
      ],
    );
  }
}
