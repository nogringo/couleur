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

  void _submitRoom() {
    if (!_isValidRoomName) return;

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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)?.addRoom ?? 'Add Room'),
      content: TextField(
        controller: _roomNameController,
        autofocus: true,
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context)?.roomName ?? 'Room Name',
          hintText:
              AppLocalizations.of(context)?.enterRoomName ?? 'Enter room name',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onSubmitted: (_) => _submitRoom(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel'),
        ),
        FilledButton(
          onPressed: _isValidRoomName ? _submitRoom : null,
          child: Text(AppLocalizations.of(context)?.join ?? 'Join'),
        ),
      ],
    );
  }
}
