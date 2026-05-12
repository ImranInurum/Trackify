// // ─────────────────────────────────────────────
// // VARIABLES
// // ─────────────────────────────────────────────
 
// BitmapDescriptor? _driverCustomMarker;
 
// LatLng? _lastDriverLatLng;
// LatLng? _nextDriverLatLng;
 
// Timer? _driverAnimationTimer;
 
 
// // ─────────────────────────────────────────────
// // INTERPOLATE POSITION
// // Creates smooth movement between old and new location
// // ─────────────────────────────────────────────
 
// LatLng _interpolatePosition(
//   LatLng from,
//   LatLng to,
//   double t,
// ) {
//   final lat = from.latitude +
//       (to.latitude - from.latitude) * t;
 
//   final lng = from.longitude +
//       (to.longitude - from.longitude) * t;
 
//   return LatLng(lat, lng);
// }
 
 
// // ─────────────────────────────────────────────
// // CALCULATE BEARING
// // Rotates car in movement direction
// // ─────────────────────────────────────────────
 
// double _calculateBearing(
//   LatLng from,
//   LatLng to,
// ) {
//   final lat1 = from.latitude * (pi / 180);
//   final lat2 = to.latitude * (pi / 180);
 
//   final dLng =
//       (to.longitude - from.longitude) * (pi / 180);
 
//   final y = sin(dLng) * cos(lat2);
 
//   final x = cos(lat1) * sin(lat2) -
//       sin(lat1) * cos(lat2) * cos(dLng);
 
//   final bearing = atan2(y, x);
 
//   return (bearing * 180 / pi + 360) % 360;
// }
 
 
// // ─────────────────────────────────────────────
// // DRIVER LOCATION UPDATE EVENT
// // Call this every time new driver coordinates come
// // ─────────────────────────────────────────────
 
// void updateDriverMarker(
//   double latitude,
//   double longitude,
// ) {
//   final newPosition = LatLng(latitude, longitude);
 
//   // First time marker setup
//   if (_lastDriverLatLng == null) {
//     _lastDriverLatLng = newPosition;
//     _nextDriverLatLng = newPosition;
 
//     _updateMarker(newPosition, 0);
 
//     return;
//   }
 
//   // Store old + new location
//   _lastDriverLatLng = _nextDriverLatLng;
//   _nextDriverLatLng = newPosition;
 
//   // Calculate rotation
//   final bearing = _calculateBearing(
//     _lastDriverLatLng!,
//     newPosition,
//   );
 
//   // Start smooth animation
//   _startDriverTween(
//     _lastDriverLatLng!,
//     newPosition,
//     bearing,
//   );
// }
 
 
// // ─────────────────────────────────────────────
// // START SMOOTH DRIVER ANIMATION
// // ─────────────────────────────────────────────
 
// void _startDriverTween(
//   LatLng from,
//   LatLng to,
//   double bearing,
// ) {
//   _driverAnimationTimer?.cancel();
 
//   const fps = 60;
//   const duration = 1000; // 1 second
 
//   const totalFrames = fps;
 
//   double t = 0;
 
//   _driverAnimationTimer = Timer.periodic(
//     const Duration(milliseconds: 16),
//     (timer) {
//       t += 1 / totalFrames;
 
//       if (t >= 1) {
//         timer.cancel();
 
//         _updateMarker(to, bearing);
 
//         return;
//       }
 
//       final interpolatedPosition =
//           _interpolatePosition(from, to, t);
 
//       _updateMarker(
//         interpolatedPosition,
//         bearing,
//       );
//     },
//   );
// }
 
 
// // ─────────────────────────────────────────────
// // UPDATE MARKER ON MAP
// // ─────────────────────────────────────────────
 
// void _updateMarker(
//   LatLng position,
//   double bearing,
// ) {
//   final updatedMarkers =
//       Set<Marker>.from(state.markers);
 
//   updatedMarkers.removeWhere(
//     (marker) =>
//         marker.markerId.value == "driver_marker",
//   );
 
//   updatedMarkers.add(
//     Marker(
//       markerId: const MarkerId("driver_marker"),
 
//       position: position,
 
//       rotation: bearing,
 
//       anchor: const Offset(0.5, 0.5),
 
//       flat: true,
 
//       icon: _driverCustomMarker ??
//           BitmapDescriptor.defaultMarker,
//     ),
//   );
 
//   emit(
//     state.copyWith(
//       markers: updatedMarkers,
//     ),
//   );
// }
 
 
// // ─────────────────────────────────────────────
// // LIVE DRIVER TRACKING API CALL
// // Call every 5–10 seconds
// // ─────────────────────────────────────────────
 
// Future<void> trackDriverLiveLocation() async {
//   while (true) {
 
//     // API response
//     final response = await http.get(
//       Uri.parse("YOUR_API"),
//     );
 
//     final data = jsonDecode(response.body);
 
//     final latitude = data["latitude"];
//     final longitude = data["longitude"];
 
//     // Smooth marker update
//     updateDriverMarker(
//       latitude,
//       longitude,
//     );
 
//     // wait before next update
//     await Future.delayed(
//       const Duration(seconds: 10),
//     );
//   }
// }