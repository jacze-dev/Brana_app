import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/qoutes.dart';

import '../providers/notes.dart';

// ignore: must_be_immutable
class SearchScreren extends StatefulWidget {
  late int tab;
  SearchScreren({super.key, required this.tab});
  static const routeName = '/screen';

  @override
  State<SearchScreren> createState() => _SearchScrerenState();
}

class _SearchScrerenState extends State<SearchScreren> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
      color: Theme.of(context).colorScheme.background,
      child: TextField(
        onChanged: (value) {
          setState(() {
            if (widget.tab == 0) {
              Provider.of<Notes>(context, listen: false).search(value);
            }
            if (widget.tab == 1) {
              Provider.of<Qoutes>(context, listen: false).search(value);
            }
          });
        },
        style: TextStyle(height: size.height * 0.001),
        decoration: InputDecoration(
            fillColor: Theme.of(context).colorScheme.onBackground,
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(size.height * 0.02),
                borderSide: BorderSide.none),
            hintText: 'Search..',
            hintStyle: Theme.of(context).textTheme.bodyMedium,
            prefixIcon: const Icon(Icons.search),
            prefixIconColor: Theme.of(context).colorScheme.surface),
      ),
    );
  }
}
