import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/ride/ride_filter.dart';
import '../../../model/ride/ride.dart';
import '../../../model/ride/ride_pref.dart';
import '../../../provider/ride_preferences_provider.dart';
import '../../../service/rides_service.dart';
import '../../theme/theme.dart';
import '../../../utils/animations_util.dart';
import 'widgets/ride_pref_bar.dart';
import 'widgets/ride_pref_modal.dart';
import 'widgets/rides_tile.dart';

///
/// The Ride Selection screen allows users to select a ride once ride preferences have been defined.
/// The screen also allows users to redefine the ride preferences and activate some filters.
///
class RidesScreen extends StatelessWidget {
  const RidesScreen({super.key});

  void onBackPressed(BuildContext context) {
    // Back to the previous view
    Navigator.of(context).pop();
  }

  void onRidePrefSelected(BuildContext context, RidePreference newPreference) {
    // Read the provider and set the current preference
    context.read<RidesPreferencesProvider>().setCurrentPreference(newPreference);
  }

  void onPreferencePressed(BuildContext context) async {
    final provider = context.read<RidesPreferencesProvider>();
    final currentPreference = provider.currentPreference;

    // Open a modal to edit the ride preferences
    final newPreference = await Navigator.of(context).push<RidePreference>(
      AnimationUtils.createTopToBottomRoute(
        RidePrefModal(initialPreference: currentPreference),
      ),
    );

    if (newPreference != null) {
      // Update the current preference via the provider
      onRidePrefSelected(context, newPreference);
    }
  }

  void onFilterPressed() {
    // Placeholder for filter logic (not implemented yet)
  }

  @override
  Widget build(BuildContext context) {
    // Watch the provider for changes
    final provider = context.watch<RidesPreferencesProvider>();
    final currentPreference = provider.currentPreference;

    // Handle case where no preference is set
    if (currentPreference == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'No ride preference selected. Please set a preference.',
            style: BlaTextStyles.body,
          ),
        ),
      );
    }

    final currentFilter = RideFilter(); // Default filter for now
    final matchingRides = RidesService.instance.getRidesFor(currentPreference, currentFilter);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: BlaSpacings.m,
          right: BlaSpacings.m,
          top: BlaSpacings.s,
        ),
        child: Column(
          children: [
            // Top search bar
            RidePrefBar(
              ridePreference: currentPreference,
              onBackPressed: () => onBackPressed(context),
              onPreferencePressed: () => onPreferencePressed(context),
              onFilterPressed: onFilterPressed,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: matchingRides.length,
                itemBuilder: (ctx, index) => RideTile(
                  ride: matchingRides[index],
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}