// import 'dart:async';
// import 'dart:convert';
// import 'dart:math';
// import 'dart:ui' as ui;
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:path/path.dart';
// import 'package:zye/core/constants/api_endpoints.dart';
// import 'package:zye/core/constants/app_images.dart';
// import 'package:zye/core/helpers/database_helper.dart';
// import 'package:zye/features/booking/presentation/cab_booking_module/bloc/cabBooking_event.dart';
// import 'package:zye/features/booking/presentation/cab_booking_module/bloc/cabBooking_state.dart';
// import 'package:zye/features/booking/presentation/cab_booking_module/model/assignment_model.dart';
// import 'package:zye/features/booking/presentation/helper/helper.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/services.dart';
// import '../../../../../core/helpers/shared_preference_helper.dart';

// class CabBookingBloc extends Bloc<CabBookingEvent, CabBookingState> {
//   final DatabaseHelper _databaseHelper = DatabaseHelper();
//   BitmapDescriptor? _driverCustomMarker;
//   bool _markerLoaded = false;
//   LatLng? _lastDriverLatLng;
//   LatLng? _nextDriverLatLng;

//   Timer? _driverAnimationTimer;
//   double _driverBearing = 0.0; // for car rotation

//   CabBookingBloc() : super(CabBookingState.initial()) {
//     _loadDriverMarker();
//     on<LoadInitialBookingData>(_onLoadInitialBookingData);
//     on<ToggleStop>(_onToggleStop);
//     on<UpdateMapController>(_onUpdateMapController);
//     on<PickupTextChanged>(_onPickupTextChanged);
//     on<StopTextChanged>(_onStopTextChanged);
//     on<DestinationTextChanged>(_onDestinationTextChanged);
//     on<FetchLocationSuggestions>(_onFetchLocationSuggestions);
//     on<ClearSuggestions>(_onClearSuggestions);
//     on<LocationSuggestionSelected>(_onLocationSuggestionSelected);
//     on<ToggleBookingType>(_onToggleBookingType);
//     on<SelectRideType>(_onSelectRideType);
//     on<SelectedTime>(_onSelectedTime);
//     on<SelectedRentalPackage>(_onSelectedRentalPackage);
//     on<SelectedRentalDateTime>(_onSelectedRentalDateTime);
//     on<SelectedDepartureDateTime>(_onSelectedDepartureDateTime);
//     on<SelectedTripType>(_onSelectedTripType);
//     on<EstimateFairAndAvailableVehicles>(_onEstimateFairAndAvailableVehicles);
//     on<SelectedVehicle>(_onSelectedVehicle);
//     on<SetShowAllVehicleFlag>(_onSetShowAllVehicleFlag);
//     on<CancelRide>(_onCancelRide);
//     on<AttemptBooking>(_onAttemptBooking);
//     on<ResetBookingForm>(_onResetBookingForm);
//     on<ClearLocationInputs>(_onClearLocationInputs);
//     on<ExchangeLocations>(_onExchangeLocations);
//     on<RideSearchCancelled>(_onRideSearchCancelled);
//     on<ResumeRideStatusPolling>(_onResumeRideStatusPolling);
//     on<FetchStatusNotification>(_onFetchRideStatusOneTime);
//     on<AddDriverMarker>(_onAddDriverMarker);
//     on<TrackDriver>(_onTrackDriver);
//     on<SmoothDriverFrame>(_onDriverFrame);
//   }

//   LatLng _interpolatePosition(LatLng from, LatLng to, double t) {
//     final lat = from.latitude + (to.latitude - from.latitude) * t;
//     final lng = from.longitude + (to.longitude - from.longitude) * t;
//     return LatLng(lat, lng);
//   }

//   double _calculateBearing(LatLng from, LatLng to) {
//     final lat1 = from.latitude * (3.14159 / 180);
//     final lat2 = to.latitude * (3.14159 / 180);
//     final dLng = (to.longitude - from.longitude) * (3.14159 / 180);

//     final y = sin(dLng) * cos(lat2);
//     final x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLng);

//     final brng = atan2(y, x);

//     return (brng * 180 / 3.14159 + 360) % 360;
//   }

//   Future<void> _onLoadInitialBookingData(
//       LoadInitialBookingData event, Emitter<CabBookingState> emit) async {
//     emit(state.copyWith(status: CabBookingStatus.loading));
//     try {
//       // Load user
//       final user = await _databaseHelper.getUser();
//       final userName = user?['name'] ?? 'User';

//       // Step 1: Check Permission
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           throw Exception('Location permission denied');
//         }
//       }

//       if (permission == LocationPermission.deniedForever) {
//         throw Exception('Location permission permanently denied');
//       }

