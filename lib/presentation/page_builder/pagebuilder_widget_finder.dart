import 'package:finanzbegleiter/domain/entities/id.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_page.dart';
import 'package:finanzbegleiter/domain/entities/pagebuilder/pagebuilder_widget.dart';

class PagebuilderWidgetFinder {
  PageBuilderWidget? findWidgetById(PageBuilderPage page, UniqueID widgetId) {
    // Durchsuche alle Sections im PageBuilderPage
    for (var section in page.sections ?? []) {
      // Durchsuche alle Widgets in der Section
      for (var widget in section.widgets ?? []) {
        // Überprüfe, ob das aktuelle Widget die gesuchte ID hat
        if (widget.id == widgetId) {
          return widget;
        }

        // Wenn das Widget einen containerChild hat, durchsuche ihn auch
        if (widget.containerChild != null) {
          final foundInContainerChild =
              _findInContainerChild(widget.containerChild!, widgetId);
          if (foundInContainerChild != null) {
            return foundInContainerChild;
          }
        }

        // Wenn das Widget Kinder hat, durchsuche sie rekursiv
        if (widget.children != null && widget.children!.isNotEmpty) {
          final foundInChildren = _findInChildren(widget.children!, widgetId);
          if (foundInChildren != null) {
            return foundInChildren;
          }
        }
      }
    }
    // Wenn das Widget nicht gefunden wurde, gebe null zurück
    return null;
  }

  PageBuilderWidget? _findInContainerChild(
      PageBuilderWidget containerChild, UniqueID widgetId) {
    // Rekursive Suche im containerChild
    if (containerChild.id == widgetId) {
      return containerChild;
    }
    if (containerChild.children != null &&
        containerChild.children!.isNotEmpty) {
      return _findInChildren(containerChild.children!, widgetId);
    }
    return null;
  }

  PageBuilderWidget? _findInChildren(
      List<PageBuilderWidget> children, UniqueID widgetId) {
    // Rekursive Suche in den Kindern eines Widgets
    for (var child in children) {
      if (child.id == widgetId) {
        return child;
      }

      // Durchsuche containerChild, falls vorhanden
      if (child.containerChild != null) {
        final foundInContainerChild =
            _findInContainerChild(child.containerChild!, widgetId);
        if (foundInContainerChild != null) {
          return foundInContainerChild;
        }
      }

      // Rekursive Suche in den Children des aktuellen Childs
      if (child.children != null && child.children!.isNotEmpty) {
        final foundInChild = _findInChildren(child.children!, widgetId);
        if (foundInChild != null) {
          return foundInChild;
        }
      }
    }
    return null;
  }
}