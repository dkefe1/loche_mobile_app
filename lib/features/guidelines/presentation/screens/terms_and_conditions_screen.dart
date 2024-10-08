import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/common_widgets/error_view.dart';
import 'package:fantasy/features/guidelines/data/models/terms_model.dart';
import 'package:fantasy/features/guidelines/presentation/blocs/guidelines_bloc.dart';
import 'package:fantasy/features/guidelines/presentation/blocs/guidelines_event.dart';
import 'package:fantasy/features/guidelines/presentation/blocs/guidelines_state.dart';
import 'package:fantasy/features/guidelines/presentation/widgets/faq_loading.dart';
import 'package:fantasy/features/guidelines/presentation/widgets/terms_component.dart';
import 'package:fantasy/features/home/presentation/widgets/app_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  TermsAndConditionsScreen({Key? key}) : super(key: key);

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
                AppLocalizations.of(context)!.tac_2),
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
                    BlocBuilder<TermsBloc, TermsState>(builder: (_, state) {
                      if (state is GetAllTermsSuccessfulState) {
                        return buildInitialInput(terms: state.terms, context: context);
                      } else if (state is GetAllTermsLoadingState) {
                        return faqLoading();
                      } else if (state is GetAllTermsFailedState) {
                        return errorView(
                            iconPath: state.error == socketErrorMessage
                                ? "images/connection.png"
                                : "images/error.png",
                            title: "Ooops!",
                            text: state.error,
                            onPressed: () {
                              final getAllTerms =
                                  BlocProvider.of<TermsBloc>(context);
                              getAllTerms.add(GetAllTermsEvent());
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

  Widget buildInitialInput({required List<TermsModel> terms, required BuildContext context}) {

    String formattedDate = "";

    if(terms.isNotEmpty){
      DateTime dateTime = DateTime.parse(terms[0].updatedAt);
      formattedDate = DateFormat('d MMMM, y').format(dateTime);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.terms_and_conditions,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text(
              AppLocalizations.of(context)!.last_updated,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
            ),
            Text(
              formattedDate,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ],
        ),
        SizedBox(
          height: 30,
        ),
        termsComponent(title: AppLocalizations.of(context)!.terms_and_conditions, contents: terms),
      ],
    );
  }
}
