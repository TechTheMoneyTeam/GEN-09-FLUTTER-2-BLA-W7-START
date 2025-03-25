// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week_3_blabla_project/ui/provider/ride_pref_provider.dart';
import '../../../model/ride/ride_filter.dart';
import 'widgets/ride_pref_bar.dart';

import '../../../model/ride/ride.dart';
import '../../../model/ride/ride_pref.dart';
import '../../../service/rides_service.dart';
import '../../theme/theme.dart';
import '../../../utils/animations_util.dart';
import 'widgets/ride_pref_modal.dart';
import 'widgets/rides_tile.dart';

///
///  The Ride Selection screen allow user to select a ride, once ride preferences have been defined.
///  The screen also allow user to re-define the ride preferences and to activate some filters.
///
class RidesScreen extends StatelessWidget {
  const RidesScreen({super.key});

  void onBackPressed(BuildContext context) {
    Navigator.of(context).pop();
  }

  void onRidePrefSelected(BuildContext context, RidePreference newPreference) {
    context.read<RidesPreferencesProvider>().setCurrentPreference(newPreference);
  }

  void onPreferencePressed(
      BuildContext context, RidePreference currentPreference) async {
    RidePreference? newPreference =
        await Navigator.of(context).push<RidePreference>(
      AnimationUtils.createTopToBottomRoute(
        RidePrefModal(initialPreference: currentPreference),
      ),
    );

    if (newPreference != null) {
      context
          .read<RidesPreferencesProvider>()
          .setCurrentPreference(newPreference);
    }
  }

  void onFilterPressed() {}

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RidesPreferencesProvider>();
    final currentPreference = provider.currentPreference;

    // Safety check - if no preference is set, we shouldn't be on this screen
    if (currentPreference == null) {
      return const Center(child: Text('No ride preference selected'));
    }

    // Get matching rides based on current preference
    final RideFilter currentFilter = RideFilter();
    final List<Ride> matchingRides =
        RidesService.instance.getRidesFor(currentPreference, currentFilter);

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
              ridePreference: currentPreference,
              onBackPressed: () => onBackPressed(context),
              onPreferencePressed: () =>
                  onPreferencePressed(context, currentPreference),
              onFilterPressed: onFilterPressed,
            ),

            Expanded(
              child: ListView.builder(
                itemCount: matchingRides.length,
                itemBuilder: (ctx, index) =>
                    RideTile(ride: matchingRides[index], onPressed: () {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}