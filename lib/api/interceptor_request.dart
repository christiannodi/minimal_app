import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:minimal_app/screen/login_page/login_page.dart';

import '../models/secure_storage_flutter/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../main.dart'; // Import global navigatorKey dari main.dart

class AuthInterceptor extends Interceptor {
  final SecureStorageHelper secureStorageHelper;

  AuthInterceptor(this.secureStorageHelper);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print("On Request Interceptor");
    print("🔹 [REQUEST] ${options.method} ${options.uri}");
    print("🔹 Headers: ${options.headers}");
    print("🔹 Body: ${options.data}");

    // Ambil access token dari Secure Storage
    final accessToken = await secureStorageHelper.getAccessToken();

    // Jika ada access token, tambahkan ke header Authorization
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    // Lanjutkan request
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Periksa jika status error adalah 401 Unauthorized
    if (err.response?.statusCode == 401) {
      try {
        print("Coba menggunakan refresh token untuk meminta access token");

        // Ambil refresh token dari Secure Storage
        final refreshToken = await secureStorageHelper.getRefreshToken();
        if (refreshToken == null) throw Exception("No refresh token available");

        // Kirim request untuk refresh token
        // final dio = Dio();
        final baseUrlEnv = dotenv.env['BASE_URL']!;
        final dio = Dio(BaseOptions(baseUrl: baseUrlEnv));
        final response = await dio.post(
          '/users/me/sessions/refresh',
          options: Options(headers: {
            'Authorization': 'Bearer $refreshToken',
          }),
        );

        // Ambil token baru dari response
        final newAccessToken = response.data['data']['access_token'];
        final newRefreshToken = response.data['data']['refresh_token'];

        // Simpan token baru ke Secure Storage
        await secureStorageHelper.save('access_token', newAccessToken);
        await secureStorageHelper.save('refresh_token', newRefreshToken);

        // Update header Authorization dengan token baru
        err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

        // Ulangi request yang gagal dengan token baru
        final retryResponse = await Dio().fetch(err.requestOptions);
        return handler.resolve(retryResponse);
      }
      //!JIKA REQUEST REFRESH TOKEN GAGAL
      catch (e) {
        // Jika refresh token gagal, lempar error
        print("Refresh token gagal: $e");

        // Hapus semua data sesi pengguna
        await secureStorageHelper.clear();

        // Arahkan ke halaman login menggunakan navigatorKey
        //!jika eror tambahkan navigator key di main.dart
        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false, // Menghapus semua halaman sebelumnya
        );

        return handler.reject(err);
      }
    }

    // Jika bukan 401, teruskan error
    super.onError(err, handler);
  }
}
