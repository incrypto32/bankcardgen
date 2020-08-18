class CardItem {
  String name;
  String accountNumber;
  String ifsc;
  String bank;
  String branch;
  String country;
  String phone;
  bool gPay;

  set setCountry(String value) {
    this.country = value;
  }

  set setPhone(String value) {
    this.phone = value;
  }

  set setAccountNo(String value) {
    this.accountNumber = value;
  }

  set setName(String value) {
    this.name = value;
  }

  set setGpay(bool value) {
    this.gPay = value;
  }

  set setIfsc(String value) {
    this.ifsc = value;
  }

  set setBank(String value) {
    this.bank = value;
  }

  set setBranch(String value) {
    this.branch = value;
  }

  get getGpay => this.gPay;

  get getBank => this.bank;
  get getCountry => this.country;
  Map<String, dynamic> get toMap => {
        "Ac/No": accountNumber,
        "Name": name,
        "Country": country,
        "Bank": bank,
        "Branch": branch,
        "IFSC": ifsc,
        "Phone No": phone,
        "Gpay": gPay,
      };

  CardItem({
    this.phone,
    this.name,
    this.accountNumber,
    this.bank,
    this.branch,
    this.country,
    this.gPay,
    this.ifsc,
  });
}
