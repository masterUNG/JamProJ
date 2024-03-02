import 'dart:convert';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pruksa/models/member_model.dart';
import 'package:pruksa/models/user_model.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/wigets/my_textfield.dart';
import 'package:pruksa/wigets/show_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/my_dialog.dart';
import '../wigets/show_titel.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool statusRedEye = true;
  final formKey = GlobalKey<FormState>();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            behavior: HitTestBehavior.opaque,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      margin: EdgeInsets.only(top: 20),
                      width: size * 0.4,
                      child: ShowImage(path: MyConstant.imgdopa)),
                  const SizedBox(height: 20),
                  ShowTitle(
                    title: MyConstant.appName,
                    textStyle: MyConstant().gh1Style(),
                  ),
                  Text(
                    'Mobile App สำหรับคนบ้านหลวง จังหวัดน่าน',
                    style: GoogleFonts.sarabun(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),
                  MyTextField(
                    validateFunc: (p0) {
                      if (p0?.isEmpty ?? true) {
                        return 'กรุณากรอกบัตรปรจำตัว';
                      } else {
                        return null;
                      }
                    },
                    controller: userController,
                    hintText: 'เลขบัตรประจำตัวประชาชน',
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),

                  // password textfield
                  MyTextField(
                    validateFunc: (p0) {
                      if (p0?.isEmpty ?? true) {
                        return 'กรุณากรอกเบอร์โทร';
                      } else {
                        return null;
                      }
                    },
                    controller: passwordController,
                    hintText: 'เบอร์โทรศัพท์',
                    obscureText: true,
                  ),
                  const SizedBox(height: 25),
/*
                Container(
                margin: EdgeInsets.symmetric(vertical: 16),
                width: size * 0.6,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      String user = userController.text;
                      String password = passwordController.text;
                      print('## user = $user, password = $password');
                      checkAuthen(user: user, password: password);
                    }
                  },
                  child: Text('เข้าสู่ระบบ'),
                  style: MyConstant().mydarkbutton(),
                ),
              ),
              */
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossFadeState,
                      children: [
                        ElevatedButton(
                          //style: Colors.accents,
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              String user = userController.text;
                              String password = passwordController.text;
                              print('## user = $user, password = $password');
                              checkAuthen(user: user, password: password);
                            }
                          },
                          child: Text(
                            'เข้าสู่ระบบ',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: MyConstant().mydarkbutton(),
                        ),
                        Padding(padding: EdgeInsets.all(10)),
                        BuildAgent(),
                      ],
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShowTitle(
                        title: 'ไม่มีบัญชี ?',
                        textStyle: MyConstant().h3Style(),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(
                            context, MyConstant.routeRegister),
                        child: Text('ลงทะเบียนผู้ใช้งาน'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 75,
                  ),

                  Text('อำเภอบ้านหลวง จังหวัดน่าน',
                      style: GoogleFonts.sarabun(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      )),
                  Text('In The Collection P Project',
                      style: GoogleFonts.prompt(
                        fontSize: 18,
                        color: Colors.pinkAccent,
                      )),
                  Container(
                      margin: EdgeInsets.only(top: 20),
                      width: size * 0.8,
                      child: ShowImage(path: 'images/logo.png')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton BuildAgent() {
    return ElevatedButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          String user = userController.text;
          String password = passwordController.text;
          print('## user = $user, password = $password');
          checkUser(user: user, password: password);
        }
      },
      child: Text(
        'สำหรับเจ้าหน้าที่',
        style: TextStyle(color: Colors.white),
      ),
      style: MyConstant().mydarkbutton(),
    );
  }

  Future<Null> checkUser({String? user, String? password}) async {
    String? apiCheckAuthen =
        '${MyConstant.domain}/dopa/api/checklogin.php?isAdd=true&user=$user&password=$password';
    await Dio().get(apiCheckAuthen).then((value) async {
      print('## value for API ==>> $value');
      if (value.toString() == 'null') {
        MyDialog().normalDialog(
            context, 'ไม่สามารถเข้าระบบได้!!!', 'ไม่มี $user ในฐานข้อมูล');
      } else {
        print('aaaaaa');
        for (var item in json.decode(value.data)) {
          UserModel model = UserModel.fromMap(item);

          // Success Authen
          //String type = model.user_position;
          // print('## Authen Success in Type ==> $type');
          SharedPreferences preferences = await SharedPreferences.getInstance();

          preferences.setString('id', model.user_key);
          // var user_key = await preferences.getString('id');
          //  preferences.setString('type', model.user_position);
          preferences.setString('posname', model.pos_name);
          // preferences.setString('name', model.name);
          preferences.setString('fullname', model.fullname);
          preferences.setString('user_photo', model.user_photo);

          Navigator.pushNamedAndRemoveUntil(
              context, MyConstant.routeAdmin, (route) => false);
        }
      }
    });
  }

  Future<Null> checkAuthen({String? user, String? password}) async {
    String apiCheckAuthen =
        '${MyConstant.domain}/dopa/api/getMemberWherecid.php?isAdd=true&user=$user';

    print('urlApi --> $apiCheckAuthen');

    await Dio().get(apiCheckAuthen).then((value) async {
      print('## value for API ==>> $value');
      if (value.toString() == 'null') {
        MyDialog().normalDialog(
            context, 'ไม่สามารถเข้าระบบได้!!!', 'ไม่มี $user ในฐานข้อมูล');
      } else {
        for (var item in json.decode(value.data)) {
          MemberModel model = MemberModel.fromMap(item);

          print('model ===> ${model.toMap()}');

          if (password == model.phone) {
            // Success Authen
            String type = model.cid;
            print('## Authen Success in Type ==> $type');

            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.setString('cid', model.cid);
            preferences.setString('phone', model.phone);
            preferences.setString('lastname', model.lastname);
            preferences.setString('name', model.name);
            preferences.setString('photo', model.images);
            Navigator.pushNamedAndRemoveUntil(
                context, MyConstant.routeDashboard, (route) => false);
          } else {
            // Authen False
            MyDialog().normalDialog(context, 'Password False !!!',
                'Password False Please Try Again');
          }
        }
      }
    });
  }
}
