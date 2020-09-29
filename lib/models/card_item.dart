class CardItem {
  String name;
  String accountNumber;
  String ifsc;
  String bank;
  String branch;
  String country;
  String phone;
  String email;
  String type;
  bool gPay;
  bool phonePe;

  CardItem({
    this.phone,
    this.name,
    this.accountNumber,
    this.bank,
    this.branch,
    this.country,
    this.gPay,
    this.phonePe,
    this.ifsc,
    this.email,
  });

  set setCountry(String value) {
    this.country = value;
  }

  set setType(String value) {
    this.type = value;
  }

  set setPhone(String value) {
    this.phone = value;
  }

  set setEmail(String value) {
    this.email = value;
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

  set setPhonePe(bool value) {
    this.phonePe = value;
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
  get getPhonePe => this.phonePe;
  get getBank => this.bank;
  get getCountry => this.country;
  get getType => this.type;
  Map<String, dynamic> get toMap {
    String code;
    country == 'India' ? code = "IFSC" : code = "IBAN";
    return {
      "A/c No": accountNumber,
      "Name": name,
      "Bank": bank.replaceAll(new RegExp(r"\s+"), "").toLowerCase(),
      "Branch": branch,
      code: ifsc,
      "Phone": phone,
      "Email": email,
      "Gpay": gPay,
      "PhonePe": phonePe,
      "Type": type
    };
  }

  String toString() {
    String text = "";
    if (accountNumber != null) {
      text += "\nA/c no : " + accountNumber.toString();
    }
    if (bank != null) {
      text += "\nBank : " + bank.toString();
    }
    if (country != null) {
      text += "\nCountry : " + country.toString();
    }
    if (name != null) {
      text += "\nName : " + name.toString();
    }
    if (ifsc != null) {
      text += country != "India"
          ? "\nIBAN : " + ifsc.toString()
          : "\nIFSC : " + ifsc.toString();
    }
    if (branch != null) {
      text += "\nBranch : " + branch.toString();
    }
    if (email != null) {
      text += "\nEmail : " + email.toString();
    }
    if (phone != null) {
      gPay ?? false
          ? text += "\nPhone/Gpay : " + phone.toString()
          : text += "\nPhone : " + phone.toString();
    }
    return text;
  }
}
