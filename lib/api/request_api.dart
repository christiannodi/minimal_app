// ignore_for_file: avoid_print

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:minimal_app/bloc/getcount_bloc/getcount_bloc.dart';
import 'package:minimal_app/models/add_cart_model.dart';
import 'package:minimal_app/models/count_model.dart';
import 'package:minimal_app/models/list_cart_model.dart';
import 'package:minimal_app/models/list_order_model.dart';
import 'package:minimal_app/models/list_shippingcost_model.dart';
import 'package:minimal_app/screen/login_page/login_page.dart';

import '../api/interceptor_request.dart';
import '../models/add_address_model.dart';
import '../models/edit_profile_model.dart';
import '../models/list_address_model.dart';
import '../models/list_product_model.dart';
import '../models/register_model.dart';
import '../models/secure_storage_flutter/secure_storage.dart';
import '../models/session_model.dart';
import '../models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/detail_product_model.dart';

class RequestApi {
  final dio = Dio(BaseOptions(baseUrl: dotenv.env['BASE_URL']!));

  //! REGISTER
  Future<Map<String, dynamic>> register(RegisterModel request) async {
    //! model yg dipake api
    try {
      final response = await dio.post('/users', data: request.toJson());

      // Print the response body to see its content
      print('Response Body: ${response.data}');

      // Return the data from response (assumes 'data' contains useful information)
      return response.data['data']; // Response berisi "id" dan "username"
    } catch (e) {
      if (e is DioException) {
        // Tangkap error dari respon API
        if (e.response != null && e.response?.data != null) {
          final errors = e.response?.data['errors'];
          throw Exception(errors); // Lempar pesan error dari API
        }
      }
      throw Exception(
          "Unexpected error occurred."); // Error default jika tidak ada respon API
    }
  }

  //! LOGIN
  Future<SessionModel> login(String username, String password) async {
    final FlutterSecureStorage secureStorage =
        FlutterSecureStorage(); //! import flutterstorage
    final response = await dio.post(
      '/users/me/sessions',
      data: {
        'username': username,
        'password': password,
      },
    );
    final session = SessionModel.fromJson(response.data['data']);
    print(response.data['data']);

    // Simpan tokens ke Secure Storage
    await secureStorage.write(key: 'access_token', value: session.accessToken);
    await secureStorage.write(
        key: 'refresh_token', value: session.refreshToken);

    print(session.accessToken);

    return session;
  }
}

class RequestApiHeader {
  final dio = Dio(BaseOptions(baseUrl: dotenv.env['BASE_URL']!));

  //! import flutterstorage
  final SecureStorageHelper secureStorageHelper;

  RequestApiHeader(this.secureStorageHelper) {
    dio.interceptors.add(AuthInterceptor(secureStorageHelper));
  }

