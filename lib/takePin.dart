
import 'dart:developer';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:nf_admin/catogory.dart';

class takePin extends StatelessWidget {

  TextEditingController pass_c = TextEditingController();
  String password="1010";
  @override
  Widget build(BuildContext context) {

    check(){
      if(pass_c.text==password)
      {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return categories();
        },));
      }
      else
      {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Enter Right Password")));
      }
    }
    double _h = MediaQuery.of(context).size.height;
    double _w = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Center(
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: _w*0.04,vertical: _h*0.2),
                decoration: BoxDecoration(color:Colors.green[50],
                borderRadius: BorderRadius.only(topLeft: Radius.circular(_w*0.1))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width * 0.8,
                      margin: EdgeInsets.all(MediaQuery.of(context).size.height * 0.03),
                      decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage("img/logo.jpeg"),fit: BoxFit.contain)
                      ),
                    ),

                    Text(
                      "N.F House",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: _w*0.064,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.08),
                          border: Border.all(color: Colors.green, width: 2),
                          borderRadius: BorderRadius.circular(14)),
                      child: TextField(
                        controller: pass_c,
                        keyboardType: TextInputType.number,
                        onChanged: (v) {},
                        // enableInteractiveSelection: false,
                        decoration: InputDecoration(
                          //  hintText: "Enter Password",
                          label: Text(
                            "Enter Password",
                            style: TextStyle(
                              color: Color(0xFF769854),
                            ),
                          ),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(_w*0.9, _h*0.06),
                            primary:Color(0xFF66814B), elevation: 0),
                        onPressed: () {
                          check();
                        },
                        child: Text("Submit")
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }



}
