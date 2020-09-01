class BankRequest {
  String bank;
  String country;
  BankRequest({this.bank, this.country});

  Map<String, String> toMap() {
    return {
      "bank": bank,
      "country": country,
    };
  }
}
