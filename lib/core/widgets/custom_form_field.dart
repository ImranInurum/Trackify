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
    this.borderColor = Colors.grey,
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

  @override
  void initState() {
    super.initState();
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
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: (showLabel && widget.value != null && widget.value!.text.isEmpty)
            ? 4.0
            : 12.0,
        horizontal: 5.0,
      ),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Theme.of(context).colorScheme.surface,
        border: Border.all(color: widget.borderColor, width: 1.0),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                TextFormField(
                  enableInteractiveSelection: widget.enableInteractiveSelection,
                  enabled: !(widget.disabled ?? false),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiaryFixedDim,
                    /*fontFamily: AssetsConstants.defaultFont*/),
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
                  obscureText: widget.isPassword,
                  controller: widget.value,
                  minLines: widget.minLines,
                  maxLines: widget.maxLines,
                  keyboardType: widget.keyboardType,
                  decoration: InputDecoration(
                    hintStyle: const TextStyle(
                      /*fontFamily: AssetsConstants.defaultFont,*/
                      overflow: TextOverflow.ellipsis,
                      color: Colors.grey,
                    ),
                    suffixIcon: _buildSuffixIcons(),
                    counterText: '',
                    prefixText: widget.prefixText,
                    contentPadding: widget.isSearch!
                        ? const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0)
                        : const EdgeInsets.symmetric(horizontal: 8.0),
                    label: showLabel && widget.value != null && widget.value!.text.isEmpty
                        ? Row(
                            children: [
                              if (widget.isFieldMandatory) ...[
                                Text('*', style: TextStyle(color: AppColors.errorLight)),
                                //AppText.body("* ", state: TextState.error)
                              ],
                              Expanded(
                                child: Text(
                                  widget.header,
                                  style: TextStyle(
                                    fontSize: 16,
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              /*                        Expanded(
                          child: AppText.body(widget.header,
                              state: TextState.disabled,
                              fontsize: 16,
                              overflow: TextOverflow.ellipsis),
                        )*/
                            ],
                          )
                        : null,
                    border: InputBorder.none,
                    focusedBorder: widget.focusBorder,
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.errorLight, width: 1.0),
                    ),
                    isDense: true,
                    hintText: widget.hint,
                    fillColor: Theme.of(context).colorScheme.surface,
                    focusColor: Theme.of(context).colorScheme.surface,
                    errorText: errorMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
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

    if (icons.isEmpty) {
      return null;
    }

    return Row(mainAxisSize: MainAxisSize.min, children: icons);
  }
}
