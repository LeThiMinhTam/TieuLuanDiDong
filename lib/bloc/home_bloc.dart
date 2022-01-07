import 'dart:async';

import 'package:final_exam/bloc/base_bloc.dart';
import 'package:final_exam/models/book.dart';
import 'package:final_exam/services/book_services.dart';

class HomeBloC extends BaseBloC {
  static final HomeBloC _instance = HomeBloC._();
  HomeBloC._() {
    _bookServices = BookServices();
  }

  static HomeBloC getInstance() {
    return _instance;
  }

  late BookServices _bookServices;

  StreamController<List<Book>> _listBooksController =
      StreamController<List<Book>>.broadcast();

  Stream<List<Book>> get listBookStream => _listBooksController.stream;

  Future<List<Book>> getListBook() async {
    List<Book> list = await _bookServices.getListBook();
    _listBooksController.sink.add(list);
    return list;
  }

  Future<bool> deleteBook(Book book) async {
    bool deleteSuccess = await _bookServices.deleteBook(book);
    await getListBook();
    return deleteSuccess;
  }

  @override
  void clearData() {}

  @override
  void dispose() {
    _listBooksController.close();
    super.dispose();
  }
}
