import 'package:bus_reservation_udemy/costom_widgets/reservation_page.dart';
import 'package:bus_reservation_udemy/costom_widgets/resevation_item_header_view.dart';
import 'package:bus_reservation_udemy/costom_widgets/serch_box.dart';
import 'package:bus_reservation_udemy/models/reservation_expetion_items.dart';
import 'package:bus_reservation_udemy/provider/app_data_provider.dart';
import 'package:bus_reservation_udemy/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({Key? key}) : super(key: key);

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  bool isFirst = true;
  List<ReservationExpansionItem> items = [];
  @override
  void didChangeDependencies() {
    if(isFirst) {
      _getData();
    }
    super.didChangeDependencies();
  }

  _getData() async {
    final reservations = await Provider.of<AppDataProvider>(context, listen: false).getAllReservations();
    items = Provider.of<AppDataProvider>(context, listen: false).getExpansionItems(reservations);
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservation List'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SearchBox(onSubmit: (value) {
              _search(value);
            }),
            ExpansionPanelList(
              expansionCallback: (index, isExpanded) {
                setState(() {
                  items[index].isExpanded = !isExpanded;
                });
              },
              children: items.map((item) => ExpansionPanel(
                  isExpanded: item.isExpanded,
                  headerBuilder: (context, isExpanded) => ReservationItemHeaderView(header: item.header),
                  body: ReservationItemBodyView(body: item.body,)
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _search(String value) async {
    final data = await Provider.of<AppDataProvider>(context, listen: false).getReservationsByMobile(value);
    if(data.isEmpty) {
      showMsg(context, 'No record found');
      return;
    }
    setState(() {
      items = Provider.of<AppDataProvider>(context, listen: false).getExpansionItems(data);
    });
  }
}