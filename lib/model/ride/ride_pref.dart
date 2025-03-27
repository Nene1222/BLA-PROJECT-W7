import '../location/locations.dart';

///
/// This model describes a ride preference.
/// A ride preference consists of the selection of a departure + arrival + a date and a number of passengers
///
class RidePreference {
  final Location departure;
  final DateTime departureDate;
  final Location arrival;
  final int requestedSeats;

  const RidePreference({
    required this.departure,
    required this.departureDate,
    required this.arrival,
    required this.requestedSeats,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true; // Check if objects are the same instance
    return other is RidePreference && // Check type
        other.departure == departure && // Compare departure Location
        // Compare only the date (year, month, day), ignoring time
        other.departureDate.year == departureDate.year &&
        other.departureDate.month == departureDate.month &&
        other.departureDate.day == departureDate.day &&
        other.arrival == arrival && // Compare arrival Location
        other.requestedSeats == requestedSeats; // Compare integer
  }

  @override
  int get hashCode =>
      departure.hashCode ^
      // Hash only the date (year, month, day)
      DateTime(departureDate.year, departureDate.month, departureDate.day).hashCode ^
      arrival.hashCode ^
      requestedSeats.hashCode; // XOR all field hash codes

  @override
  String toString() {
    return 'RidePref(departure: ${departure.name}, '
        'departureDate: ${departureDate.toIso8601String()}, '
        'arrival: ${arrival.name}, '
        'requestedSeats: $requestedSeats)';
  }
}