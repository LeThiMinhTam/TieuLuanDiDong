import 'package:final_exam/bloc/home_bloc.dart';
import 'package:final_exam/models/book.dart';
import 'package:final_exam/ui/home/edit_book_screen.dart';
import 'package:final_exam/utils/app_color.dart';
import 'package:final_exam/utils/app_dialog.dart';
import 'package:final_exam/utils/app_text_style.dart';
import 'package:final_exam/utils/string_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BookItem extends StatefulWidget {
  final Animation<double> animation;
  final Book book;
  final Function()? onRemoved;
  const BookItem(
      {Key? key,
      required this.book,
      required this.animation,
      this.onRemoved})
      : super(key: key);

  @override
  _BookItemState createState() => _BookItemState();
}

class _BookItemState extends State<BookItem> {
  late Book book;
  @override
  void initState() {
    book = widget.book;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: widget.animation,
      axis: Axis.vertical,
      child: Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Theme.of(context).backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Color(0xff141A1A1A),
              blurRadius: 32,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    '''${book.MaSach}''',
                    style: AppTextStyle.mediumBlack1A.copyWith(fontSize: 16),
                    textAlign: TextAlign.left,
                  ),
                ),
                _buildButton(context, 'Sửa', editBook,
                    color: AppColor.colorGreen),
                SizedBox(width: 5.0),
                _buildButton(context, 'Xoá', deleteBook,
                    color: AppColor.colorRed),
              ],
            ),
            SizedBox(height: 10.0),
            Text(
              'Tên sách: ${book.TenSach}',
              style: AppTextStyle.regularBlack1A,
              textAlign: TextAlign.left,
            ),
            Text(
              'Tác giả: ${book.TacGia}',
              style: AppTextStyle.regularBlack1A,
              textAlign: TextAlign.left,
            ),
            _buildRichText(context,
                text: "Số luọng: ${book.SoLuong}",
                highlightText: ' - Giá: ${book.Gia}'),
            Text(
              'Ngày xuất bản: ${book.NgayXB}',
              style: AppTextStyle.regularBlack1A,
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRichText(BuildContext context,
      {required String text, required String highlightText}) {
    return RichText(
      text: TextSpan(
        text: text,
        style: AppTextStyle.regularBlack1A,
        children: [
          TextSpan(
            text: highlightText,
            style: AppTextStyle.mediumBlack1A,
          )
        ],
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, String label, void Function()? onPressed,
      {Color color = AppColor.colorGreen}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: color,
        elevation: 0.0,
      ),
      child: Text(label),
    );
  }

  void editBook() {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => EditBookScreen(book: book)));
  }

  void deleteBook() {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return confirmDialog(
            context, 'Xoá', 'Bạn chắc chắn muốn xoá sách này?');
      },
    ).then((acceptDelete) {
      if (acceptDelete ?? false) {
        HomeBloC.getInstance().deleteBook(book).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(StringUtil.stringFromException(error))));
        });
        if (widget.onRemoved != null) {
          widget.onRemoved!.call();
        }
      }
    });
  }
}
