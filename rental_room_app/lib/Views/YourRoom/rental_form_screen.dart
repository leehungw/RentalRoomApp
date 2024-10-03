import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_room_app/Contract/YourRoom/rental_form_contract.dart';
import 'package:rental_room_app/Models/Room/room_model.dart';
import 'package:rental_room_app/Presenter/YourRoom/rental_from_presenter.dart';
import 'package:rental_room_app/Views/Home/home_screen.dart';
import 'package:rental_room_app/themes/color_palete.dart';
import 'package:rental_room_app/themes/text_styles.dart';
import 'package:rental_room_app/widgets/custom_text_field.dart';
import 'package:rental_room_app/widgets/model_button.dart';
import 'package:rental_room_app/widgets/numeric_up_down.dart';

class RentalFormScreen extends StatefulWidget {
  final Room room;
  const RentalFormScreen({super.key, required this.room});
  static const String routeName = "rental_form";

  @override
  State<RentalFormScreen> createState() => _RentalFormScreenState();
}

class _RentalFormScreenState extends State<RentalFormScreen>
    implements RentalFormContract {
  RentalFormPresenter? _rentalFormPresenter;
  final _formKey = GlobalKey<FormState>();

  //
  //params controllers
  //

  final TextEditingController _roomIdController = TextEditingController();

  final _citizenIdentificationController = TextEditingController();
  final _numberOfPeopleController = TextEditingController();
  DateTime? _startDate = DateTime.now();
  final _durationController = TextEditingController();
  final _depositController = TextEditingController();
  final _facebookController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _rentalFormPresenter = RentalFormPresenter(this);
    _roomIdController.text = widget.room.roomName;
    _durationController.text = "1";
    _numberOfPeopleController.text = "1";
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: ColorPalette.backgroundColor,
          // leadingWidth: kDefaultIconSize * 3,
          leading: SizedBox(
            width: double.infinity,
            child: InkWell(
              customBorder: const CircleBorder(),
              onHighlightChanged: (param) {},
              splashColor: ColorPalette.primaryColor,
              onTap: () => context.pop(),
              child: const Icon(
                FontAwesomeIcons.arrowLeft,
                color: ColorPalette.primaryColor,
                shadows: [Shadow(color: Colors.black12, offset: Offset(3, 6))],
              ),
            ),
          ),
          title: Text('Rental Form',
              style: TextStyles.slo.bold.copyWith(
                color: ColorPalette.primaryColor,
                shadows: [
                  const Shadow(
                    color: Colors.black12,
                    offset: Offset(3, 3),
                    blurRadius: 6,
                  )
                ],
              )),
          centerTitle: true,
          toolbarHeight: kToolbarHeight * 1.5,
        ),
        resizeToAvoidBottomInset: true,
        backgroundColor: ColorPalette.backgroundColor,
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              color: ColorPalette.backgroundColor,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Gap(30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Row(
                        children: [
                          Text(
                            "Room Name",
                            style: TextStyles.timenotifi.medium
                                .copyWith(color: ColorPalette.darkBlueText),
                          ),
                          Text(
                            ' *',
                            style: TextStyles.roomProps
                                .copyWith(color: ColorPalette.redColor),
                          ),
                        ],
                      ),
                    ),
                    const Gap(5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: CustomFormField.textFormField(
                        enabled: false,
                        stringValidator: _rentalFormPresenter!.validateRoomId,
                        editingController: _roomIdController,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.center,
                        style: TextStyles.h6.italic,
                      ),
                    ),
                    const Gap(5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Row(
                        children: [
                          Text(
                            "Identification Number",
                            style: TextStyles.timenotifi.medium
                                .copyWith(color: ColorPalette.darkBlueText),
                          ),
                          Text(
                            ' *',
                            style: TextStyles.roomProps
                                .copyWith(color: ColorPalette.redColor),
                          ),
                        ],
                      ),
                    ),
                    const Gap(5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: CustomFormField.textFormField(
                        stringValidator:
                            _rentalFormPresenter!.validateIdentification,
                        editingController: _citizenIdentificationController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: TextStyles.h6.italic,
                      ),
                    ),
                    const Gap(5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Row(
                        children: [
                          Text(
                            "Number of People",
                            style: TextStyles.timenotifi.medium
                                .copyWith(color: ColorPalette.darkBlueText),
                          ),
                          Text(
                            ' *',
                            style: TextStyles.roomProps
                                .copyWith(color: ColorPalette.redColor),
                          ),
                        ],
                      ),
                    ),
                    const Gap(5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: NumericUpDown(
                        controller: _numberOfPeopleController,
                      ),
                    ),
                    const Gap(20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Row(
                        children: [
                          Text(
                            "Start Date",
                            style: TextStyles.timenotifi.medium
                                .copyWith(color: ColorPalette.darkBlueText),
                          ),
                          Text(
                            ' *',
                            style: TextStyles.roomProps
                                .copyWith(color: ColorPalette.redColor),
                          ),
                        ],
                      ),
                    ),
                    const Gap(5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: CustomFormField.dateFormField(
                        dateTimeValidator:
                            _rentalFormPresenter!.validateStartDate,
                        style: TextStyles.h6.italic,
                        onChangedDateTime: (value) {
                          setState(() {
                            _startDate = value;
                          });
                        },
                      ),
                    ),
                    const Gap(5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Row(
                        children: [
                          Text(
                            "Duration (Month)",
                            style: TextStyles.timenotifi.medium
                                .copyWith(color: ColorPalette.darkBlueText),
                          ),
                          Text(
                            ' *',
                            style: TextStyles.roomProps
                                .copyWith(color: ColorPalette.redColor),
                          ),
                        ],
                      ),
                    ),
                    const Gap(5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: NumericUpDown(
                        min: 1,
                        max: 24,
                        controller: _durationController,
                      ),
                    ),
                    const Gap(20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Row(
                        children: [
                          Text(
                            "Deposit",
                            style: TextStyles.timenotifi.medium
                                .copyWith(color: ColorPalette.darkBlueText),
                          ),
                          Text(
                            ' *',
                            style: TextStyles.roomProps
                                .copyWith(color: ColorPalette.redColor),
                          ),
                        ],
                      ),
                    ),
                    const Gap(5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: CustomFormField.textFormField(
                        stringValidator: _rentalFormPresenter!.validateDeposit,
                        editingController: _depositController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: TextStyles.h6.italic,
                      ),
                    ),
                    const Gap(5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Row(
                        children: [
                          Text(
                            "Facebook",
                            style: TextStyles.timenotifi.medium
                                .copyWith(color: ColorPalette.darkBlueText),
                          ),
                          Text(
                            ' *',
                            style: TextStyles.roomProps
                                .copyWith(color: ColorPalette.redColor),
                          ),
                        ],
                      ),
                    ),
                    const Gap(5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: CustomFormField.textFormField(
                        stringValidator: _rentalFormPresenter!.validateFacebook,
                        editingController: _facebookController,
                        keyboardType: TextInputType.url,
                        textAlign: TextAlign.center,
                        style: TextStyles.h6.italic,
                      ),
                    ),
                    const Gap(20),
                    ModelButton(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            _rentalFormPresenter!.sendRentalForm(
                                widget.room.roomId,
                                _citizenIdentificationController.text,
                                _numberOfPeopleController.text,
                                _startDate,
                                _durationController.text,
                                _depositController.text,
                                _facebookController.text);
                          }
                        },
                        name: "Send",
                        color: ColorPalette.primaryColor.withOpacity(0.75),
                        width: 150),
                    const Gap(10),
                    ModelButton(
                        onTap: () => context.pop(),
                        name: "Cancel",
                        color: ColorPalette.redColor.withOpacity(0.75),
                        width: 150),
                    const Gap(30),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  void onRentalFailed() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: ColorPalette.greenText,
        content: Text(
          'Cannot Rental This Room! Please try again later!',
          style: TextStyle(color: ColorPalette.errorColor),
        ),
      ),
    );
  }

  @override
  void onRentalSucceed() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: ColorPalette.greenText,
        content: Text(
          'Rental succeeded!',
          style: TextStyle(color: ColorPalette.errorColor),
        ),
      ),
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ),
    );
  }

  @override
  void onWaitingProgressBar() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
  }

  @override
  void onPopContext() {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
