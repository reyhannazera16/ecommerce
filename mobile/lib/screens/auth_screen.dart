import 'package:flutter/material.dart';
import 'package:fradel_spies/providers/home_provider.dart';

import 'package:provider/provider.dart';

import '../main.dart';
import '../models/data/preference_model.dart';
import '../models/utilities/task_result_model.dart';
import '../providers/base_provider.dart';
import '../services/auth_service.dart';
import '../utilities/common_utility.dart';
import '../utilities/common_widget_utility.dart';
import '../utilities/sqlite_utility.dart';
import '../utilities/task_utility.dart';
import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  GlobalKey<FormState>? _formKey;
  TextEditingController? _nameFieldController;
  TextEditingController? _emailFieldController;
  TextEditingController? _passwordFieldController;
  TextEditingController? _passwordConfirmationFieldController;
  bool _isLogin = true;
  bool _hidePassword = true;

  bool get _isValid => _formKey?.currentState?.validate() ?? false;
  String get _nameFieldValue => _nameFieldController?.value.text ?? '';
  String get _emailFieldValue => _emailFieldController?.value.text ?? '';
  String get _passwordFieldValue => _passwordFieldController?.value.text ?? '';
  String get _passwordConfirmationFieldValue =>
      _passwordConfirmationFieldController?.value.text ?? '';

  Map<String, dynamic> get _formBody {
    return _isLogin
        ? <String, dynamic>{
            'email': _emailFieldValue,
            'password': _passwordFieldValue,
          }
        : <String, dynamic>{
            'name': _nameFieldValue,
            'email': _emailFieldValue,
            'password': _passwordFieldValue,
            'password_confirmation': _passwordConfirmationFieldValue,
          };
  }

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _nameFieldController = TextEditingController();
    _emailFieldController = TextEditingController();
    _passwordFieldController = TextEditingController();
    _passwordConfirmationFieldController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameFieldController?.dispose();
    _emailFieldController?.dispose();
    _passwordFieldController?.dispose();
    _passwordConfirmationFieldController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFFFFFFF),
        child: Column(
          children: <Widget>[
            const Expanded(
              child: Center(
                child: Image(
                  image: AssetImage('assets/greeting_logo.png'),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF080808),
                borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
              ),
              child: Form(
                key: _formKey,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 24, bottom: 4),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            _isLogin ? 'Selamat datang' : 'Daftar sekarang',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFFBFBFB),
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding:
                            EdgeInsets.only(bottom: 24, left: 48, right: 48),
                        child: AnimatedSwitcher(
                          duration: Duration(milliseconds: 300),
                          child: Text(
                            'Masukkan Detail Anda di bawah',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFDBD5D5),
                            ),
                          ),
                        ),
                      ),
                      if (!_isLogin)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                          child: TextFormField(
                            enabled: !context.watch<BaseProvider>().isBusy,
                            controller: _nameFieldController,
                            validator:
                                _isLogin ? null : CommonUtility.formValidator,
                            style: const TextStyle(color: Color(0xFFFFFFFF)),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0x26636363),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  width: 1.4,
                                  color: Color(0xFF636363),
                                ),
                              ),
                              prefixIcon: const Icon(
                                Icons.person_outlined,
                                color: Color(0xFF636363),
                              ),
                              labelText: 'Nama',
                              labelStyle:
                                  const TextStyle(color: Color(0xFF636363)),
                            ),
                          ),
                        ),
                      Padding(
                        padding:
                            EdgeInsets.fromLTRB(16, _isLogin ? 16 : 4, 16, 8),
                        child: TextFormField(
                          enabled: !context.watch<BaseProvider>().isBusy,
                          controller: _emailFieldController,
                          validator: CommonUtility.formValidator,
                          style: const TextStyle(color: Color(0xFFFFFFFF)),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0x26636363),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                width: 1.4,
                                color: Color(0xFF636363),
                              ),
                            ),
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: Color(0xFF636363),
                            ),
                            labelText: 'Email',
                            labelStyle:
                                const TextStyle(color: Color(0xFF636363)),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.fromLTRB(16, 8, 16, _isLogin ? 8 : 4),
                        child: TextFormField(
                          enabled: !context.watch<BaseProvider>().isBusy,
                          controller: _passwordFieldController,
                          validator: CommonUtility.formValidator,
                          obscureText: _hidePassword,
                          style: const TextStyle(color: Color(0xFFFFFFFF)),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0x26636363),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                width: 1.4,
                                color: Color(0xFF636363),
                              ),
                            ),
                            prefixIcon: const Icon(
                              Icons.password_outlined,
                              color: Color(0xFF636363),
                            ),
                            labelText: 'Kata sandi',
                            labelStyle:
                                const TextStyle(color: Color(0xFF636363)),
                            suffixIcon: IconButton(
                              onPressed: _changePasswordState,
                              icon: Icon(
                                _hidePassword
                                    ? Icons.lock_outlined
                                    : Icons.lock_open_outlined,
                                color: const Color(0xFF636363),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (!_isLogin)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                          child: TextFormField(
                            enabled: !context.watch<BaseProvider>().isBusy,
                            controller: _passwordConfirmationFieldController,
                            validator: _isLogin
                                ? null
                                : _passwordConfirmationValidator,
                            obscureText: true,
                            style: const TextStyle(color: Color(0xFFFFFFFF)),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0x26636363),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  width: 1.4,
                                  color: Color(0xFF636363),
                                ),
                              ),
                              prefixIcon: const Icon(
                                Icons.password_outlined,
                                color: Color(0xFF636363),
                              ),
                              labelText: 'Konfirmasi kata sandi',
                              labelStyle:
                                  const TextStyle(color: Color(0xFF636363)),
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 0, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Expanded(
                              child: Center(),
                            ),
                            Expanded(
                              child: Center(
                                child: TextButton(
                                  onPressed: () {},
                                  child: const Text('Lupa kata sandi?'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 47,
                          child: FilledButton(
                            onPressed: () => _isValid ? _onAuthTapped() : null,
                            style: FilledButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              _isLogin ? 'Masuk' : 'Daftar',
                              style: const TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: _isLogin
                                ? Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: <Widget>[
                                      const Text(
                                        'Belum punya akun?',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFFCCCCCC),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _isLogin = false;
                                          });
                                        },
                                        child: const Text('Buat sekarang'),
                                      )
                                    ],
                                  )
                                : Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: <Widget>[
                                      const Text(
                                        'Sudah punya akun?',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFFCCCCCC),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _isLogin = true;
                                          });
                                        },
                                        child: const Text('Masuk'),
                                      )
                                    ],
                                  )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _changePasswordState() => setState(() => _hidePassword = !_hidePassword);

  String? _passwordConfirmationValidator(String? value) {
    if (value == null || value.isEmpty) return 'Data tidak boleh kosong';
    if (value != _passwordFieldValue) return 'Konfirmasi harus sama';

    return null;
  }

  Future<void> _onAuthTapped() async {
    late TaskResult result;
    late final PreferenceModel preference;
    late final DateTime dateTime;

    CommonWidgetUtility.showLoading(canInterupt: false, title: 'Mohon tunggu');

    result = await TaskUtility.run(
            task: () => _isLogin
                ? AuthService.login(data: _formBody)
                : AuthService.register(data: _formBody))
        .whenComplete(() => Navigator.pop(navigatorKey.currentContext!));

    if ((result.result as String).isEmpty) {
      CommonWidgetUtility.showError(
          title: _isLogin ? 'Login gagal!' : 'Registrasi gagal',
          message: _isLogin
              ? 'Email atau kata sandi salah'
              : 'Email sudah terpakai');
      return;
    }

    dateTime = DateTime.now().toUtc();
    preference = PreferenceModel(
        key: 'token',
        value: result.result as String,
        createdAt: dateTime,
        updatedAt: dateTime);
    result = await TaskUtility.run(
        task: () => SqliteUtility.insertData(
            table: 'preferences', data: preference.toMap()));

    if ((result.result) as bool == true) {
      await navigatorKey.currentContext!
          .read<BaseProvider>()
          .getPreferencesFromSqlite();
      await navigatorKey.currentContext!.read<BaseProvider>().loadBearerToken();

      Navigator.pushAndRemoveUntil(
          navigatorKey.currentContext!,
          MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider(
                    create: (_) => HomeProvider()..init(),
                    child: const HomeScreen(),
                  )),
          (_) => false);
    }
  }
}
