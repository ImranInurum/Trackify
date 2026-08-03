import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';

class CustomFormField extends StatefulWidget {
  final String header;
  final String hint;
  final String? Function(String?)? validator;
  final TextEditingController? value;
  final String keyName;
  final TextInputType keyboardType;
  final bool isPassword;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final Color borderColor;
  final InputBorder focusBorder;
  final void Function()? onTap;
  final bool? isReadOnly;
  final String? prefixText;
  final Widget? prefixIcon;
  final void Function(String)? onChanged;
  final bool? isFocused;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final bool? isSearch;
  final bool? hasFilePicker;
  final void Function()? onPickFile;
  final void Function()? onClickArthurAssistant;
  final void Function()? onSearch;
  final bool isFieldMandatory;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final bool capitalizeFirstLetter;
  final void Function(String)? onFieldSubmitted;
  final bool? disabled;
  final bool? enableInteractiveSelection;
  final bool? hasClearIcon;
  final TextCapitalization textCapitalization;
  final Color? textColor;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;

  const CustomFormField({
    super.key,
    this.header = '',
    this.hint = '',
    this.validator,
    this.value,
    this.keyName = '',
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.padding = const EdgeInsets.all(12.0),
    this.backgroundColor,
    this.focusBorder = InputBorder.none,
    this.borderColor = const Color(0xFFD1D5DB),
    this.onTap,
    this.isReadOnly = false,
    this.prefixText,
    this.prefixIcon,
    this.onChanged,
    this.isFocused = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.maxLength = 80,
    this.isSearch = false,
    this.hasFilePicker = false,
    this.onPickFile,
    this.onClickArthurAssistant,
    this.onSearch,
    this.isFieldMandatory = false,
    this.inputFormatters,
    this.autofillHints,
    this.capitalizeFirstLetter = false,
    this.onFieldSubmitted,
    this.disabled,
    this.enableInteractiveSelection,
    this.hasClearIcon,
    this.textCapitalization = TextCapitalization.none,
    this.textColor,
    this.textInputAction,
    this.focusNode,
  });

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  late FocusNode _internalFocusNode;
  FocusNode get _effectiveFocusNode => widget.focusNode ?? _internalFocusNode;

  bool showLabel = true;
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.isPassword;
    _internalFocusNode = FocusNode();
    _effectiveFocusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(CustomFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      (oldWidget.focusNode ?? _internalFocusNode).removeListener(_onFocusChange);
      _effectiveFocusNode.addListener(_onFocusChange);
    }
  }

  @override
  void dispose() {
    _effectiveFocusNode.removeListener(_onFocusChange);
    _internalFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (mounted) {
      setState(() {
        showLabel = !_effectiveFocusNode.hasFocus;
      });
    }
  }

  void _handleTextChanged(String text) {
    String newText = text;

    if (widget.capitalizeFirstLetter) {
      newText = text.isNotEmpty ? text[0].toUpperCase() + text.substring(1) : text;

      if (widget.value != null && widget.value!.text != newText) {
        widget.value!.value = widget.value!.value.copyWith(
          text: newText,
          selection: TextSelection.collapsed(offset: newText.length),
        );
      }
    }

    if (widget.onChanged != null) {
      widget.onChanged!(newText);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.header.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: widget.header,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  if (widget.isFieldMandatory)
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: _effectiveFocusNode.hasFocus 
                    ? primaryColor.withValues(alpha: 0.15) 
                    : Colors.black.withValues(alpha: 0.05),
                blurRadius: _effectiveFocusNode.hasFocus ? 12 : 8,
                offset: const Offset(0, 4),
                spreadRadius: _effectiveFocusNode.hasFocus ? 1 : 0,
              ),
            ],
          ),
          child: TextFormField(
            textCapitalization: widget.textCapitalization,
            enableInteractiveSelection: widget.enableInteractiveSelection,
            enabled: !(widget.disabled ?? false),
            style: TextStyle(
              fontSize: 16,
              color: widget.textColor ?? Theme.of(context).colorScheme.onSurface,
              fontWeight: widget.textColor != null ? FontWeight.w600 : FontWeight.w400,
            ),
            onFieldSubmitted: widget.onFieldSubmitted,
            focusNode: _effectiveFocusNode,
            inputFormatters: widget.inputFormatters,
            autofillHints: widget.autofillHints,
            maxLength: widget.maxLength,
            autofocus: widget.isFocused!,
            onChanged: _handleTextChanged,
            readOnly: widget.isReadOnly!,
            onTap: widget.onTap,
            key: Key(widget.keyName),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: widget.validator,
            obscureText: _isObscured,
            controller: widget.value,
            minLines: widget.minLines,
            maxLines: widget.maxLines,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                fontSize: 14,
              ),
              filled: true,
              fillColor: widget.backgroundColor ?? theme.inputDecorationTheme.fillColor ?? theme.cardColor,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              prefixText: widget.prefixText,
              prefixIcon: widget.prefixIcon,
              suffixIcon: _buildSuffixIcons(),
              counterText: '',
              errorStyle: const TextStyle(height: 0.8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: widget.borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: widget.borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: primaryColor, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: 1.5),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffixIcons() {
    List<Widget> icons = [];

    if (widget.isSearch ?? false) {
      icons.add(
        Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: IconButton(
            onPressed: widget.onSearch,
            icon: Icon(
              Icons.search,
              size: 30,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      );
    }

    if (widget.hasClearIcon ?? false) {
      icons.add(
        Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: IconButton(
            onPressed: () {
              widget.value?.clear();
              _handleTextChanged('');
            },
            icon: Icon(
              Icons.clear_rounded,
              size: 14,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ),
      );
    }

    if (widget.hasFilePicker ?? false) {
      icons.add(
        Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: IconButton(
            onPressed: widget.onPickFile,
            icon: Transform.rotate(
              angle: 0.8,
              child: Icon(
                Icons.attach_file,
                size: 30,
                color: widget.disabled ?? false 
                    ? Theme.of(context).disabledColor 
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),
      );
    }

    if (widget.isPassword) {
      icons.add(
        Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: IconButton(
            onPressed: () {
              setState(() {
                _isObscured = !_isObscured;
              });
            },
            icon: Icon(
              _isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              size: 20,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ),
      );
    }

    if (icons.isEmpty) {
      return null;
    }

    return Row(mainAxisSize: MainAxisSize.min, children: icons);
  }
}
