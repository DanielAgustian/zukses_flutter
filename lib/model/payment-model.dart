class PaymentModel {
  String cardNumber,
      cardName,
      mmyy,
      cvc,
      address,
      country,
      city,
      province,
      zipCode,
      statusBayar;

  PaymentModel(
      {this.cardNumber,
      this.cardName,
      this.mmyy,
      this.cvc,
      this.address,
      this.country,
      this.city,
      this.province,
      this.zipCode,
      this.statusBayar});

  PaymentModel.fromJson(Map<String, dynamic> map) {
    this.cardNumber = map["cardNumber"];
    this.cardName = map['cardName'];
    this.statusBayar = map['statusBayar'];
  }
}
