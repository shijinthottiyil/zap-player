import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/provider/provider_searchscreen.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    Provider.of<ProviderSearchScreen>(
      context,
      listen: false,
    ).fetchingAllSongsAndAssigningToFoundSongs();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: height * 0.08,
        backgroundColor: Colors.black,
        elevation: 0.0,
        actions: [
          Container(
            padding: EdgeInsets.fromLTRB(
              0,
              width * 0.027,
              width * 0.02,
              0,
            ),
            width: width * 0.88,
            child: TextField(
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(
                  left: width * 0.1,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      width * 0.07,
                    ),
                    borderSide: BorderSide.none),
                hintText: 'Artists,songs,or albums',
                prefixIcon: const Icon(
                  Icons.search,
                ),
              ),
              onChanged: ((value) {
                Provider.of<ProviderSearchScreen>(
                  context,
                  listen: false,
                ).runFilter(value);
              }),
            ),
          )
        ],
      ),
      body: Consumer<ProviderSearchScreen>(
        builder: (context, value, child) {
          return value.getListView(context) ?? Container();
        },
      ),
    );
  }
}
