import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week_3_blabla_project/model/ride/ride.dart';
import 'package:week_3_blabla_project/model/ride/ride_pref.dart';
import 'package:week_3_blabla_project/provider/ride_pref_provider.dart';
import 'package:week_3_blabla_project/service/rides_service.dart';
import '../ride_pref/ride_pref_screen.dart';
import '../../../model/ride/ride_filter.dart';
import 'widgets/ride_pref_bar.dart';
import '../../theme/theme.dart';
import 'widgets/rides_tile.dart';

class RidesScreen extends StatelessWidget {
  final RidesService ridesService;
  
  const RidesScreen({
    Key? key,
    required this.ridesService,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // Watch the RidesPreferencesProvider
    final provider = context.watch<RidesPreferencesProvider>();
    final currentPreference = provider.currentPreference;
    
    // Initialize empty filter
    final RideFilter currentFilter = RideFilter();
    
    // Get the list of available rides regarding the current ride preference
    final availableRides = currentPreference != null
        ? ridesService.getAvailableRides(currentPreference, currentFilter)
        : <Ride>[];
    
    void onBackPressed() {
      Navigator.of(context).pop();
    }
    
    void onPreferencePressed() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RidePrefScreen(),
        ),
      );
    }
    
    void onFilterPressed() {
      // Add filter functionality if needed
    }
    
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: BlaSpacings.m,
          right: BlaSpacings.m,
          top: BlaSpacings.s,
        ),
        child: Column(
          children: [
            // Top search Search bar
            RidePrefBar(
              ridePreference: currentPreference ?? RidePreference.defaultPreference(),
              onBackPressed: onBackPressed,
              onPreferencePressed: onPreferencePressed,
              onFilterPressed: onFilterPressed,
            ),
            
            Expanded(
              child: currentPreference == null
                ? const Center(child: Text('No ride preference selected'))
                : ListView.builder(
                    itemCount: availableRides.length,
                    itemBuilder: (ctx, index) =>
                        RideTile(ride: availableRides[index], onPressed: () {}),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}