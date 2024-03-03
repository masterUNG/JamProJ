import 'package:flutter/material.dart';
import 'package:pruksa/report/act_report.dart';
import 'package:pruksa/report/risk_report.dart';
import 'package:pruksa/wigets/menu_item.dart';

class ActiveMenu extends StatelessWidget {
  const ActiveMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ระบบงานกำนัน ผู้ใหญ่บ้าน ฯ'),
      ),
      body: Container(
        decoration: BoxDecoration(),
        padding: EdgeInsets.all(10),
        child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 20, mainAxisSpacing: 30),
          children: [
            MenuItem(
                imagepath: 'images/report.png',
                titel: 'แยกรายเดือน',
                onTap: (() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ActiveReportMount()),
                  );
                })),
            MenuItem(
                imagepath: 'images/dopa.png',
                titel: 'รายงานจุดเสี่ยง',
                onTap:  (() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RiskReport()),
                  );
                }))
          ],
        ),
      ),
    );
  }
}