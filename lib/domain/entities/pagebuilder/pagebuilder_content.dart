// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:finanzbegleiter/domain/entities/landing_page.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_page.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';

class PagebuilderContent extends Equatable {
  final LandingPage? landingPage;
  final PageBuilderPage? content;
  final CustomUser? user;
  
  const PagebuilderContent({
    required this.landingPage,
    required this.content,
    required this.user,
  });

  PagebuilderContent copyWith({
    LandingPage? landingPage,
    PageBuilderPage? content,
    CustomUser? user,
  }) {
    return PagebuilderContent(
      landingPage: landingPage ?? this.landingPage,
      content: content ?? this.content,
      user: user ?? this.user,
    );
  }
  
  @override
  List<Object?> get props => [landingPage, content, user];
}