  //! FUNCTION: POST GetCount
  Future<CountDataModel> getCount() async {
    try {
      // Kirim GET request ke endpoint '/users/profiles/me'
      final response = await dio.get('/orders-count');
      print('Response Body: ${response.data}');

      // Parsing JSON menjadi objek UserData
      final countModel = CountModel.fromJson(response.data);

      return countModel.countDataModel; // Kembalikan data as UserData
    } on DioException catch (e) {
      print('Dio Error: ${e.response?.statusCode}');
      print('Message: ${e.response?.data}');
      throw Exception(e.response?.data ?? 'Error occurred');
    } catch (e) {
      print('Error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  //! FUNCTION: POST GetUserData di Profile
  Future<UserDataModel> getUserInfo() async {
    try {
      // Kirim GET request ke endpoint '/users/profiles/me'
      final response = await dio.get('/users/me/profiles');
      print('Response Body: ${response.data}');

      // Parsing JSON menjadi objek UserData
      final userModel = UserModel.fromJson(response.data);

      return userModel.userDataModel; // Kembalikan data as UserData
    } on DioException catch (e) {
      print('Dio Error: ${e.response?.statusCode}');
      print('Message: ${e.response?.data}');
      throw Exception(e.response?.data ?? 'Error occurred');
    } catch (e) {
      print('Error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  //! FUNCTION EDIT PROFILE
  //? Tambahkan list jika hasil nya berupa list
  Future<Map<String, dynamic>> editProfile(EditProfileModel request) async {
    try {
      print(
          "📡 Data before sending: ${request.toJson()}"); // Debug sebelum dikirim
      final response =
          await dio.patch('/users/me/profiles', data: request.toJson());

      print("cek");
      // Print the response body to see its content
      print('Response Body: ${response.data}');

      // Return the data from response (assumes 'data' contains useful information)
      return response.data['data']; // Response berisi "id" dan "username"
    } catch (e) {
      if (e is DioException) {
        // Tangkap error dari respon API
        if (e.response != null && e.response?.data != null) {
          final errors = e.response?.data['errors'];
          throw Exception(errors); // Lempar pesan error dari API
        }
      }
      throw Exception(
          "Unexpected error occurred."); // Error default jika tidak ada respon API
    }
  }

  //! FUNCTION GET ALL PRODUCT
  //? Tambahkan list jika hasil nya berupa list
  Future<List<ProductDataModel>> getAllProduct() async {
    try {
      // Kirim GET request ke endpoint '/users/profiles/me'
      final response = await dio.get('/products?category=Shirt');
      print('Response Body: ${response.data}');

      // Parsing JSON menjadi objek UserData
      final productModel = ProductModel.fromJson(response.data);

      return productModel.productDataModel; // Kembalikan data as UserData
    } on DioException catch (e) {
      print('Dio Error: ${e.response?.statusCode}');
      print('Message: ${e.response?.data}');
      throw Exception(e.response?.data ?? 'Error occurred');
    } catch (e) {
      print('Error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  //! FUNCTION GET ALL PRODUCT2
  //? Tambahkan list jika hasil nya berupa list
  Future<List<ProductDataModel>> getAllProduct2() async {
    try {
      // Kirim GET request ke endpoint '/users/profiles/me'
      final response = await dio.get('/products?category=T-Shirt');
      print('Response Body: ${response.data}');

      // Parsing JSON menjadi objek UserData
      final productModel = ProductModel.fromJson(response.data);

      return productModel.productDataModel; // Kembalikan data as UserData
    } on DioException catch (e) {
      print('Dio Error: ${e.response?.statusCode}');
      print('Message: ${e.response?.data}');
      throw Exception(e.response?.data ?? 'Error occurred');
    } catch (e) {
      print('Error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  //! FUNCTION GET DETAIL PRODUCT

  Future<DetailProductDataModel> getDetailedProduct(int id) async {
    try {
      // Kirim GET request ke endpoint '/users/profiles/me'
      final response = await dio.get('/products/$id');
      print('Response Body: ${response.data}');

      // Parsing JSON menjadi objek UserData
      final detailProductModel = DetailProductModel.fromJson(response.data);

      return detailProductModel.detailProductDataModel;
    } on DioException catch (e) {
      print('Dio Error: ${e.response?.statusCode}');
      print('Message: ${e.response?.data}');
      throw Exception(e.response?.data ?? 'Error occurred');
    } catch (e) {
      print('Error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  //! FUNCTION GET ALL ADDRESS
  //? Tambahkan list jika hasil nya berupa list
  Future<List<AddressDataModel>> getAllAddress() async {
    try {
      // Kirim GET request ke endpoint '/users/profiles/me'
      final response = await dio.get('/users/me/addresses');
      print('Response Body: ${response.data}');

      // Parsing JSON menjadi objek UserData
      final addressModel = AddressModel.fromJson(response.data);

      return addressModel.addressDataModel; // Kembalikan data as UserData
    } on DioException catch (e) {
      print('Dio Error: ${e.response?.statusCode}');
      print('Message: ${e.response?.data}');
      throw Exception(e.response?.data ?? 'Error occurred');
    } catch (e) {
      print('Error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  //! FUNCTION ADD ADDRESS
  //? Tambahkan list jika hasil nya berupa list
  Future<Map<String, dynamic>> addAddress(AddAddressModel request) async {
    try {
      print(
          "📡 Data before sending: ${request.toJson()}"); // Debug sebelum dikirim
      final response =
          await dio.post('/users/me/addresses', data: request.toJson());

      print("cek");
      // Print the response body to see its content
      print('Response Body: ${response.data}');

      // Return the data from response (assumes 'data' contains useful information)
      return response.data['data']; // Response berisi "id" dan "username"
    } catch (e) {
      if (e is DioException) {
        // Tangkap error dari respon API
        if (e.response != null && e.response?.data != null) {
          final errors = e.response?.data['errors'];
          throw Exception(errors); // Lempar pesan error dari API
        }
      }
      throw Exception(
          "Unexpected error occurred."); // Error default jika tidak ada respon API
    }
  }

  //! FUNCTION EDIT ADDRESS
  //? Tambahkan list jika hasil nya berupa list
  Future<Map<String, dynamic>> editAddress(
      int addressId, AddAddressModel request) async {
    try {
      print("📡 Data before sending: ${request.toJson()}");
      print(addressId);
      final response = await dio.patch('/users/me/addresses/$addressId',
          data: request.toJson());

      print("cek");
      // Print the response body to see its content
      print('Response Body: ${response.data}');

      // Return the data from response (assumes 'data' contains useful information)
      return response.data['data']; // Response berisi "id" dan "username"
    } catch (e) {
      if (e is DioException) {
        // Tangkap error dari respon API
        if (e.response != null && e.response?.data != null) {
          final errors = e.response?.data['errors'];
          throw Exception(errors); // Lempar pesan error dari API
        }
      }
      throw Exception(
          "Unexpected error occurred."); // Error default jika tidak ada respon API
    }
  }

  //! DELETE ADDRESS
  Future<Map<String, dynamic>> deleteAddress(int addressId) async {
    try {
      // Kirim GET request ke endpoint '/users/profiles/me'
      final response = await dio.delete('/users/me/addresses/$addressId');

      print("Delete Response: ${response.data}");

      return response.data;
    } on DioException catch (e) {
      print('Dio Error: ${e.response?.statusCode}');
      print('Message: ${e.response?.data}');
      throw Exception(e.response?.data ?? 'Error occurred');
    } catch (e) {
      print('Error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  //! edit Phone Number
  Future<Map<String, dynamic>> editPhoneNumber(EditProfileModel request) async {
    try {
      print(
          "📡 Data before sending: ${request.toJson()}"); // Debug sebelum dikirim
      final response = await dio.patch('/users', data: request.toJson());

      print("cek");
      // Print the response body to see its content
      print('Response Body: ${response.data}');

      // Return the data from response (assumes 'data' contains useful information)
      return response.data['data']; // Response berisi "id" dan "username"
    } catch (e) {
      if (e is DioException) {
        // Tangkap error dari respon API
        if (e.response != null && e.response?.data != null) {
          final errors = e.response?.data['errors'];
          throw Exception(errors); // Lempar pesan error dari API
        }
      }
      throw Exception(
          "Unexpected error occurred."); // Error default jika tidak ada respon API
    }
  }

  //! Edit Foto Profile
  Future<Map<String, dynamic>> uploadAvatar(String filePath) async {
    try {
      FormData formData = FormData.fromMap({
        "avatar": await MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last, // Pastikan filename benar
        ),
      });

      final response = await dio.post(
        '/users/me/avatar',
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data", // Pastikan tipe data benar
          },
        ),
      );

      if (response.data is Map<String, dynamic>) {
        return response.data['data'] ?? {};
      } else {
        throw Exception("Unexpected response format");
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          throw Exception(e.response?.data['errors'] ?? "Upload failed");
        }
      }
      throw Exception("Unexpected error occurred.");
    }
  }

  //! ADD CART
  //? Tambahkan list jika hasil nya berupa list
  Future<Map<String, dynamic>> addCart(AddCartModel request) async {
    try {
      print(
          "📡 Data before sending: ${request.toJson()}"); // Debug sebelum dikirim
      final response = await dio.post('/cart', data: request.toJson());

      print("cek");
      // Print the response body to see its content
      print('Response Body: ${response}');

      // Return the data from response (assumes 'data' contains useful information)
      return response.data['data'];
    } catch (e) {
      if (e is DioException) {
        // Tangkap error dari respon API
        if (e.response != null && e.response?.data != null) {
          final errors = e.response?.data['errors'];
          throw Exception(errors); // Lempar pesan error dari API
        }
      }
      throw Exception(
          "Unexpected error occurred."); // Error default jika tidak ada respon API
    }
  }

  //! FUNCTION GET ALL CART
  //? Tambahkan list jika hasil nya berupa list
  Future<List<CartDataModel>> getAllCart() async {
    try {
      // Kirim GET request ke endpoint '/users/profiles/me'
      final response = await dio.get('/cart');
      print('Response Body: ${response.data}');

      // Parsing JSON menjadi objek UserData
      final cartModel = CartModel.fromJson(response.data);

      return cartModel.cartDataModel; // Kembalikan data as UserData
    } on DioException catch (e) {
      print('Dio Error: ${e.response?.statusCode}');
      print('Message: ${e.response?.data}');
      throw Exception(e.response?.data ?? 'Error occurred');
    } catch (e) {
      print('Error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  //! DELETE CART
  Future<Map<String, dynamic>> deleteCart(int cartId) async {
    try {
      final response = await dio.delete('/cart/$cartId');

      print("Delete Response: ${response.data}");

      return response.data;
    } on DioException catch (e) {
      print('Dio Error: ${e.response?.statusCode}');
      print('Message: ${e.response?.data}');
      throw Exception(e.response?.data ?? 'Error occurred');
    } catch (e) {
      print('Error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  //! FUNCTION GET SHIPPING COST
  //? Tambahkan list jika hasil nya berupa list
  Future<List<ShippingcostDataModel>> getShippingCost(
      Map<String, dynamic> request) async {
    try {
      print("📡 Shipping cost request: $request");
      final response = await dio.get('/shipping-cost', data: request);

      print('response: ${response.data}');

      final shippingCostModel = ShippingcostModel.fromJson(response.data);

      return shippingCostModel.shippingcostDataModel;
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ?? 'Failed to get shipping cost';
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception("Failed to calculate shipping cost");
    }
  }

  //! FUNCTION POST ORDER
  //? Tambahkan list jika hasil nya berupa list
  Future<Map<String, dynamic>> addOrder(AddAddressModel request) async {
    try {
      print("📡 Shipping cost request: $request");
      final response = await dio.post('/orders', data: request.toJson());

      print('response: ${response.data}');

      return response.data['data']; // Response berisi "id" dan "username"
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ?? 'Failed to get shipping cost';
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception("Failed to calculate shipping cost");
    }
  }

  //! FUNCTION GET ALL ORDER MUST PAY
  //? Tambahkan list jika hasil nya berupa list
  Future<List<OrderListDataModel>> getAllOrder() async {
    try {
      // Kirim GET request ke endpoint '/users/profiles/me'
      final response = await dio.get('/orders?status=Pending');
      print('Response Body: ${response.data}');

      // Parsing JSON menjadi objek UserData
      final orderList = OrderListModel.fromJson(response.data);

      return orderList.orderListDataModel; // Kembalikan data as UserData
    } on DioException catch (e) {
      print('Dio Error: ${e.response?.statusCode}');
      print('Message: ${e.response?.data}');
      throw Exception(e.response?.data ?? 'Error occurred');
    } catch (e) {
      print('Error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  //! FUNCTION GET ALL ORDER PAID
  //? Tambahkan list jika hasil nya berupa list
  Future<List<OrderListDataModel>> getAllOrderPaid() async {
    try {
      // Kirim GET request ke endpoint '/users/profiles/me'
      final response = await dio.get('/orders?status=Paid');
      print('Response Body: ${response.data}');

      // Parsing JSON menjadi objek UserData
      final orderList = OrderListModel.fromJson(response.data);

      return orderList.orderListDataModel; // Kembalikan data as UserData
    } on DioException catch (e) {
      print('Dio Error: ${e.response?.statusCode}');
      print('Message: ${e.response?.data}');
      throw Exception(e.response?.data ?? 'Error occurred');
    } catch (e) {
      print('Error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  //! FUNCTION GET ALL ORDER PAID
  //? Tambahkan list jika hasil nya berupa list
  Future<List<OrderListDataModel>> getAllOrderReview() async {
    try {
      // Kirim GET request ke endpoint '/users/profiles/me'
      final response = await dio.get('/orders?status=Shipped');
      print('Response Body: ${response.data}');

      // Parsing JSON menjadi objek UserData
      final orderList = OrderListModel.fromJson(response.data);

      return orderList.orderListDataModel; // Kembalikan data as UserData
    } on DioException catch (e) {
      print('Dio Error: ${e.response?.statusCode}');
      print('Message: ${e.response?.data}');
      throw Exception(e.response?.data ?? 'Error occurred');
    } catch (e) {
      print('Error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  //! PAYNOW
  Future<Map<String, dynamic>> payNow(
      int orderId, AddAddressModel request) async {
    try {
      // Kirim GET request ke endpoint '/users/profiles/me'
      final response =
          await dio.patch('/orders/$orderId', data: request.toJson());

      print("Delete Response: ${response.data}");

      return response.data;
    } on DioException catch (e) {
      print('Dio Error: ${e.response?.statusCode}');
      print('Message: ${e.response?.data}');
      throw Exception(e.response?.data ?? 'Error occurred');
    } catch (e) {
      print('Error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  //!LOGOUT
  Future<void> logout(BuildContext context) async {
    try {
      final response = await dio.delete('/users/me/sessions/all');

      print("Logout Response: ${response.data}");

      // Hapus semua data di Secure Storage setelah logout
      await secureStorageHelper.clear();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } catch (e) {
      print("Logout Error: $e");
    }
  }
}
