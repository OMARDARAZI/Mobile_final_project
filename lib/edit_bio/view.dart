import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../widgets/loading.dart';
import 'logic.dart';

class EditBioPage extends StatefulWidget {
  EditBioPage({Key? key, this.bio}) : super(key: key);

  String? bio;

  @override
  State<EditBioPage> createState() => _EditBioPageState();
}

class _EditBioPageState extends State<EditBioPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _bioController;

  @override
  void initState() {
    _bioController = TextEditingController(text: widget.bio);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditBioLogic>(
      init: EditBioLogic(),
      builder: (logic) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: const Text(
              'Change Bio',
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
                  'Edit your bio',
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
                  'Your Bio is shown for everyone\n view your profile.',
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
                      FocusScope.of(context).unfocus();
                    },
                    controller: _bioController,
                    maxLength: 50,
                    maxLines: 4,
                    inputFormatters: [MaxLinesTextInputFormatter(4)],
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Bio',
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: GestureDetector(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      logic.updateBio(_bioController.text.trim(), context);
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
                          ? const Loading()
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
            ],
          ),
        );
      },
    );
  }
}

class MaxLinesTextInputFormatter extends TextInputFormatter {
  final int maxLines;

  MaxLinesTextInputFormatter(this.maxLines);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Count the number of lines in the new value
    int lines = '\n'.allMatches(newValue.text).length + 1;

    // If the number of lines exceeds the max, prevent adding a new line
    if (lines > maxLines) {
      return oldValue;
    }

    return newValue;
  }
}
