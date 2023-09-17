import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/notes.dart';
import '../providers/qoutes.dart';
import '../providers/setting.dart';
import '../screens/settings_screen.dart';

class NDrawer extends StatefulWidget {
  final Function favToggel;
  const NDrawer({super.key, required this.favToggel});

  @override
  State<NDrawer> createState() => _NDrawerState();
}

class _NDrawerState extends State<NDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _getUserData();

    super.didChangeDependencies();
  }

  void _getUserData() async {
    await Provider.of<Auth>(context, listen: false).getUserDataFromPreference();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Drawer(
      backgroundColor: Theme.of(context).drawerTheme.backgroundColor,
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          Stack(
            children: [
              SizedBox(
                  height: size.height * 0.3,
                  width: double.infinity,
                  child: Provider.of<Setting>(context).isDarkModeEnabled
                      ? Image.asset(
                          'asset/svg/logo-white.png',
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'asset/svg/logo-color.png',
                          fit: BoxFit.cover,
                        )),
              Positioned(
                bottom: size.width * 0.05,
                left: size.width * 0.05,
                child: Text(
                  'Hey Capture Your Thoughts!',
                  style: Theme.of(context).textTheme.titleSmall,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.03),
          ListTile(
            leading: CircleAvatar(
              foregroundColor: Theme.of(context).colorScheme.surface,
              child: SvgPicture.asset(
                'asset/svg/account.svg',

                // ignore: deprecated_member_use
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            title: Text(
              Provider.of<Auth>(context).userName,
              style: Theme.of(context).textTheme.titleMedium,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              Provider.of<Auth>(context).userEmail,
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Divider(),
          ListTile(
            onTap: () async {
              Future.delayed(const Duration(milliseconds: 70), () {
                Provider.of<Notes>(context, listen: false).showAll();
                Provider.of<Qoutes>(context, listen: false).showAll();
                Navigator.of(context).pop();
              });
            },
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  LineIcons.bookOpen,
                  size: size.width * 0.05,
                ),
                SizedBox(
                  width: size.width * 0.02,
                ),
                Text(
                  'All',
                  style: Theme.of(context).textTheme.titleMedium,
                )
              ],
            ),
          ),
          ListTile(
            onTap: () async {
              Future.delayed(const Duration(milliseconds: 70), () {
                Navigator.of(context)
                    .pop(Future.delayed(const Duration(milliseconds: 75), () {
                  widget.favToggel();
                }));
              });
            },
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.favorite_rounded,
                  size: size.width * 0.05,
                ),
                SizedBox(
                  width: size.width * 0.02,
                ),
                Text(
                  'Favorites',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          ListTile(
            onTap: () async {
              Future.delayed(const Duration(milliseconds: 70), () {
                Provider.of<Notes>(context, listen: false).showUploaded();
                Provider.of<Qoutes>(context, listen: false).showUploaded();
                Navigator.of(context).pop();
              });
            },
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.upload_rounded,
                  size: size.width * 0.05,
                ),
                SizedBox(
                  width: size.width * 0.02,
                ),
                Text(
                  'Uploaded',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          ListTile(
            onTap: () async {
              Future.delayed(const Duration(milliseconds: 70), () async {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(Settings.routeName);
              });
            },
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.settings,
                  size: size.width * 0.05,
                ),
                SizedBox(
                  width: size.width * 0.02,
                ),
                Text(
                  'Settings',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          ListTile(
            onTap: () async {
              Future.delayed(const Duration(milliseconds: 70), () async {
                Navigator.of(context).pop();
                await Provider.of<Auth>(context, listen: false).logout();
              });
            },
            splashColor: Theme.of(context).colorScheme.onBackground,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.logout,
                  size: size.width * 0.05,
                ),
                SizedBox(
                  width: size.width * 0.02,
                ),
                Text(
                  'Logout',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          SizedBox(
            height: size.height * 0.05,
          ),
          const Divider(),
          SizedBox(
            height: size.height * 0.02,
          ),
        ],
      ),
    );
  }
}
