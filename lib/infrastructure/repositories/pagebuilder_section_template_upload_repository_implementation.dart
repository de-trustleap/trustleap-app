import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder_section_template_upload.dart';
import 'package:finanzbegleiter/domain/repositories/pagebuilder_section_template_upload_repository.dart';
import 'package:finanzbegleiter/environment.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder_section_template_upload_model.dart';
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
      // Get current user
      final user = firebaseAuth.currentUser;
      if (user == null) {
        return left(BackendFailure());
      }

      // Get ID token
      final idToken = await user.getIdToken();
      if (idToken == null) {
        return left(BackendFailure());
      }

      // Get App Check token
      final appCheckToken = await appCheck.getToken();

      // Get function URL from environment
      final functionUrl =
          '${environment.getCloudFunctionsBaseURL()}/uploadPagebuilderSectionTemplate';

      final model = PagebuilderSectionTemplateUploadModel.fromDomain(template);

      // Prepare request body
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

      // Make HTTP POST request
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
        print("ERROR: ${response.statusCode} - ${response.body}");
        return left(BackendFailure());
      }
    } catch (e) {
      print("ERROR: $e");
      return left(BackendFailure());
    }
  }
}
