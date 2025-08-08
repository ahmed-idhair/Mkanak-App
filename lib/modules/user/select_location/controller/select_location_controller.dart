import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mkanak/app/routes/app_routes.dart';
import 'package:mkanak/modules/base_controller.dart';

class SelectLocationController extends BaseController
    with GetTickerProviderStateMixin {
  GoogleMapController? mapController;
  late AnimationController markerAnimationController;
  late Animation<double> markerScaleAnimation;
  late Animation<double> markerBounceAnimation;

  // Observable variables
  RxString searchText = ''.obs;
  Rx<LatLng> currentLocation =
      const LatLng(31.5017, 34.4668).obs; // Cairo coordinates
  Rx<LatLng> selectedLocation = const LatLng(31.5017, 34.4668).obs;
  RxBool isLoading = false.obs;
  RxBool isMapMoving = false.obs;
  RxString selectedLocationAddress = 'جاري تحديد الموقع...'.obs;
  RxBool isLoadingAddress = false.obs;

  Timer? _debounceTimer;
  int? serviceId;

  @override
  void onInit() {
    super.onInit();
    serviceId = Get.arguments['serviceId'];
    _initializeAnimations();
    _requestLocationPermission();
  }


  void _initializeAnimations() {
    markerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    markerScaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: markerAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    markerBounceAnimation = Tween<double>(begin: 0.0, end: 30.0).animate(
      CurvedAnimation(
        parent: markerAnimationController,
        curve: Curves.bounceOut,
      ),
    );
  }

  Future<void> _requestLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      selectedLocationAddress.value = 'خدمة الموقع غير مفعلة';
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        selectedLocationAddress.value = 'تم رفض صلاحية الموقع';
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      selectedLocationAddress.value = 'صلاحية الموقع مرفوضة نهائياً';
      return;
    }

    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      currentLocation.value = LatLng(position.latitude, position.longitude);
      selectedLocation.value = LatLng(position.latitude, position.longitude);

      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newLatLng(currentLocation.value),
        );
      }

      _getAddressFromCoordinates(selectedLocation.value);
    } catch (e) {
      // If getting current location fails, use Cairo as default
      _getAddressFromCoordinates(currentLocation.value);
    }
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;

    // Set map style for better appearance
    _setMapStyle();
  }

  Future<void> _setMapStyle() async {
    String mapStyle = '''
    [
      {
        "featureType": "all",
        "elementType": "geometry.fill",
        "stylers": [
          {
            "weight": "2.00"
          }
        ]
      },
      {
        "featureType": "all",
        "elementType": "geometry.stroke",
        "stylers": [
          {
            "color": "#9c9c9c"
          }
        ]
      },
      {
        "featureType": "all",
        "elementType": "labels.text",
        "stylers": [
          {
            "visibility": "on"
          }
        ]
      },
      {
        "featureType": "landscape",
        "elementType": "all",
        "stylers": [
          {
            "color": "#f2f2f2"
          }
        ]
      },
      {
        "featureType": "landscape",
        "elementType": "geometry.fill",
        "stylers": [
          {
            "color": "#ffffff"
          }
        ]
      },
      {
        "featureType": "landscape.man_made",
        "elementType": "geometry.fill",
        "stylers": [
          {
            "color": "#ffffff"
          }
        ]
      },
      {
        "featureType": "poi",
        "elementType": "all",
        "stylers": [
          {
            "visibility": "off"
          }
        ]
      },
      {
        "featureType": "road",
        "elementType": "all",
        "stylers": [
          {
            "saturation": -100
          },
          {
            "lightness": 45
          }
        ]
      },
      {
        "featureType": "road",
        "elementType": "geometry.fill",
        "stylers": [
          {
            "color": "#eeeeee"
          }
        ]
      },
      {
        "featureType": "road",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#7b7b7b"
          }
        ]
      },
      {
        "featureType": "road",
        "elementType": "labels.text.stroke",
        "stylers": [
          {
            "color": "#ffffff"
          }
        ]
      },
      {
        "featureType": "road.highway",
        "elementType": "all",
        "stylers": [
          {
            "visibility": "simplified"
          }
        ]
      },
      {
        "featureType": "road.arterial",
        "elementType": "labels.icon",
        "stylers": [
          {
            "visibility": "off"
          }
        ]
      },
      {
        "featureType": "transit",
        "elementType": "all",
        "stylers": [
          {
            "visibility": "off"
          }
        ]
      },
      {
        "featureType": "water",
        "elementType": "all",
        "stylers": [
          {
            "color": "#46bcec"
          },
          {
            "visibility": "on"
          }
        ]
      },
      {
        "featureType": "water",
        "elementType": "geometry.fill",
        "stylers": [
          {
            "color": "#c8d7d4"
          }
        ]
      },
      {
        "featureType": "water",
        "elementType": "labels.text.fill",
        "stylers": [
          {
            "color": "#070707"
          }
        ]
      },
      {
        "featureType": "water",
        "elementType": "labels.text.stroke",
        "stylers": [
          {
            "color": "#ffffff"
          }
        ]
      }
    ]
    ''';

    mapController?.setMapStyle(mapStyle);
  }

  void onCameraMove(CameraPosition position) {
    selectedLocation.value = position.target;

    if (!isMapMoving.value) {
      isMapMoving.value = true;
      isLoadingAddress.value = true;
      selectedLocationAddress.value = 'جاري تحديد الموقع...';
      _animateMarker();
    }

    // Cancel previous timer
    _debounceTimer?.cancel();
  }

  void onCameraIdle() {
    isMapMoving.value = false;
    _resetMarkerAnimation();

    // Use debounce to avoid too many API calls
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _getAddressFromCoordinates(selectedLocation.value);
    });
  }

  Future<void> _getAddressFromCoordinates(LatLng location) async {
    try {
      isLoadingAddress.value = true;

      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
        // localeIdentifier: 'ar_EG', // Arabic locale for Egypt
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        // Build Arabic address
        List<String> addressParts = [];

        if (place.street != null && place.street!.isNotEmpty) {
          addressParts.add(place.street!);
        }
        if (place.subLocality != null && place.subLocality!.isNotEmpty) {
          addressParts.add(place.subLocality!);
        }
        if (place.locality != null && place.locality!.isNotEmpty) {
          addressParts.add(place.locality!);
        }
        if (place.administrativeArea != null &&
            place.administrativeArea!.isNotEmpty) {
          addressParts.add(place.administrativeArea!);
        }
        if (place.country != null && place.country!.isNotEmpty) {
          addressParts.add(place.country!);
        }

        String address = addressParts.join('، ');
        if (address.isEmpty) {
          address = 'موقع غير محدد';
        }

        selectedLocationAddress.value = address;
      } else {
        selectedLocationAddress.value = 'لا يمكن تحديد العنوان';
      }
    } catch (e) {
      print('Error getting address: $e');
      selectedLocationAddress.value = 'خطأ في تحديد العنوان';
    } finally {
      isLoadingAddress.value = false;
    }
  }

  void _animateMarker() {
    markerAnimationController.forward();
  }

  void _resetMarkerAnimation() {
    markerAnimationController.reverse();
  }

  void onSearchChanged(String value) {
    searchText.value = value;

    if (value.isNotEmpty) {
      _searchLocation(value);
    }
  }

  Future<void> _searchLocation(String query) async {
    try {
      List<Location> locations = await locationFromAddress(query);

      if (locations.isNotEmpty) {
        Location location = locations.first;
        LatLng newLocation = LatLng(location.latitude, location.longitude);

        selectedLocation.value = newLocation;

        mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(newLocation, 15.0),
        );

        _getAddressFromCoordinates(newLocation);
      }
    } catch (e) {
      Get.snackbar(
        'خطأ في البحث',
        'لم يتم العثور على الموقع المطلوب',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void onSaveAndFollow() {
    Get.toNamed(AppRoutes.newOrder);
    // Get.snackbar(
    //   'تم الحفظ',
    //   'تم حفظ الموقع ومتابعته بنجاح\n${selectedLocationAddress.value}',
    //   backgroundColor: Colors.green,
    //   colorText: Colors.white,
    //   duration: const Duration(seconds: 3),
    //   snackPosition: SnackPosition.BOTTOM,
    // );
  }

  void onLocationTap() {
    isLoading.value = true;
    _getCurrentLocation().then((_) {
      isLoading.value = false;
    });
  }

  @override
  void onClose() {
    markerAnimationController.dispose();
    _debounceTimer?.cancel();
    super.onClose();
  }
}
