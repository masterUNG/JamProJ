import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pruksa/models/damrong_model.dart';
import 'package:pruksa/pages/admin.dart';
import 'package:pruksa/pages/edit_damrong.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/utility/my_dialog.dart';
import 'package:pruksa/wigets/show_image.dart';
import 'package:pruksa/wigets/show_progress.dart';
import 'package:pruksa/wigets/show_titel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DamrongAll extends StatefulWidget {
  const DamrongAll({Key? key}) : super(key: key);

  @override
  State<DamrongAll> createState() => _DamrongAllState();
}

class _DamrongAllState extends State<DamrongAll> {
  bool load = true;
  bool? haveData;

  List<DamrongModels> dammodels = [];
  void initState() {
    // TODO: implement initState
    super.initState();
    CheckAccess();
    //loadvaluefromapi();
    // initialFile();
  }

  Future<Null> CheckAccess() async {
    SharedPreferences preference = await SharedPreferences.getInstance();

    String key = preference.getString('id')!;

    print('### user_key = $key');
    String apigetactivelist =
        '${MyConstant.domain}/dopa/api/checkdamrong.php?isAdd=true&key=$key';

    print('api ---> $apigetactivelist');

    await Dio().get(apigetactivelist).then((value) {
      print('value ==> $value');
      // print('value ==> $id');
      if (value.toString() == 'null') {
        // No Data
        _dialogBuilder(context);
      } else {
        loadvaluefromapi();
      }
    });
  }

  Future<Null> loadvaluefromapi() async {
    if (dammodels.length != 0) {
      dammodels.clear();
    } else {}

    String apigetactivelist =
        '${MyConstant.domain}/dopa/api/getdamall.php?isAdd=true';

    await Dio().get(apigetactivelist).then((value) {
      print('value ==> $value');
      // print('value ==> $id');
      if (value.toString() == 'null') {
        // No Data
        setState(() {
          load = false;
          haveData = false;
        });
      } else {
        for (var item in json.decode(value.data)) {
          DamrongModels model = DamrongModels.fromMap(item);
          //print('name of titel =${model.titel}');

          setState(() {
            load = false;
            haveData = true;
            dammodels.add(model);
          });
        }
      }
    });
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ไม่สามารถดูข้อมูลได้'),
          content: const Text(
            'คุณไม่ได้รับให้อนุญาติให้ดูข้อมูลนี้ หากต้องการดูข้อมูลติดต่อผู้ดูแลระบบ',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('ตกลง'),
              onPressed: () {
                Get.offAllNamed(MyConstant.routeAdmin);
              },
            ),
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลร้องเรียนร้องทุกข์'),
      ),
      body: load
          ? ShowProgress()
          : haveData!
              ? ListView.builder(
                  itemCount: dammodels.length,
                  itemBuilder: (context, index) => Card(
                        elevation: 10.0,
                        margin: new EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 6.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(246, 242, 247, 0.894)),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditDamrong(
                                      dammodels: dammodels[index],
                                    ),
                                  )).then((value) => loadvaluefromapi());
                            },
                            leading: Container(
                              width: 60,
                              height: 60,
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl:
                                    ('${MyConstant.domain}/images/informrisk/${dammodels[index].contact_images}'),
                                placeholder: (context, url) => ShowProgress(),
                                errorWidget: (context, url, error) =>
                                    ShowImage(path: MyConstant.imgdopa),
                              ),
                            ),
                            title: Text(
                                'ผู้ร้อง:${dammodels[index].contact_name}'),
                            subtitle: Text(
                              'สถานะ:${dammodels[index].status_name}',
                              style: MyConstant().h3RedStyle(),
                            ),
                            trailing: Icon(Icons.keyboard_arrow_right,
                                color: Color.fromARGB(255, 22, 22, 22),
                                size: 30.0),
                          ),
                        ),
                      )
                  //
                  )
              : Column(
                  children: [
                    ShowTitle(
                      title: 'ไม่มีข้อมูล',
                      textStyle: MyConstant().h2RedStyle(),
                    ),
                  ],
                ),

      //.
    );
  }
}
