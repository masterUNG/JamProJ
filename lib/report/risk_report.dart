import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pruksa/utility/app_controller.dart';
import 'package:pruksa/utility/app_service.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/wigets/show_titel.dart';

class RiskReport extends StatefulWidget {
  const RiskReport({Key? key}) : super(key: key);

  @override
  State<RiskReport> createState() => _RiskReportState();
}

class _RiskReportState extends State<RiskReport> {
  final formKey = GlobalKey<FormState>();
  TextEditingController sdateController = TextEditingController();
  TextEditingController edateController = TextEditingController();
  late Duration duration;
  late DateTime dateTime;

  final DateFormat formatted = DateFormat('yyyy-MM-dd');

  AppController appController = Get.put(AppController());

  Map<MarkerId, Marker> mapMarkers = {};

  @override
  void initState() {
    // TODO: implement initState

    dateTime = DateTime.now();
    duration = const Duration(minutes: 10);
    super.initState();

    if (appController.riskModels.isNotEmpty) {
      appController.riskModels.clear();
    }
    // initialFile();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('พิกัดจุดเสี่ยง'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: SingleChildScrollView(
            child: Center(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    ShowTitle(title: 'กรุณาเลือกวันที่ - ถึงวันที่'),
                    builddate(constraints),
                    buildenddate(constraints),
                    SizedBox(
                      height: 10,
                    ),
                    buildbutton(),
                    Obx(() {
                      return appController.riskModels.isEmpty
                          ? const SizedBox()
                          : Container(
                              margin: const EdgeInsets.all(16),
                              padding: const EdgeInsets.all(4),
                              width: Get.width,
                              height: Get.width,
                              decoration: BoxDecoration(border: Border.all()),
                              child: GoogleMap(
                                initialCameraPosition: CameraPosition(
                                    zoom: 16,
                                    target: LatLng(
                                        double.parse(appController
                                            .riskModels.last.lat
                                            .trim()),
                                        double.parse(appController
                                            .riskModels.last.lng
                                            .trim()))),
                                            markers: Set<Marker>.of(mapMarkers.values),
                              ),
                            );
                    }),
                  ],
                ),
              ),
            ),
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
          //uploadPictureAndInsertData();

          AppService().readAllRiskData().then((value) {
            if (appController.riskModels.isNotEmpty) {
              int i = 0;
              for (var element in appController.riskModels) {
                MarkerId markerId = MarkerId('id$i');
                i++;

                Marker marker = Marker(
                    markerId: markerId,
                    position: LatLng(double.parse(element.lat.trim()),
                        double.parse(element.lng.trim())));

                mapMarkers[markerId] = marker;
              }
            }
          });
        }
      },
      label: Text(
        "ดูข้อมูล",
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

  Widget builddate(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      margin: EdgeInsets.only(top: 16),
      child: TextFormField(
        controller: sdateController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอกข้อมูลวันที่';
          } else {
            return null;
          }
        },
        // keyboardType: TextInputType.datetime,
        onTap: () async {
          DateTime? newDateTime = await showRoundedDatePicker(
            context: context,

            theme: ThemeData(primarySwatch: Colors.pink),
            locale: Locale("th", "TH"),
            era: EraMode.BUDDHIST_YEAR,
            //initialDate: DateTime.now(),
            initialDate: DateTime.now(),
            firstDate: DateTime(DateTime.now().year - 1),
            lastDate: DateTime(DateTime.now().year + 1),
            borderRadius: 16,
          );
          print(newDateTime);
          if (newDateTime != null) {
            //setState(() => dateTime = newDateTime);
            setState(() => {
                  //final DateFormat formatted = DateFormat('yyyy-mm-dd');

                  dateTime = newDateTime,
                  // dateController.text = newDateTime.toString()
                  sdateController.text = formatted.format(newDateTime)
                });
          }
        },
        decoration: InputDecoration(
          labelStyle: MyConstant().h3Style(),
          labelText: 'เริ่มวันที่:',
          prefixIcon: Icon(
            Icons.date_range,
            color: MyConstant.dark,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.dark),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.light),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget buildenddate(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      margin: EdgeInsets.only(top: 16),
      child: TextFormField(
        controller: sdateController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอกข้อมูลวันที่';
          } else {
            return null;
          }
        },
        // keyboardType: TextInputType.datetime,
        onTap: () async {
          DateTime? newDateTime = await showRoundedDatePicker(
            context: context,

            theme: ThemeData(primarySwatch: Colors.pink),
            locale: Locale("th", "TH"),
            era: EraMode.BUDDHIST_YEAR,
            //initialDate: DateTime.now(),
            initialDate: DateTime.now(),
            firstDate: DateTime(DateTime.now().year - 1),
            lastDate: DateTime(DateTime.now().year + 1),
            borderRadius: 16,
          );
          print(newDateTime);
          if (newDateTime != null) {
            //setState(() => dateTime = newDateTime);
            setState(() => {
                  //final DateFormat formatted = DateFormat('yyyy-mm-dd');

                  dateTime = newDateTime,
                  // dateController.text = newDateTime.toString()
                  edateController.text = formatted.format(newDateTime)
                });
          }
        },
        decoration: InputDecoration(
          labelStyle: MyConstant().h3Style(),
          labelText: 'ถึงวันที่:',
          prefixIcon: Icon(
            Icons.date_range,
            color: MyConstant.dark,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.dark),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.light),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
