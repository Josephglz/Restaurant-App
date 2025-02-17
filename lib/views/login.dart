import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restaurant/models/Employee.dart';
import 'package:restaurant/values.dart';
import 'home.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  bool isLoading = false;
  @override
  State<LoginScreen> createState() => _Login();
}

class _Login extends State<LoginScreen> {
  final user = TextEditingController();
  final pass = TextEditingController();
  List<Employee> empleados = [];
  bool hidePass = true;

  void _loadEmpleados() async {
    empleados.clear();
    await FirebaseFirestore.instance
        .collection('Employee')
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((doc) {
        empleados.add(Employee.fromJson(doc.data()));
      });
    });
  }

  void _toggle() {
    setState((){
      hidePass = !hidePass;
    });
  }

  @override
  Widget build(BuildContext context) {
    _loadEmpleados();
    return MaterialApp(
      title: 'login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey.shade50,
          backwardsCompatibility: false,
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        ),
      ),
      home: Hero(
        tag: 'logo',
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/profile_picture.png',
                      width: 80,
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 30,
                    bottom: 30,
                    left: MediaQuery.of(context).size.width * 0.1,
                    right: MediaQuery.of(context).size.width * 0.1,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 15,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            'Bienvenido',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              fontSize: 38,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                          child: TextField(
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              fontSize: 22,
                              color: blackLight,
                            ),
                            textInputAction: TextInputAction.next,
                            controller: user,
                            autofocus: false,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: 'Empleado',
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.grey,
                              ),
                              contentPadding: EdgeInsets.all(10),
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                              ),
                              labelText: 'Empleado',
                              labelStyle: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.green, width: 2.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                          child: TextField(
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              fontSize: 22,
                              color: blackLight,
                            ),
                            obscureText: hidePass,
                            controller: pass,
                            autofocus: false,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: 'Contraseña',
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.grey,
                              ),
                              suffixIcon: GestureDetector(
                                onTap: _toggle,
                                child: Icon(
                                  hidePass ? 
                                  Icons.visibility : 
                                  Icons.visibility_off,
                                  color: Colors.grey
                                ),
                              ),
                              contentPadding: EdgeInsets.all(10),
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                              ),
                              labelText: 'Contraseña',
                              labelStyle: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.green, width: 2.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          width: 280,
                          height: 50,
                          decoration: BoxDecoration(
                            color: reptileGreen,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextButton(
                            onPressed: () {
                              int empleadoID = -1;
                              for (int i = 0; i < empleados.length; i++) {
                                if (user.text == empleados[i].username &&
                                    pass.text == empleados[i].password) {
                                  empleadoID = i;
                                }
                              }
                              if (empleadoID > -1) {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen(
                                            empleado: empleados[empleadoID])),
                                    (Route<dynamic> route) => false);
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Container(
                                        child: Row(
                                          children: const [
                                            Icon(
                                              Icons.error,
                                              color: Colors.red,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text('Error'),
                                          ],
                                        ),
                                      ),
                                      content: Text(
                                          "Usuario o contraseña incorrectos"),
                                      actions: [
                                        TextButton(
                                          child: const Text("OK"),
                                          onPressed: Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop,
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Ingresar',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 25,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 36,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            '¿Olvidaste tu contraseña?',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: fusionRed,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
