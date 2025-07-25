import 'dart:io';

import 'package:billpod/providers/user_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:billpod/models/user_model.dart';
import 'package:billpod/services/user_service.dart';
import 'package:billpod/core/constants/api_endpoints.dart';
import '../widgets/neomorphic_appbar.dart';
import '../widgets/neomorphic_input.dart';
import '../widgets/neomorphic_button.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  UserModel? user;
  final nameController = TextEditingController();
  final currencyController = TextEditingController();
  bool loading = true;
  XFile? pickedFile;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    final res = await UserService.getMyProfile();
    if (!mounted) return;
    setState(() {
      user = res;
      nameController.text = res?.name ?? '';
      currencyController.text = res?.currency ?? '';
      loading = false;
    });
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  Future<String?> uploadImage(XFile file) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final dio = Dio();

    MultipartFile imageFile;

    if (kIsWeb) {
      final bytes = await file.readAsBytes();
      imageFile = MultipartFile.fromBytes(bytes, filename: 'upload.png');
    } else {
      imageFile = await MultipartFile.fromFile(
        file.path,
        filename: 'upload.png',
      );
    }

    final formData = FormData.fromMap({'image': imageFile});

    final res = await dio.post(
      '${ApiEndpoints.imageBase}/upload',
      data: formData,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return res.data['id'];
  }

  Future<void> handleSave() async {
    if (user == null) return;
    setState(() => loading = true);

    String? newImageId;
    if (pickedFile != null) {
      newImageId = await uploadImage(pickedFile!);
    }

    final updated = UserModel(
      id: user!.id,
      name: nameController.text.trim(),
      email: user!.email,
      profileImage: newImageId ?? user!.profileImage,
      currency: currencyController.text.trim(),
    );

    final result = await UserService.updateUserProfile(updated);
    if (!mounted) return;

    ref.read(userProvider.notifier).updateUser(updated);

    setState(() {
      user = updated;
      loading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result ? "Profile updated." : "Failed to update profile.",
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    currencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NeomorphicAppBar(title: 'Profile', showBack: true),
      body:
          loading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            pickedFile != null
                                ? kIsWeb
                                    ? NetworkImage(pickedFile!.path)
                                    : FileImage(File(pickedFile!.path))
                                        as ImageProvider
                                : user?.profileImage != null
                                ? NetworkImage(
                                  '${ApiEndpoints.imageBase}/${user!.profileImage}',
                                )
                                : const AssetImage(
                                  'assets/images/default_avatar.png',
                                ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      user?.email ?? '',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 24),
                  NeomorphicInput(controller: nameController, hint: 'Name'),
                  NeomorphicInput(
                    controller: currencyController,
                    hint: 'Preferred Currency (e.g. INR)',
                  ),
                  const SizedBox(height: 20),
                  loading
                      ? const Center(child: CircularProgressIndicator())
                      : NeomorphicButton(
                        text: 'Save Changes',
                        onTap: handleSave,
                      ),
                ],
              ),
    );
  }
}
