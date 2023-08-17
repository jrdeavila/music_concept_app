import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:get/get.dart';
import 'package:music_concept_app/lib.dart';

class SearchPlacesTextField extends StatefulWidget {
  const SearchPlacesTextField({
    super.key,
    this.onTapItem,
  });

  final void Function(Prediction position)? onTapItem;

  @override
  State<SearchPlacesTextField> createState() => _SearchPlacesTextFieldState();
}

class _SearchPlacesTextFieldState extends State<SearchPlacesTextField> {
  final TextEditingController _searchCtrl = TextEditingController();
  CancelToken _cancelToken = CancelToken();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(0.1),
          ),
        ]),
        child: TextField(
          controller: _searchCtrl,
          style: TextStyle(
            color: Get.theme.colorScheme.primary,
          ),
          onChanged: _searchPlaces,
          decoration: InputDecoration(
            filled: true,
            fillColor: Get.theme.colorScheme.onPrimary,
            prefixIcon: Icon(
              MdiIcons.magnify,
              color: Get.theme.colorScheme.primary,
            ),
            suffixIcon: GestureDetector(
              onTap: () {
                _clearPlaces();
              },
              child: Icon(
                MdiIcons.close,
                color: Colors.grey[400],
              ),
            ),
            hintText: 'Buscar direccion',
            hintStyle: TextStyle(
              color: Colors.grey[400],
            ),
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  OverlayEntry _showPredictions(List<Prediction> predictions) {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(builder: (context) {
      return Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 20.0,
        width: size.width,
        child: CompositedTransformFollower(
          showWhenUnlinked: false,
          link: _layerLink,
          offset: Offset(0.0, size.height + 20.0),
          child: DecoratedBox(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                blurRadius: 10,
                color: Colors.black.withOpacity(0.1),
              ),
            ]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Material(
                color: Get.theme.colorScheme.onPrimary,
                elevation: 1.0,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(top: 20.0),
                  shrinkWrap: true,
                  itemCount: predictions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      onTap: () {
                        _onTapItem(predictions[index]);
                      },
                      minVerticalPadding: 10.0,
                      leading: Icon(
                        MdiIcons.mapMarker,
                        color: Get.theme.colorScheme.primary,
                      ),
                      title: Text(
                        "${predictions[index].description}",
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      subtitle: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${predictions[index].structuredFormatting?.mainText}",
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12.0,
                            ),
                          ),
                          Text(
                            "${predictions[index].structuredFormatting?.secondaryText}",
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  void _clearPlaces() {
    _searchCtrl.clear();
    _cancelToken.cancel();
    _cancelToken = CancelToken();
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _searchPlaces(String value) {
    Future.delayed(
      const Duration(milliseconds: 600),
      () {
        _cancelToken.cancel();
        _cancelToken = CancelToken();

        SearchPlacesServices.searchPlaces(
                value: value, cancelToken: _cancelToken)
            .then((response) {
          if (response.isNotEmpty) {
            _overlayEntry?.remove();
            _overlayEntry = null;
            _overlayEntry = _showPredictions(response);
            Overlay.of(context).insert(_overlayEntry!);
          }
        });
      },
    );
  }

  void _onTapItem(Prediction prediction) {
    _clearPlaces();
    SearchPlacesServices.searchPlaceDetails(prediction.placeId!)
        .then((response) {
      prediction.lat = response.result?.geometry?.location?.lat?.toString();
      prediction.lng = response.result?.geometry?.location?.lng?.toString();
      widget.onTapItem?.call(prediction);
    });
  }
}