//       // Step 2: Get current position
//       final position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       // Step 3: Create LatLng from the current position
//       final LatLng currentLocation =
//           LatLng(position.latitude, position.longitude);

//       print(
//           "CurrentLocation set on marker ::: ${currentLocation.latitude} ${currentLocation.longitude}");

//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         currentLocation.latitude,
//         currentLocation.longitude,
//       );

//       String address = '';
//       if (placemarks.isNotEmpty) {
//         final place = placemarks.first;

//         // Choose most relevant parts and filter duplicates or unwanted words
//         final parts = [
//           place.name,
//           place.subLocality,
//           place.locality,
//           place.administrativeArea,
//           place.postalCode,
//           place.country,
//         ];

//         // Remove null, empty, and repeated values
//         final filtered = <String>[];
//         for (final part in parts) {
//           if (part != null &&
//               part.trim().isNotEmpty &&
//               !filtered.contains(part.trim())) {
//             filtered.add(part.trim());
//           }
//         }
//         address = parts.join(', ');
//       }

//       print("Resolved Address: $address");

//       // Step 5: Create a marker
//       final marker = Marker(
//         markerId: const MarkerId('current_location'),
//         position: currentLocation,
//         infoWindow: const InfoWindow(title: 'Your Location'),
//       );

//       // Step 5: Update State
//       emit(state.copyWith(
//         status: CabBookingStatus.loaded,
//         userName: userName,
//         pickupLocation: currentLocation,
//         pickupText: address,
//         destinationText: '',
//         dropLocation: null,
//         markers: {marker},
//       ));
//     } catch (e) {
//       emit(state.copyWith(
//         status: CabBookingStatus.error,
//         errorMessage: e.toString(),
//       ));
//     }
//   }

//   // Handle Add/Remove stop logic
//   void _onToggleStop(ToggleStop event, Emitter<CabBookingState> emit) {
//     emit(state.copyWith(
//       stopText: state.hasStop ? '' : state.stopText,
//       hasStop: !state.hasStop,
//       status: state.hasStop
//           ? CabBookingStatus.stopRemoved
//           : CabBookingStatus.stopAdded,
//     ));
//   }

//   void _onUpdateMapController(
//       UpdateMapController event, Emitter<CabBookingState> emit) {
//     emit(state.copyWith(mapController: event.controller));
//   }

//   void _onPickupTextChanged(
//       PickupTextChanged event, Emitter<CabBookingState> emit) {
//     emit(state.copyWith(pickupText: event.value));
//   }

//   void _onStopTextChanged(
//       StopTextChanged event, Emitter<CabBookingState> emit) {
//     emit(state.copyWith(stopText: event.value));
//   }

//   void _onDestinationTextChanged(
//       DestinationTextChanged event, Emitter<CabBookingState> emit) {
//     emit(state.copyWith(destinationText: event.value));
//   }

//   Completer<List<Map<String, dynamic>>>? suggestionsCompleter;

//   void _onFetchLocationSuggestions(
//       FetchLocationSuggestions event, Emitter<CabBookingState> emit) async {
//     suggestionsCompleter = Completer();
//     emit(state.copyWith(isLoadingSuggestions: true));
//     try {
//       final results = await Helper.getSuggestions(event.query);
//       emit(state.copyWith(
//         suggestions: results,
//         isLoadingSuggestions: false,
//       ));
//       suggestionsCompleter?.complete(results);
//     } catch (e) {
//       emit(state.copyWith(isLoadingSuggestions: false));
//     }
//   }

//   void _onClearSuggestions(
//       ClearSuggestions event, Emitter<CabBookingState> emit) {
//     emit(state.copyWith(suggestions: []));
//   }

//   Set<Marker> _removeCurrentLocation(Set<Marker> markers) {
//     const idsToRemove = {
//       'current_location',
//       'route_start',
//       'route_end',
//     };

//     return markers
//         .where((m) => !idsToRemove.contains(m.markerId.value))
//         .toSet();
//   }

//   void _onLocationSuggestionSelected(
//       LocationSuggestionSelected event, Emitter<CabBookingState> emit) async {
//     final suggestion = event.suggestion;
//     final description = suggestion['description'] as String;
//     final LatLng? selectedLatLng =
//         await Helper.getLatLngFromAddress(description);

//     if (selectedLatLng == null) {
//       print("❌ Could not resolve '$description' to coordinates.");
//       return;
//     }

//     final updatedMarkers = Set<Marker>.from(state.markers);

//     if (event.fieldType == 'pickup') {
//       updatedMarkers
//         ..removeWhere((m) => m.markerId.value == 'current_location')
//         ..add(
//           Marker(
//             markerId: const MarkerId('current_location'),
//             position: selectedLatLng,
//             infoWindow: const InfoWindow(
//               title: 'Pickup Location',
//             ),
//           ),
//         );

