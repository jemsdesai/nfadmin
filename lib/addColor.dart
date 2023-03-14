import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'colorModel.dart';

class add_product extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  int n = 0;
  bool t = false;
  bool coloras = false;
  String img_name = "";
  String img_path = "";
  TextEditingController t1 = TextEditingController();
  var dio =Dio();
  @override
  Widget build(BuildContext context) {
    double _h = MediaQuery.of(context).size.height;
    double _w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[100],
      ),
      body: Center(
          child: InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      "Add new Color",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.purple,
                          fontSize: _w * 0.07,
                          fontWeight: FontWeight.bold),
                    ),
                    content: SingleChildScrollView(
                      child: SizedBox(
                        height: _h * 0.5,
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: _h * 0.006,
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: _h * 0.13,
                              width: _w * 0.28,
                              decoration: BoxDecoration(
                                  border: Border.all(width: _w * 0.01)),
                              child: (t == true)
                                  ? Image.file(File(image!.path))
                                  : Center(
                                child: TextButton(
                                    onPressed: () async {
                                      image = await _picker.pickImage(
                                          source: ImageSource.gallery);
                                      t = true;
                                      img_path = image!.path;
                                      img_name = image!.name;
                                      print("img_path ====> $img_path");
                                      print("img_name ====> $img_name");
                                    },
                                    child: Text(
                                      "Choose image",
                                      style: TextStyle(
                                          color: Colors.purple,
                                          fontSize: _w * 0.04,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ),
                            ),
                            SizedBox(
                              height: _h * 0.03,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: (n == 0)
                                    ? Colors.purple[100]
                                    : model.colorlist[n],
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(_w * 0.05),
                                  topLeft: Radius.circular(_w * 0.05),
                                ),
                              ),
                              child: ExpansionTile(
                                title: Text("select"),
                                children: [
                                  SingleChildScrollView(
                                    child: SizedBox(
                                      height: _h * 0.08,
                                      width: _w * 0.6,
                                      child: GridView.builder(
                                        itemCount: model.colorlist.length,
                                        gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 6,
                                            mainAxisSpacing: 3,
                                            crossAxisSpacing: 3),
                                        itemBuilder: (context, index) {
                                          return Column(
                                            children: [
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    n = index;
                                                    print(n);
                                                  },
                                                  child: Container(
                                                    height: _h * 0.1,
                                                    width: _w * 0.1,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: _w * 0.008,
                                                          color: Colors.black),
                                                      color: model.colorlist[index],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: _h * 0.01,
                                  bottom: _h * 0.01,
                                  left: _w * 0.01,
                                  right: _w * 0.01),
                              child: TextField(
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(_w * 0.04),
                                          topLeft: Radius.circular(_w * 0.04)),
                                      borderSide: BorderSide(
                                          color: Colors.purple, width: _w * 0.006),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(_w * 0.04),
                                          topLeft: Radius.circular(_w * 0.04)),
                                      borderSide: BorderSide(
                                          color: Colors.purple, width: _w * 0.006),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(_w * 0.04),
                                          topLeft: Radius.circular(_w * 0.04)),
                                      borderSide: BorderSide(
                                          color: Colors.purple, width: _w * 0.006),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(_w * 0.04),
                                          topLeft: Radius.circular(_w * 0.04)),
                                      borderSide: BorderSide(
                                          color: Colors.purple, width: 2),
                                    ),
                                    hintText: "Color Names"),
                                controller: t1,
                              ),
                            ),
                            SizedBox(
                              height: _h * 0.02,
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.purple[300],
                                    minimumSize: Size(_w * 0.47, _h * 0.055)),
                                onPressed: () async {
                                  String str1 = t1.text;
                                  String name_of_image = img_name;
                                  int index_number = n;
                                  String path_name = "cat/cat_2/3232424/color_photo";

                                  // var formData = FormData.fromMap({
                                  //   'image' : await MultipartFile.fromBytes(img_path), 'pramuKhIde'
                                  // });

                                  var response = await dio.get("https://nfhouse.pubfire.net/addColor.php?path=${path_name}&id=1&index=${index_number}&name=${str1}&image_url=${name_of_image}");

                                  print("response ======> $response");
                                },
                                child: Text("submit")),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: Container(
              height: 100,
              width: 100,
              color: Colors.purple,
            ),
          )),
    );
  }
}
