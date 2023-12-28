import 'package:finale_proj/register/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';

import '../widgets/loading.dart';
import 'logic.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginLogic>(
        init: LoginLogic(),
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
                      'Login',
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(
                      height: 19.h,
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
                              FocusScope.of(context).focusedChild?.unfocus();
                            },
                            decoration: const InputDecoration(
                              hintText: 'someone@gmail.com',
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
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
                            controller: passwordController,
                            obscureText: logic.isObscure,
                            onTapOutside: (event) {
                              FocusScope.of(context).focusedChild?.unfocus();
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
                          logic.signInWithEmailAndPassword(
                            emailController.text.trim().toLowerCase(),
                            passwordController.text.trim(),
                            context,
                          );
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
                                    'Login',
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
                              Text('Don\'t have an account yet?'),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => RegisterPage());
                                },
                                child: Text(
                                  'Sign up',
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
        });
  }
}
