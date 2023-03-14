

import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:nf_admin/main.dart';
class server {


  /*
  * =[
  *     {
  *        id:3299jdj,
  *        nr:1500,
  *        wr:1200,
  *        color:[
  *                   {
  *                      clr_ind:3
  *                      clr_name:red
  *                      image_url:
  *                   },
  *               ]
  *
  *     }
  *   ]
  * */
  static Future getProduct(String catNum)async{
    Map allProduct={};
    String allProductString="";
    var dio=Dio();

    String res=await dio.get("https://nfhouse.pubfire.net/getProduct.php?cat_id=$catNum").then((value) => value.data.toString());
   //  log("$res");
    allProductString=res;

    return decodeFullProduct(catNum,allProductString);
  }

  static decodeFullProduct(String catNum,String allProductString){
    final dio=Dio();
    List<String> designString=[];
    List designDetailsList=[];
    List productMap=[];
    designString=allProductString.split("》"); designString.removeLast();
    designString.forEach((element) {
      List<String> d=element.split("\$");
      List<String> d2=[];
      List<List<String>> d3=[];
      d2=d[3].split("`"); d2.removeLast();
      d2.forEach((element) {
        d3.add(element.split("~"));
      });
      List d4=[
        d[0],
        d[1],
        d[2],
        d3,
      ];
      designDetailsList.add(d4);
    });
    /*
    * [
    *   {
    *     clrId: 1,
    *     index: 34,
    *     name: red,
    *     imgUrl:"https://nfhouse.pubfire.net/cat/cat_$catId/element[0]/img/img_name"
    *   }
    * ]
    * */
    designDetailsList.forEach((element1) {
      List<Map> clr=[];
      List t=element1[3];
      t.forEach((element2) async {
        Map c={
          "clrId": element2[0],
          "name": element2[1],
          "imgUrl":"https://nfhouse.pubfire.net/cat/cat_$catNum/${element1[0]}/img/${element2[2]}"
        };
        clr.add(c);
      //  log("added");
      });
      Map map={
        "id":element1[0],
        'nr':element1[1].toString().replaceAll('rn', ""),
        'wr':element1[2].toString().replaceAll('wn', ""),
        'clr':clr
      };
      productMap.add(map);
    });
  //  log("$productMap");
    return productMap;
  }

  static Future<void> addNewDesign({String catNum="null",String designCode="null",String nr="null",String wr="null"})async{
    var  dio=Dio();
    var res=await dio.get("$SERVER/makeProductDir.php?catNum=$catNum&netRate=$nr&wholesaleRate=$wr&designCode=$designCode");
  }

  static Future<void>deleteDesign(String path,[String img="null"])async{
    if(img=="null")
      {
        var  dio=Dio();
        var res=await dio.get("$SERVER/deleteFullDir.php?path=$path");
      }
    else
      {
        var  dio=Dio();
        var res=await dio.get("$SERVER/deleteFullDir.php?path=$path");
        var res2=await  dio.get("$SERVER/unlink.php?path=${img.replaceAll("https://nfhouse.pubfire.net/", "")}");
        log("${res2}");
      }
  }

  static Future addColor({String path="null",String id="null",String name="null",String img_path=""})async{
    var dio=Dio();
   // log("$img_path");
    var formData = FormData.fromMap({
      'img' : await MultipartFile.fromFile(img_path),
      'path':"$path",
      'id':"$id",
      'name':"$name",
    });
    var res=await dio.post("$SERVER/addColor.php",data:formData);
 //   log("color data == ${res.data}");

  }
  
  static Future hide_unhide({String task="null",String currPath="null",String imgName="null"})async{
    var dio=Dio();
    var res=await dio.get("$SERVER/$currPath/hide.php?task=$task&clr_name=$imgName");
  //  log("${res.data}");
  }

  static Future editDesign({String catNum="",String olddesign="",String newdesign="" ,String oldnr="",String newnr="",String oldwr="",String newwr=""})
  async
  {
    var dio=Dio();
    var res=await dio.get("$SERVER/edit.php?cat=$catNum&&oldcode=$olddesign&&newcode=$newdesign&&oldrn=$oldnr&&newrn=$newnr&&oldwr=$oldwr&&newwr=$newwr");
  //  log("${res.data}");
    return res.data.toString();
  }
}