//       emit(state.copyWith(
//         pickupText: suggestion['description'],
//         pickupLocation: selectedLatLng,
//         markers: updatedMarkers,
//       ));

//       // 👇 Move camera smoothly to new pickup position
//       if (state.mapController != null) {
//         state.mapController!.animateCamera(
//           CameraUpdate.newLatLngZoom(selectedLatLng, 15),
//         );
//       }

//       if (state.pickupLocation != null && state.dropLocation != null) {
//         add(EstimateFairAndAvailableVehicles(
//             state.pickupLocation, state.dropLocation));
//       }
//     } else if (event.fieldType == 'stop') {
//       emit(state.copyWith(
//         stopText: suggestion['description'],
//         stopLocation: selectedLatLng,
//       ));
//     } else if (event.fieldType == 'destination') {
//       final routeResult = await Helper.buildRoutePolyline(
//         state.pickupLocation!,
//         selectedLatLng,
//       );

//       // Zoom camera to fit polyline
//       final bounds = Helper.createBoundsFromLatLng(
//         state.pickupLocation!,
//         selectedLatLng,
//       );

//       final controller = state.mapController;

//       if (controller != null) {
//         await Future.delayed(const Duration(
//             milliseconds: 200)); // Wait for map to render polyline
//         controller.animateCamera(
//           CameraUpdate.newLatLngBounds(bounds, 90), // padding around edges
//         );
//       }
//       emit(state.copyWith(
//         destinationText: suggestion['description'],
//         dropLocation: selectedLatLng,
//         polylines: routeResult.polylines,
//         markers: {
//           ..._removeCurrentLocation(state.markers),
//           ...routeResult.markers, // add start + end markers
//         },
//       ));

//       if (state.pickupLocation != null && state.dropLocation != null) {
//         add(EstimateFairAndAvailableVehicles(
//             state.pickupLocation, state.dropLocation));
//       }
//     }

//     // Clear suggestions after selection
//     emit(state.copyWith(suggestions: []));
//   }

//   void _onToggleBookingType(
//       ToggleBookingType event, Emitter<CabBookingState> emit) {
//     final isForSomeone = !state.isBookingForSomeone;
//     emit(state.copyWith(
//       bookingType: isForSomeone ? 'Someone else' : 'Book for self',
//       isBookingForSomeone: isForSomeone,
//     ));
//   }

//   void _onSelectRideType(SelectRideType event, Emitter<CabBookingState> emit) {
//     emit(state.copyWith(selectedRideType: event.rideType));
//   }

//   void _onSelectedTime(SelectedTime event, Emitter<CabBookingState> emit) {
//     emit(state.copyWith(selectedTimeOption: event.selectedTimeOption));
//     print("Selected Time Options ::: ${state.selectedTimeOption}");
//   }

//   void _onSelectedRentalPackage(
//       SelectedRentalPackage event, Emitter<CabBookingState> emit) {
//     emit(state.copyWith(selectedRentalPackage: event.packageDescription));
//   }

//   void _onSelectedRentalDateTime(
//       SelectedRentalDateTime event, Emitter<CabBookingState> emit) {
//     emit(state.copyWith(
//         selectedRentalDateTime: event.selectedRentalDateAndTime));
//   }

//   void _onSelectedDepartureDateTime(
//       SelectedDepartureDateTime event, Emitter<CabBookingState> emit) {
//     emit(state.copyWith(
//         selectedDepartureDateTime: event.selectedDepartureDateAndTime));
//   }

//   void _onSelectedTripType(
//       SelectedTripType event, Emitter<CabBookingState> emit) {
//     emit(state.copyWith(selectedTripType: event.selectedTripType));
//   }

//   void _onEstimateFairAndAvailableVehicles(
//       EstimateFairAndAvailableVehicles event,
//       Emitter<CabBookingState> emit) async {
//     print("PickUp LatLng for estimate fair api :: ${event.pickUpLatLng}");
//     print("DropOff LatLng for estimate fair api :: ${event.dropOffLatLng}");
//     try {
//       emit(state.copyWith(
//           selectVehicleTypeLoader: true,
//           fetchedVehicles: [],
//           errorMessage: null));
//       final requestBody = jsonEncode({
//         "pickupLocation": {
//           "latitude": event.pickUpLatLng!.latitude,
//           "longitude": event.pickUpLatLng!.longitude
//         },
//         "dropoffLocation": {
//           "latitude": event.dropOffLatLng!.latitude,
//           "longitude": event.dropOffLatLng!.longitude
//         }
//       });

