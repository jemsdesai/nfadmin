import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nf_admin/server.dart';
import 'package:get/get.dart';

class addDesign extends StatefulWidget {
  String currCatogories, designCode, netRate, wholesaleRate;
  bool isEdit;

  addDesign(this.currCatogories, this.isEdit,
      [this.designCode = "", this.netRate = "", this.wholesaleRate = ""]);

  @override
  State<addDesign> createState() => _addDesignState();
}

class _addDesignState extends State<addDesign> {
  final netRate_tc = TextEditingController();
  final wholeRate_tc = TextEditingController();
  final designCode_tc = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    netRate_tc.text = widget.netRate;
    designCode_tc.text = widget.designCode;
    wholeRate_tc.text = widget.wholesaleRate;

  }

  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    double _h = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF516440),
        centerTitle: true,
        title: widget.isEdit
            ? Text("Edit Current Design")
            : Text("Add New Design"),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          margin:
          EdgeInsets.symmetric(vertical: _h * 0.02, horizontal: _w * 0.03),
          height: _h * 0.8,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Color(0xFFCDE8B6),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(_w * 0.1),
                  bottomRight: Radius.circular(_w * 0.1))),
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: _h * 0.04, horizontal: _w * 0.04),
            child: Column(
              children: [
                SizedBox(
                  height: _h * 0.06,
                  child: TextField(
                    controller: designCode_tc,
                    onChanged: (v) {},
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      label: Text(
                        "Design Code",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Color(0xFF516440), width: 2),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(_w * 0.05))),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Color(0xFF516440), width: 2),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(_w * 0.05),
                              bottomRight: Radius.circular(_w * 0.05))),
                      border: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Color(0xFF516440), width: 2),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(_w * 0.05),
                              bottomRight: Radius.circular(_w * 0.05))),
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(height: _h * 0.02),
                SizedBox(
                  height: _h * 0.06,
                  child: TextField(
                    controller: netRate_tc,
                    onChanged: (v) {},
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      label: Text(
                        "Net Rate",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Color(0xFF516440), width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Color(0xFF516440), width: 2),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(_w * 0.05),
                              bottomRight: Radius.circular(_w * 0.05))),
                      border: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Color(0xFF516440), width: 2),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(_w * 0.05),
                              bottomRight: Radius.circular(_w * 0.05))),
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(height: _h * 0.02),
                SizedBox(
                  height: _h * 0.06,
                  child: TextField(
                    controller: wholeRate_tc,
                    onChanged: (v) {},
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      label: Text(
                        "Deluxe Rate",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Color(0xFF516440), width: 2),
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(_w * 0.05))),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Color(0xFF516440), width: 2),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(_w * 0.05),
                              bottomRight: Radius.circular(_w * 0.05))),
                      border: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Color(0xFF516440), width: 2),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(_w * 0.05),
                              bottomRight: Radius.circular(_w * 0.05))),
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(height: _h * 0.08),
                Padding(
                  padding: EdgeInsets.all(_w * 0.02),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xFF516440),
                          minimumSize: Size(_w * 0.44, _h * 0.05)),
                      onPressed: () {
                        if (widget.isEdit) {
                          server.editDesign(
                              catNum: widget.currCatogories,
                              olddesign: widget.designCode,
                              oldnr: widget.netRate,
                              oldwr: widget.wholesaleRate,
                              newdesign: designCode_tc.text,
                              newnr: netRate_tc.text,
                              newwr: wholeRate_tc.text).then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.green,
                                content: Text(
                                  "Edited SuccessFully",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800),
                                )));
                            Get.back();
                          });
                        } else {
                          server
                              .addNewDesign(
                              catNum: widget.currCatogories,
                              designCode: designCode_tc.text,
                              nr: netRate_tc.text,
                              wr: wholeRate_tc.text)
                              .then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.green,
                                content: Text(
                                  "Product Added",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800),
                                )));
                            Get.back();
                          });
                        }
                      },
                      child: widget.isEdit
                          ? Text("Edit Design")
                          : Text("Add Design")),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
