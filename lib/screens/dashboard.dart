import 'package:brana_app/widgets/tool_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../screens/search_screen.dart';
import '../widgets/drawer.dart';

import '../widgets/qoute_holder.dart';
import '../widgets/note_holder.dart';
import 'edit_new_screen.dart';
import '../providers/notes.dart';
import '../providers/qoutes.dart';

class DashBoard extends StatefulWidget {
  static var routeName = '/dashboard';
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> with TickerProviderStateMixin {
  late final TabController _tabController;

  var numNotes = 0;
  var numQoutes = 0;
  bool onfav = false;
  bool isInNote = true;

  late Notes notesProvider;
  late Qoutes qoutesProvider;

  late Future<void> fetchqoute;

  @override
  void didChangeDependencies() {
    numNotes = Provider.of<Notes>(context).notes.length;
    numQoutes = Provider.of<Qoutes>(context).qoutes.length;
    notesProvider = Provider.of<Notes>(context, listen: false);
    qoutesProvider = Provider.of<Qoutes>(context, listen: false);

    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    // fetchData();
  }

  void favToggel() {
    setState(() {
      onfav = !onfav;
      Provider.of<Notes>(context, listen: false).showFavtoggel();
      Provider.of<Qoutes>(context, listen: false).showFavToggel();
    });
  }

  // Future<void> fetchData() async {
  //   await notesProvider.fetchAndSet();
  // }
  void shareApp() {
    setState(() {
      Share.share('hello');
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: NDrawer(favToggel: favToggel),
      body: SafeArea(
        child: Column(
          children: [
            ToolBar(favToggle: favToggel),
            SizedBox(
              height: size.height * 0.04,
            ),
            SearchScreren(
              tab: _tabController.index,
            ),
            SizedBox(
              height: size.height * 0.04,
            ),
            TabBar.secondary(
              controller: _tabController,
              tabs: [
                Tab(
                  child: Text(
                    "Notes",
                    style: _tabController.index == 0
                        ? Theme.of(context).textTheme.titleMedium
                        : Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Tab(
                  child: Text(
                    "Quotes",
                    style: _tabController.index == 1
                        ? Theme.of(context).textTheme.titleMedium
                        : Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const <Widget>[
                  NoteHolder(),
                  QuoteHolder(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          elevation: 2,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(size.height * 0.1)),
          backgroundColor: Theme.of(context).colorScheme.onBackground,
          foregroundColor: Theme.of(context).colorScheme.surface,
          onPressed: () {
            if (_tabController.index == 0) {
              Navigator.of(context).pushNamed(EditNewScreen.routeName,
                  arguments: {'isNote': true, 'id': ''});
            }
            if (_tabController.index == 1) {
              Navigator.of(context).pushNamed(EditNewScreen.routeName,
                  arguments: {'isNote': false, 'id': ''});
            }
          },
          child: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.surface,
          )),
    );
  }
}