//       final response = await http.post(
//         Uri.parse(ApiEndpoints.estimateFareAndGetCars),
//         headers: {
//           'Content-Type': 'application/json',
//           'accept': 'application/json',
//         },
//         body: requestBody,
//       );

//       if (response.statusCode == 200) {
//         final decoded = jsonDecode(response.body);
//         List<Map<String, dynamic>> availableVehiclesDetails = [];
//         if (decoded is List) {
//           availableVehiclesDetails = decoded
//               .map((e) => Map<String, dynamic>.from(e))
//               .map((item) => {
//                     ...item,
//                     'vehicleType': item['vehicleType'] != null
//                         ? item['vehicleType'][0].toUpperCase() +
//                             item['vehicleType'].substring(1).toLowerCase()
//                         : '',
//                   })
//               .toList();
//           emit(state.copyWith(
//               selectVehicleTypeLoader: false,
//               fetchedVehicles: availableVehiclesDetails));
//         } else if (decoded is Map && decoded.containsKey('vehicles')) {
//           availableVehiclesDetails = (decoded['vehicles'] as List)
//               .map((e) => Map<String, dynamic>.from(e))
//               .map((item) => {
//                     ...item,
//                     'vehicleType': item['vehicleType'] != null
//                         ? item['vehicleType'][0].toUpperCase() +
//                             item['vehicleType'].substring(1).toLowerCase()
//                         : '',
//                   })
//               .toList();
//           emit(state.copyWith(
//               selectVehicleTypeLoader: false,
//               fetchedVehicles: availableVehiclesDetails));
//         } else {
//           emit(state.copyWith(
//               status: CabBookingStatus.error,
//               selectVehicleTypeLoader: false,
//               errorMessage: 'Unexpected Json Structure: $decoded',
//               fetchedVehicles: []));
//         }
//       } else {
//         print("Failed to load vehicles. Status code: ${response.statusCode}");
//         emit(state.copyWith(
//             status: CabBookingStatus.error,
//             selectVehicleTypeLoader: false,
//             errorMessage: 'Something went wrong',
//             fetchedVehicles: []));
//       }
//     } catch (e) {
//       emit(state.copyWith(
//           status: CabBookingStatus.error,
//           errorMessage: e.toString(),
//           fetchedVehicles: []));
//     }
//   }

//   void _onSelectedVehicle(
//       SelectedVehicle event, Emitter<CabBookingState> emit) {
//     emit(state.copyWith(selectedVehicle: event.selectedVehicle));
//     HapticFeedback.vibrate();
//   }

//   void _onSetShowAllVehicleFlag(
//       SetShowAllVehicleFlag event, Emitter<CabBookingState> emit) {
//     emit(state.copyWith(
//       showAllVehicles: !state.showAllVehicles,
//     ));
//   }

//   void _onCancelRide(CancelRide event, Emitter<CabBookingState> emit) {
//     emit(state.copyWith(
//         isRideBooked: event.isRideBooked,
//         selectedVehicle: event.selectedVehicle));
//   }

//   void _onAttemptBooking(
//       AttemptBooking event, Emitter<CabBookingState> emit) async {
//     final pickupAddress = event.pickupAddress ?? '';
//     final dropoffAddress = event.dropoffAddress ?? '';

//     print("Pickup Drop Address : ${pickupAddress} _ ${dropoffAddress}");

//     if (event.pickupLatLng == null &&
//         event.dropoffLatLng == null &&
//         pickupAddress.isEmpty &&
//         dropoffAddress.isEmpty) {
//       emit(state.copyWith(
//         rideFlowStatus: RideFlowStatus.idle,
//         errorMessage: 'Please fill the location inputs properly',
//         status: CabBookingStatus.error,
//       ));
//       return;
//     }

//     // Start booking
//     emit(
//       state.copyWith(
//         rideFlowStatus: RideFlowStatus.creatingRequest,
//         errorMessage: null,
//       ),
//     );

//     try {
//       final user = await _databaseHelper.getCurrentUser();
//       final token = await _databaseHelper.getAuthToken();

//       final requestBody = jsonEncode(
//         {
//           "userId": user?["registration_code"],
//           "pickupLocation": {
//             "latitude": event.pickupLatLng!.latitude,
//             "longitude": event.pickupLatLng!.longitude,
//             "address": event.pickupAddress
//           },
//           "dropoffLocation": {
//             "latitude": event.dropoffLatLng!.latitude,
//             "longitude": event.dropoffLatLng!.longitude,
//             "address": event.dropoffAddress
//           },
//           "estimatedArrivalTime": "",
//           "vehicleType": event.selectedVehicleDetails["vehicleType"]
//               .toString()
//               .toUpperCase(),
//           "ac": event.selectedVehicleDetails["ac"]
//         },
//       );

