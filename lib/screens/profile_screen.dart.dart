import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_ecommerce/models/user_model.dart';
import 'package:riverpod_ecommerce/provider/auth_provider.dart';
import 'package:riverpod_ecommerce/utils/app_toast.dart';
import 'package:riverpod_ecommerce/utils/capitaliaze.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final UserModel user;
  const ProfileScreen({super.key, required this.user});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    // ref.listen<AsyncValue<String>>(authProvider, (prev, next) {
    //   if (prev != next) {
    //     next.whenOrNull(
    //       data: (message) {
    //         if (message.isNotEmpty) {
    //           AppToast.show(
    //             context,
    //             message,
    //             type: ToastTypes.success,
    //             position: ToastPosition.bottom,
    //             duration: Duration(seconds: 5),
    //           );

    //           Future.microtask(() {
    //             if (!context.mounted) return;
    //             ref.read(authProvider.notifier).reset();

    //             Navigator.popAndPushNamed(context, '/');
    //           });
    //         }
    //       },
    //       error: (e, _) {
    //         AppToast.show(
    //           context,
    //           e.toString(),
    //           type: ToastTypes.error,
    //           position: ToastPosition.bottom,
    //           duration: Duration(seconds: 5),
    //         );
    //       },
    //     );
    //   }
    // });
    return Scaffold(
      appBar: AppBar(title: Text('Profile', style: TextStyle(fontSize: 18))),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/images/avatar.png'),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Full Name',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                  ),
                  Text(
                    capitalizeFirstLetter(widget.user.name),
                    style: TextStyle(fontSize: 14.5),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Email',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                  ),
                  Text(widget.user.email, style: TextStyle(fontSize: 14.5)),
                ],
              ),
              SizedBox(height: 20),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   mainAxisSize: MainAxisSize.max,
              //   children: [
              //     Text(
              //       'Username',
              //       style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
              //     ),
              //     Text(widget.user.username, style: TextStyle(fontSize: 14.5)),
              //   ],
              // ),
              // SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final result = await ref.read(authProvider.notifier).logOut();
                  if (result) {
                    if (!context.mounted) return;
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/',
                      (Route<dynamic> route) => false,
                    );
                    AppToast.show(
                      context,
                      'Logout successful',
                      type: ToastTypes.success,
                      position: ToastPosition.bottom,
                      duration: Duration(seconds: 5),
                    );
                  } else {
                    AppToast.show(
                      context,
                      'failed to logout',
                      type: ToastTypes.error,
                      position: ToastPosition.bottom,
                      duration: Duration(seconds: 5),
                    );
                  }
                },
                child: Text('Log Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
