import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/common_widgets/error_view.dart';
import 'package:fantasy/features/common_widgets/loading_container.dart';
import 'package:fantasy/features/guidelines/data/models/about_us_model.dart';
import 'package:fantasy/features/guidelines/presentation/blocs/guidelines_bloc.dart';
import 'package:fantasy/features/guidelines/presentation/blocs/guidelines_event.dart';
import 'package:fantasy/features/guidelines/presentation/blocs/guidelines_state.dart';
import 'package:fantasy/features/guidelines/presentation/widgets/about_us_component.dart';
import 'package:fantasy/features/home/presentation/widgets/app_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                AppLocalizations.of(context)!.a_2),
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
                        SizedBox(
                          height: 30,
                        ),
                        BlocBuilder<AboutUsBloc, AboutUsState>(builder: (_, state) {
                          if (state is GetAboutUsSuccessfulState) {
                            return buildInitialInput(aboutUs: state.content[0], context: context);
                          } else if (state is GetAboutUsLoadingState) {
                            return aboutUsLoading();
                          } else if (state is GetAboutUsFailedState) {
                            return errorView(
                                iconPath: state.error == socketErrorMessage
                                    ? "images/connection.png"
                                    : "images/error.png",
                                title: "Ooops!",
                                text: state.error,
                                onPressed: () {
                                  final getAboutUs =
                                  BlocProvider.of<AboutUsBloc>(context);
                                  getAboutUs.add(GetAboutUsEvent());
                                });
                          } else {
                            return SizedBox();
                          }
                        }),
                        SizedBox(
                          height: 40,
                        )
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget buildInitialInput({required AboutUsModel aboutUs, required BuildContext context}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: Image.asset("images/about.png", height: 54, width: 114.26, fit: BoxFit.cover,)),
        SizedBox(height: 20,),
        Text(AppLocalizations.of(context)!.about_us, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),
        SizedBox(height: 20,),
        aboutUsComponent(title: AppLocalizations.of(context)!.short_brief, value: """${aboutUs.content}"""),
        SizedBox(height: 20,),
        Text("${AppLocalizations.of(context)!.latest_version} ${aboutUs.version_title}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),
        SizedBox(height: 10,),
        Text(aboutUs.version_content, textAlign: TextAlign.start, style: TextStyle(
            fontSize: 12, color: Color(0xFF000000).withOpacity(0.7)
        ),),
        SizedBox(height: 20,),
        Text(AppLocalizations.of(context)!.thank_you, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),),
      ],
    );
  }

  Widget aboutUsLoading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: BlinkContainer(width: 163, height: 54, borderRadius: 0),),
        SizedBox(height: 20,),
        BlinkContainer(width: 100, height: 20, borderRadius: 0),
        SizedBox(height: 10,),
        BlinkContainer(width: 80, height: 20, borderRadius: 0),
        SizedBox(height: 5,),
        BlinkContainer(width: double.infinity, height: 350, borderRadius: 10),
        SizedBox(height: 20,),
        BlinkContainer(width: 150, height: 20, borderRadius: 0),
        SizedBox(height: 5,),
        BlinkContainer(width: double.infinity, height: 150, borderRadius: 0)
      ],
    );
  }
}
