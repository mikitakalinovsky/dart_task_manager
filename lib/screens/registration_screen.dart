import 'package:dart_task_manager/bloc/connectivity_bloc/connectivity_bloc.dart';
import 'package:dart_task_manager/bloc/user_bloc/user_bloc.dart';
import 'package:dart_task_manager/bloc/user_bloc/user_event.dart';
import 'package:dart_task_manager/bloc/validation_bloc/registration_bloc.dart';
import 'package:dart_task_manager/constants.dart';
import 'package:dart_task_manager/models/user.dart';
import 'package:dart_task_manager/repository/auth_repo.dart';
import 'package:dart_task_manager/repository/ids_repo.dart';
import 'package:dart_task_manager/utils/utils.dart';
import 'package:dart_task_manager/widgets/text_input_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:hive/hive.dart';
import 'package:uiblock/uiblock.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegistrationScreen();
}

class _RegistrationScreen extends State<RegistrationScreen> {
  User currentUser;

  FocusNode loginNode = FocusNode();
  FocusNode passNode = FocusNode();

  Future<void> register(String login, String pass) async {
    bool isOnline = context.read<ConnectivityBloc>().state;
    if (!isOnline) {
      snackBarNotification(context, "Отсутствует подключение к интернету.",
          duration: 2);
    } else {
      AuthorisationRepository repository = new AuthorisationRepository();

      int newId = await IdRepository().getLastCreatedUserId();

      currentUser = new User(newId, login, pass);
      context.read<UserBloc>().add(SetUserEvent(currentUser));

      var listBox = await Hive.openBox<User>('userBox');
      listBox.clear();
      listBox.put('user', currentUser);
      listBox.close();

      context.read<RegistrationFormBloc>().clear();

      repository.addUser(currentUser);
      snackBarNotification(context, "Успешно зарегестрирован.", duration: 1);
      Navigator.pushReplacementNamed(context, "homeScreen");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
          ),
          systemOverlayStyle: Utils.statusBarColor(),
          backgroundColor: backgroundColor,
          title: Text(
            "DTM",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: backgroundColor,
        body: Builder(builder: (context) {
          var registrationBloc = BlocProvider.of<RegistrationFormBloc>(context);

          return FormBlocListener<RegistrationFormBloc, String, String>(
            onSubmitting: (context, state) {
              UIBlock.block(context);
            },
            onSuccess: (context, state) async {
              UIBlock.unblock(context);
              snackBarNotification(context, "Выполняется регистрация...",
                  duration: 1);
              register(registrationBloc.login.value,
                  registrationBloc.password.value);
            },
            onFailure: (context, state) {
              UIBlock.unblock(context);

              snackBarNotification(context, state.failureResponse, duration: 1);
            },
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 150),
                        child: Text(
                          "регистрация",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              letterSpacing: 3),
                        ),
                      ),
                      TextInputWidget(
                        textFieldBloc: registrationBloc.login,
                        focusNode: loginNode,
                        helperText: 'логин',
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(passNode);
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextInputWidget(
                        textFieldBloc: registrationBloc.password,
                        focusNode: passNode,
                        helperText: 'пароль',
                        onEditingComplete: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      TextButton(
                          onPressed: () {
                            registrationBloc.submit();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white)),
                            child: Padding(
                                padding: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 50, right: 50),
                                child: Text(
                                  "регистрация",
                                  style: TextStyle(
                                      color: Colors.white, letterSpacing: 3),
                                )),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }
}