//       final response = await http.post(Uri.parse(ApiEndpoints.cabBooking),
//           headers: {
//             'Content-Type': 'application/json',
//             'Accept-Language': user?['language'] ?? 'en',
//             'Authorization': "Bearer ${token.toString()}",
//             'Accept': "application/json",
//           },
//           body: requestBody);

//       print("Response code of attempt cab booking ::: ${response.statusCode}");
//       print("Response body of attempt cab booking ::: ${response.body}");

//       if (response.statusCode == 202) {
//         // Generate polyline route
//         final decoded = jsonDecode(response.body) as Map<String, dynamic>;
//         final rideId = decoded['rideId'] as String;
//         if (rideId.isNotEmpty) {
//           await SharedPrefHelper.clearBookingTime();
//           await SharedPrefHelper.clearRideId();
//           await SharedPrefHelper.saveRideId(rideId);
//           final now = DateTime.now().millisecondsSinceEpoch;
//           await SharedPrefHelper.saveBookingTime(now);
//           print("In state format :- ${state.pickupLocation}");
//           await SharedPrefHelper.savePickupLatLng(event.pickupLatLng!);
//           await SharedPrefHelper.savePickupAddress(event.pickupAddress!);
//           await SharedPrefHelper.saveDropLatLng(event.dropoffLatLng!);
//           await SharedPrefHelper.saveDropAddress(event.dropoffAddress!);
//           await SharedPrefHelper.saveSelectedVehicle(
//               event.selectedVehicleDetails["vehicleType"]!.toString());
//         }
//         // final initialStatus = (decoded['status'] as String?) ?? '';

//         emit(
//           state.copyWith(
//             rideId: rideId,
//             isRideBooked: true,
//             rideFlowStatus: RideFlowStatus.searchingDriver,
//             rideStatusPollAttempts: 0,
//           ),
//         );

//         await pollRideStatus(rideId, emit);
//       } else {
//         emit(
//           state.copyWith(
//             rideFlowStatus: RideFlowStatus.failed,
//             isRideBooked: false,
//             status: CabBookingStatus.error,
//             errorMessage: response.body,
//           ),
//         );
//       }
//     } catch (e) {
//       emit(
//         state.copyWith(
//           rideFlowStatus: RideFlowStatus.failed,
//           isRideBooked: false,
//           status: CabBookingStatus.error,
//           errorMessage: e.toString(),
//         ),
//       );
//     }
//   }

//   Future<void> pollRideStatus(
//     String rideId,
//     Emitter<CabBookingState> emit,
//   ) async {
//     const interval = Duration(seconds: 10);
//     const maxAttempts = 18;

//     for (var attempt = 0; attempt < maxAttempts; attempt++) {
//       if (state.rideId != rideId || state.rideFlowStatus != RideFlowStatus.searchingDriver) {
//         return;
//       }

//       if (state.rideFlowStatus == RideFlowStatus.notificationOverride) {
//         print("⛔ Polling force-stopped by notification handler");
//         return;
//       }

//       final token = await _databaseHelper.getAuthToken();
//       final response = await http.get(
//         Uri.parse(ApiEndpoints.getCabRideStatus(rideId)),
//         headers: {
//           'Authorization': "Bearer ${token.toString()}",
//           'Accept': "application/json",
//           'X-Request-Id': "trace-12345",
//         },
//       );

//       print(
//           "Status (${attempt + 1}/18): ${response.body}, code ${response.statusCode}");

//       if (response.statusCode != 200) {
//         emit(
//           state.copyWith(
//             rideFlowStatus: RideFlowStatus.failed,
//             isRideBooked: false,
//             status: CabBookingStatus.error,
//             errorMessage:
//                 'Failed to get ride status. Code: ${response.statusCode}',
//           ),
//         );
//         return;
//       }

//       final decoded = jsonDecode(response.body);
//       final assignment = AssignmentStatus.fromJson(decoded);

//       final live = assignment.driverLiveLocation;
//       final driverLatLng = LatLng(live?.latitude ?? 0.0, live?.longitude ?? 0.0);

//       switch (assignment.status?.toUpperCase()) {
//         case "PENDING":
//           emit(state.copyWith(
//             rideFlowStatus: RideFlowStatus.searchingDriver,
//             rideStatusPollAttempts: attempt + 1,
//           ));

//           await Future.delayed(interval);
//           continue;

//         case "EXPIRED":
//           emit(
//             state.copyWith(
//               rideFlowStatus: RideFlowStatus.idle,
//               isRideBooked: false,
//               errorMessage: 'Ride request expired. Please try again.',
//             ),
//           );

