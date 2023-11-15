class UserModel {
  String? uid;
  String? email;
  String? phone;
  String? fname;
  String? image;




  UserModel({this.uid, this.email, this.phone, required eamil,this.fname,  this.image,});

  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      eamil: map['email'],
      phone: map['phone'],
      fname: map['fname'],
      image: map['image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'phone': phone,
      'fname': fname,
      'image': image,
    };
  }
}