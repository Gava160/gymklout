import 'dart:io';
import 'dart:typed_data';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/app-settings/custom_notification.dart';
import 'package:gymklout/common/appbar.dart';
import 'package:gymklout/common/buttons/custom_button.dart';
import 'package:gymklout/common/buttons/icon_custom_button.dart';
import 'package:gymklout/screens/complete-profile-registration/widgets/process_header.dart';
import 'package:gymklout/services/api_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
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

  // ─── Crop state ──────────────────────────────────────────────────────────────
  final CropController _cropController = CropController();
  Uint8List? _imageBytes; // raw bytes loaded into crop widget
  Uint8List? _croppedBytes; // result after cropping
  bool _isCropping = false; // shows crop UI
  bool _cropInProgress = false; // spinner while crop processes

  final ImagePicker _picker = ImagePicker();

  // ─── Pick image ──────────────────────────────────────────────────────────────
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        imageQuality: 90,
      );

      if (picked == null) return;

      final bytes = await picked.readAsBytes();

      setState(() {
        _imageBytes = bytes;
        _croppedBytes = null;
        _isCropping = true; // show crop UI immediately
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

  // ─── Trigger crop ────────────────────────────────────────────────────────────
  void _doCrop() {
    setState(() => _cropInProgress = true);
    _cropController.crop(); // calls onCropped callback below
  }

  // ─── Show source picker sheet ─────────────────────────────────────────────────
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
                  style: AppDefaults.textStyle(
                    context,
                    fontWeight: FontWeight.w500,
                  ).copyWith(color: getDefaultHeaderColor(context)),
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
                  Platform.isIOS ? 'Choose from Photos' : 'Choose from Gallery',
                  style: AppDefaults.textStyle(
                    context,
                    fontWeight: FontWeight.w500,
                  ).copyWith(color: getDefaultHeaderColor(context)),
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

  // ─── Upload to backend ────────────────────────────────────────────────────────
  Future<void> _uploadAvatar() async {
    if (_croppedBytes == null) {
      showTopAlert(
        context,
        message: 'Please select and crop a photo first.',
        type: AlertType.warning,
      );
      return;
    }

    setState(() => isSubmitting = true);

    try {
      // Write bytes to a temp file for multipart upload
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/avatar_upload.jpg');
      await tempFile.writeAsBytes(_croppedBytes!);

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token') ?? '';

      final uri = Uri.parse('${ApiService.baseUrl}/api/v1/profiles/avatar');
      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..files.add(
          await http.MultipartFile.fromPath(
            'avatar',
            tempFile.path,
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
                child: _isCropping && _imageBytes != null
                    // ─── Crop UI ───────────────────────────────────────────
                    ? Column(
                        children: [
                          Expanded(
                            child: Crop(
                              controller: _cropController,
                              image: _imageBytes!,
                              aspectRatio: 1,
                              withCircleUi: true,
                              onCropped: (result) {
                                switch (result) {
                                  case CropSuccess(:final croppedImage):
                                    setState(() {
                                      _croppedBytes = croppedImage;
                                      _isCropping = false;
                                      _cropInProgress = false;
                                    });
                                  case CropFailure():
                                    setState(() => _cropInProgress = false);
                                    if (mounted) {
                                      showTopAlert(
                                        context,
                                        message:
                                            'Crop failed. Please try again.',
                                        type: AlertType.error,
                                      );
                                    }
                                }
                              },
                            ),
                          ),
                          // ─── Crop action buttons ───────────────────────
                          Padding(
                            padding: AppDefaults.defaultPadding,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Cancel crop
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: IconCustomButtonAuth(
                                    noPadding: true,
                                    icon: FluentIcons.dismiss_12_regular,
                                    backgroundColor: AppDefaults.textColor
                                        .withAlpha(40),
                                    foregroundColor: AppDefaults.textColor,
                                    onSubmit: () {
                                      HapticFeedback.lightImpact();
                                      setState(() {
                                        _isCropping = false;
                                        _imageBytes = null;
                                      });
                                    },
                                  ),
                                ),
                                // Confirm crop
                                SizedBox(
                                  width: size.width * 0.40,
                                  child: AppCustomButton(
                                    noPadding: true,
                                    setPadding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 15,
                                    ),
                                    label: Text(
                                      'Crop',
                                      style:
                                          AppDefaults.textStyle(
                                            context,
                                            fontWeight: FontWeight.w800,
                                          ).copyWith(
                                            color: AppDefaults.white,
                                            fontSize:
                                                (AppDefaults.textStyle(
                                                      context,
                                                    ).fontSize ??
                                                    16) +
                                                4,
                                          ),
                                    ),
                                    icon: const Icon(
                                      FluentIcons.crop_24_regular,
                                      size: 20,
                                    ),
                                    isLoading: _cropInProgress,
                                    onSubmit: () {
                                      HapticFeedback.selectionClick();
                                      _doCrop();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    // ─── Preview UI ────────────────────────────────────────
                    : SingleChildScrollView(
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

                              // ─── Avatar circle ─────────────────────────
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
                                    image: _croppedBytes != null
                                        ? DecorationImage(
                                            image: MemoryImage(_croppedBytes!),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: _croppedBytes == null
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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

                              // ─── Change photo ──────────────────────────
                              if (_croppedBytes != null)
                                TextButton.icon(
                                  onPressed: _showImageSourceSheet,
                                  icon: Icon(
                                    FluentIcons.arrow_sync_16_regular,
                                    size: 14,
                                    color: AppDefaults.primaryColor,
                                  ),
                                  label: Text(
                                    'Change photo',
                                    style: AppDefaults.textStyle(context)
                                        .copyWith(
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

              // ─── Bottom actions (only shown on preview screen) ───────────
              if (!_isCropping)
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
                                      (AppDefaults.textStyle(
                                            context,
                                          ).fontSize ??
                                          16) +
                                      4,
                                ),
                          ),
                          icon: const Icon(
                            FluentIcons.save_16_regular,
                            size: 20,
                          ),
                          isLoading: isSubmitting,
                          onSubmit: () {
                            HapticFeedback.selectionClick();
                            _uploadAvatar();
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
