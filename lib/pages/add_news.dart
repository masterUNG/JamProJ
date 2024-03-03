import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pruksa/utility/app_controller.dart';
import 'package:pruksa/utility/app_service.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/utility/my_dialog.dart';
import 'package:pruksa/wigets/show_image.dart';
import 'package:pruksa/wigets/show_titel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddNews extends StatefulWidget {
  const AddNews({Key? key}) : super(key: key);

  @override
  State<AddNews> createState() => _AddNewsState();
}

class _AddNewsState extends State<AddNews> {
  String avatar = '';
  File? file;
  TextEditingController titelController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  AppController appController = Get.put(AppController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppService().processReadAllAdmin();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('เพิ่มข่าวประชาสัมพันธ์'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              BuildTitel(),
              const SizedBox(
                height: 20,
              ),
              BuildDetail(),
              const SizedBox(
                height: 20,
              ),
              const ShowTitle(title: 'กรุณาเพิ่มรูปภาพถ้ามี'),
              const SizedBox(
                height: 20,
              ),
              buildAvatar(size),
              const SizedBox(
                height: 10,
              ),
              listUserAdmin(),
              buildbutton(),
            ],
          ),
        ),
      ),
    );
  }

  Obx listUserAdmin() {
    return Obx(() {
      return appController.userModels.isEmpty
          ? const SizedBox()
          : ListView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: appController.chooseUserModels.length,
              itemBuilder: (context, index) => CheckboxListTile(
                activeColor: Colors.blue,
                value: appController.chooseUserModels[index],
                onChanged: (value) {
                  appController.chooseUserModels[index] = value!;
                },
                title: Text(appController.userModels[index].fullname),
              ),
            );
    });
  }

  Future<Null> uploadPictureAndInsertData() async {
    String titel = titelController.text;
    String detail = detailController.text;

    print('## สถานที่ = $titel ,รายละเอียด = $detail');

    if (file == null) {
      // No Avatar
      MyDialog()
          .normalDialog(context, 'ไม่ได้แนบรูปภาพ ?', 'กรุณาแนบรูปภาพด้วยค่ะ');
    } else {
      //      // Have Avatar
      print('### process Upload Avatar');
      SharedPreferences preference = await SharedPreferences.getInstance();
      String userkey = preference.getString('id')!;

      print('### key = $userkey');

      print('### process Upload Avatar');
      String apiSaveAvatar = '${MyConstant.domain}/dopa/api/savenewpic.php';
      int i = Random().nextInt(100000);
      String nameAvatar = 'new$i.jpg';
      Map<String, dynamic> map = Map();
      map['file'] =
          await dio.MultipartFile.fromFile(file!.path, filename: nameAvatar);
      dio.FormData data = dio.FormData.fromMap(map);
      await dio.Dio().post(apiSaveAvatar, data: data).then((value) {
        avatar = '$nameAvatar';
        print('### avatar = $avatar');
        processInsertMySQL(
          userkey: userkey,
          titel: titel,
          detail: detail,
        );
      });
    }
  }

  Future<Null> processInsertMySQL({
    String? titel,
    String? userkey,
    String? detail,
  }) async {
    print('### processInsertMySQL Work and avatar ==>> $avatar');
    String apiInsertUser =
        '${MyConstant.domain}/dopa/api/insertnews.php?isAdd=true&titel=$titel&image=$avatar&detail=$detail&userkey=$userkey';
    await dio.Dio().get(apiInsertUser).then((value) {
      if (value.toString() == 'true') {
        for (var i = 0; i < appController.chooseUserModels.length; i++) {
          if ((appController.chooseUserModels[i]) &&
              (appController.userModels[i].token!.isNotEmpty)) {
            AppService().processSentNoti(
                token: appController.userModels[i].token!,
                title: titel!,
                message: detail!);
          }
        }

        Navigator.pop(context);
      } else {
        MyDialog().normalDialog(
            context, 'ไม่สามารถเพิ่มข้อมูลได้!!!', 'โปรดลองใหม่อีกครั่ง');
      }
    });
  }

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var result = await ImagePicker().getImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
  }

  Row buildAvatar(double size) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => chooseImage(ImageSource.camera),
          icon: Icon(
            Icons.add_a_photo,
            size: 36,
            color: MyConstant.dark,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          width: size * 0.5,
          height: size * 0.5,
          child: file == null
              ? ShowImage(path: MyConstant.imgphoto)
              : Image.file(file!),
        ),
        IconButton(
          onPressed: () => chooseImage(ImageSource.gallery),
          icon: Icon(
            Icons.add_photo_alternate,
            size: 36,
            color: MyConstant.dark,
          ),
        ),
      ],
    );
  }

  ElevatedButton buildbutton() {
    return ElevatedButton.icon(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          // checkAuthen(user: user, password: password);
          uploadPictureAndInsertData();
        }
      },
      label: const Text("เพิ่มข้อมูล"),
      icon: const Icon(
        Icons.save,
        size: 24,
      ),

      //style: MyConstant().mydarkbutton(),
      style: ElevatedButton.styleFrom(
        primary: MyConstant.dark,
        minimumSize: const Size(100, 40), //elevated btton background color
      ),
    );
  }

  Container BuildTitel() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(244, 243, 243, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: titelController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอกชื่อเรื่อง';
          } else {
            return null;
          }
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'กรุณากรอกชื่อเรื่อง',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ),
    );
  }

  Container BuildDetail() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(244, 243, 243, 1),
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
        maxLines: 4,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'กรุณากรอกรายละเอียด',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ),
    );
  }
}
