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
  });

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  FocusNode node = FocusNode();
  bool showLabel = true;
  String? errorMessage;
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.isPassword;
    node.addListener(() {
      setState(() {
        showLabel = !node.hasFocus;
      });
    });
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

    if (widget.validator != null) {
      setState(() {
        errorMessage = widget.validator!(newText);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: node.hasFocus 
                ? primaryColor.withOpacity(0.15) 
                : Colors.black.withOpacity(0.05),
            blurRadius: node.hasFocus ? 12 : 8,
            offset: const Offset(0, 4),
            spreadRadius: node.hasFocus ? 1 : 0,
          ),
        ],
      ),
      child: TextFormField(
        enableInteractiveSelection: widget.enableInteractiveSelection,
        enabled: !(widget.disabled ?? false),
        style: const TextStyle(fontSize: 16),
        onFieldSubmitted: widget.onFieldSubmitted,
        focusNode: node,
        inputFormatters: widget.inputFormatters,
        autofillHints: widget.autofillHints,
        maxLength: widget.maxLength,
        autofocus: widget.isFocused!,
        onChanged: _handleTextChanged,
        readOnly: widget.isReadOnly!,
        onTap: widget.onTap,
        key: Key(widget.keyName),
        validator: widget.validator,
        obscureText: _isObscured,
        controller: widget.value,
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: const TextStyle(
            overflow: TextOverflow.ellipsis,
            color: Colors.grey,
            fontSize: 14,
          ),
          filled: true,
          fillColor: widget.backgroundColor ?? const Color(0xFFF9FAFB),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          prefixText: widget.prefixText,
          suffixIcon: _buildSuffixIcons(),
          counterText: '',
          errorText: errorMessage,
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
            borderSide: BorderSide(color: AppColors.errorLight),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: AppColors.errorLight, width: 1.5),
          ),
        ),
      ),
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
            icon: const Icon(Icons.search, size: 30),
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
            icon: const Icon(Icons.clear_rounded, size: 14),
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
                color: widget.disabled ?? false ? Colors.grey : Colors.black,
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
              color: Colors.grey,
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
