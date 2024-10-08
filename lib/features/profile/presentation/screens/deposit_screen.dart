import 'dart:io';

import 'package:fantasy/core/constants.dart';
import 'package:fantasy/core/globals.dart';
import 'package:fantasy/features/home/presentation/blocs/home_bloc.dart';
import 'package:fantasy/features/home/presentation/blocs/home_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'profile_payement_success_screen.dart';

class DepositScreen extends StatefulWidget {

  String checkout_url;
  bool isPackage;
  DepositScreen({super.key, required this.checkout_url, required this.isPackage});

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {

  InAppWebViewController? _webViewController;

  double _progress = 0;

  bool isComplete = false;

  @override
  void initState() {
    updateStatus();
    super.initState();
  }

  Future updateStatus() async {
    await Future.delayed(Duration(seconds: 10));
    isComplete = true;
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS ?
    GestureDetector(
        onPanUpdate: (details) {
          if (details.delta.dx > 30) {
            if(isComplete){
              Navigator.of(context).pop();
            }
          }
        },
        child: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: buildInitialInput(),
        )
    )
        : WillPopScope(
      onWillPop: () async {
        if(isComplete) {
          return true;
        }
        return false;
      },
      child: buildInitialInput(),
    );
  }

  Widget buildInitialInput(){
    return Scaffold(
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: Uri.parse(widget.checkout_url)),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                useShouldOverrideUrlLoading: true,
              ),
            ),
            onWebViewCreated: (controller) {
              _webViewController = controller;
            },
            onProgressChanged: (InAppWebViewController controller, int progress){
              setState(() {
                _progress = progress/100;
              });
            },
            // shouldOverrideUrlLoading: (controller, navigationAction) async {
            //
            //   print("YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY");
            //
            //   final url = navigationAction.request.url;
            //   print(url);
            //
            //   return NavigationActionPolicy.ALLOW;
            // },
            onLoadStop: (controller, url) async {

              if(url.toString() == "${baseUrl}api/v1/credit/success"){
                await _webViewController?.stopLoading();
                final getClientTeam = BlocProvider.of<ClientTeamBloc>(context);
                getClientTeam.add(GetClientTeamEvent());
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfilePaymentSuccessScreen(isPackage: widget.isPackage)));
              }

              if(url == "${baseUrl}api/v1/credit/error"){
                Navigator.pop(context);
              }
              // if (url.toString().startsWith(kRedirectUri)) {
              //   await _webViewController?.stopLoading();
              //   Navigator.of(context).pop(url.toString());
              // }
            },
          ),
          _progress < 1 ? Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(child: CircularProgressIndicator(color: primaryColor),)) : SizedBox()
        ],
      ),
    );
  }

}
