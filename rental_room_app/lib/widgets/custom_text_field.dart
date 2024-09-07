import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rental_room_app/themes/color_palete.dart';
import 'package:rental_room_app/themes/text_styles.dart';

enum CustomFormFieldType { textFormField, genderFormField, dateFormField }

class CustomFormField extends StatefulWidget {
  final CustomFormFieldType type;
  //TextFormField
  final TextEditingController? editingController;
  final String? Function(String?)? stringValidator;
  final TextInputType? keyboardType;
  final TextAlign? textAlign;
  final TextStyle? style;
  final bool? obscureText;
  final IconButton? surfixIcon;
  final bool? enabled;
  final String? initialValue;

  //GenderFormField
  final String? gender;
  final Function(String?)? onChangedString;
  final FormFieldState<String?>? state;

  //DateTimeFormField
  final String? Function(DateTime?)? dateTimeValidator;
  final Function(DateTime?)? onChangedDateTime;
  final DateTimeFieldPickerMode? dateTimeFieldPickerMode;
  const CustomFormField._(
      // ignore: unused_element
      {super.key,
      required this.type,
      this.stringValidator,
      this.editingController,
      this.keyboardType,
      this.textAlign,
      this.style,
      this.obscureText,
      this.surfixIcon,
      this.gender,
      this.onChangedString,
      this.state,
      this.dateTimeValidator,
      this.onChangedDateTime,
      this.dateTimeFieldPickerMode,
      this.enabled,
      this.initialValue});
  factory CustomFormField.textFormField(
      {TextEditingController? editingController,
      String? Function(String?)? stringValidator,
      TextInputType? keyboardType,
      TextAlign? textAlign,
      TextStyle? style,
      bool? obscureText,
      IconButton? surfixIcon,
      bool? enabled,
      String? initialValue}) {
    return CustomFormField._(
      type: CustomFormFieldType.textFormField,
      editingController: editingController,
      stringValidator: stringValidator,
      keyboardType: keyboardType,
      textAlign: textAlign,
      style: style,
      obscureText: obscureText,
      surfixIcon: surfixIcon,
      enabled: enabled,
      initialValue: initialValue,
    );
  }
  factory CustomFormField.genderFormField({
    required String? gender,
    required Function(String?) onChangedString,
    String? Function(String?)? stringValidator,
    FormFieldState<String?>? state,
    TextStyle? style,
  }) {
    return CustomFormField._(
      type: CustomFormFieldType.genderFormField,
      gender: gender,
      onChangedString: onChangedString,
      stringValidator: stringValidator,
      state: state,
      style: style,
    );
  }
  factory CustomFormField.dateFormField({
    required String? Function(DateTime?) dateTimeValidator,
    required Function(DateTime?) onChangedDateTime,
    TextStyle? style,
    DateTimeFieldPickerMode? dateTimePickerMode,
  }) {
    return CustomFormField._(
      type: CustomFormFieldType.dateFormField,
      dateTimeValidator: dateTimeValidator,
      onChangedDateTime: onChangedDateTime,
      style: style,
      dateTimeFieldPickerMode: dateTimePickerMode,
    );
  }

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  @override
  Widget build(BuildContext context) {
    if (widget.type == CustomFormFieldType.genderFormField) {
      return FormField(
        validator: widget.stringValidator,
        builder: (FormFieldState<String?> state) {
          return InputDecorator(
            decoration: InputDecoration(
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              helperText: "",
              errorText: state.errorText,
            ),
            child: Row(
              children: <Widget>[
                const Gap(10),
                Radio<String>(
                  activeColor: ColorPalette.primaryColor,
                  value: "Male",
                  groupValue: widget.gender,
                  onChanged: (value) {
                    widget.onChangedString!(value);
                    state.didChange(widget.gender);
                  },
                ),
                Text(
                  "Male",
                  style: widget.style ?? TextStyles.h5,
                ),
                const Gap(35),
                Radio<String>(
                    activeColor: ColorPalette.primaryColor,
                    value: "Female",
                    groupValue: widget.gender,
                    onChanged: (value) {
                      widget.onChangedString!(value);
                      state.didChange(widget.gender);
                    }),
                Text(
                  "Female",
                  style: widget.style ?? TextStyles.h5,
                ),
              ],
            ),
          );
        },
      );
    } else if (widget.type == CustomFormFieldType.dateFormField) {
      return DateTimeFormField(
        validator: widget.dateTimeValidator,
        onChanged: widget.onChangedDateTime,
        mode: widget.dateTimeFieldPickerMode ?? DateTimeFieldPickerMode.date,
        style: widget.style ?? TextStyles.h5,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          enabledBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(width: 1, color: ColorPalette.detailBorder),
              borderRadius: BorderRadius.circular(20)),
          focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(width: 1, color: ColorPalette.primaryColor),
              borderRadius: BorderRadius.circular(20)),
          errorBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(width: 1, color: ColorPalette.errorColor),
              borderRadius: BorderRadius.circular(20)),
          helperText: " ",
        ),
      );
    }
    return TextFormField(
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
      controller: widget.editingController,
      validator: widget.stringValidator,
      enabled: widget.enabled,
      initialValue: widget.initialValue,
      keyboardType: widget.keyboardType,
      style: widget.style ?? TextStyles.h6,
      textAlign: widget.textAlign ?? TextAlign.left,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        enabledBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(width: 1, color: ColorPalette.detailBorder),
            borderRadius: BorderRadius.circular(20)),
        disabledBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(width: 1, color: ColorPalette.detailBorder),
            borderRadius: BorderRadius.circular(20)),
        focusedBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(width: 1, color: ColorPalette.primaryColor),
            borderRadius: BorderRadius.circular(20)),
        errorBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(width: 1, color: ColorPalette.errorColor),
            borderRadius: BorderRadius.circular(20)),
        helperText: " ",
        suffixIcon: widget.surfixIcon,
      ),
      obscureText: widget.obscureText ?? false,
      obscuringCharacter: '*',
    );
  }
}
