import 'dart:convert';

import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/uploaded_file.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

class VerifyOtpCall {
  static Future<ApiCallResponse> call({
    String? idToken =
        'eyJhbGciOiJSUzI1NiIsImtpZCI6IjM4MDI5MzRmZTBlZWM0NmE1ZWQwMDA2ZDE0YTFiYWIwMWUzNDUwODMiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vb3dsLWJ5LXNlcmVuZS1taW5kcyIsImF1ZCI6Im93bC1ieS1zZXJlbmUtbWluZHMiLCJhdXRoX3RpbWUiOjE3NjM0MDI0NDEsInVzZXJfaWQiOiJzcWJpend3dnNRTW1aejdPbXFickh0RkFhbXUxIiwic3ViIjoic3FiaXp3d3ZzUU1tWno3T21xYnJIdEZBYW11MSIsImlhdCI6MTc2MzQwMjQ0MSwiZXhwIjoxNzYzNDA2MDQxLCJwaG9uZV9udW1iZXIiOiIrOTE2Mzg4OTU1MTY0IiwiZmlyZWJhc2UiOnsiaWRlbnRpdGllcyI6eyJwaG9uZSI6WyIrOTE2Mzg4OTU1MTY0Il19LCJzaWduX2luX3Byb3ZpZGVyIjoicGhvbmUifX0.AcCqdGzPgohHPFL3W9W-0z7Xzr7Hv-Zcl8TNQsyx6hmNLLD_h6zIzRtnFBdwUkg0vYLl_r_lsanY1pXDiS02IhhmeehhcciwdHTCWmREp6gQUPlI4ibApeCYuZMulX5qOyTwGyMcZSNZGyxZ7brf-DJ8jXfaVgSdxaZNENW00jSxaILJJOngeWhk0khjqkRcT92vcdcZXgpHUIwbXwg8qBhM26jmMJYq0duvQdBdPTdGfom0aL3J9nZsSSaiLP9Ud4yhCGEdl5KE2DX1Hb_DbCkFusY0fzwcJ8bP-YHSQs3kjZdvwBGrtBv_V2uIlr33FJ6EievadFCg3m2cAWPk7Q',
  }) async {
    final ffApiRequestBody = '''
{"idToken":"${escapeStringForJson(idToken)}"}''';
    return ApiManager.instance.makeApiCall(
      callName: 'verifyOtp',
      apiUrl: 'https://owl-app-backend.vercel.app/api/auth/firebase-login',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? status(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.status''',
      ));
  static String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  static dynamic data(dynamic response) => getJsonField(
        response,
        r'''$.data''',
      );
  static dynamic dataerror(dynamic response) => getJsonField(
        response,
        r'''$.data.error''',
      );
  static String? dataerrorcode(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.data.error.code''',
      ));
  static String? dataerrormessage(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$.data.error.message''',
      ));
}

// create new account on backend // DONE 👍👍👍
class UsersignupCall {
  static Future<ApiCallResponse> call({
    String? fullName = '',
    String? email = '',
    String? organizationName = '',
    String? referralCode = '',
    String? phoneNumber = '',
  }) {
    final Map<String, dynamic> bodyMap = {
      "full_name": fullName,
      "email": email,
      "organization_name": organizationName,
      "phone_number": phoneNumber,
    };

    if (referralCode != null && referralCode.isNotEmpty) {
      bodyMap["referral_code"] = referralCode;
    }

    final body = jsonEncode(bodyMap);

    return ApiManager.instance.makeApiCall(
      callName: 'usersignup',
      apiUrl: 'https://owl-app-backend.vercel.app/api/auth/signup',
      callType: ApiCallType.POST,
      headers: {'Content-Type': 'application/json'},
      body: body,
      bodyType: BodyType.JSON,
      returnBody: true,
    );
  }

  static bool? success(ApiCallResponse response) => castToType<bool>(
        getJsonField(response.jsonBody, r'$.status'),
      );

  static String? message(ApiCallResponse response) => castToType<String>(
        getJsonField(response.jsonBody, r'$.message'),
      );
}

class GetUserDetails {
  static Future<ApiCallResponse> call({
    required String phoneNumber,
  }) {
    return ApiManager.instance.makeApiCall(
      callName: 'checkuser',
      apiUrl: 'https://owl-app-backend.vercel.app/api/auth/user-by-phone',
      callType: ApiCallType.POST,
      headers: {'Content-Type': 'application/json'},
      body: '''
      {
        "phone_number": "$phoneNumber"
      } 
      ''',
      bodyType: BodyType.JSON,
    );
  }

  static bool userExists(ApiCallResponse response) {
    return response.jsonBody?['status'] == true;
  }
}

// check number of session left

class GetSessionLeft {
  static Future<ApiCallResponse> call({
    required String userId,
  }) {
    return ApiManager.instance.makeApiCall(
      callName: 'getSessionLeft',
      apiUrl: 'https://owl-app-backend.vercel.app/api/auth/sessions',
      callType: ApiCallType.POST,
      headers: {'Content-Type': 'application/json'},
      body: '''
      {
        "user_id": "$userId"
      } 
      ''',
      bodyType: BodyType.JSON,
    );
  }

  static int sessionsLeft(ApiCallResponse response) {
    return response.jsonBody?['data']?['sessionsLeft'] ?? 0;
  }
}

// check user api // DONE 👍👍👍
class CheckUserApi {
  static Future<ApiCallResponse> call({
    required String phoneNumber,
  }) {
    return ApiManager.instance.makeApiCall(
      callName: 'checkuser',
      apiUrl: 'https://owl-app-backend.vercel.app/api/auth/check-user',
      callType: ApiCallType.POST,
      headers: {'Content-Type': 'application/json'},
      body: '''
      {
        "phone_number": "$phoneNumber"
      } 
      ''',
      bodyType: BodyType.JSON,
    );
  }

  static bool userExists(ApiCallResponse response) {
    return response.jsonBody?['data']?['user_exists'] == true;
  }
}

// to create meeting ///❤️❤️❤️❤️ // DONE 👍👍👍👍
class CreatemeetingCall {
  static Future<ApiCallResponse> call({
    String? userId = '',
    String? meetingDate = '',
    String? meetingTime = '',
    int? duration,
    String? professionalName = '',
  }) async {
    final ffApiRequestBody = '''
{
  "user_id": "${escapeStringForJson(userId)}",
  "meeting_date":"${escapeStringForJson(meetingDate)}",
  "meeting_time":"${escapeStringForJson(meetingTime)}",
  "duration": ${duration},
  "professional_name":"${escapeStringForJson(professionalName)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'createmeeting',
      apiUrl: 'https://owl-app-backend.vercel.app/api/meeting/create',
      callType: ApiCallType.POST,
      headers: {
        'Content-type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

// process meeting call // ❤️❤️❤️
class ProcessmeetingCall {
  static Future<ApiCallResponse> call({
    String? meetingId = '',
    String? meetingTitle = '',
    String? name = '',
    String? email = '',
    String? participants = '',
    String? startTime = '',
    String? provider = '',
  }) async {
    final ffApiRequestBody = '''
{
  "meetingId":"${escapeStringForJson(meetingId)}",
  "meetingMeta": {
    "meeting_id": "${escapeStringForJson(meetingId)}",
    "meetingInfo":{
      "meetingTitle": "${escapeStringForJson(meetingTitle)}"
    },
    "googleUser": {
      "name": "${escapeStringForJson(name)}",
      "email":"${escapeStringForJson(email)}"
    },
    "participants": [
      "${escapeStringForJson(participants)}"
    ],
    "startTime": "${escapeStringForJson(startTime)}"
  },
  "provider": "${escapeStringForJson(provider)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'processmeeting',
      apiUrl: 'https://owl-app-backend.vercel.app/api/meeting/process-meeting',
      callType: ApiCallType.POST,
      headers: {
        'Content-type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static dynamic bn(dynamic response) => getJsonField(
        response,
        r'''$''',
      );
}

// for uploading file to backend .. IMPORTANT // DONE 👍👍👍
class UploadrecordingCall {
  static Future<ApiCallResponse> call({
    String? meetingId = '',
    String? userId = '',
    String? professionalName = '',
    FFUploadedFile? file,
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'uploadrecording',
      apiUrl: 'https://owl-app-backend.vercel.app/api/meeting/upload',
      callType: ApiCallType.POST,
      headers: {},
      params: {
        'meeting_id': meetingId,
        'user_id': userId,
        'professional_name': professionalName,
        'file': file,
      },
      bodyType: BodyType.MULTIPART,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static dynamic jgf(dynamic response) => getJsonField(
        response,
        r'''$''',
      );
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  if (item is DocumentReference) {
    return item.path;
  }
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}

String? escapeStringForJson(String? input) {
  if (input == null) {
    return null;
  }
  return input
      .replaceAll('\\', '\\\\')
      .replaceAll('"', '\\"')
      .replaceAll('\n', '\\n')
      .replaceAll('\t', '\\t');
}
