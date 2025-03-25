import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/ride/ride_pref.dart';
import '../../../provider/ride_pref_provider.dart';
import '../../../utils/animations_util.dart';
import '../../theme/theme.dart';
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

  void onRidePrefSelected(BuildContext context, RidePreference newPreference) async {
    // 1 - Update the current preference using the provider
    context.read<RidesPreferencesProvider>().setCurrentPreferrence(newPreference);

    // 2 - Navigate to the rides screen (with a bottom to top animation)
    await Navigator.of(context)
        .push(AnimationUtils.createBottomToTopRoute(RidesScreen(
          ridesService: context.read(),
        )));
  }

 @override
Widget build(BuildContext context) {
  final provider = context.watch<RidesPreferencesProvider>();
  final currentRidePreference = provider.currentPreference;
  final pastPreferences = provider.preferencesHistory;

  return Scaffold( 
    backgroundColor: Colors.white, // Ensure good contrast
    body: Stack(
      children: [
        // 1 - Background Image
        const BlaBackground(),

        // 2 - Foreground content
        Column(
          children: [
            SizedBox(height: BlaSpacings.m),
            Text(
              "Your pick of rides at low price",
              style: BlaTextStyles.heading.copyWith(color: Colors.white),
            ),
            SizedBox(height: 100),
            Container(
              margin: EdgeInsets.symmetric(horizontal: BlaSpacings.xxl),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RidePrefForm(
                    initialPref: currentRidePreference,
                    onSubmit: (pref) => onRidePrefSelected(context, pref),
                    onRidePrefSelected: (RidePreference) {},
                  ),
                  SizedBox(height: BlaSpacings.m),

                  // 2.2 Display past preferences with a proper Material ancestor
                  SizedBox(
                    height: 200,
                    child: Material( // ✅ Added Material to ensure ListTile works
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: pastPreferences.length,
                        itemBuilder: (ctx, index) => RidePrefHistoryTile(
                          ridePref: pastPreferences[index],
                          onPressed: () =>
                              onRidePrefSelected(context, pastPreferences[index]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
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