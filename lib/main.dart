import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:nf_admin/takePin.dart';

const SERVER="https://nfhouse.pubfire.net";
void main(){
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown  ]);


  runApp(GetMaterialApp(
    title: "N.F. Admin",
    debugShowCheckedModeBanner: false,
    home: takePin(),
  ));

}