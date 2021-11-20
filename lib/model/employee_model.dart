class EmployeeModel {
  final String id;
  final String nama;
  final String email;
  final String address;
  final String phone;
  final String username;
  final String password;
  final String image;

  EmployeeModel(this.id, this.nama, this.email, this.address, this.phone,
      this.username, this.password, this.image);
}

class TotalEmployeeModel {
  final String totalItems;

  TotalEmployeeModel(this.totalItems);
}
