import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/services/time_convert.dart';
import 'package:fantasy/features/profile/data/models/agent_transaction.dart';
import 'package:flutter/material.dart';

Widget agentTransactionComponent({required AgentTransaction agentTransaction}) {

  TimeConvert timeConvert = TimeConvert();

  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Date",
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,),
          ),
          Flexible(
            child: Text(
              timeConvert.formatDateTime(DateTime.parse(agentTransaction.createdAt).add(Duration(hours: 3))),
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
            "Amount",
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,),
          ),
          Flexible(
            child: Text(
              agentTransaction.amount.toString(),
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