import 'package:finale_proj/login/view.dart';
import 'package:finale_proj/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';

import 'logic.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key}) : super(key: key);


  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterLogic>(
      init: RegisterLogic(),
      builder: (logic) {
        return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,

          body: ListView(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                        ),
                        Text(
                          'Name',
                          style: TextStyle(fontSize: 13.sp),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: nameController,
                          onTapOutside: (event) {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                          },
                          decoration: const InputDecoration(
                            hintText: 'John Doe',
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                        ),
                        Text(
                          'E-mail',
                          style: TextStyle(fontSize: 13.sp),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: emailController,
                          onTapOutside: (event) {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                          },
                          decoration: const InputDecoration(
                            hintText: 'someone@gmail.com',
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                        ),
                        Text(
                          'Password',
                          style: TextStyle(fontSize: 13.sp),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          obscureText: logic.isObscure,
                          controller: passwordController,
                          onTapOutside: (event) {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                          },
                          decoration: InputDecoration(
                            focusColor: Theme.of(context).primaryColor,
                            hintText: '*******************',
                            suffixIcon: IconButton(
                              onPressed: () {
                                logic.changeObscure();
                              },
                              icon: Icon(logic.isObscure
                                  ? Iconsax.eye
                                  : Iconsax.eye_slash),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: GestureDetector(
                      onTap: () {
                        logic.registerWithEmailAndPassword(
                            emailController.text.trim().toLowerCase(),
                            passwordController.text.trim(),
                            nameController.text.trim(),
                            context);
                      },
                      child: Container(
                        height: 7.h,
                        width: MediaQuery.sizeOf(context).width,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: logic.isLoading
                              ? Loading()
                              : Text(
                                  'Register',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.sp,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Text('Already have an account?'),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.offAll(() => LoginPage());
                              },
                              child: Text(
                                'Login here',
                                style: TextStyle(
                                    color: Theme.of(context).hoverColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
