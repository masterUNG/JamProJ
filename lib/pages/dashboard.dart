import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:pruksa/pages/appoint_his.dart';

import 'package:pruksa/pages/contact_his.dart';

import 'package:pruksa/pages/eservice.dart';
import 'package:pruksa/pages/informdam_his.dart';
import 'package:pruksa/pages/informdis_his.dart';
import 'package:pruksa/pages/informrisk_his.dart';
import 'package:pruksa/pages/news.dart';
import 'package:pruksa/pages/news_detail.dart';

import 'package:pruksa/pages/newspr.dart';
import 'package:pruksa/pages/redcross_his.dart';

import 'package:pruksa/utility/my_constant.dart';

import 'package:pruksa/wigets/show_progress.dart';
import 'package:pruksa/wigets/show_singout.dart';
import 'package:pruksa/wigets/show_titel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/news_model.dart';
import '../wigets/show_image.dart';
import 'about.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  final tabs = [
    Dashboard(),
    News(),
  ];
  String? nameuser;
  String? lastname;
  String? cid;
  bool load = true;
  bool? haveData;
  List<NewsModel> newsmodels = [];
  String? avatar;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    finduser();
    loadvaluefromapi();
    // initialFile();
  }

  Future<Null> finduser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameuser = preferences.getString('name');
      lastname = preferences.getString('lastname');
      avatar = preferences.getString('photo');
      cid = preferences.getString('cid');
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
        appBar: AppBar(
          // backgroundColor: Colors.transparent,
          backgroundColor: MyConstant.primary,
          elevation: 0,

          title: Text('อำเภอบ้านหลวง E-service',
              style: GoogleFonts.prompt(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications_none,
                color: Colors.white,
              ),
            )
          ],
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
                      // Navigator.pushNamed(context, MyConstant.routeAddActive);

                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Eservice()))
                          .then((value) => {});
                    },
                    child: Icon(
                      Icons.widgets,
                      size: 35.0,
                      color: Colors.pink,
                    ),
                  ),
                ),
                label: 'E-Service',
              ),
              BottomNavigationBarItem(
                icon: IconButton(
                  icon: const Icon(Icons.announcement),
                  iconSize: 30,
                  color: Colors.grey,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => NewsPr()));
                  },
                ),
                label: 'ประกาศ',
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
                          '${MyConstant.domain}/images/member/$avatar'),
                    ),
                    accountName: Text(nameuser == null
                        ? 'Name ?'
                        : ' คุณ $nameuser $lastname'),
                    accountEmail: Text(cid == null ? 'CID ?' : ' $cid ')),
                MenuAbout(),
              ],
            )
          ],
        )),
        body: SafeArea(
          child: ListView(
            children: [
              BuildTop(),
              Buildtitel(),
              const SizedBox(
                height: 15.0,
              ),
              GridView(physics: const ScrollPhysics(),shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 3 / 2,
                ),
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const InformHis()),
                      );
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          child: Image.asset('images/dopa.png'),
                          backgroundColor: MyConstant.dark,
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text('แจ้งจุดเสี่ยง')
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InformDisHis()),
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
                        Text('แจ้งสาธารณภัย')
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Informdamhis()),
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
                        Text('ร้องทุกข์ร้องเรียน')
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RedcrossHis()),
                      );
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          child: Image.asset('images/redcross.jpg'),
                          backgroundColor: MyConstant.dark,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text('งานกาดชาด')
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ContactHis()),
                      );
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          child: Image.asset('images/webboard.png'),
                          backgroundColor: MyConstant.dark,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text('ติดต่อสอบถาม')
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AppointHis()),
                      );
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          child: Image.asset('images/appoint.png'),
                          backgroundColor: MyConstant.dark,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text('จองคิว')
                      ],
                    ),
                  ),
                ],
              ),
              ListTile(
                title: Text(
                  'ข่าวกิจกรรม',
                  style: MyConstant().h1RedStyle(),
                ),
              ),
              BuildNews()
            ],
          ),
        ));
  }

  Padding Buildtitel() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'บริการของเรา',
            style: MyConstant().h1RedStyle(),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Eservice()),
              );
            },
            child: Text(
              'ดูทั้งหมด',
              style: MyConstant().h3RedStyle(),
            ),
          )
        ],
      ),
    );
  }

  Widget BuildNews() {
    return ListView.builder(
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        itemCount: newsmodels.length,
        itemBuilder: (context, index) => Card(
              elevation: 10.0,
              margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Container(
                decoration:
                    BoxDecoration(color: Color.fromRGBO(246, 242, 247, 0.894)),
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
                  title: Text('เรื่อง: ${newsmodels[index].news_name_th}'),
                  subtitle: Text('รายละเอียด'),
                  trailing: Icon(Icons.keyboard_arrow_right,
                      color: Color.fromARGB(255, 22, 22, 22), size: 30.0),
                ),
              ),
            )
        //
        );
  }

  ListTile MenuAbout() {
    return ListTile(
      onTap: () {
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => About()),
          );
        });
      },
      leading: Icon(Icons.ac_unit_outlined),
      title: ShowTitle(title: 'เกี่ยวกับโปรแกรม'),
      subtitle: ShowTitle(title: 'แสดงรายละเอียดเกี่ยวกับโปรแกรม'),
    );
  }

  ListTile MenuAllnew() {
    return ListTile(
      onTap: (() {
        setState(() {});
      }),
      leading: Icon(Icons.ac_unit_outlined),
      title: ShowTitle(title: 'เกี่ยวกับโปรแกรม'),
      subtitle: ShowTitle(title: 'แสดงรายละเอียดเกี่ยวกับโปรแกรม'),
    );
  }

  ListTile MenuUser() {
    return ListTile(
      onTap: (() {
        setState(() {});
      }),
      leading: Icon(Icons.account_box),
      title: ShowTitle(title: 'ข้อมูลผู้ใข้'),
      subtitle: ShowTitle(title: 'แสดงรายละเอียดผู้ใช้'),
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
                    text: 'คุณ $nameuser $lastname',
                    style: MyConstant().gh2WhiteStyle()),
              ])),
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white70, width: 2)),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                      '${MyConstant.domain}/images/member/$avatar'),
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