//         case "NO_DRIVERS_FOUND":
//           emit(state.copyWith(
//             rideFlowStatus: RideFlowStatus.noDriversFound,
//             isRideBooked: false,
//           ));
//           return;

//         case "ASSIGNED":
//           // Build polyline based on flow
//           final routeResult = await Helper.buildRoutePolyline(driverLatLng, state.pickupLocation!);

//           // Zoom camera to fit polyline
//           final bounds = Helper.createBoundsFromLatLng(
//             driverLatLng,
//             state.pickupLocation!,
//           );

//           final controller = state.mapController;
//           if (controller != null) {
//             await Future.delayed(const Duration(milliseconds: 200));
//             controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 90));
//           }


//           emit(state.copyWith(
//             rideFlowStatus: RideFlowStatus.driverAssigned,
//             isRideBooked: true,
//             assignmentStatus: assignment,
//             polylines: routeResult.polylines,
//             markers: {
//               ..._removeCurrentLocation(state.markers),
//               ...routeResult.markers, // add start + end markers
//             },
//           ));
//           // Add driver marker if available
//           if (live != null) {
//             add(AddDriverMarker(live.latitude!, live.longitude!));
//           }
//           // NOW START CONTINUOUS DRIVER TRACKING LOOP
//           add(TrackDriver(rideId: rideId, trackDriver: true));
//           return;

//         default:
//           emit(state.copyWith(
//             rideFlowStatus: RideFlowStatus.failed,
//             isRideBooked: false,
//             errorMessage: 'Invalid or unknown ride status.',
//           ));
//           return;
//       }
//     }

//     emit(state.copyWith(
//       rideFlowStatus: RideFlowStatus.noDriversFound,
//       isRideBooked: false,
//       errorMessage: 'No drivers found within 3 minutes.',
//     ));
//   }

//   Future<void> _onTrackDriver(
//       TrackDriver event, Emitter<CabBookingState> emit) async
//   {
//     print("TracDriver value In Track Function ::: ${event.trackDriver}");
//     const interval = Duration(milliseconds: 10000);

//     while (event.trackDriver == true) {
//       final token = await _databaseHelper.getAuthToken();
//       final response = await http.get(
//         Uri.parse(ApiEndpoints.getCabRideStatus(event.rideId)),
//         headers: {
//           'Authorization': "Bearer $token",
//           'Accept': "application/json",
//           'X-Request-Id': "trace-12345",
//         },
//       );

//       print("Before break");
//       if (response.statusCode != 200) break;
//       print("After break");
//       final decoded = jsonDecode(response.body);
//       final assignment = AssignmentStatus.fromJson(decoded);
//       print("TRACKED RESPONSE: ${jsonEncode(assignment.toJson())}");
//       final live = assignment.driverLiveLocation;
//       final driverLatLng = LatLng(
//           assignment.driverLiveLocation?.latitude ?? 0.0,
//           assignment.driverLiveLocation?.longitude ?? 0.0);

//       if (live != null && live.latitude != null && live.longitude != null) {
//         emit(state.copyWith(
//           assignmentStatus: assignment,
//         ));
//         add(AddDriverMarker(live.latitude!, live.longitude!));

//         final controller = state.mapController;

//         if (controller != null) {
//           await Future.delayed(const Duration(
//               milliseconds: 200)); // Wait for map to render polyline
//           controller.animateCamera(
//             CameraUpdate.newLatLng(driverLatLng), // padding around edges
//           );
//         }
//       }
//       await Future.delayed(interval);
//     }
//   }

//   void _onAddDriverMarker(
//       AddDriverMarker event, Emitter<CabBookingState> emit)
//   {
//     final newPos = LatLng(event.latitude, event.longitude);

//     // first fix
//     if (_lastDriverLatLng == null) {
//       _lastDriverLatLng = newPos;
//       _nextDriverLatLng = newPos;
//       add(SmoothDriverFrame(newPos, 0));
//       return;
//     }

//     // store positions for animation
//     _lastDriverLatLng = _nextDriverLatLng;
//     _nextDriverLatLng = newPos;

//     final bearing = _calculateBearing(_lastDriverLatLng!, newPos);
//     _startDriverTween(_lastDriverLatLng!, newPos, bearing);
//   }

//   void _onDriverFrame(
//     SmoothDriverFrame event,
//     Emitter<CabBookingState> emit,
//   )
//   {
//     final updatedMarkers = Set<Marker>.from(state.markers);

//     updatedMarkers.removeWhere((m) => m.markerId.value == 'driver_marker');
//     updatedMarkers.removeWhere((m) => m.markerId.value == 'route_start');

