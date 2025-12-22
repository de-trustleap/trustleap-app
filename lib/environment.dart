import 'package:flutter/foundation.dart';
import 'package:web/web.dart' as web;

class Environment {
  final prodBaseURL = "app.trust-leap.de";
  final stagingBaseURL = "staging.trust-leap.de";

  final landingPageProdBaseURL = "https://empfohlen-von.de";
  final landingPageStagingBaseURL = "https://staging.empfohlen-von.de";

  final cloudFunctionsProdBaseURL =
      "https://europe-west3-finanzwegbegleiter.cloudfunctions.net";
  final cloudFunctionsStagingBaseURL =
      "https://europe-west3-trustleap-staging.cloudfunctions.net";

  bool isStaging() {
    final String currentUrl = web.window.location.hostname;
    final bool isStaging = currentUrl.contains(stagingBaseURL) ||
        !const bool.fromEnvironment("dart.vm.product");
    return isStaging;
  }

  String getAppCheckToken() {
    if (isStaging()) {
      if (kDebugMode) {
        return "a323d75a-66be-445f-aca5-efdf1a120d3e";
      } else {
        return "6LeQCdQqAAAAAKGfloIpjaK8QSnXYAI3E9Lyljtq";
      }
    } else {
      if (kDebugMode) {
        return "A0791EC5-107E-4C90-BF82-34E5FE2EA2DF";
      } else {
        return "6LcVOGMqAAAAAAzRRZjRjkO5o-xtO4H2X_ZbN9r2";
      }
    }
  }

  String getLandingpageBaseURL() {
    if (isStaging()) {
      return landingPageStagingBaseURL;
    } else {
      return landingPageProdBaseURL;
    }
  }

  String getBaseURL() {
    if (isStaging()) {
      return stagingBaseURL;
    } else {
      return prodBaseURL;
    }
  }

  String getCloudFunctionsBaseURL() {
    if (isStaging()) {
      return cloudFunctionsStagingBaseURL;
    } else {
      return cloudFunctionsProdBaseURL;
    }
  }
}
