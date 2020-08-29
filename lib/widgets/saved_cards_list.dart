import 'dart:io';

import 'package:bankcardmaker/providers/state_provider.dart';
import 'package:bankcardmaker/widgets/saved_card.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedCardsList extends StatelessWidget {
  const SavedCardsList({
    Key key,
    @required this.pathList,
    @required this.shareSheet,
    @required this.deleteDialog,
  }) : super(key: key);

  final List pathList;
  final Function shareSheet;
  final Function deleteDialog;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pathList.length,
      itemBuilder: (context, index) {
        return SavedCard(
            pathList: pathList,
            shareSheet: shareSheet,
            deleteDialog: deleteDialog,
            index: index);
      },
    );
  }
}
