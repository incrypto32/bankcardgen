import 'package:flutter/material.dart';
import 'package:bcard/widgets/saved_card.dart';

class SavedCardsList extends StatelessWidget {
  const SavedCardsList({
    Key key,
    @required this.pathList,
    @required this.deleteDialog,
  }) : super(key: key);

  final List pathList;

  final Function deleteDialog;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pathList.length,
      itemBuilder: (context, index) {
        return SavedCard(
          path: pathList[index],
          deleteDialog: deleteDialog,
        );
      },
    );
  }
}
