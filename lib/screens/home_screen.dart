import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:notes_app_hive/boxes/boxes.dart';
import 'package:notes_app_hive/constants/colors.dart';
import 'package:notes_app_hive/models/notes_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //** controllers ->
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  //?? dispose ->
  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notes App',
          style: TextStyle(
            fontFamily: 'poppins_bold',
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),

      //?? body ->
      body: ValueListenableBuilder<Box<NotesModel>>(
        builder: (context, box, _) {
          var data = box.values.toList().cast<NotesModel>();
          return ListView.builder(
            itemCount: box.length,
            reverse: true,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  elevation: 5.0,
                  color: cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 10.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            //*** for title ->
                            Text(
                              data[index].title.toString(),
                              style: const TextStyle(
                                fontFamily: 'poppins_medium',
                                letterSpacing: 0.8,
                                fontSize: 18.0,
                              ),
                            ),
                            const Spacer(),

                            //?? for editing ->
                            InkWell(
                              onTap: () {
                                _editDialog(
                                  data[index],
                                  data[index].title.toString(),
                                  data[index].description.toString(),
                                );
                              },
                              child: const Icon(
                                Icons.edit,
                                color: Colors.cyan,
                              ),
                            ),
                            const SizedBox(width: 15.0),

                            //?? for deleting ->
                            InkWell(
                              onTap: () {
                                delete(data[index]);
                              },
                              child: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),

                        //*** for description ->
                        Text(
                          data[index].description.toString(),
                          maxLines: 2,
                          style: const TextStyle(
                            fontFamily: 'poppins',
                            letterSpacing: 0.8,
                            fontSize: 14.0,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        valueListenable: Boxes.getData().listenable(),
      ),

      // floating action button ->
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        onPressed: () async {
          _showMyDialog();
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  //?? dialog box ->
  Future<void> _showMyDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Add Notes',
            style: TextStyle(
              fontFamily: 'poppins_medium',
            ),
          ),

          //??
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  style: const TextStyle(
                    fontFamily: 'poppins_bold',
                    letterSpacing: 0.8,
                  ),
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'Enter Title',
                    hintStyle: TextStyle(
                      fontFamily: 'poppins_medium',
                      letterSpacing: 0.8,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  style: const TextStyle(
                    fontFamily: 'poppins_bold',
                    letterSpacing: 0.8,
                  ),
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Enter Description',
                    hintStyle: TextStyle(
                      fontFamily: 'poppins_medium',
                      letterSpacing: 0.8,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),

          actions: [
            //?? add ->
            TextButton(
              onPressed: () {
                final data = NotesModel(
                  title: titleController.text,
                  description: descriptionController.text,
                );

                final box = Boxes.getData();
                box.add(data);

                data.save();
                titleController.clear();
                descriptionController.clear();

                Navigator.pop(context);
              },
              child: const Text(
                'Add',
                style: TextStyle(
                  fontFamily: 'poppins',
                  letterSpacing: 0.8,
                ),
              ),
            ),

            //?? cancel ->
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'poppins',
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  //?? for deleting ->
  void delete(NotesModel notesModel) async {
    await notesModel.delete();
  }

  //?? for editing ->
  Future<void> _editDialog(
    NotesModel notesModel,
    String title,
    String description,
  ) async {
    //** assigning text ->
    titleController.text = title;
    descriptionController.text = description;

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Edit Notes',
            style: TextStyle(
              fontFamily: 'poppins_medium',
            ),
          ),

          //??
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  style: const TextStyle(
                    fontFamily: 'poppins_bold',
                    letterSpacing: 0.8,
                  ),
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'Enter Title',
                    hintStyle: TextStyle(
                      fontFamily: 'poppins_medium',
                      letterSpacing: 0.8,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  style: const TextStyle(
                    fontFamily: 'poppins_bold',
                    letterSpacing: 0.8,
                  ),
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Enter Description',
                    hintStyle: TextStyle(
                      fontFamily: 'poppins_medium',
                      letterSpacing: 0.8,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),

          actions: [
            //?? edit ->
            TextButton(
              onPressed: () async {
                //** only modifying title- >
                notesModel.title = titleController.text.toString();

                //** only modifying description- >
                notesModel.description = descriptionController.text.toString();

                //** saving the changes ->
                notesModel.save();

                //** clearing the controllers ->
                titleController.clear();
                descriptionController.clear();

                Navigator.pop(context);
              },
              child: const Text(
                'Edit',
                style: TextStyle(
                  fontFamily: 'poppins',
                  letterSpacing: 0.8,
                ),
              ),
            ),

            //?? cancel ->
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'poppins',
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
