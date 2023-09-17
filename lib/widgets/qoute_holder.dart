import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../widgets/qoutecard.dart';

import '../helpers/dialog_helper.dart';
import '../providers/qoutes.dart';
import '../providers/setting.dart';

class QuoteHolder extends StatefulWidget {
  const QuoteHolder({super.key});

  @override
  State<QuoteHolder> createState() => _QuoteHolderState();
}

class _QuoteHolderState extends State<QuoteHolder> {
  late Future<void> fetchQuote;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: Provider.of<Qoutes>(context, listen: false)
            .fetchAndSet(Provider.of<Setting>(context).sort),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Consumer<Qoutes>(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'asset/svg/empty_wallet.svg',
                      // ignore: deprecated_member_use
                      color: Theme.of(context).colorScheme.secondary,
                      height: size.height * 0.1,
                    ),
                    const Text('Got no quotes yet, start adding some!'),
                  ],
                ),
              ),
              builder: (context, qoutes, ch) {
                return qoutes.qoutes.isEmpty
                    ? ch!
                    : Provider.of<Setting>(context).getQuotePreview ==
                            QuotePreview.grid
                        ? GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisExtent: size.height * 0.25),
                            itemCount: qoutes.qoutes.length,
                            padding: EdgeInsets.all(size.width * 0.03),
                            itemBuilder: (BuildContext context, int index) {
                              return QouteCard(
                                id: qoutes.qoutes[index].id,
                                title: qoutes.qoutes[index].title,
                                qoute: qoutes.qoutes[index].qoute,
                                qoutedBy: qoutes.qoutes[index].qoutedBy,
                                createdDate: qoutes.qoutes[index].createdDate,
                                updatedDate: qoutes.qoutes[index].updatedDate,
                                isFav: qoutes.qoutes[index].isFav,
                                isPinned: qoutes.qoutes[index].isPinned,
                                isUploaded: qoutes.qoutes[index].isUploaded,
                                fun: DialogHelper.showOptionDialog,
                              );
                            },
                          )
                        : ListView.builder(
                            padding: EdgeInsets.all(size.width * 0.03),
                            itemCount: qoutes.qoutes.length,
                            itemBuilder: (context, index) {
                              return QouteCard(
                                id: qoutes.qoutes[index].id,
                                title: qoutes.qoutes[index].title,
                                qoute: qoutes.qoutes[index].qoute,
                                qoutedBy: qoutes.qoutes[index].qoutedBy,
                                createdDate: qoutes.qoutes[index].createdDate,
                                updatedDate: qoutes.qoutes[index].updatedDate,
                                isFav: qoutes.qoutes[index].isFav,
                                isPinned: qoutes.qoutes[index].isPinned,
                                isUploaded: qoutes.qoutes[index].isUploaded,
                                fun: DialogHelper.showOptionDialog,
                              );
                            });
              },
            );
          }
        });
  }
}
