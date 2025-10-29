import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import '../models/task_note.dart';

class TaskNotesScreen extends StatefulWidget {
  final String taskId;
  final String taskName;
  final String? zone;

  const TaskNotesScreen({
    super.key,
    required this.taskId,
    required this.taskName,
    this.zone,
  });

  @override
  State<TaskNotesScreen> createState() => _TaskNotesScreenState();
}

class _TaskNotesScreenState extends State<TaskNotesScreen> {
  late Box<TaskNote> _notesBox;
  final _noteController = TextEditingController();
  final _imagePicker = ImagePicker();
  List<String> _selectedPhotos = [];
  TaskNote? _existingNote;

  @override
  void initState() {
    super.initState();
    _notesBox = Hive.box<TaskNote>('task_notes');
    _loadExistingNote();
  }

  void _loadExistingNote() {
    // Find existing note for this task
    for (var note in _notesBox.values) {
      if (note.taskId == widget.taskId) {
        setState(() {
          _existingNote = note;
          _noteController.text = note.note;
          _selectedPhotos = List.from(note.photoUrls);
        });
        break;
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      print('Attempting to pick image from source: $source');
      
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      ).catchError((error) {
        print('Image picker error: $error');
        throw error;
      });

      print('Image picked: ${image?.path}');

      if (image == null) {
        print('No image selected - user cancelled');
        return;
      }

      if (image.path.isEmpty) {
        throw Exception('Image path is empty');
      }

      print('Getting application directory...');
      final directory = await getApplicationDocumentsDirectory();
      print('App directory: ${directory.path}');
      
      final fileName = '${const Uuid().v4()}.jpg';
      final targetPath = '${directory.path}/$fileName';
      print('Copying image to: $targetPath');
      
      final savedImage = await File(image.path).copy(targetPath);
      print('Image saved successfully: ${savedImage.path}');

      if (!mounted) return;

      setState(() {
        _selectedPhotos.add(savedImage.path);
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Photo added successfully!'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.green,
        ),
      );
    } on Exception catch (e) {
      print('Exception picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    } catch (e, stackTrace) {
      print('Unexpected error picking image: $e');
      print('Stack trace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unexpected error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'Details',
              textColor: Colors.white,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Error Details'),
                    content: SingleChildScrollView(
                      child: Text('$e\n\n$stackTrace'),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      }
    }
  }

  Future<void> _saveNote() async {
    if (_noteController.text.isEmpty && _selectedPhotos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a note or photo')),
      );
      return;
    }

    if (_existingNote != null) {
      // Update existing note
      _existingNote!.note = _noteController.text;
      _existingNote!.photoUrls = _selectedPhotos;
      _existingNote!.updatedDate = DateTime.now();
      await _existingNote!.save();
    } else {
      // Create new note
      final note = TaskNote(
        id: const Uuid().v4(),
        taskId: widget.taskId,
        note: _noteController.text,
        photoUrls: _selectedPhotos,
      );
      await _notesBox.add(note);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note saved!')),
      );
      Navigator.pop(context, true);
    }
  }

  Future<void> _deletePhoto(String photoPath) async {
    setState(() {
      _selectedPhotos.remove(photoPath);
    });

    // Delete the file
    try {
      final file = File(photoPath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      print('Error deleting photo: $e');
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () async {
                Navigator.pop(context);
                try {
                  await _pickImage(ImageSource.camera);
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Camera error: ${e.toString()}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                try {
                  await _pickImage(ImageSource.gallery);
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Gallery error: ${e.toString()}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('Cancel'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _viewPhoto(String photoPath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _PhotoViewScreen(photoPath: photoPath),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Notes'),
        actions: [
          if (_existingNote != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Note?'),
                    content: const Text('This will delete the note and all photos.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  // Delete all photos
                  for (var photoPath in _existingNote!.photoUrls) {
                    try {
                      final file = File(photoPath);
                      if (await file.exists()) {
                        await file.delete();
                      }
                    } catch (e) {
                      print('Error deleting photo: $e');
                    }
                  }

                  await _existingNote!.delete();
                  if (mounted) {
                    Navigator.pop(context);
                  }
                }
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Info
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.taskName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    if (widget.zone != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        widget.zone!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer
                              .withOpacity(0.7),
                        ),
                      ),
                    ],
                    if (_existingNote != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Last updated: ${DateFormat('MMM d, y h:mm a').format(_existingNote!.updatedDate ?? _existingNote!.createdDate)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer
                              .withOpacity(0.6),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Note Input
            const Text(
              '📝 Notes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: 'Add notes about this task...\n\nExample:\n- What products worked best\n- How long it took\n- Any issues encountered\n- Tips for next time',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
              ),
            ),
            const SizedBox(height: 24),

            // Photos Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '📸 Photos',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FilledButton.icon(
                  onPressed: _showImageSourceDialog,
                  icon: const Icon(Icons.add_photo_alternate),
                  label: const Text('Add Photo'),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Photo Grid
            if (_selectedPhotos.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.photo_library_outlined,
                          size: 64,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No photos added yet',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add before/after photos to track your progress',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _selectedPhotos.length,
                itemBuilder: (context, index) {
                  final photoPath = _selectedPhotos[index];
                  return Stack(
                    children: [
                      GestureDetector(
                        onTap: () => _viewPhoto(photoPath),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(photoPath),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.black54,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.white,
                            ),
                            onPressed: () => _deletePhoto(photoPath),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveNote,
        icon: const Icon(Icons.save),
        label: const Text('Save'),
      ),
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }
}

// Photo viewer screen
class _PhotoViewScreen extends StatelessWidget {
  final String photoPath;

  const _PhotoViewScreen({required this.photoPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: Image.file(File(photoPath)),
        ),
      ),
    );
  }
}
