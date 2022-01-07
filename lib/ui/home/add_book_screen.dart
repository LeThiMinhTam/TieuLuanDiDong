import 'package:final_exam/bloc/add_book_bloc.dart';
import 'package:final_exam/bloc/home_bloc.dart';
import 'package:final_exam/utils/app_color.dart';
import 'package:final_exam/utils/app_dialog.dart';
import 'package:final_exam/utils/app_text_style.dart';
import 'package:final_exam/utils/string_util.dart';
import 'package:final_exam/utils/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({Key? key}) : super(key: key);

  @override
  _AddStudentScreenState createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  TextEditingController _MaSachController = TextEditingController();
  TextEditingController _TenSachController = TextEditingController();
  TextEditingController _TacGiaController = TextEditingController();
  TextEditingController _NgayXBController = TextEditingController();
  TextEditingController _SoLuongController = TextEditingController();
  TextEditingController _GiaController = TextEditingController();
  
  FocusNode _TenSachNode = FocusNode();
  FocusNode _TacGiaNode = FocusNode();
  FocusNode _SoLuongNode = FocusNode();
  FocusNode _GiaNode = FocusNode();
  late AddBookBloC _addBookBloC;

  @override
  void initState() {
    _addBookBloC = AddBookBloC.getInstance();
    _addBookBloC.clearData();
    super.initState();
  }

  @override
  void dispose() {
    _MaSachController.dispose();
    _TenSachController.dispose();
    _TacGiaController.dispose();
    _NgayXBController.dispose();
    _SoLuongController.dispose();
    _GiaController.dispose();
    _GiaNode.dispose();
    _TenSachNode.dispose();
    _TacGiaNode.dispose();
    _SoLuongNode.dispose();
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
                        textField(
                          context,
                          controller: _MaSachController,
                          labelText: 'Mã sách',
                          keyboardType: TextInputType.name,
                          textCapitalization: TextCapitalization.words,
                          maxLength: 60,
                          onChanged: (value) =>
                              _addBookBloC.MaSach = value,
                          onSubmitted: (value) {
                            _TenSachNode.requestFocus();
                          },
                        ),
                        SizedBox(height: 18.0),
                        textField(
                          context,
                          controller: _TenSachController,
                          focusNode: _TenSachNode,
                          labelText: 'Tên sách',
                          textCapitalization: TextCapitalization.characters,
                          maxLength: 15,
                          onChanged: (value) =>
                              _addBookBloC.TenSach = value,
                          onSubmitted: (value) {
                            _TacGiaNode.requestFocus();
                          },
                        ),
                        SizedBox(height: 18.0),
                        textField(
                          context,
                          controller: _TacGiaController,
                          focusNode: _TacGiaNode,
                          labelText: 'Tác giả',
                          textCapitalization: TextCapitalization.characters,
                          maxLength: 6,
                          onChanged: (value) => _addBookBloC.TacGia = value,
                          onSubmitted: (value) {
                            _SoLuongNode.requestFocus();
                          },
                        ),
                        SizedBox(height: 18.0),
                        textField(
                          context,
                          controller: _SoLuongController,
                          focusNode: _SoLuongNode,
                          labelText: 'Số lượng',
                          textCapitalization: TextCapitalization.words,
                          maxLength: 50,
                          onChanged: (value) => _addBookBloC.SoLuong = value,
                          onSubmitted: (value) {
                            _GiaNode.requestFocus();
                          },
                        ),
                        SizedBox(height: 18.0),
                        textField(
                          context,
                          controller: _GiaController,
                          focusNode: _GiaNode,
                          labelText: 'Giá',
                          keyboardType: TextInputType.number,
                          maxLength: 4,
                          onChanged: (value) =>
                              _addBookBloC.Gia = value,
                          onSubmitted: (value) {},
                        ),
                        SizedBox(height: 18.0),
                        _NgayXBField(context),
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
        'Thêm sách',
        style: AppTextStyle.mediumBlack1A.copyWith(fontSize: 18),
      ),
      centerTitle: true,
    );
  }

  Widget _NgayXBField(BuildContext context) {
    return TextField(
      controller: _NgayXBController,
      cursorColor: AppColor.colorDarkBlue,
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Ngày xuất bản',
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        filled: true,
        fillColor: AppColor.colorGreyEE,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            width: 0.8,
            color: AppColor.colorDarkBlue,
          ),
        ),
        suffixIcon: Icon(
          Icons.calendar_today_rounded,
          size: 23,
        ),
        isDense: true,
      ),
      onTap: pickDOB,
    );
  }

  Widget _saveButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: AppColor.colorWhite,
      child: StreamBuilder<bool>(
          stream: _addBookBloC.saveButtonState,
          builder: (_, snapshot) {
            bool isEnable = snapshot.data ?? false;
            return MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              disabledColor: AppColor.colorGrey97,
              minWidth: double.infinity,
              height: 54,
              color: AppColor.colorDarkBlue,
              onPressed: isEnable ? addBook : null,
              child: Text(
                'Thêm',
                style: TextStyle(
                  color: AppColor.colorWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              padding: EdgeInsets.all(0),
            );
          }),
    );
  }

  Widget _loadingState(BuildContext context) {
    return StreamBuilder<bool>(
        stream: _addBookBloC.loadingState,
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

  void pickDOB() {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(1900, 1, 1),
      maxTime: DateTime.now(),
      currentTime: _NgayXBController.text.isNotEmpty
          ? DateFormat('dd/MM/yyyy').parse(_NgayXBController.text)
          : DateTime.now(),
      locale: LocaleType.vi,
      onConfirm: (time) {
        _NgayXBController.text = DateFormat('dd/MM/yyyy').format(time);
        _addBookBloC.NgayXB = _NgayXBController.text;
      },
    );
  }

  void addBook() {
    WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
    _addBookBloC.addBook().then((sucess) {
      HomeBloC.getInstance().getListBook();
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return succesfulMessageDialog(context, content: 'Thêm sách');
        },
      ).then((_) {
        Navigator.pop(context);
      });
    }).catchError((error) {
      _addBookBloC.hideLoading();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(StringUtil.stringFromException(error))));
    });
  }
}
