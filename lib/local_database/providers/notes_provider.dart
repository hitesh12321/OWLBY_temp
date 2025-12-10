import 'package:flutter/material.dart';
import 'package:owlby_serene_m_i_n_d_s/local_database/db/project_database.dart';

import '../models/note_model.dart';

class NotesProvider with ChangeNotifier {
  List<NoteModel> _notes = [];

  List<NoteModel> get notes => _notes;

  Future<void> loadNotes() async {
    _notes = await OwlbyDatabase.instance.getNotes();
    notifyListeners();
  }

  Future<void> addNote(String title, String content) async {
    final note = NoteModel(
      title: title,
      content: content,
      createdAt: DateTime.now().toString(),
    );
    await OwlbyDatabase.instance.addNote(note);
    await loadNotes();
  }

  Future<void> updateNote(NoteModel note) async {
    await OwlbyDatabase.instance.updateNote(note);
    await loadNotes();
  }

  Future<void> deleteNote(int id) async {
    await OwlbyDatabase.instance.deleteNote(id);
    await loadNotes();
  }
}
