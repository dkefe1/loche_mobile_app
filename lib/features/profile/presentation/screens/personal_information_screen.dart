import 'dart:io';

import 'package:cloudinary/cloudinary.dart';
import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/globals.dart';
import 'package:fantasy/core/secret.dart';
import 'package:fantasy/core/services/shared_preference_services.dart';
import 'package:fantasy/features/auth/signin/presentation/screens/signin_screen.dart';
import 'package:fantasy/features/common_widgets/date_formfield.dart';
import 'package:fantasy/features/common_widgets/error_flashbar.dart';
import 'package:fantasy/features/common_widgets/loading_button.dart';
import 'package:fantasy/features/common_widgets/loading_container.dart';
import 'package:fantasy/features/common_widgets/phone_textformfield.dart';
import 'package:fantasy/features/common_widgets/submit_button.dart';
import 'package:fantasy/features/common_widgets/textformfield.dart';
import 'package:fantasy/features/home/presentation/widgets/app_header.dart';
import 'package:fantasy/features/profile/data/models/profile.dart';
import 'package:fantasy/features/profile/data/models/update_profile.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_event.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class PersonalInformationScreen extends StatefulWidget {

  final Profile profile;

  PersonalInformationScreen({Key? key, required this.profile}) : super(key: key);

  @override
  State<PersonalInformationScreen> createState() => _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {

  File? _pickedImage;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final signupFormKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool isPhoneNumberEmpty = false;
  bool isPhoneNumberInValid = false;
  bool isFirstNameEmpty = false;
  bool isLastNameEmpty = false;
  bool isDateEmpty = false;

  bool isProPicLoading = false;

  DateTime firstDate = DateTime.now().subtract(Duration(days: 130 * 365));
  DateTime initialDate = DateTime.now().subtract(Duration(days: 21 * 365));
  DateTime lastDate = DateTime.now().subtract(Duration(days: 21 * 365));

  final dateController = TextEditingController();

  final cloudinary = Cloudinary.signedConfig(apiKey: cloudinaryApiKey, apiSecret: cloudinaryApiSecret, cloudName: cloudinaryCloudName);

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      var selected = File(image.path);
      setState(() {
        _pickedImage = selected;
        // contentType = lookupMimeType(image.path);
      });
      if (_pickedImage!.lengthSync() > 5 * 1024 * 1024){
        errorFlashBar(context: context, message: "Image must be less than 5MB");
        return;
      }
      setState(() {
        isProPicLoading = true;
      });
      final response = await cloudinary.upload(
          file: selected.path,
          fileBytes: selected.readAsBytesSync(),
          resourceType: CloudinaryResourceType.image,
          progressCallback: (count, total) {
            print(
                'Uploading image from file with progress: $count/$total');
          });

      if(response.isSuccessful) {
        print('Get your image from with ${response.secureUrl}');
        print('Get the public id ${response.publicId}');
        final updateProPic = BlocProvider.of<UpdateProPicBloc>(context);
        updateProPic.add(PatchProPicEvent(response.publicId!, response.secureUrl!));
        setState(() {
          widget.profile.pp_secure_url = response.secureUrl;
          isProPicLoading = false;
        });
      }
    } else {}
  }

  final prefs = PrefService();

  @override
  void initState() {
    DateTime dateTime = DateTime.parse(widget.profile.birth_date);
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

    firstNameController.text = widget.profile.first_name;
    lastNameController.text = widget.profile.last_name;
    phoneController.text = widget.profile.phone_number.substring(4);
    dateController.text = formattedDate;
    initialDate = DateTime.parse(widget.profile.birth_date);
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<UpdateProfileBloc, UpdateProfileState>(
          builder: (_, state) {
            return buildInitialInput();
          }, listener: (_, state) async {
        if (state is UpdateProfileLoadingState) {
          isLoading = true;
        } else if (state is UpdateProfileSuccessfulState) {
          isLoading = false;
          final profile = BlocProvider.of<ProfileBloc>(context);
          profile.add(GetProfileEvent());
          Navigator.pop(context);
        } else if (state is UpdateProfileFailedState) {
          isLoading = false;
          if(state.error == jwtExpired || state.error == doesNotExist){
            await prefs.signout();
            await prefs.removeToken();
            await prefs.removeCreatedTeam();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => SignInScreen()),
                    (route) => false);
          } else {
            errorFlashBar(context: context, message: state.error);
          }
        }
      }),
    );
  }

  Widget buildInitialInput() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/splash.png"), fit: BoxFit.cover)),
      child: Column(
        children: [
          AppHeader(
              title: "",
              desc:
              "Take control of your profile, rewards, and credits - unleash the power of customization and enjoy the full experience!"),
          Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20),
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(defaultBorderRadius))),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20,),
                      Center(
                        child: Column(
                          children: [
                            BlocConsumer<UpdateProPicBloc, UpdateProPicState>(
                                builder: (_, state) {
                                  return initialProPic();
                                }, listener: (_, state) async {
                              if (state is UpdateProPicLoadingState) {
                                isProPicLoading = true;
                              } else if (state is UpdateProPicSuccessfulState) {
                                isProPicLoading = false;
                                final profile = BlocProvider.of<ProfileBloc>(context);
                                profile.add(GetProfileEvent());
                              } else if (state is UpdateProPicFailedState) {
                                isProPicLoading = false;
                                if(state.error == jwtExpired || state.error == doesNotExist){
                                  await prefs.signout();
                                  await prefs.removeToken();
                                  await prefs.removeCreatedTeam();
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignInScreen()),
                                          (route) => false);
                                } else {
                                  errorFlashBar(context: context, message: state.error);
                                }
                              }
                            }),
                            SizedBox(height: 10,),
                            Text(widget.profile.full_name, style: TextStyle(color: primaryColor, fontWeight: FontWeight.w700, fontSize: 14),),
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      Text(
                        "Profile Information".toUpperCase(),
                        style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.w400,
                            fontSize: textFontSize),
                      ),
                      SizedBox(height: 10,),
                      textFormField(
                          controller: firstNameController,
                          hintText: "First Name",
                          icon: Ic.baseline_person_outline,
                          autoFocus: false, onInteraction: (){
                        setState(() {
                          isFirstNameEmpty = false;
                        });
                      }),
                      isFirstNameEmpty
                          ? Text(
                        "Value can not be empty",
                        style: TextStyle(
                            color: dangerColor, fontSize: textFontSize),
                      )
                          : SizedBox(),
                      SizedBox(
                        height: 10,
                      ),
                      textFormField(
                          controller: lastNameController,
                          hintText: "Last Name",
                          icon: Ic.baseline_person_outline,
                          autoFocus: false, onInteraction: (){
                        setState(() {
                          isLastNameEmpty = false;
                        });
                      }),
                      isLastNameEmpty
                          ? Text(
                        "Value can not be empty",
                        style: TextStyle(
                            color: dangerColor, fontSize: textFontSize),
                      )
                          : SizedBox(),
                      SizedBox(
                        height: 10,
                      ),
                      phoneTextFormField(
                        isEnabled: false,
                          controller: phoneController,
                          hintText: "Phone Number",
                          icon: Ic.outline_local_phone,
                          autoFocus: false, onInteraction: (){
                        setState(() {
                          isPhoneNumberEmpty = false;
                        });
                      }),
                      isPhoneNumberEmpty
                          ? Text(
                        "Value can not be empty",
                        style: TextStyle(
                            color: dangerColor, fontSize: textFontSize),
                      )
                          : SizedBox(),
                      isPhoneNumberInValid
                          ? Text(
                        "Please enter a valid phone number",
                        style: TextStyle(
                            color: dangerColor, fontSize: textFontSize),
                      )
                          : SizedBox(),
                      SizedBox(
                        height: 10,
                      ),
                      dateFormField(controller: dateController, icon: Ic.outline_calendar_today, hintText: "Date of birth", onPressed: (){
                        displayDatePicker(context);
                      }, onInteraction: (){
                        setState(() {
                          isDateEmpty = false;
                        });
                      }),
                      isDateEmpty
                          ? Text(
                        "Value can not be empty",
                        style: TextStyle(
                            color: dangerColor, fontSize: textFontSize),
                      )
                          : SizedBox(),
                      SizedBox(height: 70,),
                      isLoading ? loadingButton() : SizedBox(
                          width: double.infinity,
                          child: submitButton(onPressed: () {
                            if(firstNameController.text.isEmpty){
                              return setState(() {
                                isFirstNameEmpty = true;
                              });
                            }
                            if(lastNameController.text.isEmpty){
                              return setState(() {
                                isLastNameEmpty = true;
                              });
                            }
                            if(phoneController.text.isEmpty){
                              return setState(() {
                                isPhoneNumberEmpty = true;
                              });
                            }

                            if(dateController.text.isEmpty){
                              return setState(() {
                                isDateEmpty = true;
                              });
                            }

                            if(phoneController.text.length != 9){
                              return setState(() {
                                isPhoneNumberInValid = true;
                              });
                            } else {
                              setState(() {
                                isPhoneNumberInValid = false;
                              });
                            }
                            final updateProfile = BlocProvider.of<UpdateProfileBloc>(context);
                            updateProfile.add(PatchUpdateEvent(UpdateProfile(first_name: firstNameController.text, last_name: lastNameController.text, phone_number: "+251${phoneController.text}", birth_date: dateController.text)));
                          }, text: "Save", disabled: false)),
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Future displayDatePicker(BuildContext context) async {
    var date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: onPrimaryColor,
              onSurface: primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      final pickedDate = date.toLocal().toString().split(" ")[0];
      List splittedDate = pickedDate.split("-");
      String dateFormat = "${splittedDate[0]}-${splittedDate[1]}-${splittedDate[2]}";
      setState(() {
        dateController.text = dateFormat;
      });
    }
  }

  Widget initialProPic() {
    return isProPicLoading ? BlinkContainer(width: 90, height: 90, borderRadius: 200) : Container(
      height: 90,
      width: 90,
      decoration: BoxDecoration(
          color: lightPrimary,
          border: Border.all(color: primaryColor, width: 2),
          borderRadius: BorderRadius.circular(200),
          image: DecorationImage(
              image: widget.profile.pp_secure_url == null
                  ? AssetImage("images/account.png")
                  : NetworkImage(widget.profile.pp_secure_url!) as ImageProvider,
              fit: BoxFit.fill)),
      child: GestureDetector(
        onTap: () {
          _pickImage();
        },
        child: Align(
            alignment: Alignment.bottomRight,
            child: Image.asset(
              "images/camera_icon.png",
              height: 15,
              width: 16.5,
              fit: BoxFit.cover,
            )),
      ),
    );
  }

}
