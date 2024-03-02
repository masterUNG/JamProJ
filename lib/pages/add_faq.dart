import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/utility/my_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddFaq extends StatefulWidget {
  const AddFaq({Key? key}) : super(key: key);

  @override
  State<AddFaq> createState() => _AddFaqState();
}

class _AddFaqState extends State<AddFaq> {
  final formKey = GlobalKey<FormState>();
  TextEditingController titelController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มข้อมูลคำถามที่พบบ่อย'),
        backgroundColor: MyConstant.dark,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Form(
          key: formKey,
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              Buildtitel(),
              SizedBox(
                height: 20,
              ),
              Builddetail(),
              SizedBox(
                height: 20,
              ),
              buildbutton(),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton buildbutton() {
    return ElevatedButton.icon(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          // checkAuthen(user: user, password: password);
          // InsertData();
          postData();
        }
      },
      label: Text(
        "เพิ่มข้อมูล",
        style: TextStyle(color: Colors.white),
      ),
      icon: Icon(
        Icons.save,
        size: 24,
        color: Colors.white,
      ),

      //style: MyConstant().mydarkbutton(),
      style: ElevatedButton.styleFrom(
        primary: MyConstant.dark,
        minimumSize: Size(100, 40), //elevated btton background color
      ),
    );
  }

  Container Buildtitel() {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Color.fromRGBO(244, 243, 243, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: titelController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอกข้อมูลด้วยครับ';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'กรุณากรอกชื่อเรื่อง',
          hintStyle: TextStyle(color: Colors.black38, fontSize: 15),
        ),
      ),
    );
  }

  Container Builddetail() {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Color.fromRGBO(244, 243, 243, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: detailController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอกรายละเอียด';
          } else {
            return null;
          }
        },
        maxLines: 8,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'กรุณากรอกรายละเอียด',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ),
    );
  }

  Future<Null> InsertData() async {
    String titel = titelController.text;
    String detail = detailController.text;

    print('## สถานที่ = $titel ,รายละเอียด = $detail');

    SharedPreferences preferences = await SharedPreferences.getInstance();

    String id = preferences.getString('id')!;
    String apiInsertUser =
        '${MyConstant.domain}/dopa/api/insertfaq.php?isAdd=true&titel=$titel&detail=$detail&user_key=$id';
    await Dio().get(apiInsertUser).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
      } else {
        MyDialog().normalDialog(
            context, 'ไม่สามารถเพิ่มข้อมูลได้!!!', 'โปรดลองใหม่อีกครั่ง');
      }
    });
  }

  Future<void> postData() async {
    String titel = titelController.text;
    String detail = detailController.text;

    String urlApi = '${MyConstant.domain}/dopa/api/insertfaq1.php?isAdd=true';

    print('## urlAPI = $urlApi');

    print('## สถานที่ = $titel ,รายละเอียด = $detail');

    // SharedPreferences preferences = await SharedPreferences.getInstance();

    // String id = preferences.getString('id')!;
    // final dio = Dio();
    // final response = await dio.post(
    //   '${MyConstant.domain}/dopa/api/insertfaq1.php?isAdd=true',
    //   data: {
    //     'title': titelController.text,
    //     'detail': detailController.text,
    //     'user_key': id,
    //   },
    // );
    // print(response.data);
  }
}
