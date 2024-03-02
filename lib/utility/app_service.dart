import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppService {
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
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      Get.snackbar(event.notification!.title!, event.notification!.body!);
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
}