//     updatedMarkers.add(
//       Marker(
//         markerId: const MarkerId('driver_marker'),
//         position: event.position,
//         rotation: event.bearing,
//         icon: _driverCustomMarker ?? BitmapDescriptor.defaultMarker,
//         anchor: const Offset(0.5, 0.5),
//       ),
//     );

//     emit(state.copyWith(markers: updatedMarkers));
//   }

//   void _startDriverTween(LatLng from, LatLng to, double bearing)
//   {
//     _driverAnimationTimer?.cancel();

//     const fps = 60;
//     const duration = 800; // ms
//     const step = duration / fps;

//     double t = 0;

//     _driverAnimationTimer =
//         Timer.periodic(Duration(milliseconds: step.round()), (timer) {
//       t += 1 / fps;

//       if (t >= 1) {
//         timer.cancel();
//         add(SmoothDriverFrame(to, bearing));
//         return;
//       }

//       final pos = _interpolatePosition(from, to, t);
//       add(SmoothDriverFrame(pos, bearing));
//     });
//   }

//   Future<void> _onFetchRideStatusOneTime(
//     FetchStatusNotification event,
//     Emitter<CabBookingState> emit,
//   ) async
//   {

//     // Pause polling because notification came immediately
//     emit(state.copyWith(
//         rideFlowStatus: RideFlowStatus.notificationOverride
//     ));

//     final payloadData = event.data;

//     final rideId = payloadData["rideId"] ?? '';
//     final notificationTitle = payloadData["notificationTitle"];
//     final notificationBody = payloadData["notificationBody"];
//     final trackDriver = notificationBody != "Your Trip has ended!!!";
//     print("TracDriver value ::: $trackDriver");
//     if(trackDriver) {
//       final token = await _databaseHelper.getAuthToken();
//       final response = await http.get(
//         Uri.parse(ApiEndpoints.getCabRideStatus(rideId)),
//         headers: {
//           'Authorization': "Bearer ${token.toString()}",
//           'Accept': "application/json",
//           'X-Request-Id': "trace-12345",
//         },
//       );
//       print("getRideStatus code: ${response.statusCode}");
//       print("getRideStatus body: ${response.body}");
//       if (response.statusCode != 200) {
//         emit(
//           state.copyWith(
//             rideFlowStatus: RideFlowStatus.failed,
//             isRideBooked: false,
//             status: CabBookingStatus.error,
//             errorMessage:
//             'Failed to get ride status. Code: ${response.statusCode}',
//           ),
//         );
//         return;
//       }

//       final decoded = jsonDecode(response.body);
//       final assignment = AssignmentStatus.fromJson(decoded);
//       // Decide flow based on notification
//       LatLng from;
//       LatLng to;

//       final live = assignment.driverLiveLocation;
//       final driverLatLng = LatLng(live?.latitude ?? 0.0, live?.longitude ?? 0.0);

//       if (notificationTitle == "Driver Assigned") {
//         print(
//             "🚗 Notification: DRIVER ASSIGNED → Build driver → pickup polyline");

//         from = driverLatLng;
//         to = state.pickupLocation!;
//       } else if (notificationBody == "Trip Verified!!! Ride Started") {
//         print("🟢 Notification: RIDE STARTED → Build pickup → drop polyline");

//         from = state.pickupLocation!;
//         to = state.dropLocation!;
//       } else {
//         print("ℹ️ Default route: pickup → drop");

//         from = state.pickupLocation!;
//         to = state.dropLocation!;
//       }

//       // Build polyline based on flow
//       final routeResult = await Helper.buildRoutePolyline(from, to);

//       // Zoom camera to fit polyline
//       final bounds = Helper.createBoundsFromLatLng(
//         from,
//         to,
//       );

//       final controller = state.mapController;
//       if (controller != null) {
//         await Future.delayed(const Duration(milliseconds: 200));
//         controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 90));
//       }

//       emit(state.copyWith(
//         rideFlowStatus: notificationBody ==  "Trip Verified!!! Ride Started" ? RideFlowStatus.customerPicked : RideFlowStatus.driverAssigned,
//         isRideBooked: true,
//         assignmentStatus: assignment,
//         polylines: routeResult.polylines,
//         markers: {
//           ..._removeCurrentLocation(state.markers),
//           ...routeResult.markers, // add start + end markers
//         },
//       ));

//       // Add driver marker if available
//       if (live != null) {
//         add(AddDriverMarker(live.latitude!, live.longitude!));
//       }
//       add(TrackDriver(rideId: rideId, trackDriver: trackDriver));
//     } else {
//       // Start continuous tracking after assigned
//       add(TrackDriver(rideId: rideId, trackDriver: trackDriver));
//       await SharedPrefHelper.clearBookingTime();
//       await SharedPrefHelper.clearRideId();
//       emit(CabBookingState.initial());
//       add(LoadInitialBookingData());
//     }
//   }

