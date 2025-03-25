import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/model/location/locations.dart';
import 'package:week_3_blabla_project/model/ride/ride_pref.dart';


class RidePrefForm extends StatefulWidget {
  final RidePreference? initialPref;
  final Function(RidePreference) onRidePrefSelected;
  final Function(RidePreference) onSubmit; 

  const RidePrefForm({
    Key? key,
    this.initialPref,
    required this.onSubmit, required this.onRidePrefSelected,
  }) : super(key: key);

  @override
  State<RidePrefForm> createState() => _RidePrefFormState();
}

class _RidePrefFormState extends State<RidePrefForm> {
  late Location _departure;
  late Location _arrival;
  late DateTime _departureDate;
  late int _requestedSeats;

  @override
  void initState() {
    super.initState();
    _initializeFormValues();
  }

  @override
  void didUpdateWidget(RidePrefForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialPref != widget.initialPref) {
      _initializeFormValues();
    }
  }

  void _initializeFormValues() {
    final initialPref = widget.initialPref;
    if (initialPref != null) {
      _departure = initialPref.departure;
      _arrival = initialPref.arrival;
      _departureDate = initialPref.departureDate;
      _requestedSeats = initialPref.requestedSeats;
    } else {
      _departure = Location.defaultLocation();
      _arrival = Location.defaultLocation();
      _departureDate = DateTime.now();
      _requestedSeats = 1;
    }
  }

  void _swapLocations() {
    setState(() {
      final temp = _departure;
      _departure = _arrival;
      _arrival = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ListTile(
            title: Text(_departure.name),
            leading: const Icon(Icons.location_on),
            onTap: () {}, // Implement location selection logic
          ),
          ListTile(
            title: Text(_arrival.name),
            leading: const Icon(Icons.location_on),
            trailing: IconButton(
              icon: const Icon(Icons.swap_vert),
              onPressed: _swapLocations,
            ),
            onTap: () {},
          ),
          ListTile(
            title: Text(_departureDate.toLocal().toString().split(' ')[0]),
            leading: const Icon(Icons.calendar_today),
            onTap: () {}, // Implement date picker logic
          ),
          ListTile(
            title: Text('$_requestedSeats Seat(s)'),
            leading: const Icon(Icons.person),
            onTap: () {}, // Implement seat selection logic
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final pref = RidePreference(
                departure: _departure,
                arrival: _arrival,
                departureDate: _departureDate,
                requestedSeats: _requestedSeats,
              );
              widget.onRidePrefSelected(pref);
            },
            child: const Text('Find Rides'),
          ),
        ],
      ),
    );
  }
}