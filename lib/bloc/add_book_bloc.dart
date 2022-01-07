import 'dart:async';

import 'package:final_exam/bloc/base_bloc.dart';
import 'package:final_exam/models/book.dart';
import 'package:final_exam/services/book_services.dart';

class AddBookBloC extends BaseBloC {
  static final AddBookBloC _instance = AddBookBloC._();
  AddBookBloC._() {
    _bookServices = BookServices();
  }

  static AddBookBloC getInstance() {
    return _instance;
  }

  late BookServices _bookServices;
  late Book _book;

  StreamController<bool> _saveButtonController =
      StreamController<bool>.broadcast();

  Stream<bool> get saveButtonState => _saveButtonController.stream;

  set MaSach(String value) {
    _book.MaSach = value.trim();
    _saveButtonController.sink.add(_book.isFullInformation());
  }

  set TenSach(String value) {
    _book.TenSach = value.trim();
    _saveButtonController.sink.add(_book.isFullInformation());
  }

  set TacGia(String value) {
    _book.TacGia = value.trim();
    _saveButtonController.sink.add(_book.isFullInformation());
  }

  set NgayXB(String value) {
    _book.NgayXB = value.trim();
    _saveButtonController.sink.add(_book.isFullInformation());
  }

  set SoLuong(String value) {
    _book.SoLuong = value.trim();
    _saveButtonController.sink.add(_book.isFullInformation());
  }

  set Gia(String value) {
    _book.Gia = value.trim();
    _saveButtonController.sink.add(_book.isFullInformation());
  }

  Future<bool> addBook() async {
    showLoading();
    bool result = await _bookServices.addBook(_book);
    hideLoading();
    return result;
  }

  @override
  void clearData() {
    hideLoading();
    _saveButtonController.sink.add(false);
    _book = Book();
  }

  @override
  void dispose() {
    _saveButtonController.close();
    super.dispose();
  }
}
