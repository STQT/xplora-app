import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/chips_input.dart';
import '../widgets/progress_indicator.dart';
import '../widgets/fields.dart';
import '../providers/profile_provider.dart';
import 'package:image_picker/image_picker.dart';


class CompleteProfileStep2 extends StatefulWidget {
  @override
  _CompleteProfileStep2State createState() => _CompleteProfileStep2State();
}

class _CompleteProfileStep2State extends State<CompleteProfileStep2> {
  final TextEditingController bioController = TextEditingController();

  bool isFormValid = false;
  List<String> selectedInterests = [];
  List<String> selectedLanguages = [];
  File? _selectedImage;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ProfileProvider>(context, listen: false);
      provider.fetchInterestsAndLanguages();
    });

    bioController.addListener(_validateForm);
  }

  @override
  void dispose() {
    bioController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      isFormValid = selectedInterests.isNotEmpty &&
          selectedLanguages.isNotEmpty &&
          bioController.text.isNotEmpty &&
          _selectedImage != null;
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery, // можно также использовать ImageSource.camera
      maxWidth: 600,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      // Обновляем провайдер
      Provider.of<ProfileProvider>(context, listen: false)
          .updateProfileImage(_selectedImage!);
      _validateForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: provider.isLoading
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView( // ✅ Fix scrolling issue
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ProfileHeader(),
                  SizedBox(height: 8),
                  ProfileDescription(text: "Tell us a bit more about yourself!"),
                  SizedBox(height: 32),

                  ChipsInput(
                    label: "Interests",
                    options: provider.interests,
                    selectedItems: selectedInterests,
                    onChanged: (value) {
                      setState(() => selectedInterests = value);
                      _validateForm();
                    },
                  ),
                  SizedBox(height: 16),

                  ChipsInput(
                    label: "Languages",
                    options: provider.languages,
                    selectedItems: selectedLanguages,
                    onChanged: (value) {
                      setState(() => selectedLanguages = value);
                      _validateForm();
                    },
                  ),

                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(75),
                      ),
                      child: _selectedImage != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(75),
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                        ),
                      )
                          : Icon(
                        Icons.camera_alt,
                        size: 50,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  CustomTextField(label: "Bio", controller: bioController),
                  SizedBox(height: 16),

                  SubmitButton(
                    text: "Complete form",
                    isEnabled: isFormValid,
                    onPressed: isFormValid
                        ? () {
                      final provider = Provider.of<ProfileProvider>(context, listen: false);

                      // Получаем ID интересов и языков
                      List<int> interestIds = selectedInterests
                          .map((name) => provider.interests.indexOf(name) + 1)
                          .toList();

                      List<int> languageIds = selectedLanguages
                          .map((name) => provider.languages.indexOf(name) + 1)
                          .toList();

                      // Сохраняем данные в провайдере
                      provider.updateProfileStep2(
                        interests: interestIds.map((id) => id.toString()).toList(),
                        languages: languageIds.map((id) => id.toString()).toList(),
                      );

                      if (_selectedImage != null) {
                        provider.updateProfileImage(_selectedImage!);
                      }

                      // Переход на следующий шаг
                      Navigator.pushNamed(context, '/step3');
                    }
                        : null,
                  ),
                  SizedBox(height: 16),

                  ProfileProgressIndicator(step: 2),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
