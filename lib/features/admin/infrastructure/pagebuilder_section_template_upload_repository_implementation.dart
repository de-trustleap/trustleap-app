import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/features/admin/domain/pagebuilder_section_template_edit.dart';
import 'package:finanzbegleiter/features/admin/domain/pagebuilder_section_template_upload.dart';
import 'package:finanzbegleiter/features/admin/domain/pagebuilder_section_template_upload_repository.dart';
import 'package:finanzbegleiter/environment.dart';
import 'package:finanzbegleiter/features/admin/infrastructure/pagebuilder_section_template_edit_model.dart';
import 'package:finanzbegleiter/features/admin/infrastructure/pagebuilder_section_template_upload_model.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class PagebuilderSectionTemplateUploadRepositoryImplementation
    implements PagebuilderSectionTemplateUploadRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseAppCheck appCheck;
  final Environment environment = Environment();

  PagebuilderSectionTemplateUploadRepositoryImplementation({
    required this.firebaseAuth,
    required this.appCheck,
  });

  @override
  Future<Either<DatabaseFailure, Unit>> uploadTemplate(
      PagebuilderSectionTemplateUpload template) async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) {
        return left(BackendFailure());
      }

      final idToken = await user.getIdToken();
      if (idToken == null) {
        return left(BackendFailure());
      }
      final appCheckToken = await appCheck.getToken();
      final functionUrl =
          '${environment.getCloudFunctionsBaseURL()}/uploadPagebuilderSectionTemplate';
      final model = PagebuilderSectionTemplateUploadModel.fromDomain(template);

      final body = jsonEncode({
        'appCheckToken': appCheckToken,
        'jsonContent': base64Encode(model.jsonData),
        'jsonFileName': model.jsonFileName,
        'thumbnailData': base64Encode(model.thumbnailData),
        'thumbnailFileName': model.thumbnailFileName,
        'assetDataList':
            model.assetDataList.map((data) => base64Encode(data)).toList(),
        'assetFileNames': model.assetFileNames,
        'environment': model.environment,
        'type': model.type,
      });

      final response = await http.post(
        Uri.parse(functionUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        return right(unit);
      } else {
        return left(BackendFailure());
      }
    } catch (e) {
      return left(BackendFailure());
    }
  }

  @override
  Future<Either<DatabaseFailure, Unit>> editTemplate(
      PagebuilderSectionTemplateEdit template) async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) {
        return left(BackendFailure());
      }

      final idToken = await user.getIdToken();
      if (idToken == null) {
        return left(BackendFailure());
      }
      final appCheckToken = await appCheck.getToken();
      final functionUrl =
          "${environment.getCloudFunctionsBaseURL()}/editPagebuilderSectionTemplate";
      final model = PagebuilderSectionTemplateEditModel.fromDomain(template);

      final body = jsonEncode({
        "appCheckToken": appCheckToken,
        "templateId": model.templateId,
        if (model.jsonData != null)
          "jsonContent": base64Encode(model.jsonData!),
        if (model.thumbnailData != null)
          "thumbnailData": base64Encode(model.thumbnailData!),
        "deletedAssetUrls": model.deletedAssetUrls,
        "replacements": model.replacements
            .map((r) => {
                  "oldUrl": r.oldUrl,
                  "newAssetBase64": base64Encode(r.newAssetData),
                })
            .toList(),
        "newAssetDataList":
            model.newAssetDataList.map((data) => base64Encode(data)).toList(),
        "environment": model.environment,
        if (model.type != null) "type": model.type,
      });

      final response = await http.post(
        Uri.parse(functionUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $idToken",
        },
        body: body,
      );

      if (response.statusCode == 200) {
        return right(unit);
      } else {
        return left(BackendFailure());
      }
    } catch (e) {
      return left(BackendFailure());
    }
  }
}
