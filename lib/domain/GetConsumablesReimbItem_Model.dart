class GetConsumableSreimbitemModel {
  final String sItemName;
  final String fQty;
  final String sUoM;
  final String fAmount;

  GetConsumableSreimbitemModel({
    required this.sItemName,
    required this.fQty,
    required this.sUoM,
    required this.fAmount,

  });

  // Factory constructor to create an instance from JSON
  factory GetConsumableSreimbitemModel.fromJson(Map<String, dynamic> json) {
    return GetConsumableSreimbitemModel(
      sItemName: json['sItemName'],
      fQty: json['fQty'],
      sUoM: json['sUoM'],
      fAmount: json['fAmount'],

    );
  }
}
