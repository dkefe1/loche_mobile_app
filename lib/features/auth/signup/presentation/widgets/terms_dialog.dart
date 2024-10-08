import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/common_widgets/error_view.dart';
import 'package:fantasy/features/guidelines/data/models/terms_model.dart';
import 'package:fantasy/features/guidelines/presentation/blocs/guidelines_bloc.dart';
import 'package:fantasy/features/guidelines/presentation/blocs/guidelines_event.dart';
import 'package:fantasy/features/guidelines/presentation/blocs/guidelines_state.dart';
import 'package:fantasy/features/guidelines/presentation/widgets/faq_loading.dart';
import 'package:fantasy/features/guidelines/presentation/widgets/terms_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

Widget termsDialog({required BuildContext context}){
  return Dialog(
    backgroundColor: backgroundColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<TermsBloc, TermsState>(builder: (_, state) {
              if (state is GetAllTermsSuccessfulState) {
                return termsBody(terms: state.terms);
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
            SizedBox(height: 10,),
          ],
        ),
      ),
    ),
  );
}

Widget termsBody({required List<TermsModel> terms}){

  String formattedDate = "";

  if(terms.isNotEmpty){
    DateTime dateTime = DateTime.parse(terms[0].updatedAt);
    formattedDate = DateFormat('d MMMM, y').format(dateTime);
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Terms and Conditions",
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      SizedBox(
        height: 10,
      ),
      Row(
        children: [
          Text(
            "Last Updated: ",
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
      termsComponent(title: "Terms and Conditions", contents: terms),
    ],
  );
}