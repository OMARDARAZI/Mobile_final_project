import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../widgets/loading.dart';
import 'logic.dart';

class ChangeNamePage extends StatelessWidget {
  ChangeNamePage({Key? key}) : super(key: key);

  TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChangeNameLogic>(
      init: ChangeNameLogic(),
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: const Text(
              'Change Name',
              style: TextStyle(color: Colors.black),
            ),
            leading: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                  color: Colors.black),
            ),
          ),
          body: ListView(
            children: [
              SizedBox(
                height: 10.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Pick a Name',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Your Name is how people see\n you online.',
                  style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                ),
              ),

              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    onTapOutside: (event) {
                      FocusScope.of(context).focusedChild?.unfocus();
                    },
                    validator: (value) {
                      if(value==''){
                        return 'Please enter a name';
                      }
                      else if(value!.length<3){
                        return 'Enter at least 3 characters';
                      }
                    },
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: 'John Doe',
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: GestureDetector(
                  onTap: () {
                    if(_formKey.currentState!.validate()){
                      logic.changeName(nameController.text.trim(),context);

                    }
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
                              'Submit',
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
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Note: You can change your name once every 30 day.',
                  style: TextStyle(fontSize: 10.sp, color: Colors.redAccent),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
