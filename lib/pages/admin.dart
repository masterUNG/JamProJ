import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pruksa/models/news_model.dart';
import 'package:pruksa/pages/adminmenu.dart';
import 'package:pruksa/pages/damrong_all.dart';
import 'package:pruksa/pages/disaster_all.dart';
import 'package:pruksa/pages/faq_his.dart';
import 'package:pruksa/pages/inform_news.dart';
import 'package:pruksa/pages/informrisk_all.dart';
import 'package:pruksa/pages/member_list.dart';
import 'package:pruksa/pages/newpr_list.dart';
import 'package:pruksa/pages/news.dart';
import 'package:pruksa/pages/news_detail.dart';
import 'package:pruksa/pages/newspr.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/wigets/show_image.dart';
import 'package:pruksa/wigets/show_progress.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../wigets/show_singout.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  var height, width;

  String? nameuser;
  String? fullname;
  String? posname;
  String? avatar;
  bool load = true;
  bool? haveData;
  List<NewsModel> newsmodels = [];
  int _selectedIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadvaluefromapi();
    finduser();
    // initialFile();
  }

  Future<Null> finduser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameuser = preferences.getString('name');
      fullname = preferences.getString('fullname');
      avatar = preferences.getString('user_photo');
      posname = preferences.getString('posname');
    });
  }

  Future<Null> loadvaluefromapi() async {
    if (newsmodels.length != 0) {
      newsmodels.clear();
    } else {}

    String apigetactivelist =
        '${MyConstant.domain}/dopa/api/getnews.php?isAdd=true';
    await Dio().get(apigetactivelist).then((value) {
      // print('value ==> $value');
      // print('value ==> $id');
      if (value.toString() == 'null') {
        // No Data
        setState(() {
          load = false;
          haveData = false;
        });
      } else {
        for (var item in json.decode(value.data)) {
          NewsModel model = NewsModel.fromMap(item);
          //print('name of titel =${model.titel}');

          setState(() {
            load = false;
            haveData = true;
            newsmodels.add(model);
          });
        }
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: mainAppBar(),
        body: SafeArea(
          child: ListView(
            children: [
              BuildTop(),
              const SizedBox(
                height: 15.0,
              ),
              Buildtitel(),
              const SizedBox(
                height: 15.0,
              ),
              gridGroup(context),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Text(
                      'ข่าวล่าสุด',
                      style: MyConstant().h1blackStyle(),
                    )
                  ],
                ),
              ),
              BuildNews(),
            ],
          ),
        ),
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            items: [
              BottomNavigationBarItem(
                icon: IconButton(
                  icon: const Icon(Icons.home),
                  iconSize: 30,
                  color: Colors.grey,
                  onPressed: () {},
                ),
                label: 'หน้าหลัก',
              ),
              BottomNavigationBarItem(
                icon: IconButton(
                  icon: const Icon(Icons.newspaper),
                  iconSize: 30,
                  color: Colors.grey,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => News()));
                  },
                ),
                label: 'ข่าวกิจกรรม',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.pink,
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AdminMenu()));
                    },
                    child: Icon(
                      Icons.widgets,
                      size: 35.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                label: 'บริการทั้งหมด',
              ),
              BottomNavigationBarItem(
                icon: IconButton(
                  icon: const Icon(Icons.supervised_user_circle_sharp),
                  iconSize: 30,
                  color: Colors.grey,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MemberList()));
                  },
                ),
                label: 'สมาชิก',
              ),
              BottomNavigationBarItem(
                icon: IconButton(
                  icon: const Icon(Icons.phone_enabled),
                  tooltip: 'ติดต่ออำเภอ',
                  iconSize: 30,
                  color: Colors.grey,
                  onPressed: () async {
                    Uri phoneno = Uri.parse('tel:054761044');
                    if (await launchUrl(phoneno)) {
                      //dialer opened
                    } else {
                      //dailer is not opened
                    }
                  },
                ),
                label: 'โทร',
              ),
            ],
          ),
        ),
        drawer: Drawer(
          child: Stack(
            children: [
              ShowSignOut(),
              Column(
                children: [
                  UserAccountsDrawerHeader(
                      otherAccountsPictures: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.face_outlined),
                          iconSize: 36,
                          color: MyConstant.light,
                          tooltip: 'Edit Shop',
                        ),
                      ],
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [MyConstant.light, MyConstant.dark],
                          center: Alignment(-0.8, -0.2),
                          radius: 1,
                        ),
                      ),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage: NetworkImage(
                            '${MyConstant.domain}/dopa/resource/users/images/$avatar'),
                      ),
                      accountName:
                          Text(nameuser == null ? 'Name ?' : ' $fullname '),
                      accountEmail:
                          Text(posname == null ? 'Type ?' : ' $posname ')),

                  // ShowMenu(),
                  // ShowProduct()
                ],
              ),
            ],
          ),
        ));
  }

  GridView gridGroup(BuildContext context) {
    return GridView(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, childAspectRatio: 3 / 2),
              children: [
                Buildrisk(context),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DisasterAll()),
                    );
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        child: Image.asset('images/disaster.jpg'),
                        backgroundColor: MyConstant.dark,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text('ข้อมูลสาธารณภัย')
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DamrongAll()),
                    );
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        child: Image.asset('images/damrong.jpg'),
                        backgroundColor: MyConstant.dark,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text('ข้อมูลร้องทุกข์ร้องเรียน')
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InfromNews()),
                    );
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        child: Image.asset('images/news.png'),
                        backgroundColor: MyConstant.dark,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text('ประชาสัมพันธ์')
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NewPrList()),
                    );
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        child: Image.asset('images/pr.png'),
                        backgroundColor: MyConstant.dark,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text('ประกาศ')
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FaqHis()),
                    );
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        child: Image.asset('images/faq.png'),
                        backgroundColor: MyConstant.dark,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text('คำถามที่พบบ่อย')
                    ],
                  ),
                ),
              ],
            );
  }

  AppBar mainAppBar() {
    return AppBar(
      // backgroundColor: Colors.transparent,
      backgroundColor: MyConstant.primary,
      elevation: 0,

      title: Text('P(Pruksa) Project'),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.notifications_none,
            color: Colors.white,
          ),
        )
      ],
    );
  }

  InkWell Buildrisk(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InformRiskAll()),
        );
      },
      child: Column(
        children: [
          CircleAvatar(
            child: Image.asset('images/dopa.png'),
            backgroundColor: MyConstant.dark,
          ),
          SizedBox(
            height: 10.0,
          ),
          Text('ข้อมูลจุดเสี่ยง')
        ],
      ),
    );
  }

  Padding Buildtitel() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'หมวดหมู่',
            style: MyConstant().h1RedStyle(),
          ),
          Text(
            'ดูทั้งหมด',
            style: MyConstant().h3RedStyle(),
          )
        ],
      ),
    );
  }

  Widget BuildNews() {
    return ListView.builder(physics: const ScrollPhysics(),
        shrinkWrap: true,
        itemCount: newsmodels.length,
        itemBuilder: (context, index) => Card(
              elevation: 10.0,
              margin:
                  new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromRGBO(246, 242, 247, 0.894)),
                child: ListTile(
                  onTap: () {
                    print('## You Click Edit');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewsDetail(
                            newsModel: newsmodels[index],
                          ),
                        )).then((value) => loadvaluefromapi());
                  },
                  leading: Container(
                    width: 60,
                    height: 60,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl:
                          ('${MyConstant.domain}/images/news/${newsmodels[index].news_cover}'),
                      placeholder: (context, url) => ShowProgress(),
                      errorWidget: (context, url, error) =>
                          ShowImage(path: MyConstant.imgdopa),
                    ),
                  ),
                  title: Text('เรื่อง:${newsmodels[index].news_name_th}'),
                  subtitle: Text('รายละเอียด'),
                  trailing: Icon(Icons.keyboard_arrow_right,
                      color: Color.fromARGB(255, 22, 22, 22), size: 30.0),
                ),
              ),
            )
        //
        );
  }

  Container BuildTop() {
    return Container(
      padding: EdgeInsets.only(top: 40, left: 15, right: 15, bottom: 20),
      decoration: BoxDecoration(
          color: MyConstant.primary,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          )),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                  text: TextSpan(children: [
                TextSpan(text: 'สวัสดี'),
                TextSpan(
                    text: 'คุณ $nameuser ', style: MyConstant().h2WhiteStyle()),
              ])),
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white70, width: 2)),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      '${MyConstant.domain}/dopa/resource/users/images/$avatar'),
                  radius: 30,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
