import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nf_admin/catalog.dart';
import 'package:nf_admin/server.dart';



class categories extends StatefulWidget {
  const categories({Key? key}) : super(key: key);

  @override
  State<categories> createState() => _categoriesState();
}

class _categoriesState extends State<categories> {

  List<String> catName=[
    """𝐁𝐫𝐢𝐝𝐚𝐥""",
    """𝐁𝐫𝐢𝐝𝐚𝐥 𝐋𝐢𝐭𝐞""",
    """𝐅𝐚𝐧𝐜𝐲""",
    """𝐆𝐨𝐭𝐚 𝐏𝐚𝐭𝐭𝐢""",
  ];

  List<String>catImagePath=[
    "img/nflogo1.jpeg",
    "img/nflogo1.jpeg",
    "img/nflogo1.jpeg",
    "img/nflogo1.jpeg",
  ];

  List<Color>themeColor=[
    Color(0xFF516440),
    Color(0xFF769854),
    Colors.green,
    Color(0xFFAFC59C),
    Color(0xFFD5ECBF),
    Color(0xFFD3EABE),
    Color(0xFF506C32)
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    double _w=MediaQuery.of(context).size.width;
    double _h=MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF506C32),
        centerTitle: true,
        title: Text("𝐂𝐚𝐭𝐞𝐠𝐨𝐫𝐢𝐞𝐬"),
      ),
      body: ListView.separated(

          padding: EdgeInsets.symmetric(vertical: _h*0.01,horizontal: _w*0.03),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Get.to(()=>catalog(catName[index],index));
              },
              child:
              Container(
                height: _h*0.14,
                width: _w*0.9,
                padding: EdgeInsets.all(_w*0.03),
                decoration: BoxDecoration(
                    color:themeColor[5],
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(_w*0.1),bottomRight: Radius.circular(_w*0.1))
                ),
                child: Row(
                  children: [
                    SizedBox(
                      height: _h*0.12,
                      width: _w*0.30,
                      child: Image(image: AssetImage(catImagePath[index])),
                    ),
                    Center(
                      child: Text(catName[index],style: TextStyle(fontSize: _w*0.08,color: themeColor[0]),),
                    ),
                  ],
                ),
              ),
            );
          }, separatorBuilder: (context, index) => Divider(color: themeColor[1],thickness: 1.2,), itemCount: catName.length),
    );
  }
}

