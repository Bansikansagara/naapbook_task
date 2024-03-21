class RegisterModel {
  final String firstName;
  final String lastName;
  final String email;
  final String mobile;
  final String password;
  final String designation;

  RegisterModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobile,
    required this.password,
    required this.designation,
  });

  Map<String, dynamic> toMap() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'mobile': mobile,
      'password': password,
      'designation': designation,
    };
  }
}