//   void _onRideSearchCancelled(
//     RideSearchCancelled event,
//     Emitter<CabBookingState> emit,
//   ) async {
//     try {
//       final token = await _databaseHelper.getAuthToken();
//       final response = await http
//           .post(Uri.parse(ApiEndpoints.cancelCabRide(event.rideId)), headers: {
//         'Authorization': "Bearer ${token.toString()}",
//         'Accept': "application/json",
//       });

//       final decodedResponse = jsonDecode(response.body);

//       if (response.statusCode == 200 &&
//           decodedResponse['status'] == 'Ride cancelled successfully') {
//         print('${decodedResponse['status']}');
//         await SharedPrefHelper.clearBookingTime();
//         await SharedPrefHelper.clearRideId();
//         emit(CabBookingState.initial());
//         add(LoadInitialBookingData());
//       }
//     } catch (e) {
//       print("Failed to cancel ride request, Error: ${e.toString()}");
//       emit(
//         state.copyWith(
//           rideFlowStatus: RideFlowStatus.failed,
//           isRideBooked: false,
//           status: CabBookingStatus.error,
//           errorMessage: 'Failed to cancel ride request',
//         ),
//       );
//     }
//   }

//   void _onClearLocationInputs(
//       ClearLocationInputs event, Emitter<CabBookingState> emit) {
//     if (event.fieldType == 'pickup') {
//       emit(state.copyWith(
//           pickupLocation: event.clearLatLng, pickupText: event.clearText));
//     } else if (event.fieldType == 'stop') {
//       emit(state.copyWith(
//           stopLocation: event.clearLatLng, stopText: event.clearText));
//     } else if (event.fieldType == 'destination') {
//       emit(state.copyWith(
//           dropLocation: event.clearLatLng, destinationText: event.clearText));
//     }
//   }

//   void _onExchangeLocations(
//       ExchangeLocations event, Emitter<CabBookingState> emit) async {
//     // Generate new polyline for the swapped locations
//     final routeResult = await Helper.buildRoutePolyline(
//       event.dropoffLatLng, // New pickup becomes old dropoff
//       event.pickupLatLng, // New dropoff becomes old pickup
//     );

//     // Zoom camera to fit the new polyline
//     final bounds = Helper.createBoundsFromLatLng(
//       event.dropoffLatLng,
//       event.pickupLatLng,
//     );

//     final controller = state.mapController;

//     if (controller != null) {
//       await Future.delayed(
//           const Duration(milliseconds: 200)); // Wait for map to render polyline
//       controller.animateCamera(
//         CameraUpdate.newLatLngBounds(bounds, 70), // padding around edges
//       );
//     }

//     emit(state.copyWith(
//         pickupText: event.dropoffText,
//         pickupLocation: event.dropoffLatLng,
//         destinationText: event.pickupText,
//         dropLocation: event.pickupLatLng,
//         markers: {
//           ..._removeCurrentLocation(state.markers),
//           ...routeResult.markers, // add start + end markers from new route
//         },
//         polylines: routeResult.polylines,
//         // update with new polyline
//         isSwapped: !event.isSwapped));
//   }

//   void _onResetBookingForm(
//       ResetBookingForm event, Emitter<CabBookingState> emit) {
//     emit(CabBookingState.initial());
//   }

//   Future<void> _onResumeRideStatusPolling(
//     ResumeRideStatusPolling event,
//     Emitter<CabBookingState> emit,
//   ) async {
//     if (event.rideId.isEmpty) {
//       print("⚠️ No rideId found, skipping polling");
//       return;
//     }

//     // Restore searching state
//     emit(
//       state.copyWith(
//           rideId: event.rideId,
//           pickupLocation: event.pickupLocation,
//           pickupText: event.pickupAddress,
//           dropLocation: event.dropLocation,
//           destinationText: event.dropAddress,
//           rideFlowStatus: RideFlowStatus.searchingDriver,
//           isRideBooked: true,
//           selectedVehicle: event.selectedVehicle),
//     );

//     await pollRideStatus(event.rideId, emit);
//   }

//   Future<void> _loadDriverMarker() async {
//     if (_markerLoaded) return;

//     final ByteData data = await rootBundle.load(AppImages.cabMarker);
//     final ui.Codec codec = await ui.instantiateImageCodec(
//       data.buffer.asUint8List(),
//       targetWidth: 110,
//     );
//     final ui.FrameInfo fi = await codec.getNextFrame();
//     final Uint8List markerBytes =
//         (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
//             .buffer
//             .asUint8List();

//     _driverCustomMarker = BitmapDescriptor.fromBytes(markerBytes);
//     _markerLoaded = true;
//   }
// }
