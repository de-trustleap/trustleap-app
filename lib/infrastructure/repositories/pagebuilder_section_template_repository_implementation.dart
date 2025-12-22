import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:finanzbegleiter/core/failures/database_failures.dart';
import 'package:finanzbegleiter/core/firebase_exception_parser.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section_template.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_section_template_meta.dart';
import 'package:finanzbegleiter/domain/repositories/pagebuilder_section_template_repository.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_section_template_meta_model.dart';
import 'package:finanzbegleiter/infrastructure/models/pagebuilder/pagebuilder_section_template_model.dart';

class PagebuilderSectionTemplateRepositoryImplementation
    implements PagebuilderSectionTemplateRepository {
  final FirebaseFirestore firestore;

  PagebuilderSectionTemplateRepositoryImplementation(this.firestore);

  @override
  Future<Either<DatabaseFailure, List<PagebuilderSectionTemplateMeta>>>
      getAllTemplateMetas() async {
    try {
      final querySnapshot =
          await firestore.collection("landingPageSectionsTemplatesMeta").get();

      final List<PagebuilderSectionTemplateMeta> metas = [];

      for (var doc in querySnapshot.docs) {
        final model = PagebuilderSectionTemplateMetaModel.fromFirestore(
          doc.data(),
          doc.id,
        );
        metas.add(model.toDomain());
      }

      return right(metas);
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    } catch (e) {
      return left(BackendFailure());
    }
  }

  @override
  Future<Either<DatabaseFailure, PagebuilderSectionTemplate>> getTemplateById(
      String id) async {
    try {
      final docSnapshot = await firestore
          .collection("landingPageSectionsTemplates")
          .doc(id)
          .get();

      if (!docSnapshot.exists || docSnapshot.data() == null) {
        return left(NotFoundFailure());
      }

      final model = PagebuilderSectionTemplateModel.fromFirestore(
        docSnapshot.data()!,
        docSnapshot.id,
      );

      final domainEntity = model.toDomain(null);

      return right(domainEntity);
    } on FirebaseException catch (e) {
      return left(FirebaseExceptionParser.getDatabaseException(code: e.code));
    } catch (e) {
      return left(BackendFailure());
    }
  }
}
