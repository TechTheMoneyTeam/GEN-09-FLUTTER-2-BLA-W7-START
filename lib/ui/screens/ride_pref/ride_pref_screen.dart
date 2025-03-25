import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week_3_blabla_project/ui/provider/async_value.dart';
import 'package:week_3_blabla_project/ui/provider/ride_pref_provider.dart';

import '../../../model/ride/ride_pref.dart';
import '../../theme/theme.dart';
import '../../../utils/animations_util.dart';
import '../rides/rides_screen.dart';
import 'widgets/ride_pref_form.dart';
import 'widgets/ride_pref_history_tile.dart';

const String blablaHomeImagePath = 'assets/images/blabla_home.png';


class RidePrefScreen extends StatelessWidget {
  const RidePrefScreen({super.key});

  void onRidePrefSelected(
      BuildContext context, RidePreference newPreference) async {
    // 1 - Update the current preference
    context
        .read<RidesPreferencesProvider>()
        .setCurrentPreference(newPreference);

    // 2 - Navigate to the rides screen (with a bottom to top animation)
    await Navigator.of(context)
        .push(AnimationUtils.createBottomToTopRoute(RidesScreen()));

    // 3 - After wait - Update the state -- TODO MAKE IT WITH STATE MANAGEMENT
    // Since this is now a StatelessWidget, you need to use a state management solution
    // like Provider, Riverpod, Bloc, etc. to update the state.
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RidesPreferencesProvider>();
    final currentRidePreference = provider.currentPreference;
    final pastPreference = provider.pastPreferences;

    Widget content;

    switch (pastPreference.state) {
      case AsyncValueState.loading:
        content = const Center(child: Text('Loading...'));
        break;
      case AsyncValueState.error:
        content = const Center(child: Text('No connection. Try later'));
        break;
      case AsyncValueState.success:
        List<RidePreference> pastPref = provider.preferencesHistory;
        content = Column(
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
                          onRidePrefSelected(context, newPreference)),
                  SizedBox(height: BlaSpacings.m),

                  // 2.2 Optionally display a list of past preferences
                  SizedBox(
                    height: 200, // Set a fixed height
                    child: ListView.builder(
                      shrinkWrap: true, // Fix ListView height issue
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: pastPref.length,
                      itemBuilder: (ctx, index) => RidePrefHistoryTile(
                        ridePref: pastPref[index],
                        onPressed: () =>
                            onRidePrefSelected(context, pastPref[index]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
        break;
      case AsyncValueState.empty:
        content =
            const Center(child: Text('Fetching data failed, please try again'));
        break;
    }

    return Stack(
      children: [
        // 1 - Background Image
        const BlaBackground(),

        // 2 - Foreground content
        content,
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