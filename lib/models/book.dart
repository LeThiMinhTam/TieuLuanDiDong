class Book {
  String? MaSach;
  String? TenSach;
  String? TacGia;
  String? NgayXB;
  String? SoLuong;
  String? Gia;

  Book(
      {this.MaSach,
      this.TenSach,
      this.TacGia,
      this.NgayXB,
      this.SoLuong,
      this.Gia});

  Book.fromJson(Map<String, dynamic> json) {
    MaSach = json['MaSach'];
    TenSach = json['TenSach'];
    TacGia = json['TacGia'];
    NgayXB = json['NgayXB'];
    SoLuong = json['SoLuong'];
    Gia = json['Gia'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MaSach'] = this.MaSach;
    data['TenSach'] = this.TenSach;
    data['TacGia'] = this.TacGia;
    data['NgayXB'] = this.NgayXB;
    data['SoLuong'] = this.SoLuong;
    data['Gia'] = this.Gia;
    return data;
  }

  bool isFullInformation() {
    if (MaSach == null ||
        TenSach == null ||
        TacGia == null ||
        NgayXB == null ||
        SoLuong == null ||
        Gia == null) {
      return false;
    }
    return MaSach!.isNotEmpty &&
        TenSach!.isNotEmpty &&
        TacGia!.isNotEmpty &&
        NgayXB!.isNotEmpty &&
        SoLuong!.isNotEmpty &&
        Gia!.isNotEmpty;
  }
}
