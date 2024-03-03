import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pruksa/models/noti_model.dart';
import 'package:pruksa/models/risk_model.dart';
import 'package:pruksa/models/user_model.dart';
import 'package:pruksa/utility/app_controller.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class AppService {
  //depency คือตัวที่ใช้สำหรับเรียก field ที่อยู่ใน คลาส Apppcontroller
  AppController appController = Get.put(AppController());

  Future<void> processNoti({required bool fromAdmin}) async {
    //update Token
    FirebaseAuth.instance.authStateChanges().listen((event) async {
      print('## event ---> $event');

      if (event == null) {
        //SignOut Status
        print('## work');

        await FirebaseAuth.instance.signInAnonymously().then((value) {
          print('## signIn Success');
          processFindToken(fromAdmin: fromAdmin);
        }).catchError((onError) {
          print('## onError --> $onError');
        });
      } else {
        //SignIn Status
        processFindToken(fromAdmin: fromAdmin);
      }
    });

    FirebaseMessaging.onMessage.listen((event) {
      Get.snackbar(event.notification!.title!, event.notification!.body!);

      saveNoti(
          title: event.notification!.title!,
          message: event.notification!.body!);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      Get.snackbar(event.notification!.title!, event.notification!.body!);

      saveNoti(
          title: event.notification!.title!,
          message: event.notification!.body!);
    });
  }

  Future<void> processFindToken({required bool fromAdmin}) async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    String? token = await firebaseMessaging.getToken();

    print('## token --> $token');

    if (fromAdmin) {
      //From Admin

      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? userKey = preferences.getString('id');

      String urlAPI =
          '${MyConstant.domain}/dopa/api/updatetoken.php?isAdd=true&token=$token&key=$userKey';

      await Dio().get(urlAPI).then((value) => print('Update Success'));
    } else {
      //From User
    }
  }

  Future<void> processReadAllAdmin() async {
    String urlApi = 'https://banluang.org//dopa/api/getalluser.php?isAdd=true';

    await Dio().get(urlApi).then((value) {
      if (appController.userModels.isNotEmpty) {
        appController.userModels.clear();
        appController.chooseUserModels.clear();
      }

      for (var element in json.decode(value.data)) {
        UserModel userModel = UserModel.fromMap(element);

        appController.userModels.add(userModel);
        appController.chooseUserModels.add(true);
      }
    });
  }

  Future<void> processSentNoti({
    required String token,
    required String title,
    required String message,
  }) async {
    String urlApi =
        '${MyConstant.domain}/dopa/api/apinoti.php?isAdd=true&title=$title&body=$message&token=$token';

    await Dio().get(urlApi).then((value) => print('## Send Noti Success'));
  }

  Future<void> processCheckNoti() async {
    var result = await GetStorage().read('noti');
    print('## result --> $result');
  }

  Future<void> saveNoti({
    required String title,
    required String message,
  }) async {
    var notis = <NotiModel>[];

    var result = await GetStorage().read('noti');
    if (result != null) {
      notis.addAll(result);
    }
  }

  Future<void> goToDirection({required String lat, required String lng}) async {
    String url = 'https://www.google.co.th/maps/search/?api=1&query=$lat,$lng';
    print('## url ---> $url');

    Uri uri = Uri.parse(url);

    if (await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Cannot open';
    }
  }

  Future<void> readAllRiskData() async {
    String urlApi =
        'https://banluang.org//dopa/api/getriskreport.php?isAdd=true';

    await Dio().get(urlApi).then((value) {
      if (appController.riskModels.isNotEmpty) {
        appController.riskModels.clear();
      }

      for (var element in json.decode(value.data)) {
        RiskModel riskModel = RiskModel.fromMap(element);
        appController.riskModels.add(riskModel);
      }
    });
  }
}
