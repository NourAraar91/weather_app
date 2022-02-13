import 'package:flutter/material.dart';
import 'package:weather_app/models/city.dart';
import 'package:weather_app/widgets/search_bar_text_field_widget.dart';

class CitySelectionScreen extends StatefulWidget {
  const CitySelectionScreen({Key? key, required this.items, this.onSelectItem})
      : super(key: key);
  final List<City> items;
  final Function(int, City)? onSelectItem;

  @override
  _CitySelectionScreenState createState() => _CitySelectionScreenState();
}

class _CitySelectionScreenState extends State<CitySelectionScreen> {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  List<City> itemsList = [];
  List<City> searchList = [];
  var isSearching = false;

  @override
  void initState() {
    itemsList = widget.items;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('Cities', style: TextStyle(color: Colors.white)),
      ),
      body: InkWell(
        onTap: () {
          focusNode.unfocus();
        },
        child: Column(
          children: <Widget>[
            SearchBarTextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: (query) {
                searchFor(query);
              },
            ),
            Expanded(child: buildItemList())
          ],
        ),
      ),
    );
  }

  buildItemList() {
    List<City> items = [];
    if (isSearching) {
      items = searchList;
    } else {
      items = itemsList;
    }
    items.sort();

    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
                onTap: () {
                  if (widget.onSelectItem != null) {
                    widget.onSelectItem!(index, items[index]);
                  }
                },
                child: ListItem(title: items[index].name ?? "")),
          );
        });
  }

  searchFor(String query) {
    if (query.isNotEmpty) {
      isSearching = true;
      List<City> dummyListData = itemsList.where((city) {
        return city.name.toLowerCase().contains(query.toLowerCase());
      }).toList();

      setState(() {
        searchList.clear();
        searchList.addAll(dummyListData);
      });
    } else {
      isSearching = false;
      setState(() {
        searchList.clear();
        searchList.addAll(itemsList);
      });
    }
  }
}

class ListItem extends StatelessWidget {
  final String title;
  const ListItem({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 18.0, color: Colors.white),
      ),
    );
  }
}
