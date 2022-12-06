import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:practice_project/dialog/app_dialogs.dart';

import '../widgets/floating_action_button_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  List<Map<String,dynamic>> _items = [];
  ///Hive store data in key value pair
  final _shoppingBox = Hive.box('shopping_box');///calls the open box as everything in hive works as openbox
  Future<void> createItem(Map<String, dynamic> newItem) async {
    await _shoppingBox.add(newItem); ///Auto generate key 0,1,2...
    print("Amount data is ${_shoppingBox.length}");
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hive'),
      ),
      floatingActionButton: FloatingActionButtonWidget(
          onPressed: () async{
            AppDialogs.modalBottomSheetForAddData(
              nameController: _nameController,
              quantityController: _quantityController,
              onPress: (){
                createItem({
                  "name": _nameController.text,
                  "quantity": _quantityController.text,
                });
                //clear the text fields
                _nameController.text='';
                _quantityController.text='';
                Get.back();
              },);
          },
      ),
    );
  }
}