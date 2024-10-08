class Withdraw{
  final num amount;
  String? account_number;
  String? bank_code;
  String? account_name;
  final String toBankOrCredit;
  final String fromPrizeOrCommission;

  Withdraw({required this.amount, this.account_number, this.bank_code, this.account_name, required this.fromPrizeOrCommission, required this.toBankOrCredit});
}