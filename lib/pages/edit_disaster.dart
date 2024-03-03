// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pruksa/models/informdis_model.dart';
import 'package:pruksa/models/member_model.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/utility/my_dialog.dart';
import 'package:pruksa/wigets/show_progress.dart';
import 'package:pruksa/wigets/show_titel.dart';

class EditDisaster extends StatefulWidget {
  final InformDisModel Dismodels;
  const EditDisaster({Key? key, required this.Dismodels}) : super(key: key);

  @override
  State<EditDisaster> createState() => _EditDisasterState();
}

class _EditDisasterState extends State<EditDisaster> {
  InformDisModel? Dismodels;
  List groupList = [];
  String? selecteValue;
  TextEditingController titleController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  List<String> pathImages = [];
  List<File?> files = [];
  bool statusImage = false; // false => Not Change Image

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Dismodels = widget.Dismodels;
    // print('### image from mySQL ==>> ${productModel!.images}');
    nameController.text = Dismodels!.inform_name;
    //titleController.text = Riskmodels!.inform_titel;
    placeController.text = Dismodels!.inform_place;
    detailController.text = Dismodels!.inform_detail;
    // remarkController.text = Dismodels!.inform_remark;
    loadActivegroupFromAPI();
  }

  Future<void> loadActivegroupFromAPI() async {
    String apiGetActiveGroup = '${MyConstant.domain}/dopa/api/getstatus.php';
    await Dio().get(apiGetActiveGroup).then((value) {
      //print('value ==> $value');
      var item = json.decode(value.data);

      setState(() {
        groupList = item;
      });
    });
    //print(poslist);
  }

  Future<void> processEdit() async {
    if (formKey.currentState!.validate()) {
      if (selecteValue == null) {
        MyDialog().normalDialog(
            context, 'กรุณากรอกข้อมูลให้ครบค่ะ!!!', 'เลือกประเภทด้วยค่ะ');
      } else {
        MyDialog().showProgressDialog(context);

        String remark = remarkController.text;

        String id = Dismodels!.inform_key;
        String cid = Dismodels!.cid;
        print('cid is $cid');
        String apiEditProduct =
            '${MyConstant.domain}/dopa/api/edit_informdis.php?isUpdate=true&id=$id&remark=$remark&status=$selecteValue';
        //await Dio().get(apiEditProduct).then((value) => Navigator.pop(context));

        print('## apiEditProduct ---> $apiEditProduct');

        await Dio().get(apiEditProduct).then((value) {
          Get.back();

          if (value.toString() == 'true') {
            print('## value is Success');

            sendnotitomember(cid);
          } else {
            print('false');
          }
        });
      }
    }
  }

  Future<void> processdel() async {
    MyDialog().showProgressDialog(context);

    String id = Dismodels!.inform_key;
    print(' id - $id');

    String apiEditProduct =
        '${MyConstant.domain}/dopa/api/del_informdis.php?isDelete=true&id=$id';
    await Dio().get(apiEditProduct).then((value) => Navigator.pop(context));
    Navigator.pop(context);
  }

  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลการแจ้งสาธารณภัย'),
        backgroundColor: MyConstant.primary,
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Form(
          key: formKey,
          child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              SizedBox(
                height: 10.0,
              ),
              Text(
                'ชื่อ : ${Dismodels!.inform_name} เบอร์โทร ${Dismodels!.inform_tel} ',
                style: MyConstant().h2Blacktyle(),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'รายละเอียด : ${Dismodels!.inform_detail}  ',
                style: MyConstant().h2Blacktyle(),
              ),
              ShowTitle(
                  title: 'ภาพถ่ายจุดเสี่ยง :',
                  textStyle: MyConstant().h2Style()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 16),
                    width: 200,
                    height: 200,
                    child: CachedNetworkImage(
                      imageUrl:
                          '${MyConstant.domain}/images/disaster/${Dismodels!.inform_images}',
                      placeholder: (context, url) => ShowProgress(),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              ShowTitle(title: 'Location :', textStyle: MyConstant().h2Style()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 16),
                    width: 300,
                    height: 300,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          double.parse('${Dismodels!.lat}'),
                          double.parse('${Dismodels!.lng}'),
                        ),
                        zoom: 16,
                      ),
                      markers: <Marker>{
                        Marker(
                            markerId: MarkerId('id'),
                            position: LatLng(
                              double.parse('${Dismodels!.lat}'),
                              double.parse('${Dismodels!.lng}'),
                            ),
                            infoWindow: InfoWindow(
                                title: 'คุณอยู่ที่นี่ ',
                                snippet:
                                    'lat = ${Dismodels!.lat}, lng = ${Dismodels!.lng}')),
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              ShowTitle(
                  title: 'สำหรับเจ้าหน้าที่ :',
                  textStyle: MyConstant().h2Style()),
              BuildRemark(),
              const SizedBox(
                height: 20.0,
              ),
              buildGroup(),
              const SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossFadeState,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        processEdit();
                      },
                      child: const Text(
                        'อับเดทข้อมูล',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: MyConstant().mygreenbutton(),
                    ),
                    const Padding(padding: EdgeInsets.all(10)),
                    ElevatedButton(
                      onPressed: () {
                        _dialogBuilder(context);
                      },
                      child: Text(
                        'ลบข้อมูล',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: MyConstant().myredbutton(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการลบข้อมูล'),
          content: const Text(
            'หากกดปุ่มยืนยันแล้วข้อมูลจะถูกลบจากฐานข้อมูล ไม่สามารถกู้ข้อมูลได้',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('ยืนยัน'),
              onPressed: () {
                processdel();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildGroup() {
    return Container(
      padding: EdgeInsets.all(5),
      child: DropdownButtonFormField(
          isExpanded: true,
          hint: Text('กรุณาระบุประเภท'),
          value: selecteValue,
          //validator: Validators.required('เลือกสถานะการแต่งงาน'),
          items: groupList.map((pos) {
            return DropdownMenuItem(
                value: pos['status_id'], child: Text(pos['status_name']));
            // print(pos['active_id']);
          }).toList(),
          onChanged: (value) {
            setState(() {
              selecteValue = value as String;

              // print(selecteValue);
            });
          }),
    );
  }

  Container BuildRemark() {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Color.fromRGBO(244, 243, 243, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: remarkController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอกรายละเอียด';
          } else {
            return null;
          }
        },
        maxLines: 4,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'กรุณากรอกรายละเอียด',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ),
    );
  }

  Future<void> sendnotitomember(String cid) async {
    String findtoken =
        '${MyConstant.domain}/dopa/api/getcidtoken.php?isAdd=true&cid=$cid';

    print('## findtoken = $findtoken');

    await Dio().get(findtoken).then((value) {
      //print('value is $value');
      var results = jsonDecode(value.data);
      print('## reult == $results');
      for (var element in results) {
        MemberModel model = MemberModel.fromMap(element);
        String? tokens = model.token;
        print('## token is $tokens');
        String titel = 'ข้อมูลคำขอของท่านการมีการอับเดท';
        String body = 'กรุณาดูข้อมูลที่เมนูสาธารณภัยด้วยค่ะ ';

        String sendtoken =
            '${MyConstant.domain}/dopa/api/apinoti.php?isAdd=true&title=$titel&body=$body&token=$tokens';

        print('## sentToken url ===> $sendtoken');

        sendfcmtomember(sendtoken);
      }
    });
  }

  Future<Null> sendfcmtomember(String sendtoken) async {
    await Dio().get(sendtoken).then((value) => Navigator.pop(context));
  }
}
