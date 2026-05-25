import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {

  final TextEditingController noteController =
      TextEditingController();
      final TextEditingController searchController =
    TextEditingController();

  List<String> notes = [];
  List<String> filteredNotes = [];

  @override
void initState() {
  super.initState();
  loadNotes();
}

  void addNote() {

    if(noteController.text.trim().isEmpty) return;

    setState(() {

      notes.add(noteController.text);
      filteredNotes = notes;
      saveNotes();

    });

    noteController.clear();
  }

  void deleteNote(int index) {

    setState(() {

      notes.removeAt(index);
      filteredNotes = notes;
      saveNotes();

    });
  }

  void searchNotes(String query){

  final results = notes.where((note){

    return note.toLowerCase()
        .contains(query.toLowerCase());

  }).toList();

  setState(() {

    filteredNotes = results;

  });
}

  Future<void> saveNotes() async {

  final prefs =
      await SharedPreferences.getInstance();

  prefs.setStringList('notes', notes);
}

Future<void> loadNotes() async {

  final prefs =
      await SharedPreferences.getInstance();

  final savedNotes =
      prefs.getStringList('notes');

  if(savedNotes != null){

    setState(() {

      notes = savedNotes;
      filteredNotes = savedNotes;

    });
  }
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Study Notes"),
        backgroundColor: const Color(0xFF0F172A),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,

        onPressed: () {

          showDialog(
            context: context,

            builder: (_) {

              return AlertDialog(

                backgroundColor: const Color(0xFF1E293B),

                title: const Text(
  "Add New Note",
  style: TextStyle(
    fontWeight: FontWeight.bold,
  ),
),

                content: TextField(

                  controller: noteController,

                  decoration: InputDecoration(

  hintText: "Enter your study note",

  filled: true,

  fillColor: const Color(0xFF0F172A),

  border: OutlineInputBorder(

    borderRadius: BorderRadius.circular(15),

    borderSide: BorderSide.none,
  ),
),
                ),

                actions: [

                  TextButton(
                    onPressed: () {

                      Navigator.pop(context);

                    },

                    child: const Text("Cancel"),
                  ),

                  ElevatedButton(
                    onPressed: () {

                      addNote();

                      Navigator.pop(context);

                    },

                    child: const Text("Add"),
                  ),

                ],
              );
            },
          );
        },

        child: const Icon(Icons.add),
      ),

     body: Padding(
  padding: const EdgeInsets.all(15),

  child: Column(

    children: [

      TextField(

        controller: searchController,

        onChanged: searchNotes,

        decoration: InputDecoration(

          hintText: "Search notes...",

          prefixIcon: const Icon(Icons.search),

          filled: true,

          fillColor: const Color(0xFF1E293B),

          border: OutlineInputBorder(

            borderRadius: BorderRadius.circular(15),

            borderSide: BorderSide.none,
          ),
        ),
      ),

      const SizedBox(height: 20),

      Expanded(

        child: filteredNotes.isEmpty

            ? const Center(

                child: Column(

                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [

                    Icon(
                      Icons.note_alt_outlined,
                      size: 80,
                      color: Colors.white38,
                    ),

                    SizedBox(height: 20),

                    Text(
                      "No Notes Found",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              )

            : ListView.builder(

                itemCount: filteredNotes.length,

                itemBuilder: (context, index) {

                  return AnimatedContainer(

                    duration:
                        const Duration(milliseconds: 300),

                    margin: const EdgeInsets.only(
                      bottom: 15,
                    ),

                    decoration: BoxDecoration(

                      color: const Color(0xFF1E293B),

                      borderRadius:
                          BorderRadius.circular(18),

                      boxShadow: [

                        BoxShadow(

                          color: Colors.black.withOpacity(0.2),

                          blurRadius: 10,

                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),

                    child: ListTile(

                      contentPadding:
                          const EdgeInsets.all(15),

                      leading: const CircleAvatar(

                        backgroundColor: Colors.pink,

                        child: Icon(Icons.note),
                      ),

                      title: Text(

                        filteredNotes[index],

                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      subtitle: const Text(
                        "Study Note",
                        style: TextStyle(
                          color: Colors.white54,
                        ),
                      ),

                      trailing: IconButton(

                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),

                        onPressed: () {

                          deleteNote(index);

                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    ],
  ),
),
    );
  }
}