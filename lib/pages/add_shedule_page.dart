import 'package:bus_reservation_udemy/datasource/temp_db.dart';
import 'package:bus_reservation_udemy/models/bus_model.dart';
import 'package:bus_reservation_udemy/models/bus_schedule.dart';
import 'package:bus_reservation_udemy/models/but_route.dart';
import 'package:bus_reservation_udemy/provider/app_data_provider.dart';
import 'package:bus_reservation_udemy/utils/constants.dart';
import 'package:bus_reservation_udemy/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddSchedulePage extends StatefulWidget {
  const AddSchedulePage({Key? key}) : super(key: key);

  @override
  State<AddSchedulePage> createState() => _AddSchedulePageState();
}

class _AddSchedulePageState extends State<AddSchedulePage> {
  final _formKey = GlobalKey<FormState>();
  String? busType;
  BusRoute? busRoute;
  Bus? bus;
  TimeOfDay? timeOfDay;
  final priceController = TextEditingController();
  final discountController = TextEditingController();
  final feeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Schedule'),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            shrinkWrap: true,
            children: [
              Consumer<AppDataProvider>(
                builder: (context, provider, child) => DropdownButtonFormField<Bus>(
                  onChanged: (value) {
                    setState(() {
                      bus = value;
                    });
                  },
                  isExpanded: true,
                  value: bus,
                  hint: const Text('Select Bus'),
                  items: provider.busList
                      .map((e) => DropdownMenuItem<Bus>(
                    value: e,
                    child: Text('${e.busName}-${e.busType}'),
                  ))
                      .toList(),
                ),
              ),
              Consumer<AppDataProvider>(
                builder: (context, provider, child) => DropdownButtonFormField<BusRoute>(
                  onChanged: (value) {
                    setState(() {
                      busRoute = value;
                    });
                  },
                  isExpanded: true,
                  value: busRoute,
                  hint: const Text('Select Route'),
                  items: provider.routeList
                      .map((e) => DropdownMenuItem<BusRoute>(
                    value: e,
                    child: Text(e.routeName),
                  ))
                      .toList(),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: priceController,
                decoration: const InputDecoration(
                  hintText: 'Ticket Price',
                  filled: true,
                  prefixIcon: Icon(Icons.price_change),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return emptyFieldErrMessage;
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: discountController,
                decoration: const InputDecoration(
                  hintText: 'Discount(%)',
                  filled: true,
                  prefixIcon: Icon(Icons.discount),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return emptyFieldErrMessage;
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: feeController,
                decoration: const InputDecoration(
                  hintText: 'Processing Fee',
                  filled: true,
                  prefixIcon: Icon(Icons.monetization_on_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return emptyFieldErrMessage;
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: _selectTime,
                    child: const Text('Select Departure Time'),
                  ),
                  Text(timeOfDay == null
                      ? 'No time chosen'
                      : getFormattedTime(timeOfDay!)),
                ],
              ),
              Center(
                child: SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: addSchedule,
                    child: const Text('ADD Schedule'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addSchedule() {
    if (_formKey.currentState!.validate()) {
      final schedule = BusSchedule(
        scheduleId: TempDB.tableSchedule.length + 1,
        bus: bus!,
        busRoute: busRoute!,
        departureTime: getFormattedTime(timeOfDay!),
        ticketPrice: int.parse(priceController.text),
        discount: int.parse(discountController.text),
        processingFee: int.parse(feeController.text),
      );
    }
  }

  void _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if(time != null) {
      setState(() {
        timeOfDay = time;
      });
    }
  }

  void resetFields() {
    priceController.clear();
    discountController.clear();
    feeController.clear();
  }
}
