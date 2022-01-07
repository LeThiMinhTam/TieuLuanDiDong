import 'dart:async';

import 'package:final_exam/bloc/base_bloc.dart';
import 'package:final_exam/models/book.dart';
import 'package:final_exam/services/book_services.dart';

class EditBookBloC extends BaseBloC {
  static final EditBookBloC _instance = EditBookBloC._();
  EditBookBloC._() {
    _bookServices = BookServices();
  }

  static EditBookBloC getInstance() {
    return _instance;
  }

  late BookServices _bookServices;
  late Book _book;

  set book(Book value) {
    _book = value;
  }


  Future<bool> updateBook() async {
    showLoading();
    bool result = await _bookServices.editBook(_book);
    hideLoading();
    return result;
  }

  @override
  void clearData() {
    hideLoading();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
