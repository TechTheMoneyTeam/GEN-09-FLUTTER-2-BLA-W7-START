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

class RidePrefScreen extends StatelessWidget {
  const RidePrefScreen({super.key});

  void onRidePrefSelected(BuildContext context, RidePreference newPreference) async {
  
    context.read<RidesPreferencesProvider>().setCurrentPreference(newPreference);

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
    backgroundColor: Colors.white, 
    body: Stack(
      children: [
   
        const BlaBackground(),


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

               
                  SizedBox(
                    height: 200,
                    child: Material( 
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
        fit: BoxFit.cover, 
      ),
    );
  }
}