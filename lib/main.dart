import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:minimal_app/api/request_api.dart';
import 'package:minimal_app/bloc/addaddress_bloc/addaddress_bloc.dart';
import 'package:minimal_app/bloc/addcart_bloc/addcart_bloc.dart';
import 'package:minimal_app/bloc/addorder_bloc/addorder_bloc.dart';
import 'package:minimal_app/bloc/deleteaddress_bloc/deleteaddress_bloc.dart';
import 'package:minimal_app/bloc/deletecart/deletecart_bloc.dart';
import 'package:minimal_app/bloc/editavatar_bloc/editavatar_bloc.dart';
import 'package:minimal_app/bloc/getalladdress_bloc/getalladdress_bloc_bloc.dart';
import 'package:minimal_app/bloc/getallcart_bloc/getallcart_bloc.dart';
import 'package:minimal_app/bloc/getallproduct2_bloc/getallproduct2_bloc.dart';
import 'package:minimal_app/bloc/getallproduct_bloc/getallproduct_bloc.dart';
import 'package:minimal_app/bloc/getdetailedproduct_bloc/getdetailedproduct_bloc.dart';
import 'package:minimal_app/bloc/getorder_bloc/getorder_bloc.dart';
import 'package:minimal_app/bloc/getorderpaid_bloc/getorder_bloc.dart';
import 'package:minimal_app/bloc/getshippingcost_bloc/getshippingcost_bloc.dart';
import 'package:minimal_app/bloc/getuserdata_bloc/getuserdata_bloc.dart';
import 'package:minimal_app/bloc/login_bloc/login_bloc.dart';
import 'package:minimal_app/bloc/paynow_bloc/paynow_bloc.dart';
import 'package:minimal_app/bloc/register_bloc/register_bloc.dart';
import 'package:minimal_app/models/secure_storage_flutter/secure_storage.dart';
import 'package:minimal_app/screen/bottom_bar/bottom_bar.dart';
import 'bloc/editaddress_bloc/editaddress_bloc.dart';
import 'bloc/editphonenumber_bloc/editphonenumber_bloc.dart';
import 'bloc/editprofile_bloc/editprofile_bloc.dart';
import 'bloc/getcount_bloc/getcount_bloc.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final secureStorageHelper = SecureStorageHelper();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => RegisterBloc(requestApi: RequestApi())),
        BlocProvider(
          create: (context) => LoginBloc(requestApi: RequestApi()),
        ),
        BlocProvider(
          create: (context) => GetuserdataBloc(
            requestApiHeader: RequestApiHeader(secureStorageHelper),
          ),
        ),
        BlocProvider(
          create: (context) => AddaddressBloc(
            requestApiHeader: RequestApiHeader(secureStorageHelper),
          ),
        ),
        BlocProvider(
          create: (context) => DeleteaddressBloc(
            requestApiHeader: RequestApiHeader(secureStorageHelper),
          ),
        ),
        BlocProvider(
          create: (context) => EditphonenumberBloc(
            requestApiHeader: RequestApiHeader(secureStorageHelper),
          ),
        ),
        BlocProvider(
          create: (context) => EditprofileBloc(
            requestApiHeader: RequestApiHeader(secureStorageHelper),
          ),
        ),
        BlocProvider(
          create: (context) => EditaddressBloc(
            requestApiHeader: RequestApiHeader(secureStorageHelper),
          ),
        ),
        BlocProvider(
          create: (context) => EditavatarBloc(
            requestApiHeader: RequestApiHeader(secureStorageHelper),
          ),
        ),
        BlocProvider(
          create: (context) => GetalladdressBloc(
            requestApiHeader: RequestApiHeader(secureStorageHelper),
          ),
        ),
        BlocProvider(
          create: (context) => GetallproductBloc(
            requestApiHeader: RequestApiHeader(secureStorageHelper),
          ),
        ),
        BlocProvider(
          create: (context) => GetdetailedproductBloc(
            requestApiHeader: RequestApiHeader(secureStorageHelper),
          ),
        ),
        BlocProvider(
          create: (context) => AddcartBloc(
            requestApiHeader: RequestApiHeader(secureStorageHelper),
          ),
        ),
        BlocProvider(
          create: (context) => GetallcartBloc(
            requestApiHeader: RequestApiHeader(secureStorageHelper),
          ),
        ),
        BlocProvider(
          create: (context) => DeletecartBloc(
            requestApiHeader: RequestApiHeader(secureStorageHelper),
          ),
        ),
        BlocProvider(
          create: (context) => GetshippingcostBloc(
            requestApiHeader: RequestApiHeader(secureStorageHelper),
          ),
        ),
        BlocProvider(
          create: (context) => AddorderBloc(
            requestApiHeader: RequestApiHeader(secureStorageHelper),
          ),
        ),
        BlocProvider(
          create: (context) => GetcountBloc(
            requestApiHeader: RequestApiHeader(secureStorageHelper),
          ),
        ),
        BlocProvider(
          create: (context) => GetorderBloc(
            requestApiHeader: RequestApiHeader(secureStorageHelper),
          ),
        ),
        BlocProvider(
          create: (context) => PaynowBloc(
            requestApiHeader: RequestApiHeader(secureStorageHelper),
          ),
        ),
        BlocProvider(
          create: (context) => GetorderpaidBloc(
            requestApiHeader: RequestApiHeader(secureStorageHelper),
          ),
        ),
        BlocProvider(
          create: (context) => Getallproduct2Bloc(
            requestApiHeader: RequestApiHeader(secureStorageHelper),
          ),
        ),
      ],
      child: MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          home: MainPage()),
    );
  }
}
