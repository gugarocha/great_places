import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../screens/map_screen.dart';
import '../utils/location_util.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPostion;

  const LocationInput(this.onSelectPostion, {Key? key}) : super(key: key);

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  bool _isLoading = false;
  String? _previewImageUrl;

  void _showPreview(double lat, double lng) {
    final staticMapImageUrl = LocationUtil.generateLocationPreviewImage(
      latitude: lat,
      longitude: lng,
    );

    setState(() {
      _previewImageUrl = staticMapImageUrl;
      _isLoading = false;
    });
  }

  Future<void> getCurrentUserLocation() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final locationData = await Location().getLocation();

      _showPreview(locationData.latitude!, locationData.longitude!);

      widget.onSelectPostion(LatLng(
        locationData.latitude!,
        locationData.longitude!,
      ));
    } catch (e) {
      return;
    }
  }

  Future<void> _selectOnMap() async {
    final LatLng? selectedPosition = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => const MapScreen(),
      ),
    );

    if (selectedPosition == null) return;

    _showPreview(selectedPosition.latitude, selectedPosition.longitude);

    widget.onSelectPostion(selectedPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _isLoading
              ? const CircularProgressIndicator()
              : _previewImageUrl == null
                  ? const Text('Localização não informada!')
                  : Image.network(
                      _previewImageUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text('Localização atual'),
              onPressed: getCurrentUserLocation,
            ),
            TextButton.icon(
              icon: const Icon(Icons.map),
              label: const Text('Selecione no mapa'),
              onPressed: _selectOnMap,
            ),
          ],
        ),
      ],
    );
  }
}
