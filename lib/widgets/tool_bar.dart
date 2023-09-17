import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../providers/notes.dart';
import '../providers/qoutes.dart';

class ToolBar extends StatefulWidget {
  final Function favToggle;
  const ToolBar({super.key, required this.favToggle});

  @override
  State<ToolBar> createState() => _ToolBarState();
}

class _ToolBarState extends State<ToolBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DrawerButton(
          style: ButtonStyle(
              iconColor: MaterialStatePropertyAll(
                  Theme.of(context).colorScheme.secondary)),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        Row(
          children: [
            IconButton(
                onPressed: () {
                  widget.favToggle();
                },
                icon: Icon(Provider.of<Notes>(context).isShowFavOnly &&
                        Provider.of<Qoutes>(context).isShowFavOnly
                    ? Icons.favorite
                    : Icons.favorite_border),
                color: Theme.of(context).colorScheme.surface),
            IconButton(
                onPressed: () async {
                  await Share.share('the link of the app');
                },
                icon: const Icon(Icons.share),
                color: Theme.of(context).colorScheme.surface),
          ],
        ),
      ],
    );
  }
}
