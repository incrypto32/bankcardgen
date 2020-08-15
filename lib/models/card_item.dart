class CardItem {
  final String name;
  final String accountNumber;
  final String ifsc;
  final String bank;
  final String branch;
  final String country;
  final String phone;
  final bool gPay;

  CardItem(
      {this.phone,
      this.name,
      this.accountNumber,
      this.bank,
      this.branch,
      this.country,
      this.gPay,
      this.ifsc});
}
