import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week_3_blabla_project/ui/provider/ride_pref_provider.dart';
import '../../../model/ride/ride_pref.dart';

import '../../theme/theme.dart';
import '../../../utils/animations_util.dart';
import '../rides/rides_screen.dart';
import 'widgets/ride_pref_form.dart';
import 'widgets/ride_pref_history_tile.dart';

const String blablaHomeImagePath = 'assets/images/blabla_home.png';

///
/// This screen allows user to:
/// - Enter his/her ride preference and launch a search on it
/// - Or select a last entered ride preferences and launch a search on it
///
class RidePrefScreen extends StatelessWidget {
  const RidePrefScreen({super.key});

  void onRidePrefSelected(
      BuildContext context, RidePreference newPreference) async {
    context
        .read<RidesPreferencesProvider>()
        .setCurrentPreference(newPreference);
    await Navigator.of(context)
        .push(AnimationUtils.createBottomToTopRoute(const RidesScreen()));
  }

  @override
  Widget build(BuildContext context) {
    // Watch the RidesPreferencesProvider for changes
    final ridesPreferencesProvider = context.watch<RidesPreferencesProvider>();

    // Get the current preference and history from the provider
    final currentRidePreference =
        ridesPreferencesProvider.currentPreference;
    final List<RidePreference> pastPreferences =
        ridesPreferencesProvider.preferencesHistory;

    return Stack(
      children: [
        // 1 - Background Image
        const BlaBackground(),

        // 2 - Foreground content
        Column(
          children: [
            const SizedBox(height: BlaSpacings.m),
            Text(
              "Your pick of rides at low price",
              style: BlaTextStyles.heading.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 100),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: BlaSpacings.xxl),
              decoration: BoxDecoration(
                color: Colors.white, // White background
                borderRadius: BorderRadius.circular(16), // Rounded corners
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 2.1 Display the Form to input the ride preferences
                  RidePrefForm(
                    initialPreference: currentRidePreference,
                    onSubmit: (newPreference) =>
                        onRidePrefSelected(context, newPreference),
                  ),
                  const SizedBox(height: BlaSpacings.m),

                  // 2.2 Optionally display a list of past preferences
                  SizedBox(
                    height: 200, // Set a fixed height
                    child: ListView.builder(
                      shrinkWrap: true, // Fix ListView height issue
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: pastPreferences.length,
                      itemBuilder: (ctx, index) => RidePrefHistoryTile(
                        ridePref: pastPreferences[index],
                        onPressed: () =>
                            onRidePrefSelected(context, pastPreferences[index]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class BlaBackground extends StatelessWidget {
  const BlaBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 340,
      child: Image.asset(
        blablaHomeImagePath,
        fit: BoxFit.cover, // Adjust image fit to cover the container
      ),
    );
  }
}
