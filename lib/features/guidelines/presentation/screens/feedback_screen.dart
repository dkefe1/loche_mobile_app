import 'package:fantasy/core/constants.dart';
import 'package:fantasy/features/common_widgets/error_flashbar.dart';
import 'package:fantasy/features/common_widgets/error_view.dart';
import 'package:fantasy/features/common_widgets/loading_button.dart';
import 'package:fantasy/features/common_widgets/loading_container.dart';
import 'package:fantasy/features/common_widgets/submit_button.dart';
import 'package:fantasy/features/common_widgets/success_flashbar.dart';
import 'package:fantasy/features/guidelines/data/models/feedback_title_model.dart';
import 'package:fantasy/features/guidelines/presentation/blocs/guidelines_bloc.dart';
import 'package:fantasy/features/guidelines/presentation/blocs/guidelines_event.dart';
import 'package:fantasy/features/guidelines/presentation/blocs/guidelines_state.dart';
import 'package:fantasy/features/guidelines/presentation/widgets/description_textformfield.dart';
import 'package:fantasy/features/home/presentation/widgets/app_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {

  TextEditingController descriptionController = TextEditingController();

  bool isCategoryEmpty = false;
  bool isDescriptionEmpty = false;
  bool isDescriptionInvalid = false;
  bool isLoading = false;

  FeedbackTitleModel? value;

  List<FeedbackTitleModel> categories = [];

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<PostFeedbackBloc, PostFeedbackState>(
          builder: (_, state) {
            return buildInitialInput();
          }, listener: (_, state) {
        if (state is PostFeedbackLoadingState) {
          isLoading = true;
        } else if (state is PostFeedbackSuccessfulState) {
          isLoading = false;
          value = null;
          descriptionController.clear();
          successFlashBar(context: context, message: AppLocalizations.of(context)!.thank_you_feedback);
        } else if (state is PostFeedbackFailedState) {
          isLoading = false;
          errorFlashBar(context: context, message: state.error);
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
              AppLocalizations.of(context)!.fd_2),
          Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20),
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(defaultBorderRadius))),
                child: BlocConsumer<FeedbackTitleBloc, FeedbackTitleState>(
                    listener: (_, state){
                      if(state is GetAllFeedbackTitleSuccessfulState){
                        categories = state.titles;
                      }
                    },
                    builder: (_, state) {
                      if(state is GetAllFeedbackTitleSuccessfulState) {
                        return feedbackBody();
                      } else if(state is GetAllFeedbackTitleLoadingState) {
                        return categoriesLoading();
                      } else if(state is GetAllFeedbackTitleFailedState) {
                        return errorView(
                            iconPath: state.error == socketErrorMessage
                                ? "images/connection.png"
                                : "images/error.png",
                            title: "Ooops!",
                            text: state.error,
                            onPressed: () {
                              final getAllTitles = BlocProvider.of<FeedbackTitleBloc>(context);
                              getAllTitles.add(GetAllFeedbackTitleEvent());
                            });
                      } else {
                        return SizedBox();
                      }
                    }),
              ))
        ],
      ),
    );
  }

  Widget feedbackBody(){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
          ),
          Text(
            AppLocalizations.of(context)!.feedbacks,
            style:
            TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            AppLocalizations.of(context)!.feedbacks_desc,
            style:
            TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
          ),
          SizedBox(height: 15,),
          Text(
            AppLocalizations.of(context)!.categories,
            style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w400,
                fontSize: 12),
          ),
          SizedBox(height: 5,),
          categoriesComponent(),
          isCategoryEmpty
              ? Text(
            AppLocalizations.of(context)!.value_can_not_be_empty,
            style: TextStyle(
                color: dangerColor, fontSize: textFontSize),
          )
              : SizedBox(),
          SizedBox(height: 15,),
          descriptionTextFormField(controller: descriptionController, hintText: AppLocalizations.of(context)!.your_feedback, onInteraction: (){
            setState(() {
              isDescriptionEmpty = false;
            });
          }),
          isDescriptionEmpty
              ? Text(
            AppLocalizations.of(context)!.value_can_not_be_empty,
            style: TextStyle(
                color: dangerColor, fontSize: textFontSize),
          )
              : SizedBox(),
          isDescriptionInvalid
              ? Text(
            AppLocalizations.of(context)!.value_can_not_be_less_than_ten,
            style: TextStyle(
                color: dangerColor, fontSize: textFontSize),
          )
              : SizedBox(),
          SizedBox(height: 40,),
          isLoading ? loadingButton() : SizedBox(
              width: double.infinity,
              child: submitButton(onPressed: () {
                if(value == null){
                  return setState(() {
                    isCategoryEmpty = true;
                  });
                }
                if(descriptionController.text.isEmpty){
                  return setState(() {
                    isDescriptionEmpty = true;
                  });
                }
                if(descriptionController.text.length < 10){
                  return setState(() {
                    isDescriptionInvalid = true;
                  });
                } else {
                  setState(() {
                    isDescriptionInvalid = false;
                  });
                }
                final postFeedback = BlocProvider.of<PostFeedbackBloc>(context);
                postFeedback.add(CreateFeedbackEvent(value!.id, descriptionController.text));
              }, text: AppLocalizations.of(context)!.send, disabled: false)),
          SizedBox(height: 20,),
          Text(AppLocalizations.of(context)!.value_your_feedback, textAlign: TextAlign.center, style: TextStyle(fontSize: 12),),
          SizedBox(height: 40,)
        ],
      ),
    );
  }

  Widget categoriesLoading(){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30,),
          BlinkContainer(width: 150, height: 30, borderRadius: 0),
          SizedBox(height: 15,),
          BlinkContainer(width: double.infinity, height: 15, borderRadius: 0),
          SizedBox(height: 5,),
          BlinkContainer(width: double.infinity, height: 15, borderRadius: 0),
          SizedBox(height: 5,),
          BlinkContainer(width: 200, height: 15, borderRadius: 0),
          SizedBox(height: 15,),
          BlinkContainer(width: 100, height: 30, borderRadius: 0),
          SizedBox(height: 5,),
          BlinkContainer(width: double.infinity, height: 60, borderRadius: 15),
          SizedBox(height: 15,),
          BlinkContainer(width: double.infinity, height: 200, borderRadius: 8),
          SizedBox(height: 15,),
          BlinkContainer(width: double.infinity, height: 50, borderRadius: 8),
          SizedBox(height: 10,),
        ],
      ),
    );
  }

  Widget categoriesFailed({required String error, required VoidCallback onPressed}){
    return Container(
      width: double.infinity,
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: lightPrimary,
          border: Border.all(color: primaryColor),
          borderRadius: BorderRadius.circular(5)),
      child: Row(
        children: [
          Expanded(child: Text(error, style: TextStyle(color: dangerColor, fontSize: 14),)),
          SizedBox(width: 10,),
          GestureDetector(
              onTap: (){
                onPressed();
              },
              child: Iconify(Mdi.reload, color: primaryColor, size: 20,)),
        ],
      ),
    );
  }

  Widget categoriesComponent() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          border: Border.all(color: primaryColor),
          borderRadius: BorderRadius.circular(5)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<FeedbackTitleModel>(
            value: value,
            isExpanded: true,
            hint: Text(AppLocalizations.of(context)!.options, style: TextStyle(
                color: textBlackColor,
                fontSize: textFontSize2,
                fontWeight: FontWeight.w500),),
            items: categories.map(buildMenuCategories).toList(),
            icon: Iconify(
              MaterialSymbols.arrow_drop_down_rounded,
              color: primaryColor,
              size: 30,
            ),
            onChanged: (value) {
              setState(() {
                this.value = value;
                isCategoryEmpty = false;
              });
            }),
      ),
    );
  }

  DropdownMenuItem<FeedbackTitleModel> buildMenuCategories(FeedbackTitleModel category) =>
      DropdownMenuItem(
          value: category,
          child: Text(
            category.title,
            style: TextStyle(
                color: primaryColor,
                fontSize: textFontSize2,
                fontWeight: FontWeight.w500),
          ));

}
