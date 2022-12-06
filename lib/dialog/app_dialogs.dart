import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/text_field_widget.dart';

class AppDialogs{
  static void modalBottomSheetForAddData({
      required TextEditingController nameController,
      required TextEditingController quantityController,
      required Function onPress,
}){
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(
          bottom: Get.mediaQuery.viewInsets.bottom,
          top: 15,
          left: 15,
          right: 15,
        ),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextFieldWidget(
              controller: nameController,
              name: 'Name',
            ),
            TextFieldWidget(
              controller: quantityController,
              keyboard: TextInputType.number,
              name: 'Quantity',
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed:() => onPress,
              child: Text('Create New'),),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
      elevation: 5,
      isScrollControlled: true,
    );
}
}