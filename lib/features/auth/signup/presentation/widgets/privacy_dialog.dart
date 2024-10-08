import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/common_widgets/error_view.dart';
import 'package:fantasy/features/guidelines/data/models/privacy_model.dart';
import 'package:fantasy/features/guidelines/presentation/blocs/guidelines_bloc.dart';
import 'package:fantasy/features/guidelines/presentation/blocs/guidelines_event.dart';
import 'package:fantasy/features/guidelines/presentation/blocs/guidelines_state.dart';
import 'package:fantasy/features/guidelines/presentation/widgets/faq_loading.dart';
import 'package:fantasy/features/guidelines/presentation/widgets/policy_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

Widget privacyDialog({required BuildContext context}){
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
            BlocBuilder<PrivacyBloc, PrivacyState>(builder: (_, state) {
              if (state is GetAllPrivacySuccessfulState) {
                return privacyBody(policies: state.policies);
              } else if (state is GetAllPrivacyLoadingState) {
                return faqLoading();
              } else if (state is GetAllPrivacyFailedState) {
                return errorView(
                    iconPath: state.error == socketErrorMessage
                        ? "images/connection.png"
                        : "images/error.png",
                    title: "Ooops!",
                    text: state.error,
                    onPressed: () {
                      final getAllPolicies =
                      BlocProvider.of<PrivacyBloc>(context);
                      getAllPolicies.add(GetAllPrivacyEvent());
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

Widget privacyBody({required List<PrivacyModel> policies}){

  String formattedDate = "";

  if(policies.isNotEmpty){
    DateTime dateTime = DateTime.parse(policies[0].updatedAt);
    formattedDate = DateFormat('d MMMM, y').format(dateTime);
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Privacy and Policy",
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
      policyComponent(title: "Privacy Policy", contents: policies),
    ],
  );
}