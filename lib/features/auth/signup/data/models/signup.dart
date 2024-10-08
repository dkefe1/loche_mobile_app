class SignUp {
  final String first_name;
  final String last_name;
  final String phone_number;
  final String birth_date;
  final String pin;
  final String pin_confirm;
  final bool accept;
  String? agent_code;

  SignUp(
      {required this.first_name,
        required this.last_name,
        required this.phone_number,
        required this.birth_date,
        required this.pin,
        required this.pin_confirm,
        required this.accept, this.agent_code});
}
