import 'dart:io';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/app-settings/custom_notification.dart';
import 'package:gymklout/common/appbar.dart';
import 'package:gymklout/common/bottom-sheets/open_update_block.dart';
import 'package:gymklout/common/buttons/custom_button.dart';
import 'package:gymklout/common/buttons/icon_custom_button.dart';
import 'package:gymklout/screens/complete-profile-registration/widgets/process_header.dart';
import 'package:gymklout/services/api_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileAvatarSetScreen extends ConsumerStatefulWidget {
  const ProfileAvatarSetScreen({super.key});
  @override
  ConsumerState<ProfileAvatarSetScreen> createState() =>
      _ProfileAvatarSetScreenState();
}

class _ProfileAvatarSetScreenState
    extends ConsumerState<ProfileAvatarSetScreen> {
  bool isSubmitting = false;
  File? _selectedImage;

  final ImagePicker _picker = ImagePicker();

  // ─── Pick image from gallery or camera ──────────────────────────────────────
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        imageQuality: 90,
      );

      if (picked == null) return;

      // ─── Crop to square ────────────────────────────────────────────────────
      final CroppedFile? cropped = await ImageCropper().cropImage(
        sourcePath: picked.path,
        compressQuality: 90,
        compressFormat: ImageCompressFormat.jpg,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Photo',
            toolbarColor: AppDefaults.primaryColor,
            toolbarWidgetColor: AppDefaults.white,
            lockAspectRatio: true,
            hideBottomControls: false,
            showCropGrid: true,
            initAspectRatio: CropAspectRatioPreset.square,
            aspectRatioPresets: [CropAspectRatioPreset.square],
          ),
          IOSUiSettings(
            title: 'Crop Photo',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
            hidesNavigationBar: false,
            doneButtonTitle: 'Done',
            cancelButtonTitle: 'Cancel',
            aspectRatioPresets: [CropAspectRatioPreset.square],
          ),
        ],
      );

      if (cropped == null) return;

      setState(() {
        _selectedImage = File(cropped.path);
      });
    } catch (e) {
      if (mounted) {
        showTopAlert(
          context,
          message: 'Failed to pick image. Please try again.',
          type: AlertType.error,
        );
      }
    }
  }

  // ─── Show bottom sheet to choose source ─────────────────────────────────────
  void _showImageSourceSheet() {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
      ),
      backgroundColor: getDefaultBgColor(context),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Choose Photo Source',
                style:
                    AppDefaults.textStyle(
                      context,
                      fontWeight: FontWeight.w700,
                    ).copyWith(
                      color: getDefaultHeaderColor(context),
                      fontSize:
                          (AppDefaults.textStyle(context).fontSize ?? 16) + 4,
                    ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(FluentIcons.camera_24_regular),
                title: Text(
                  'Take a Photo',
                  style:
                      AppDefaults.textStyle(
                        context,
                        fontWeight: FontWeight.w500,
                      ).copyWith(
                        color: getDefaultHeaderColor(context),
                        fontSize:
                            (AppDefaults.textStyle(context).fontSize ?? 16),
                      ),
                ),
                onTap: () {
                  HapticFeedback.selectionClick();
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(FluentIcons.image_24_regular),
                title: Text(
                  'Choose from ${Platform.isIOS ? 'Photos' : 'Gallery'}',
                  style:
                      AppDefaults.textStyle(
                        context,
                        fontWeight: FontWeight.w500,
                      ).copyWith(
                        color: getDefaultHeaderColor(context),
                        fontSize:
                            (AppDefaults.textStyle(context).fontSize ?? 16),
                      ),
                ),
                onTap: () {
                  HapticFeedback.selectionClick();
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Upload to backend ───────────────────────────────────────────────────────
  Future<void> _uploadAvatar() async {
    if (_selectedImage == null) {
      showTopAlert(
        context,
        message: 'Please select a photo first.',
        type: AlertType.warning,
      );
      return;
    }

    setState(() => isSubmitting = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token') ?? '';

      final uri = Uri.parse('${ApiService.baseUrl}/api/v1/profiles/avatar');
      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..files.add(
          await http.MultipartFile.fromPath(
            'avatar',
            _selectedImage!.path,
            contentType: http.MediaType('image', 'jpeg'),
          ),
        );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        if (mounted) {
          showTopAlert(
            context,
            message: 'Profile photo updated successfully!',
            type: AlertType.success,
          );
          // Navigate forward — adjust route to your next screen
          Navigator.of(context).pop();
        }
      } else {
        final body = response.body;
        String message = 'Upload failed. Please try again.';
        if (body.contains('No face detected')) {
          message = 'No face detected. Please use a clear photo of your face.';
        } else if (body.contains('under 5MB')) {
          message = 'Image is too large. Please use an image under 5MB.';
        }
        if (mounted) {
          showTopAlert(context, message: message, type: AlertType.error);
        }
      }
    } catch (e) {
      if (mounted) {
        showTopAlert(
          context,
          message: 'Something went wrong. Please try again.',
          type: AlertType.error,
        );
      }
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: false,
      resizeToAvoidBottomInset: false,
      backgroundColor: getDefaultBgColor(context),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kTextTabBarHeight + 35),
        child: SafeArea(
          child: Padding(
            padding: AppDefaults.defaultPadding,
            child: CustomAppBar(title: "", actions: []),
          ),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Padding(
                    padding: AppDefaults.defaultPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ProcessheaderWidget(
                          header: "Upload Profile Photo",
                          subHeader:
                              "This is required by gym centers we work with.",
                        ),
                        const SizedBox(height: 40),

                        // ─── Avatar preview / picker ───────────────────────
                        GestureDetector(
                          onTap: _showImageSourceSheet,
                          child: Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppDefaults.textColor.withAlpha(20),
                              border: Border.all(
                                color: AppDefaults.primaryColor,
                                width: 2,
                              ),
                              image: _selectedImage != null
                                  ? DecorationImage(
                                      image: FileImage(_selectedImage!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: _selectedImage == null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        FluentIcons.camera_add_24_regular,
                                        size: 36,
                                        color: AppDefaults.primaryColor,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Tap to add photo',
                                        style:
                                            AppDefaults.textStyle(
                                              context,
                                              fontWeight: FontWeight.w500,
                                            ).copyWith(
                                              fontSize: 12,
                                              color: AppDefaults.textColor
                                                  .withAlpha(150),
                                            ),
                                      ),
                                    ],
                                  )
                                : null,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ─── Retake hint ───────────────────────────────────
                        if (_selectedImage != null)
                          TextButton.icon(
                            onPressed: _showImageSourceSheet,
                            icon: Icon(
                              FluentIcons.arrow_sync_16_regular,
                              size: 14,
                              color: AppDefaults.primaryColor,
                            ),
                            label: Text(
                              'Change photo',
                              style: AppDefaults.textStyle(context).copyWith(
                                fontSize: 13,
                                color: AppDefaults.primaryColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              // ─── Bottom actions ──────────────────────────────────────────
              Padding(
                padding: AppDefaults.defaultPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: IconCustomButtonAuth(
                        noPadding: true,
                        icon: FluentIcons.arrow_left_12_regular,
                        backgroundColor: AppDefaults.textColor.withAlpha(40),
                        foregroundColor: AppDefaults.textColor,
                        onSubmit: () {
                          HapticFeedback.lightImpact();
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.40,
                      child: AppCustomButton(
                        noPadding: true,
                        setPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 15,
                        ),
                        label: Text(
                          "Upload",
                          style:
                              AppDefaults.textStyle(
                                context,
                                fontWeight: FontWeight.w800,
                              ).copyWith(
                                color: AppDefaults.white,
                                fontSize:
                                    (AppDefaults.textStyle(context).fontSize ??
                                        16) +
                                    4,
                              ),
                        ),
                        icon: const Icon(FluentIcons.save_16_regular, size: 20),
                        isLoading: isSubmitting,
                        onSubmit: () {
                          HapticFeedback.selectionClick();
                          // _uploadAvatar();
                          openUpdateSheet(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
