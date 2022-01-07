import 'dart:convert';

import 'package:final_exam/models/book.dart';
import 'package:final_exam/services/file_services.dart';
import 'package:flutter/services.dart';

//ghi các thông tin của student trong file students.json
class BookServices extends FileServices {
  final String fileName = 'books.json';

  ///lấy data student từ file [books.json]
  ///trả về default data từ assets nếu không có dữ liệu từ file
  Future<List<Book>> getListBook() async {
    try {
      String data = await readData(fileName);
      List jsonData = json.decode(data);
      return jsonData.map<Book>((e) => Book.fromJson(e)).toList();
    } catch (error) {
      String bookData =
          await rootBundle.loadString('assets/json/book_data.json');
      await writeData(fileName, bookData);
      List jsonData = json.decode(bookData);
      return jsonData.map<Book>((e) => Book.fromJson(e)).toList();
    }
  }

  Future<bool> addBook(Book book) async {
    List<Book> listBook = await getListBook();
    int index = listBook
        .indexWhere((element) => element.MaSach == book.MaSach);
    if (index != -1) {
      throw Exception('Sách đã tồn tại');
    }
    listBook.insert(0, book);
    List<Map<String, dynamic>> list = [];
    listBook.forEach((element) {
      list.add(element.toJson());
    });
    await writeData(fileName, list);
    return true;
  }

  Future<bool> deleteBook(Book book) async {
    List<Book> listBook = await getListBook();
    int index = listBook
        .indexWhere((element) => element.MaSach == book.MaSach);
    if (index == -1) {
      throw Exception('Sách không tồn tại');
    }
    listBook.removeAt(index);
    List<Map<String, dynamic>> list = [];
    listBook.forEach((element) {
      list.add(element.toJson());
    });
    await writeData(fileName, list);
    return true;
  }

  Future<bool> editBook(Book book) async {
    List<Book> listBook = await getListBook();
    int index = listBook
        .indexWhere((element) => element.MaSach == book.MaSach);
    if (index == -1) {
      throw Exception('Sách không tồn tại');
    }
    listBook[index] = book;
    List<Map<String, dynamic>> list = [];
    listBook.forEach((element) {
      list.add(element.toJson());
    });
    await writeData(fileName, list);
    return true;
  }
}
