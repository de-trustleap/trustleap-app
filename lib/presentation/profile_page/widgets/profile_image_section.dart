// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:finanzbegleiter/application/image/image_cubit.dart';
import 'package:finanzbegleiter/core/failures/storage_failure_mapper.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/form_error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImageSection extends StatefulWidget {
  final String userID;

  const ProfileImageSection({
    Key? key,
    required this.userID,
  }) : super(key: key);

  @override
  State<ProfileImageSection> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ProfileImageSection> {
  final GlobalKey<_MyWidgetState> myWidgetKey = GlobalKey();

  Future<void> _pickImage() async {
    final context = myWidgetKey.currentContext;
    final ImagePicker picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (context != null && context.mounted) {
      BlocProvider.of<ImageCubit>(context).uploadImage(image, widget.userID);
    }
  }

  String? _getImageUploadFailureMessage(ImageState state) {
    if (state is ImageUploadFailureState) {
      return StorageFailureMapper.mapFailureMessage(state.failure);
    } else if (state is ImageExceedsFileSizeLimitFailureState) {
      return "Sie haben die zulässige Maximalgröße von 5 MB überschritten";
    } else if (state is ImageIsNotValidFailureState) {
      return "Das ist kein gültiges Bildformat";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return BlocConsumer<ImageCubit, ImageState>(
      listener: (context, state) {
        if (state is ImageUploadSuccessState) {
          // TODO: ImageURL in User speichern. Am besten aber über Cloud Function.
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            Stack(
              key: myWidgetKey,
              children: [
                CachedNetworkImage(
                  width: 200,
                  height: 200,
                  imageUrl:
                      state is ImageUploadSuccessState ? state.imageURL : "",
                  imageBuilder: (context, imageProvider) {
                    return Container(
                        decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ));
                  },
                  placeholder: (context, url) {
                    return Stack(children: [
                      Image.asset("images/placeholder.jpg",
                          height: 200, width: 200),
                      const LoadingIndicator()
                    ]);
                  },
                  errorWidget: (context, url, error) {
                    return Image.asset("images/placeholder.jpg",
                        height: 200, width: 200);
                  },
                ),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: ElevatedButton(
                        onPressed: () {
                          _pickImage();
                        },
                        style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(20),
                            backgroundColor: themeData.colorScheme.secondary),
                        child: state is ImageUploadLoadingState
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Icon(Icons.add_a_photo,
                                color: Colors.white)))
              ],
            ),
            if (_getImageUploadFailureMessage(state) != null) ...[
              const SizedBox(height: 20),
              FormErrorView(message: _getImageUploadFailureMessage(state)!)
            ]
          ],
        );
      },
    );
  }
}
