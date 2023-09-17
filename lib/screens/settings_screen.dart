import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/qoutes.dart';

import '../providers/notes.dart';
import '../providers/setting.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});
  static const routeName = '/settings';

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late bool isDarkModeEnabled;
  @override
  void didChangeDependencies() async {
    getSwitchMode();
    super.didChangeDependencies();
  }

  void getSwitchMode() async {
    isDarkModeEnabled = Provider.of<Setting>(context).isDarkModeEnabled;
  }

  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: EdgeInsets.all(size.height * 0.02),
          children: [
            Text(
              'Settings',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.left,
            ),
            SizedBox(height: size.height * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Dark mode'),
                Switch(
                  inactiveTrackColor: Colors.white,
                  inactiveThumbColor:
                      isDarkModeEnabled ? Colors.white : Colors.black,
                  value: isDarkModeEnabled,
                  onChanged: (value) {
                    setState(() {
                      setState(() {
                        Provider.of<Setting>(context, listen: false)
                            .modeToggle();
                      });
                    });
                  },
                )
              ],
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Sort by"),
                IconButton(
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  icon: Icon(
                    isExpanded
                        ? LineIcons.chevronCircleUp
                        : LineIcons.chevronCircleDown,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ],
            ),
            if (isExpanded)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      TextButton(
                        style: ButtonStyle(
                            backgroundColor:
                                Provider.of<Setting>(context).getSort == Sort.no
                                    ? MaterialStatePropertyAll(
                                        Theme.of(context).colorScheme.onPrimary)
                                    : null),
                        onPressed: () {
                          Provider.of<Setting>(context, listen: false)
                              .setSort(Sort.no);
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        child: Text(
                          'Default',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      TextButton(
                        style: ButtonStyle(
                            backgroundColor:
                                Provider.of<Setting>(context).getSort ==
                                        Sort.titelAsc
                                    ? MaterialStatePropertyAll(
                                        Theme.of(context).colorScheme.onPrimary)
                                    : null),
                        onPressed: () {
                          Provider.of<Setting>(context, listen: false)
                              .setSort(Sort.titelAsc);
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        child: Text(
                          'Title ASC',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      TextButton(
                        style: ButtonStyle(
                            backgroundColor:
                                Provider.of<Setting>(context).getSort ==
                                        Sort.titelDesc
                                    ? MaterialStatePropertyAll(
                                        Theme.of(context).colorScheme.onPrimary)
                                    : null),
                        onPressed: () {
                          Provider.of<Setting>(context, listen: false)
                              .setSort(Sort.titelDesc);
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        child: Text(
                          'Title DESC',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      TextButton(
                        style: ButtonStyle(
                            backgroundColor:
                                Provider.of<Setting>(context).getSort ==
                                        Sort.createdDateAsc
                                    ? MaterialStatePropertyAll(
                                        Theme.of(context).colorScheme.onPrimary)
                                    : null),
                        onPressed: () {
                          Provider.of<Setting>(context, listen: false)
                              .setSort(Sort.createdDateAsc);
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        child: Text(
                          'Date ASC',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      TextButton(
                        style: ButtonStyle(
                            backgroundColor:
                                Provider.of<Setting>(context).getSort ==
                                        Sort.createdDateDesc
                                    ? MaterialStatePropertyAll(
                                        Theme.of(context).colorScheme.onPrimary)
                                    : null),
                        onPressed: () {
                          Provider.of<Setting>(context, listen: false)
                              .setSort(Sort.createdDateDesc);
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        child: Text(
                          'Date DESC',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            SizedBox(
              height: size.height * 0.02,
            ),
            const SizedBox(
              width: double.infinity,
              child: Text(
                'Preview',
                textAlign: TextAlign.left,
              ),
            ),
            const Divider(),
            Consumer<Setting>(
              child: Text(
                'Note',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              builder: (context, setting, ch) => Padding(
                padding: EdgeInsets.only(left: size.width * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ch!,
                    Row(
                      children: [
                        IconButton(
                          style: ButtonStyle(
                              backgroundColor: setting.getNotePreview ==
                                      NotePreview.grid
                                  ? MaterialStatePropertyAll(
                                      Theme.of(context).colorScheme.onPrimary)
                                  : null),
                          onPressed: () {
                            setState(() {
                              setting.setNotePreview(NotePreview.grid);
                            });
                          },
                          icon: const Icon(LineIcons.table),
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        IconButton(
                          style: ButtonStyle(
                              backgroundColor: setting.getNotePreview ==
                                      NotePreview.list
                                  ? MaterialStatePropertyAll(
                                      Theme.of(context).colorScheme.onPrimary)
                                  : null),
                          onPressed: () {
                            setState(() {
                              setting.setNotePreview(NotePreview.list);
                            });
                          },
                          icon: const Icon(LineIcons.list),
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Consumer<Setting>(
              child: Text(
                'Quote',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              builder: (context, setting, ch) => Padding(
                padding: EdgeInsets.only(left: size.width * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ch!,
                    Row(
                      children: [
                        IconButton(
                          style: ButtonStyle(
                              backgroundColor: setting.getQuotePreview ==
                                      QuotePreview.list
                                  ? MaterialStatePropertyAll(
                                      Theme.of(context).colorScheme.onPrimary)
                                  : null),
                          onPressed: () {
                            setting.setQoutePreview(QuotePreview.list);
                          },
                          icon: const Icon(LineIcons.list),
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        IconButton(
                          style: ButtonStyle(
                              backgroundColor: setting.getQuotePreview ==
                                      QuotePreview.grid
                                  ? MaterialStatePropertyAll(
                                      Theme.of(context).colorScheme.onPrimary)
                                  : null),
                          onPressed: () {
                            setState(() {
                              setting.setQoutePreview(QuotePreview.grid);
                            });
                          },
                          icon: const Icon(LineIcons.table),
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            const SizedBox(
              width: double.infinity,
              child: Text(
                'Sync & Backup',
                textAlign: TextAlign.left,
              ),
            ),
            const Divider(),
            Padding(
              padding: EdgeInsets.only(left: size.width * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sync all',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  IconButton(
                      onPressed: () {
                        Provider.of<Notes>(context, listen: false).uploadAll(
                            Provider.of<Notes>(context, listen: false).notes);
                        Provider.of<Qoutes>(context, listen: false).uploadAll(
                            Provider.of<Qoutes>(context, listen: false).qoutes);

                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Uploaded succesfuly!')));
                      },
                      icon: const Icon(LineIcons.syncIcon),
                      color: Theme.of(context).colorScheme.surface),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: size.width * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Backup',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  IconButton(
                      onPressed: () {
                        Provider.of<Notes>(context, listen: false)
                            .fetchAndSetFromServer();
                        Provider.of<Qoutes>(context, listen: false)
                            .fetchAndSetFromServer();

                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Downloaded succesfuly!')));
                      },
                      icon: const Icon(LineIcons.download),
                      color: Theme.of(context).colorScheme.surface),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Share',
                    textAlign: TextAlign.left,
                  ),
                  IconButton(
                      onPressed: () {
                        Share.share('Link of the app');
                      },
                      icon: const Icon(LineIcons.share),
                      color: Theme.of(context).colorScheme.surface),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            const SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Version',
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    '1.0.0',
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: double.infinity,
              child: Text(
                'About us',
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.1, vertical: size.height * 0.02),
              width: double.infinity,
              child: Text(
                'My name is yaikob zeray. I\'m a student of Software Engineering I can develop different apps with high quality and  beauty!',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    LineIcons.facebookMessenger,
                    size: 20.0,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    LineIcons.github,
                    size: 20.0,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    LineIcons.instagram,
                    size: 20.0,
                    color: Color.fromARGB(255, 255, 193, 7),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    LineIcons.linkedin,
                    size: 20.0,
                    color: Color.fromARGB(255, 7, 160, 255),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
