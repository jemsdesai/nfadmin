import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nf_admin/server.dart';
import 'package:image_picker/image_picker.dart';
import 'addProduct.dart';
import 'package:permission_handler/permission_handler.dart';
import 'main.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_cropper/image_cropper.dart';

class catalog extends StatefulWidget {
  String catName;
  int cat_index;

  catalog(this.catName, this.cat_index);

  @override
  State<catalog> createState() => _catalogState();
}

class _catalogState extends State<catalog> {
  final stc = Get.put(searchStatContraller());
  List data = [];
  List<String> suggetion = [];

  CroppedFile? _croppedFile;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateData();
  }



  updateData() async {
    data = await server.getProduct("${widget.cat_index + 1}");
    suggetion.clear();
    data.sort(
      (a, b) {
        int a1, b1;
        a1 = int.parse(a['id']);
        b1 = int.parse(b['id']);
        return a1.compareTo(b1);
      },
    );
    data.forEach((element) {
      suggetion.add(element['id']);
    });
  }

  getimage(bool ishide, int index1, int index) {
    if (!ishide) {
      return DecorationImage(
          image: CachedNetworkImageProvider(
        data[index]['clr'][index1]['imgUrl'],
      )); //NetworkImage(data[index]['clr'][index1]['imgUrl']));
    } else {
      log("${data[index]['clr'][index1]['imgUrl']}");
      return DecorationImage(image: AssetImage("img/logo.jpeg"));
    }
  }

  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    double _h = MediaQuery.of(context).size.height;
    bool rate = true;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xFF769854),
        centerTitle: true,
        title: Obx(() => stc.isSeachOn.value
            ? Padding(
                padding: EdgeInsets.only(top: _h * 0.01, bottom: _h * 0.01),
                child: TypeAheadField(
                    keepSuggestionsOnSuggestionSelected: false,
                    hideOnLoading: true,
                    hideOnEmpty: true,
                    suggestionsBoxDecoration:
                        SuggestionsBoxDecoration(color: Color(0xFF516440)),
                    textFieldConfiguration: TextFieldConfiguration(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: "Search Design",
                            hintStyle: TextStyle(color: Colors.white),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white, width: _w * 0.008),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(_w * 0.2))),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white, width: _w * 0.008),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(_w * 0.2))),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white, width: _w * 0.008),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(_w * 0.2))))),
                    hideSuggestionsOnKeyboardHide: false,
                    suggestionsCallback: (String qry) async {
                      List<String> result = [];
                      int i = 0;
                      suggetion.forEach((element) {
                        if (element.contains(qry)) {
                          result.add(element);
                          i++;
                        }
                      });
                      return result;
                    },
                    itemBuilder: (context, itemData) {
                      return SizedBox(
                        height: _h * 0.1,
                        width: _w * 0.9,
                        child: Card(
                          color: themeColor[4].withOpacity(0.7),
                          elevation: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Design Code -",
                                style: TextStyle(
                                    color: Colors.black, fontSize: _w * 0.04),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                width: _w * 0.03,
                              ),
                              Center(
                                  child: Text(
                                itemData,
                                style: TextStyle(
                                    color: Colors.white, fontSize: _w * 0.05),
                                textAlign: TextAlign.center,
                              )),
                            ],
                          ),
                        ),
                      );
                    },
                    onSuggestionSelected: (selected) {
                      int itemSelected = 0;
                      int i = 0;
                      data.forEach((element) {
                        if (element['id'].toString().contains(selected)) {
                          stc.selectedItem.value = i;
                          stc.isItemSelected.value = true;
                        }
                        i++;
                      });

                      log("${selected}");
                    }),
              )
            : Text("${widget.catName}")),
        actions: [
          Obx(() => stc.isSeachOn.value
              ? IconButton(
                  onPressed: () {
                    stc.isItemSelected.value = false;
                    stc.isSeachOn.value = false;
                  },
                  icon: Icon(Icons.close))
              : IconButton(
                  onPressed: () {
                    stc.isSeachOn.value = true;
                  },
                  icon: Icon(Icons.search)))
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF769854),
          child: Icon(
            Icons.add,
            size: _w * 0.07,
          ),
          onPressed: () {
            Get.to(() => addDesign((widget.cat_index + 1).toString(), false));
          }),
      body: RefreshIndicator(
        onRefresh: () {
          setState(() {
            updateData();
          });
          return Future.delayed(Duration(milliseconds: 5));
        },
        child: Obx(() => stc.isItemSelected.value
            ? Container(
                margin: EdgeInsets.symmetric(
                    vertical: _h * 0.005, horizontal: _w * 0.02),
                decoration: BoxDecoration(
                    color: themeColor[5].withOpacity(0.7),
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(_w * 0.1))),
                child: Column(
                  children: [
                    SizedBox(
                      height: _h * 0.038,
                      width: _w * 0.9,
                      child: Card(
                        color: themeColor[4].withOpacity(0.5),
                        elevation: 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Design Code -",
                              style: TextStyle(
                                  color: Colors.black, fontSize: _w * 0.04),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              width: _w * 0.03,
                            ),
                            Center(
                                child: Text(
                              data[stc.selectedItem.value]['id'],
                              style: TextStyle(
                                  color: Colors.white, fontSize: _w * 0.05),
                              textAlign: TextAlign.center,
                            )),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: themeColor[1],
                      thickness: 1.2,
                    ),
                    SizedBox(
                        height: _h * 0.08,
                        width: _w * 0.9,
                        child: ListView.builder(
                          itemCount:
                              (data[stc.selectedItem.value]['clr'] as List)
                                  .length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index1) {
                            bool isHide;
                            if (data[stc.selectedItem.value]['clr'][index1]
                                    ['imgUrl']
                                .toString()
                                .contains(">")) {
                              isHide = true;
                            } else {
                              isHide = false;
                            }
                            return InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(
                                        "Hide/Delete This Color ??",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      actions: [
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: Color(0xFF67834C),
                                                minimumSize: Size(
                                                    _w * 0.35, _h * 0.05)),
                                            onPressed: () {
                                              if (data[stc.selectedItem
                                                  .value]['clr']
                                              [index1]['imgUrl']
                                                  .toString()
                                                  .contains(">")) {
                                                isHide = true;
                                              } else {
                                                isHide = false;
                                              }

                                              String currPath =
                                                  "cat/cat_${widget.cat_index + 1}/${data[stc.selectedItem.value]['id']}/color_photo";
                                              String clrString =
                                                  "${data[stc.selectedItem.value]['clr'][index1]['clrId']}~${data[stc.selectedItem.value]['clr'][index1]['name']}~${data[stc.selectedItem.value]['clr'][index1]['imgUrl'].toString().replaceAll("${SERVER}/cat/cat_${widget.cat_index + 1}/${data[stc.selectedItem.value]['id']}/img/", "")}";
                                              log("${clrString}");
                                              if (isHide) {
                                                server
                                                    .hide_unhide(
                                                    currPath: currPath,
                                                    imgName: clrString,
                                                    task: "unhide")
                                                    .then((_) {
                                                  setState(() {});
                                                  Navigator.pop(context);
                                                });
                                              } else {
                                                server
                                                    .hide_unhide(
                                                    currPath: currPath,
                                                    imgName: clrString,
                                                    task: "hide")
                                                    .then((_) {
                                                  setState(() {});
                                                  Navigator.pop(context);
                                                });
                                              }
                                            },
                                            child: isHide?Text("Hide"):Text("Unhide")
                                        ),
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: Color(0xFF66814B),
                                                minimumSize: Size(
                                                    _w * 0.35, _h * 0.05)),
                                            onPressed: () {
                                              // String currPath =
                                              //     "cat/cat_${widget.cat_index + 1}/${data[stc.selectedItem.value]['id']}/color_photo";
                                              String clrString =
                                                  "cat/cat_${widget.cat_index + 1}/${data[stc.selectedItem.value]['id']}/color_photo/${data[stc.selectedItem.value]['clr'][index1]['clrId']}~${data[stc.selectedItem.value]['clr'][index1]['name']}~${data[stc.selectedItem.value]['clr'][index1]['imgUrl'].toString().replaceAll("${SERVER}/cat/cat_${widget.cat_index + 1}/${data[stc.selectedItem.value]['id']}/img/", "")}";
                                              log("${clrString}");

                                              server
                                                  .deleteDesign(clrString,data[stc.selectedItem.value]['clr'][index1]['imgUrl'])
                                                  .then((_) {
                                                setState(() {});
                                                Navigator.pop(context);
                                              });
                                            },
                                            child: Text("Delete"))
                                      ],
                                    ));
                              },
                              child: SizedBox(
                                width: _w * 0.2,
                                // height: _h*0.08,
                                child: GridTile(
                                  child: Container(
                                    // color:model.colorlist[int.parse(data[index]['clr'][index1]['index'])] ,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        //border: Border.all(color: Colors.green),
                                        image: getimage(isHide, index1,
                                            stc.selectedItem.value)),
                                    // child: SizedBox(height: _h*0.08,
                                  ),
                                  footer: Container(
                                      margin: EdgeInsets.all(_w * 0.003),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(_w * 0.02))),
                                      width: _w * 0.12,
                                      child: Text(
                                        data[stc.selectedItem.value]['clr']
                                        [index1]['name'],
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: _w * 0.028),
                                      )),
                                ),
                              ),
                            );
                          },
                        )),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(_w * 0.02),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: themeColor[0],
                                  minimumSize: Size(_w * 0.28, _h * 0.05)),
                              onPressed: () {
                                final ImagePicker _picker = ImagePicker();
                                XFile? image;
                                int n = -1;
                                bool t = false;
                                bool coloras = false;
                                String img_name = "";
                                String img_path = "";
                                TextEditingController t1 =
                                    TextEditingController();
                                //  var dio =Dio();
                                showCupertinoModalPopup(
                                  context: context,
                                  builder: (context2) => AlertDialog(
                                    title: Text(
                                      "Add new Photo",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color(0xFF769854),
                                          fontSize: _w * 0.07,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    content: StatefulBuilder(
                                      builder: (context, set1) {
                                        return SingleChildScrollView(
                                          child: SizedBox(
                                            height: _h * 0.5,
                                            child: Column(
                                              // mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: _h * 0.006,
                                                ),
                                                Column(
                                                  children: [
                                                    Container(
                                                      alignment: Alignment.center,
                                                      height: _h * 0.13,
                                                      width: _w * 0.4,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: _w * 0.01)),
                                                      child: (t == true)
                                                          ? Image.file(
                                                              File(img_path))
                                                          : Center(
                                                              child: TextButton(
                                                                  onPressed:
                                                                      () async {
                                                                    image = await _picker
                                                                        .pickImage(
                                                                            source:
                                                                                ImageSource.gallery);
                                                                    t = true;

                                                                    File file =
                                                                        File(image!
                                                                            .path);
                                                                    //  log("${result}");
                                                                    // img_name=base64.encode(result!);
                                                                    // log("${imageString}");

                                                                    img_path =
                                                                        image!.path;
                                                                    //   img_name = image!.name;
                                                                    File compresedImg=await customCompressed(imagePath: File(img_path));
                                                                    img_path=compresedImg.absolute.path;
                                                                    print(
                                                                        "img_path ====> $img_path");
                                                                    print(
                                                                        "img_name ====> $img_name");
                                                                    set1(() {});
                                                                  },
                                                                  child: Text(
                                                                    "Choose image",
                                                                    style: TextStyle(
                                                                        color: Color(
                                                                            0xFF769854),
                                                                        fontSize:
                                                                            _w *
                                                                                0.04,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold),
                                                                  )),
                                                            ),
                                                    ),
                                                    TextButton(onPressed: (){
                                                      _cropImage(image!).then((value) { set1((){img_path=value;});});
                                                    }, child: Text("EDIT"))
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: _h * 0.03,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: _h * 0.01,
                                                      bottom: _h * 0.01,
                                                      left: _w * 0.01,
                                                      right: _w * 0.01),
                                                  child: TextField(
                                                    decoration: InputDecoration(
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius: BorderRadius.only(
                                                              bottomRight: Radius
                                                                  .circular(_w *
                                                                      0.04),
                                                              topLeft: Radius
                                                                  .circular(_w *
                                                                      0.04)),
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xFF769854),
                                                              width:
                                                                  _w * 0.006),
                                                        ),
                                                        disabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius: BorderRadius.only(
                                                              bottomRight: Radius
                                                                  .circular(_w *
                                                                      0.04),
                                                              topLeft: Radius
                                                                  .circular(_w *
                                                                      0.04)),
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xFF769854),
                                                              width:
                                                                  _w * 0.006),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius: BorderRadius.only(
                                                              bottomRight: Radius
                                                                  .circular(_w *
                                                                      0.04),
                                                              topLeft: Radius
                                                                  .circular(_w *
                                                                      0.04)),
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xFF769854),
                                                              width:
                                                                  _w * 0.006),
                                                        ),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius: BorderRadius.only(
                                                              bottomRight: Radius
                                                                  .circular(_w *
                                                                      0.04),
                                                              topLeft: Radius
                                                                  .circular(_w *
                                                                      0.04)),
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xFF769854),
                                                              width: 2),
                                                        ),
                                                        hintText:
                                                            "Color Names"),
                                                    controller: t1,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: _h * 0.02,
                                                ),
                                                ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            primary: Color(
                                                                0xFF769854),
                                                            minimumSize: Size(
                                                                _w * 0.47,
                                                                _h * 0.055)),
                                                    onPressed: () async {
                                                      String clrName = t1.text;
                                                      int index_number = n;
                                                      String path_name =
                                                          "cat/cat_${widget.cat_index + 1}/${data[stc.selectedItem.value]['id']}/";
                                                      String id = ((data[stc
                                                                          .selectedItem
                                                                          .value]
                                                                      [
                                                                      'clr'] as List)
                                                                  .length +
                                                              1)
                                                          .toString();

                                                      server
                                                          .addColor(
                                                              path: path_name,
                                                              id: id,
                                                              img_path:_croppedFile!=null?_croppedFile!.path:img_path
                                                                  ,
                                                              name: clrName)
                                                          .then((_) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                              backgroundColor:
                                                                  Colors.green,
                                                              content: Text(
                                                                "Color Photo Added",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800),
                                                              )),
                                                        );
                                                        Navigator.pop(context2);
                                                        setState(() {});
                                                      });
                                                    },
                                                    child: Text("submit")),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: Text("Add Color")),
                        ),
                        Padding(
                          padding: EdgeInsets.all(_w * 0.02),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: themeColor[0],
                                  minimumSize: Size(_w * 0.28, _h * 0.05)),
                              onPressed: () {
                                stc.isSeachOn.value = false;
                                stc.isItemSelected.value = false;
                                Get.to(() => addDesign(
                                    (widget.cat_index + 1).toString(),
                                    true,
                                    data[stc.selectedItem.value]['id'],
                                    data[stc.selectedItem.value]['nr'],
                                    data[stc.selectedItem.value]['wr']));
                              },
                              child: Text("Edit")),
                        ),
                        Padding(
                          padding: EdgeInsets.all(_w * 0.02),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: themeColor[0],
                                  minimumSize: Size(_w * 0.28, _h * 0.05)),
                              onPressed: () {
                                bool isPressed = false;
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(
                                        builder: (context2, set) {
                                          return AlertDialog(
                                            title: Text(
                                              "Sure For Delete ??",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                            actions: [
                                              ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary:
                                                              Color(0xFF516440),
                                                          minimumSize: Size(
                                                              _w * 0.35,
                                                              _h * 0.05)),
                                                  onPressed: () {
                                                    if (!isPressed) {
                                                      server
                                                          .deleteDesign(
                                                              "cat/cat_${widget.cat_index + 1}/${data[stc.selectedItem.value]['id']}")
                                                          .then((_) {
                                                        setState(() {});
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                SnackBar(
                                                                    backgroundColor:
                                                                        Color(
                                                                            0xFFD2102C),
                                                                    content:
                                                                        Text(
                                                                      "Product Deleted",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontWeight:
                                                                              FontWeight.w800),
                                                                    )));
                                                      });

                                                      isPressed = true;
                                                      Navigator.pop(context2);
                                                    }
                                                  },
                                                  child: Text("Yes")),
                                              ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary:
                                                              Color(0xFF516440),
                                                          minimumSize: Size(
                                                              _w * 0.35,
                                                              _h * 0.05)),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("No"))
                                            ],
                                          );
                                        },
                                      );
                                    });
                              },
                              child: Text("Delete")),
                        )
                      ],
                    )
                  ],
                ),
              )
            : FutureBuilder(
                future: updateData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(
                                vertical: _h * 0.005, horizontal: _w * 0.02),
                            decoration: BoxDecoration(
                                color: themeColor[5].withOpacity(0.7),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(_w * 0.1))),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: _h * 0.038,
                                  width: _w * 0.9,
                                  child: Card(
                                    color: themeColor[4].withOpacity(0.5),
                                    elevation: 10,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Design Code -",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: _w * 0.04),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          width: _w * 0.03,
                                        ),
                                        Center(
                                            child: Text(
                                          data[index]['id'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: _w * 0.05),
                                          textAlign: TextAlign.center,
                                        )),
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(
                                  color: themeColor[1],
                                  thickness: 1.2,
                                ),
                                Container(
                                    height: _h * 0.08,
                                    width: _w * 0.9,
                                    child: ListView.builder(
                                      itemCount:
                                          (data[index]['clr'] as List).length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index1) {
                                        bool isHide;
                                        if (data[index]['clr'][index1]['imgUrl']
                                            .toString()
                                            .contains(">")) {
                                          isHide = true;
                                        } else {
                                          isHide = false;
                                        }
                                        return InkWell(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                      title: Text(
                                                        "Hide/Delete This Color ??",
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                      actions: [
                                                        ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                                primary: Color(
                                                                    0xFF67834C),
                                                                minimumSize: Size(
                                                                    _w * 0.35,
                                                                    _h * 0.05)),
                                                            onPressed: () {
                                                              if (data[index]['clr']
                                                                          [
                                                                          index1]
                                                                      ['imgUrl']
                                                                  .toString()
                                                                  .contains(
                                                                      ">")) {
                                                                isHide = true;
                                                              } else {
                                                                isHide = false;
                                                              }

                                                              String currPath =
                                                                  "cat/cat_${widget.cat_index + 1}/${data[index]['id']}/color_photo";
                                                              String clrString =
                                                                  "${data[index]['clr'][index1]['clrId']}~${data[index]['clr'][index1]['name']}~${data[index]['clr'][index1]['imgUrl'].toString().replaceAll("${SERVER}/cat/cat_${widget.cat_index + 1}/${data[index]['id']}/img/", "")}";
                                                              log("${clrString}");
                                                              if (isHide) {
                                                                server
                                                                    .hide_unhide(
                                                                        currPath:
                                                                            currPath,
                                                                        imgName:
                                                                            clrString,
                                                                        task:
                                                                            "unhide")
                                                                    .then((_) {
                                                                  setState(
                                                                      () {});
                                                                  Navigator.pop(
                                                                      context);
                                                                });
                                                              } else {
                                                                server
                                                                    .hide_unhide(
                                                                        currPath:
                                                                            currPath,
                                                                        imgName:
                                                                            clrString,
                                                                        task:
                                                                            "hide")
                                                                    .then((_) {
                                                                  setState(
                                                                      () {});
                                                                  Navigator.pop(
                                                                      context);
                                                                });
                                                              }
                                                            },
                                                            child: !isHide?Text("Hide"):Text("Unhide")),
                                                        ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                                primary: Color(
                                                                    0xFF66814B),
                                                                minimumSize: Size(
                                                                    _w * 0.35,
                                                                    _h * 0.05)),
                                                            onPressed: () {
                                                              //     "cat/cat_${widget.cat_index + 1}/${data[stc.selectedItem.value]['id']}/color_photo";
                                                              String clrString =
                                                                  "cat/cat_${widget.cat_index + 1}/${data[index]['id']}/color_photo/${data[index]['clr'][index1]['clrId']}~${data[index]['clr'][index1]['name']}~${data[index]['clr'][index1]['imgUrl'].toString().replaceAll("${SERVER}/cat/cat_${widget.cat_index + 1}/${data[index]['id']}/img/", "")}";
                                                              log("${clrString}");

                                                              server
                                                                  .deleteDesign(clrString,data[index]['clr'][index1]['imgUrl'])
                                                                  .then((_) {
                                                                setState(() {});
                                                                Navigator.pop(context);
                                                              });
                                                            },
                                                            child: Text("Delete"))
                                                      ],
                                                    ));
                                          },
                                          child: SizedBox(
                                            width: _w * 0.2,
                                            // height: _h*0.08,
                                            child: GridTile(
                                              child: Container(
                                                // color:model.colorlist[int.parse(data[index]['clr'][index1]['index'])] ,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: getimage(
                                                        isHide, index1, index)),
                                                // child: SizedBox(height: _h*0.08,
                                              ),
                                              footer: Container(
                                                  margin: EdgeInsets.all(
                                                      _w * 0.003),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  _w * 0.02))),
                                                  width: _w * 0.12,
                                                  child: Text(
                                                    data[index]['clr'][index1]
                                                        ['name'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: _w * 0.028),
                                                  )),
                                            ),
                                          ),
                                        );
                                      },
                                    )),
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(_w * 0.02),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: themeColor[0],
                                              minimumSize: Size(_w * 0.28, _h * 0.05)),
                                          onPressed: () {
                                            final ImagePicker _picker = ImagePicker();
                                            XFile? image;
                                            int n = -1;
                                            bool t = false;
                                            bool coloras = false;
                                            String img_name = "";
                                            String img_path = "";
                                            TextEditingController t1 =
                                            TextEditingController();
                                            //  var dio =Dio();
                                            showCupertinoModalPopup(
                                              context: context,
                                              builder: (context2) => AlertDialog(
                                                title: Text(
                                                  "Add new Photo",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Color(0xFF769854),
                                                      fontSize: _w * 0.07,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                content: StatefulBuilder(
                                                  builder: (context, set1) {
                                                    return SingleChildScrollView(
                                                      child: SizedBox(
                                                        height: _h * 0.5,
                                                        child: Column(
                                                          // mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            SizedBox(
                                                              height: _h * 0.006,
                                                            ),
                                                            Column(
                                                              children: [
                                                                Container(
                                                                  alignment: Alignment.center,
                                                                  height: _h * 0.13,
                                                                  width: _w * 0.4,
                                                                  decoration: BoxDecoration(
                                                                      border: Border.all(
                                                                          width: _w * 0.01)),
                                                                  child: (t == true)
                                                                      ? Image.file(
                                                                      File(img_path))
                                                                      : Center(
                                                                    child: TextButton(
                                                                        onPressed:
                                                                            () async {
                                                                          image = await _picker
                                                                              .pickImage(
                                                                              source:
                                                                              ImageSource.gallery);
                                                                          t = true;

                                                                          File file =
                                                                          File(image!
                                                                              .path);
                                                                          //  log("${result}");
                                                                          // img_name=base64.encode(result!);
                                                                          // log("${imageString}");

                                                                          img_path =
                                                                              image!.path;
                                                                          //   img_name = image!.name;
                                                                          File compresedImg=await customCompressed(imagePath: File(img_path));
                                                                          img_path=compresedImg.absolute.path;
                                                                          print(
                                                                              "img_path ====> $img_path");
                                                                          print(
                                                                              "img_name ====> $img_name");
                                                                          set1(() {});
                                                                        },
                                                                        child: Text(
                                                                          "Choose image",
                                                                          style: TextStyle(
                                                                              color: Color(
                                                                                  0xFF769854),
                                                                              fontSize:
                                                                              _w *
                                                                                  0.04,
                                                                              fontWeight:
                                                                              FontWeight
                                                                                  .bold),
                                                                        )),
                                                                  ),
                                                                ),
                                                                TextButton(onPressed: (){
                                                                  _cropImage(image!).then((value) { set1((){img_path=value;});});
                                                                }, child: Text("EDIT"))
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: _h * 0.03,
                                                            ),
                                                            Padding(
                                                              padding: EdgeInsets.only(
                                                                  top: _h * 0.01,
                                                                  bottom: _h * 0.01,
                                                                  left: _w * 0.01,
                                                                  right: _w * 0.01),
                                                              child: TextField(
                                                                decoration: InputDecoration(
                                                                    enabledBorder:
                                                                    OutlineInputBorder(
                                                                      borderRadius: BorderRadius.only(
                                                                          bottomRight: Radius
                                                                              .circular(_w *
                                                                              0.04),
                                                                          topLeft: Radius
                                                                              .circular(_w *
                                                                              0.04)),
                                                                      borderSide: BorderSide(
                                                                          color: Color(
                                                                              0xFF769854),
                                                                          width:
                                                                          _w * 0.006),
                                                                    ),
                                                                    disabledBorder:
                                                                    OutlineInputBorder(
                                                                      borderRadius: BorderRadius.only(
                                                                          bottomRight: Radius
                                                                              .circular(_w *
                                                                              0.04),
                                                                          topLeft: Radius
                                                                              .circular(_w *
                                                                              0.04)),
                                                                      borderSide: BorderSide(
                                                                          color: Color(
                                                                              0xFF769854),
                                                                          width:
                                                                          _w * 0.006),
                                                                    ),
                                                                    focusedBorder:
                                                                    OutlineInputBorder(
                                                                      borderRadius: BorderRadius.only(
                                                                          bottomRight: Radius
                                                                              .circular(_w *
                                                                              0.04),
                                                                          topLeft: Radius
                                                                              .circular(_w *
                                                                              0.04)),
                                                                      borderSide: BorderSide(
                                                                          color: Color(
                                                                              0xFF769854),
                                                                          width:
                                                                          _w * 0.006),
                                                                    ),
                                                                    border:
                                                                    OutlineInputBorder(
                                                                      borderRadius: BorderRadius.only(
                                                                          bottomRight: Radius
                                                                              .circular(_w *
                                                                              0.04),
                                                                          topLeft: Radius
                                                                              .circular(_w *
                                                                              0.04)),
                                                                      borderSide: BorderSide(
                                                                          color: Color(
                                                                              0xFF769854),
                                                                          width: 2),
                                                                    ),
                                                                    hintText:
                                                                    "Color Names"),
                                                                controller: t1,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: _h * 0.02,
                                                            ),
                                                            ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                    primary: Color(
                                                                        0xFF769854),
                                                                    minimumSize: Size(
                                                                        _w * 0.47,
                                                                        _h * 0.055)),
                                                                onPressed: () async {
                                                                  String clrName = t1.text;
                                                                  int index_number = n;
                                                                  String path_name =
                                                                      "cat/cat_${widget.cat_index + 1}/${data[index]['id']}/";
                                                                  String id = ((data[stc
                                                                      .selectedItem
                                                                      .value]
                                                                  [
                                                                  'clr'] as List)
                                                                      .length +
                                                                      1)
                                                                      .toString();

                                                                  server
                                                                      .addColor(
                                                                      path: path_name,
                                                                      id: id,
                                                                      img_path:_croppedFile!=null?_croppedFile!.path:img_path
                                                                      ,
                                                                      name: clrName)
                                                                      .then((_) {
                                                                    ScaffoldMessenger.of(
                                                                        context)
                                                                        .showSnackBar(
                                                                      SnackBar(
                                                                          backgroundColor:
                                                                          Colors.green,
                                                                          content: Text(
                                                                            "Color Photo Added",
                                                                            style: TextStyle(
                                                                                color: Colors
                                                                                    .white,
                                                                                fontWeight:
                                                                                FontWeight
                                                                                    .w800),
                                                                          )),
                                                                    );
                                                                    Navigator.pop(context2);
                                                                    setState(() {});
                                                                  });
                                                                },
                                                                child: Text("submit")),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            );
                                          },
                                          child: Text("Add Color")),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(_w * 0.02),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: themeColor[0],
                                              minimumSize: Size(_w * 0.28, _h * 0.05)),
                                          onPressed: () {
                                            stc.isSeachOn.value = false;
                                            stc.isItemSelected.value = false;
                                            Get.to(() => addDesign(
                                                (widget.cat_index + 1).toString(),
                                                true,
                                                data[stc.selectedItem.value]['id'],
                                                data[stc.selectedItem.value]['nr'],
                                                data[stc.selectedItem.value]['wr']));
                                          },
                                          child: Text("Edit")),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(_w * 0.02),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: themeColor[0],
                                              minimumSize: Size(_w * 0.28, _h * 0.05)),
                                          onPressed: () {
                                            bool isPressed = false;
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return StatefulBuilder(
                                                    builder: (context2, set) {
                                                      return AlertDialog(
                                                        title: Text(
                                                          "Sure For Delete ??",
                                                          style:
                                                          TextStyle(color: Colors.red),
                                                        ),
                                                        actions: [
                                                          ElevatedButton(
                                                              style:
                                                              ElevatedButton.styleFrom(
                                                                  primary:
                                                                  Color(0xFF516440),
                                                                  minimumSize: Size(
                                                                      _w * 0.35,
                                                                      _h * 0.05)),
                                                              onPressed: () {
                                                                if (!isPressed) {
                                                                  server
                                                                      .deleteDesign(
                                                                      "cat/cat_${widget.cat_index + 1}/${data[index]['id']}")
                                                                      .then((_) {
                                                                    setState(() {});
                                                                    ScaffoldMessenger.of(
                                                                        context)
                                                                        .showSnackBar(
                                                                        SnackBar(
                                                                            backgroundColor:
                                                                            Color(
                                                                                0xFFD2102C),
                                                                            content:
                                                                            Text(
                                                                              "Product Deleted",
                                                                              style: TextStyle(
                                                                                  color: Colors
                                                                                      .white,
                                                                                  fontWeight:
                                                                                  FontWeight.w800),
                                                                            )));
                                                                  });

                                                                  isPressed = true;
                                                                  Navigator.pop(context2);
                                                                }
                                                              },
                                                              child: Text("Yes")),
                                                          ElevatedButton(
                                                              style:
                                                              ElevatedButton.styleFrom(
                                                                  primary:
                                                                  Color(0xFF516440),
                                                                  minimumSize: Size(
                                                                      _w * 0.35,
                                                                      _h * 0.05)),
                                                              onPressed: () {
                                                                Navigator.pop(context);
                                                              },
                                                              child: Text("No"))
                                                        ],
                                                      );
                                                    },
                                                  );
                                                });
                                          },
                                          child: Text("Delete")),
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => Divider(
                              color: themeColor[1],
                            ),
                        itemCount: data.length);
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF769854),
                      ),
                    );
                  }
                },
              )),
      ),
    );



  }

  Future<File> customCompressed({
    @required File? imagePath,
  }) async {
    var path=await FlutterNativeImage.compressImage(
        imagePath!.absolute.path,
        quality: 100,
        percentage: 50
    );
    return path;
  }
  Future<String> _cropImage(XFile _pickedFile) async {
    if (_pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Color(0xFF769854),
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
            presentStyle: CropperPresentStyle.dialog,
            boundary: const CroppieBoundary(
              width: 520,
              height: 520,
            ),
            viewPort:
            const CroppieViewPort(width: 480, height: 480, type: 'circle'),
            enableExif: true,
            enableZoom: true,
            showZoomer: true,
          ),
        ],
      );
      if (croppedFile != null) {
          _croppedFile = croppedFile;
      }
    }
    return _croppedFile!.path;
  }

  List<Color> themeColor = [
    Color(0xFF516440),
    Color(0xFF769854),
    Colors.green,
    Color(0xFFAFC59C),
    Color(0xFFD5ECBF),
    Color(0xFFD3EABE),
    Color(0xFF506C32)
  ];
}

class searchStatContraller extends GetxController {
  RxBool isSeachOn = false.obs;
  RxBool isItemSelected = false.obs;
  RxInt selectedItem = 0.obs;
  RxBool isImagePicked=false.obs;
}
