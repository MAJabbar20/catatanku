import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note_model.dart';

class NoteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'notes';

  // Get notes stream for specific user
  Stream<List<Note>> getNotesStream(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Note.fromFirestore(doc)).toList();
    });
  }

  // Get single note
  Future<Note?> getNote(String noteId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(noteId).get();
      if (doc.exists) {
        return Note.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error getting note: $e');
      return null;
    }
  }

  // Add new note
  Future<String?> addNote({
    required String userId,
    required String title,
    required String content,
  }) async {
    try {
      final now = DateTime.now();
      final note = Note(
        id: '',
        userId: userId,
        title: title,
        content: content,
        createdAt: now,
        updatedAt: now,
      );

      final docRef = await _firestore
          .collection(_collection)
          .add(note.toFirestore());

      return docRef.id;
    } catch (e) {
      print('Error adding note: $e');
      return null;
    }
  }

  // Update note
  Future<bool> updateNote({
    required String noteId,
    required String title,
    required String content,
  }) async {
    try {
      await _firestore.collection(_collection).doc(noteId).update({
        'title': title,
        'content': content,
        'updatedAt': Timestamp.now(),
      });
      return true;
    } catch (e) {
      print('Error updating note: $e');
      return false;
    }
  }

  // Delete note
  Future<bool> deleteNote(String noteId) async {
    try {
      await _firestore.collection(_collection).doc(noteId).delete();
      return true;
    } catch (e) {
      print('Error deleting note: $e');
      return false;
    }
  }

  // Search notes
  Future<List<Note>> searchNotes(String userId, String query) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .get();

      final notes = snapshot.docs
          .map((doc) => Note.fromFirestore(doc))
          .where((note) =>
              note.title.toLowerCase().contains(query.toLowerCase()) ||
              note.content.toLowerCase().contains(query.toLowerCase()))
          .toList();

      return notes;
    } catch (e) {
      print('Error searching notes: $e');
      return [];
    }
  }
}