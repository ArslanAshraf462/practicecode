import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:practice_project/boxes/boxes.dart';
import 'package:practice_project/models/notes_model.dart';


import '../widgets/floating_action_button_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  //List<Map<String,dynamic>> _items = [];
  ///Hive store data in key value pair
 // final _shoppingBox = Hive.box<Shopping>('shopping_box');///calls the open box as everything in hive works as openbox
//   Future<void> createItem(Map<String,dynamic> newItem) async {
//     await _shoppingBox.add(newItem); ///Auto generate key 0,1,2...
//     var item=_shoppingBox.get('key');
//     print("Amount data is ${item}");
// }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure?'),
        content:  Text('Do you want to exit an App'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child:  Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Hive'),
        ),
        body: ValueListenableBuilder<Box<NotesModel>>(
            valueListenable: Boxes.getData().listenable(),
            builder: (context, box, _) {
              var data= box.values.toList().cast<NotesModel>();
              return ListView.builder(
                itemCount: box.length,
                itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(data[index].title.toString(),
                              style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w500 , color: Colors.black),),
                            Spacer(),
                            InkWell(
                                onTap: () {
                                  delete(data[index]);
                                },
                                child: Icon(Icons.delete,color: Colors.red,)),
                            SizedBox(width: 15,),
                            InkWell(
                                onTap: () {
                                  _editDialog(
                                      data[index],
                                      data[index].title.toString(),
                                      data[index].description.toString(),
                                  );
                                },
                                child: Icon(Icons.edit)),
                          ],
                        ),

                        Text(data[index].description.toString(),
                          style: TextStyle(fontSize: 18 , fontWeight: FontWeight.w300, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },);
            },),
        floatingActionButton: FloatingActionButtonWidget(
            onPressed: () async{
              _showMyDialog();
            },
        ),
      ),
    );
  }

  void delete(NotesModel notesModel)async{
    await notesModel.delete() ;
  }

  Future<void> _editDialog(NotesModel notesModel,String title, String description)async{
    _nameController.text=title;
    _descriptionController.text=description;
    return showDialog(
        context: context,
        builder:(context){
          return AlertDialog(
            title: Text('Edit NOTES'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                        hintText: 'Enter title',
                        border: OutlineInputBorder()
                    ),
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                        hintText: 'Enter description',
                        border: OutlineInputBorder()
                    ),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: (){

                Navigator.pop(context);
              }, child: const Text('Cancel')),

              TextButton(onPressed: (){
                notesModel.title=_nameController.text.toString();
                notesModel.description =_descriptionController.text.toString();
                notesModel.save();
                _nameController.clear();
                _descriptionController.clear();
                Navigator.pop(context);
              }, child: Text('Edit')),
            ],
          );
        }
    ) ;
  }

  Future<void> _showMyDialog()async{

    return showDialog(
        context: context,
        builder:(context){
          return AlertDialog(
            title: Text('Add NOTES'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                        hintText: 'Enter title',
                        border: OutlineInputBorder()
                    ),
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                        hintText: 'Enter description',
                        border: OutlineInputBorder()
                    ),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: const Text('Cancel')),

              TextButton(onPressed: (){
                final data = NotesModel(title: _nameController.text,
                    description: _descriptionController.text) ;

                final box = Boxes.getData();
                box.add(data);

                 //data.save() ;
                print(box);
                _nameController.clear();
                _descriptionController.clear();

                // box.

                Navigator.pop(context);
              }, child: Text('Add')),
            ],
          );
        }
    ) ;
  }
}