import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/time_convert.dart';
import 'package:fantasy/features/profile/data/models/client_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget transactionComponent({required ClientTransaction clientTransaction, required BuildContext context}) {

  TimeConvert timeConvert = TimeConvert();

  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(context)!.transaction_type_g,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,),
          ),
          Flexible(
            child: Text(
              clientTransaction.transactionType,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      SizedBox(height: 10,),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(context)!.date_g,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,),
          ),
          Flexible(
            child: Text(
              timeConvert.formatDateTime(DateTime.parse(clientTransaction.createdAt).add(Duration(hours: 3))),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      SizedBox(height: 10,),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(context)!.amount_transaction_page,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,),
          ),
          Flexible(
            child: Text(
              clientTransaction.amount.toString(),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      SizedBox(height: 10,),
      Divider(color: dividerColor, thickness: 1.0,),
      SizedBox(height: 10,),
    ],
  );
}