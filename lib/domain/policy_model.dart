class PolicyDocModel {
  final String sPolicyCode;
  final String sPolictyTitle;
  final String sPolictyDescription;
  final String dUploadDate;
  final String sPolicyFile;

  PolicyDocModel({
    required this.sPolicyCode,
    required this.sPolictyTitle,
    required this.sPolictyDescription,
    required this.dUploadDate,
    required this.sPolicyFile,
  });

  // Factory method to create a Policy instance from a map (JSON)
  factory PolicyDocModel.fromJson(Map<String, dynamic> json) {
    return PolicyDocModel(
      sPolicyCode: json['sPolicyCode'],
      sPolictyTitle: json['sPolictyTitle'],
      sPolictyDescription: json['sPolictyDescription'],
      dUploadDate: json['dUplaodDate'],
      sPolicyFile: json['sPolicyFile'],
    );
  }

  // Method to convert a Policy instance to a map (JSON)
  // Map<String, dynamic> toJson() {
  //   return {
  //     'sPolicyCode': sPolicyCode,
  //     'sPolictyTitle': sPolictyTitle,
  //     'sPolictyDescription': sPolictyDescription,
  //     'dUplaodDate': dUploadDate,
  //     'sPolicyFile': sPolicyFile,
  //   };
  // }
}
