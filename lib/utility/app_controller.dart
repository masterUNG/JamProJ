import 'package:get/get.dart';
import 'package:pruksa/models/risk_model.dart';
import 'package:pruksa/models/user_model.dart';

class AppController extends GetxController{

  RxList<UserModel> userModels = <UserModel>[].obs;
  RxList<bool> chooseUserModels = <bool>[].obs;

  RxList<RiskModel> riskModels = <RiskModel>[].obs;
  
}