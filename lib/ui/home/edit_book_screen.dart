import 'package:final_exam/bloc/edit_book_bloc.dart';
import 'package:final_exam/bloc/home_bloc.dart';
import 'package:final_exam/models/book.dart';
import 'package:final_exam/utils/app_color.dart';
import 'package:final_exam/utils/app_dialog.dart';
import 'package:final_exam/utils/app_text_style.dart';
import 'package:final_exam/utils/string_util.dart';
import 'package:final_exam/utils/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class EditBookScreen extends StatefulWidget {
  final Book book;
  const EditBookScreen({Key? key, required this.book}) : super(key: key);

  @override
  _EditBookScreenState createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  EditBookBloC _editBloC = EditBookBloC.getInstance();
  late Book book;

  @override
  void initState() {
    _editBloC.clearData();
    _editBloC.book = widget.book;
    book = widget.book;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: Stack(
        children: [
          Scaffold(
            appBar: _buildAppBar(context),
            backgroundColor: Theme.of(context).backgroundColor,
            resizeToAvoidBottomInset: true,
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '''${book.MaSach}''',
                          style: AppTextStyle.mediumBlack1A
                              .copyWith(fontSize: 16.0),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          'Tên sách: ${book.TenSach}',
                          style: AppTextStyle.regularBlack1A
                              .copyWith(fontSize: 16.0),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 4.0),
                        _buildRichText(context,
                            text: "Tác giả: ${book.TacGia} - ${book.TacGia}",
                            highlightText:
                                ' - Số lượng ${book.SoLuong}'),
                        SizedBox(height: 4.0),
                        Text(
                          'Ngày xuất bản: ${book.NgayXB}',
                          style: AppTextStyle.regularBlack1A
                              .copyWith(fontSize: 16.0),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 18.0),
                        
                      ],
                    ),
                  ),
                ),
                _saveButton(context),
              ],
            ),
          ),
          _loadingState(context),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).backgroundColor,
      leading: BackButton(),
      title: Text(
        'Thông tin sách',
        style: AppTextStyle.mediumBlack1A.copyWith(fontSize: 18),
      ),
      centerTitle: true,
    );
  }

  Widget _buildRichText(BuildContext context,
      {required String text, required String highlightText}) {
    return RichText(
      text: TextSpan(
        text: text,
        style: AppTextStyle.regularBlack1A.copyWith(fontSize: 16.0),
        children: [
          TextSpan(
            text: highlightText,
            style: AppTextStyle.mediumBlack1A.copyWith(fontSize: 16.0),
          )
        ],
      ),
    );
  }

  Widget _saveButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: AppColor.colorWhite,
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        disabledColor: AppColor.colorGrey97,
        minWidth: double.infinity,
        height: 54,
        color: AppColor.colorDarkBlue,
        onPressed: updateStudent,
        child: Text(
          'Cập nhật',
          style: TextStyle(
            color: AppColor.colorWhite,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        padding: EdgeInsets.all(0),
      ),
    );
  }

  Widget _loadingState(BuildContext context) {
    return StreamBuilder<bool>(
        stream: _editBloC.loadingState,
        builder: (_, snapshot) {
          bool isLoading = snapshot.data ?? false;
          if (isLoading) {
            return Container(
              height: double.infinity,
              width: double.infinity,
              color: AppColor.colorGrey97.withOpacity(0.5),
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          }
          return SizedBox.shrink();
        });
  }

  void updateStudent() {
    WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
    _editBloC.updateBook().then((success) {
      HomeBloC.getInstance().getListBook();
      showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return succesfulMessageDialog(context, content: 'Cập nhật');
        },
      ).then((value) => Navigator.pop(context));
    }).catchError((error) {
      _editBloC.hideLoading();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(StringUtil.stringFromException(error))));
    });
  }
}
