import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/common_widgets/error_view.dart';
import 'package:fantasy/features/guidelines/data/models/faq_model.dart';
import 'package:fantasy/features/guidelines/presentation/blocs/guidelines_bloc.dart';
import 'package:fantasy/features/guidelines/presentation/blocs/guidelines_event.dart';
import 'package:fantasy/features/guidelines/presentation/blocs/guidelines_state.dart';
import 'package:fantasy/features/guidelines/presentation/widgets/faq_component.dart';
import 'package:fantasy/features/guidelines/presentation/widgets/faq_loading.dart';
import 'package:fantasy/features/home/presentation/widgets/app_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({Key? key}) : super(key: key);

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
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
                AppLocalizations.of(context)!.faq_2),
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
                    BlocBuilder<FAQsBloc, FAQsState>(builder: (_, state) {
                      if (state is GetAllFAQsSuccessfulState) {
                        return buildInitialInput(faqs: state.faqs);
                      } else if (state is GetAllFAQsLoadingState) {
                        return faqLoading();
                      } else if (state is GetAllFAQsFailedState) {
                        return errorView(
                            iconPath: state.error == socketErrorMessage
                                ? "images/connection.png"
                                : "images/error.png",
                            title: "Ooops!",
                            text: state.error,
                            onPressed: () {
                              final getAllFAQ =
                                  BlocProvider.of<FAQsBloc>(context);
                              getAllFAQ.add(GetAllFAQsEvent());
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

  Widget buildInitialInput({required List<FAQModel> faqs}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.frequently_asked_question,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          AppLocalizations.of(context)!.frequently_asked_question_desc,
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
        ),
        SizedBox(
          height: 30,
        ),
        faqComponent(title: AppLocalizations.of(context)!.faq, contents: faqs)
      ],
    );
  }
}
