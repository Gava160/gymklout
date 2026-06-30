import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymklout/app-settings/app_data.dart';
import 'package:gymklout/common/appbar.dart';
import 'package:gymklout/common/bottom-sheets/open_update_avatar.dart';
import 'package:gymklout/common/buttons/custom_button.dart';
import 'package:gymklout/providers/auth_provider.dart';
import 'package:iconsax/iconsax.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});
  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  bool isSubmitting = false;
  bool buttonIsEnabled = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final profile = ref.watch(currentProfileProvider);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        backgroundColor: getDefaultBgColor(context),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kTextTabBarHeight + 35),
          child: SafeArea(
            child: Padding(
              padding: AppDefaults.defaultPadding,
              child: CustomAppBar(title: "Edit Profile", actions: []),
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: AppDefaults.defaultPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: profile?.avatarUrl ?? "",
                                    cacheKey: profile?.avatarUrl ?? "",
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) {
                                      // print(imagePath);
                                      return CircleAvatar(
                                        radius: 100,
                                        backgroundColor: AppDefaults.textColor
                                            .withAlpha(20),
                                        child: showSpinner(),
                                      );
                                    },
                                    errorWidget: (context, url, error) =>
                                        CircleAvatar(
                                          radius: 100,
                                          backgroundColor: AppDefaults.textColor
                                              .withAlpha(20),
                                          child: const Icon(
                                            Icons.person,
                                            size: 24,
                                          ),
                                        ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  right: 5,
                                  child: GestureDetector(
                                    onTap: () {
                                      HapticFeedback.selectionClick();
                                      openUpdateAvatarSheet(
                                        context,
                                        popAfterSuccess: true,
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppDefaults.darkBgColor,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withAlpha(40),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Icon(Iconsax.camera),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SafeArea(
                child: Center(
                  child: SizedBox(
                    width: size.width * 0.50,
                    child: AppCustomButton(
                      noPadding: true,
                      label: Text(
                        "Save",
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
                      onSubmit: () {},
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
