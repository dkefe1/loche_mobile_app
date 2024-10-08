import 'dart:io';

import 'package:cloudinary/cloudinary.dart';
import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/secret.dart';
import 'package:fantasy/core/services/shared_preference_services.dart';
import 'package:fantasy/features/auth/signin/presentation/screens/signin_screen.dart';
import 'package:fantasy/features/common_widgets/ads_component.dart';
import 'package:fantasy/features/common_widgets/error_flashbar.dart';
import 'package:fantasy/features/common_widgets/error_view.dart';
import 'package:fantasy/features/common_widgets/loading_container.dart';
import 'package:fantasy/features/common_widgets/pin_changed_view.dart';
import 'package:fantasy/features/common_widgets/success_flashbar.dart';
import 'package:fantasy/features/guidelines/presentation/widgets/guidelines_detail_box.dart';
import 'package:fantasy/features/home/data/models/advertisement.dart';
import 'package:fantasy/features/home/data/models/selected_players.dart';
import 'package:fantasy/features/profile/data/models/profile.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_event.dart';
import 'package:fantasy/features/profile/presentation/blocs/profile_state.dart';
import 'package:fantasy/features/profile/presentation/screens/agents_screen.dart';
import 'package:fantasy/features/profile/presentation/screens/awards_screen.dart';
import 'package:fantasy/features/profile/presentation/screens/change_password_screen.dart';
import 'package:fantasy/features/profile/presentation/screens/deposit_choice_screen.dart';
import 'package:fantasy/features/profile/presentation/screens/notes_screen.dart';
import 'package:fantasy/features/profile/presentation/screens/package_choice_screen.dart';
import 'package:fantasy/features/profile/presentation/screens/package_screen.dart';
import 'package:fantasy/features/profile/presentation/screens/personal_information_screen.dart';
import 'package:fantasy/features/profile/presentation/screens/request_agent_code_screen.dart';
import 'package:fantasy/features/profile/presentation/screens/scouts_screen.dart';
import 'package:fantasy/features/profile/presentation/screens/transaction_history_screen.dart';
import 'package:fantasy/features/profile/presentation/screens/wallet_screen.dart';
import 'package:fantasy/features/profile/presentation/widgets/client_request_widget.dart';
import 'package:fantasy/features/profile/presentation/widgets/clipboard_widget.dart';
import 'package:fantasy/features/profile/presentation/widgets/credit_box.dart';
import 'package:fantasy/features/profile/presentation/widgets/credit_box2.dart';
import 'package:fantasy/features/profile/presentation/widgets/logout_box.dart';
import 'package:fantasy/features/profile/presentation/widgets/logout_dialog.dart';
import 'package:fantasy/features/profile/presentation/widgets/transfer_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  TextEditingController agentController = TextEditingController();
  TextEditingController depositController = TextEditingController();
  TextEditingController transferController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController toPhoneNumberController = TextEditingController();

  final cloudinary = Cloudinary.signedConfig(apiKey: cloudinaryApiKey, apiSecret: cloudinaryApiSecret, cloudName: cloudinaryCloudName);

  File? _pickedImage;

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
          isProPicLoading = false;
        });
      }
    } else {}
  }

  bool isProPicLoading = false;

  final loginService = PrefService();

  @override
  void initState() {
    final profile = BlocProvider.of<ProfileBloc>(context);
    profile.add(GetProfileEvent());
    final getClientRequest = BlocProvider.of<ClientRequestBloc>(context);
    getClientRequest.add(GetClientRequestEvent());
    super.initState();
  }

  @override
  void dispose() {
    agentController.dispose();
    depositController.dispose();
    transferController.dispose();
    phoneNumberController.dispose();
    toPhoneNumberController.dispose();
    super.dispose();
  }

  copy() {
    final value = ClipboardData(text: agentController.text);
    Clipboard.setData(value);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
        listener: (_, state) async {

          if(state is GetProfileSuccessfulState){
            print(state.profile.profile.agent_code);
            agentController.text = state.profile.profile.agent_code;
            phoneNumberController.text = state.profile.profile.phone_number.substring(4);
            setState(() {});
          }

          if(state is GetProfileFailedState){
            if(state.error == jwtExpired || state.error == doesNotExist){
              await loginService.signout();
              await loginService.removeToken();
              await loginService.removeCreatedTeam();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SignInScreen()),
                      (route) => false);
            }
          }
        },
        builder: (_, state) {
          if (state is GetProfileSuccessfulState) {
            return buildInitialInput(profile: state.profile.profile, ads: state.profile.ads);
          } else if (state is GetProfileLoadingState) {
            return profileLoading();
          } else if (state is GetProfileFailedState) {
            if(state.error == pinChangedMessage){
              return Expanded(
                child: pinChangedErrorView(
                    iconPath: state.error == socketErrorMessage
                        ? "images/connection.png"
                        : "images/error.png",
                    title: "Ooops!",
                    text: state.error,
                    onPressed: () async {
                      await loginService.signout();
                      await loginService.removeToken();
                      await loginService.removeCreatedTeam();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInScreen()),
                              (route) => false);
                    }),
              );
            }
            return Expanded(
              child: errorView(
                iconPath: state.error == socketErrorMessage ? "images/connection.png" : "images/error.png",
                title: "Ooops!",
                  text: state.error,
                  onPressed: () {
                    final getProfile = BlocProvider.of<ProfileBloc>(context);
                    getProfile.add(GetProfileEvent());
                  }),
            );
          } else {
            return SizedBox();
          }
        });
  }

  Widget buildInitialInput({required Profile profile, required List<Advertisement> ads}) {
    return Expanded(
        child: Column(
          children: [
            Expanded(
              child: Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(defaultBorderRadius))),
      child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Column(
                      children: [
                        BlocConsumer<UpdateProPicBloc, UpdateProPicState>(
                            builder: (_, state) {
                              return initialProPic(profile: profile);
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
                              await loginService.signout();
                              await loginService.removeToken();
                              await loginService.removeCreatedTeam();
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
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          profile.full_name,
                          style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 14),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            creditBox2(iconPath: "images/deposit.png", desc: AppLocalizations.of(context)!.deposit, width: 30, height: 30, onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => DepositChoiceScreen(depositController: depositController, phoneNumberController: phoneNumberController, credit: profile.credit, autoJoin: false)));
                            }),
                            SizedBox(width: 10,),
                            creditBox(iconPath: "images/amount.png", value: profile.credit.toString(), desc: "Coin"),
                            SizedBox(width: 10,),
                            creditBox2(iconPath: "images/transfer_credit.png", desc: AppLocalizations.of(context)!.transfer, width: 29.39, height: 25, onPressed: (){
                              showDialog(
                                  barrierDismissible: false,
                                  context: context, builder: (BuildContext context) {
                                return transferDialog(transferController: transferController, toPhoneNumberController: toPhoneNumberController, context: context, credit: profile.credit);
                              });
                            }),
                          ],
                        ),
                        profile.gameweek_package == null ? SizedBox() : Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: creditBox(iconPath: "images/package_ball.png", value: profile.gameweek_package!.toString(), desc: "Round"),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    AppLocalizations.of(context)!.account_information.toUpperCase(),
                    style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w400,
                        fontSize: textFontSize),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  guidelinesDetailBox(
                      label: AppLocalizations.of(context)!.personal_information,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PersonalInformationScreen(
                                      profile: profile,
                                    )));
                      }),
                  guidelinesDetailBox(
                      label: AppLocalizations.of(context)!.change_pin,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangePasswordScreen()));
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    AppLocalizations.of(context)!.your_referral_code.toUpperCase(),
                    style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w400,
                        fontSize: textFontSize),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  BlocConsumer<ClientRequestBloc, ClientRequestState>(
                      listener: (_, state) async {
                        if(state is GetClientRequestFailedState){
                          if(state.error == jwtExpired || state.error == doesNotExist){
                            await loginService.signout();
                            await loginService.removeToken();
                            await loginService.removeCreatedTeam();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignInScreen()),
                                    (route) => false);
                          }
                        }
                      },
                      builder: (_, state) {
                        if (state is GetClientRequestSuccessfulState) {
                          if(state.clientRequest == null){
                            return guidelinesDetailBox(
                                label: AppLocalizations.of(context)!.request_your_referral_code,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RequestAgentCodeScreen()));
                                });
                          } else {
                            if(state.clientRequest!.status == "Pending") {
                              return clientRequestWidget(label: "Pending", labelColor: Colors.amber);
                            } else if (state.clientRequest!.status == "Rejected"){
                              return clientRequestWidget(label: "Rejected", labelColor: dangerColor2);
                            } else if (state.clientRequest!.status == "Contacted"){
                              return clientRequestWidget(label: "Pending", labelColor: Colors.amber);
                            }
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              clipBoardWidget(controller: agentController, onCopyPressed: (){
                                copy();
                                successFlashBar(context: context, message: "Text Copied!");
                              }, onSharePressed: (){
                                Share.share(agentController.text);
                              }),
                              SizedBox(height: 10,),
                              guidelinesDetailBox(
                                  label: AppLocalizations.of(context)!.wallet,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => WalletScreen(profile: profile,)));
                                  }),
                              guidelinesDetailBox(
                                  label: AppLocalizations.of(context)!.agents_list,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AgentsScreen(profile: profile,)));
                                  }),
                            ],
                          );
                        } else if (state is GetClientRequestLoadingState) {
                          return BlinkContainer(
                              width: double.infinity, height: 50, borderRadius: 10);
                        } else if (state is GetClientRequestFailedState) {
                          return SizedBox();
                        } else {
                          return SizedBox();
                        }
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    AppLocalizations.of(context)!.credit.toUpperCase(),
                    style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w400,
                        fontSize: textFontSize),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  guidelinesDetailBox(
                      label: AppLocalizations.of(context)!.deposit_credit,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DepositChoiceScreen(depositController: depositController, phoneNumberController: phoneNumberController, credit: profile.credit, autoJoin: false)));
                      }),
                  guidelinesDetailBox(
                      label: AppLocalizations.of(context)!.purchase_package,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PackageChoiceScreen(autoJoin: false, phoneNumber: phoneNumberController.text,)));
                      }),
                  guidelinesDetailBox(
                      label: AppLocalizations.of(context)!.transfer_credit,
                      onPressed: () {
                        showDialog(
                            barrierDismissible: false,
                            context: context, builder: (BuildContext context) {
                          return transferDialog(transferController: transferController, toPhoneNumberController: toPhoneNumberController, context: context, credit: profile.credit);
                        });
                      }),
                  guidelinesDetailBox(
                      label: AppLocalizations.of(context)!.transaction,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TransactionHistoryScreen(fullname: profile.full_name)));
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    AppLocalizations.of(context)!.prize.toUpperCase(),
                    style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w400,
                        fontSize: textFontSize),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  guidelinesDetailBox(
                      label: AppLocalizations.of(context)!.my_awards,
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => AwardsScreen(clientId: profile.id, profile: profile,)));
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    AppLocalizations.of(context)!.notes.toUpperCase(),
                    style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w400,
                        fontSize: textFontSize),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  guidelinesDetailBox(
                      label: AppLocalizations.of(context)!.notes,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotesScreen()));
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    AppLocalizations.of(context)!.scouts.toUpperCase(),
                    style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w400,
                        fontSize: textFontSize),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  guidelinesDetailBox(
                      label: AppLocalizations.of(context)!.scouts,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ScoutsScreen()));
                      }),
                  SizedBox(
                    height: 40,
                  ),
                  logoutBox(
                      label: AppLocalizations.of(context)!.logout,
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return logoutDialog(
                                  context: context,
                                  onPressed: () async {
                                    await loginService.signout();
                                    await loginService.removeToken();
                                    await loginService.removeCreatedTeam();
                                    final removePlayers = Provider.of<SelectedPlayersProvider>(context, listen: false);
                                    removePlayers.removeAllPlayers();
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SignInScreen()),
                                        (route) => false);
                                  });
                            });
                      }),
                  SizedBox(
                    height: 40,
                  )
                ],
              ),
      ),
    ),
            ),
            AdsComponent(ads: ads, height: 50),
          ],
        ));
  }

  Widget profileLoading() {
    return Expanded(
        child: Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(defaultBorderRadius))),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: Column(
                children: [
                  BlinkContainer(width: 90, height: 90, borderRadius: 200),
                  SizedBox(
                    height: 10,
                  ),
                  BlinkContainer(width: 100, height: 20, borderRadius: 0),
                  SizedBox(
                    height: 10,
                  ),
                  BlinkContainer(width: 150, height: 40, borderRadius: 8)
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            BlinkContainer(width: 100, height: 20, borderRadius: 0),
            SizedBox(
              height: 10,
            ),
            BlinkContainer(
                width: double.infinity, height: 50, borderRadius: 10),
            SizedBox(
              height: 10,
            ),
            BlinkContainer(
                width: double.infinity, height: 50, borderRadius: 10),
            SizedBox(
              height: 10,
            ),
            BlinkContainer(width: 100, height: 20, borderRadius: 0),
            SizedBox(
              height: 10,
            ),
            BlinkContainer(
                width: double.infinity, height: 50, borderRadius: 10),
            SizedBox(
              height: 10,
            ),
            BlinkContainer(width: 100, height: 20, borderRadius: 0),
            SizedBox(
              height: 10,
            ),
            BlinkContainer(
                width: double.infinity, height: 50, borderRadius: 10),
            SizedBox(
              height: 40,
            ),
            BlinkContainer(
                width: double.infinity, height: 50, borderRadius: 10),
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    ));
  }

  Widget initialProPic({required Profile profile}) {
    return isProPicLoading ? BlinkContainer(width: 90, height: 90, borderRadius: 200) : Container(
      height: 90,
      width: 90,
      decoration: BoxDecoration(
          color: lightPrimary,
          border: Border.all(color: primaryColor, width: 2),
          borderRadius: BorderRadius.circular(200),
          image: DecorationImage(
              image: profile.pp_secure_url == null
                  ? AssetImage("images/account.png")
                  : NetworkImage(profile.pp_secure_url!) as ImageProvider,
              fit: BoxFit.cover)),
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
