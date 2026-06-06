import 'dart:async';
import 'package:flutter/material.dart';
import 'package:popytka_ua/data/services/nominatim_service.dart';
import 'package:popytka_ua/presentation/theme/app_colors.dart';

/// A text field with address autocomplete suggestions.
class AddressAutocompleteField extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController? controller;
  final void Function(NominatimResult result)? onAddressSelected;
  final bool filled;
  final Color? fillColor;

  const AddressAutocompleteField({
    super.key,
    required this.hintText,
    this.icon = Icons.location_on,
    this.controller,
    this.onAddressSelected,
    this.filled = false,
    this.fillColor,
  });

  @override
  State<AddressAutocompleteField> createState() =>
      _AddressAutocompleteFieldState();
}

class _AddressAutocompleteFieldState extends State<AddressAutocompleteField> {
  late TextEditingController _controller;
  final NominatimService _nominatimService = NominatimService();
  final LayerLink _layerLink = LayerLink();

  OverlayEntry? _overlayEntry;
  List<NominatimResult> _suggestions = [];
  Timer? _debounce;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _removeOverlay();
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onTextChanged(String query) {
    _debounce?.cancel();

    if (query.length < 3) {
      _removeOverlay();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      setState(() => _isLoading = true);

      final results = await _nominatimService.searchAddress(query);

      if (mounted) {
        setState(() {
          _suggestions = results;
          _isLoading = false;
        });

        if (results.isNotEmpty) {
          _showOverlay();
        } else {
          _removeOverlay();
        }
      }
    });
  }

  void _showOverlay() {
    _removeOverlay();
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: context.findRenderObject() != null
            ? (context.findRenderObject() as RenderBox).size.width
            : 300,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 50),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            color: theme.colorScheme.surface,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  final result = _suggestions[index];
                  return ListTile(
                    dense: true,
                    leading: const Icon(
                      Icons.place,
                      color: AppColors.secondary,
                      size: 20,
                    ),
                    title: Text(
                      result.shortName,
                      style: TextStyle(color: onSurface, fontSize: 14),
                    ),
                    subtitle: Text(
                      result.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: onSurface.withValues(alpha: 0.54),
                        fontSize: 11,
                      ),
                    ),
                    onTap: () => _selectAddress(result),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _selectAddress(NominatimResult result) {
    _controller.text = result.shortName;
    _removeOverlay();
    widget.onAddressSelected?.call(result);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        controller: _controller,
        onChanged: _onTextChanged,
        onTap: () {
          if (_suggestions.isNotEmpty) {
            _showOverlay();
          }
        },
        style: TextStyle(
          color: onSurface,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: onSurface.withValues(alpha: 0.54)),
          prefixIcon: Icon(widget.icon, color: AppColors.secondary),
          suffixIcon: _isLoading
              ? const Padding(
                  padding: EdgeInsets.all(12),
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : null,
          filled: widget.filled,
          fillColor: widget.fillColor ?? onSurface.withValues(alpha: 0.05),
          border: widget.filled
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                )
              : InputBorder.none,
          isDense: !widget.filled,
          contentPadding: widget.filled
              ? const EdgeInsets.symmetric(horizontal: 16, vertical: 14)
              : EdgeInsets.zero,
        ),
      ),
    );
  }
}
