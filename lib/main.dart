import 'package:finale_proj/login/view.dart';
import 'package:finale_proj/nav_bar/view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:sizer/sizer.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor:Color(0xff663399) ,

    ));
    return Sizer(
      builder: (context, orientation, deviceType) => GetMaterialApp(
        theme: ThemeData(
          primaryColor: const Color(0xff663399),
          backgroundColor: const Color(0xffededed),
          focusColor: const Color(0xff2ecc71),
          hoverColor: const Color(0xffff6f61),
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return NavBarPage();
            }
            else {
              return LoginPage();
            }
          }
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
