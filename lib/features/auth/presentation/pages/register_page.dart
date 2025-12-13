import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/auth_ui_components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../../domain/usecases/register_params.dart';
import '../bloc/auth_state.dart';
import '../../../../core/di/injection.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final ValueNotifier<bool> _passwordObscure = ValueNotifier(true);
  final ValueNotifier<bool> _confirmObscure = ValueNotifier(true);
  late final AuthBloc _authBloc = sl<AuthBloc>();

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _passwordObscure.dispose();
    _confirmObscure.dispose();
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider.value(
      value: _authBloc,
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            _nameController.clear();
            _surnameController.clear();
            _usernameController.clear();
            _emailController.clear();
            _phoneNumberController.clear();
            _passwordController.clear();
            _confirmController.clear();
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFB2EBF2), Color(0xFF0288D1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Container(
                      width: size.width < 400 ? size.width * 0.95 : 360,
                      padding: const EdgeInsets.symmetric(
                        vertical: 24,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.0),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.0),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 8),
                          AuthLogo(height: 100),
                          const SizedBox(height: 12),
                          AuthTitle(
                            title: 'Crear cuenta',
                            subtitle: 'Completa los datos para registrarte',
                          ),
                          const SizedBox(height: 22),
                          AuthInput(
                            controller: _nameController,
                            hintText: 'Nombre',
                            icon: Icons.person,
                            keyboardType: TextInputType.name,
                          ),
                          const SizedBox(height: 10),
                          AuthInput(
                            controller: _surnameController,
                            hintText: 'Apellido',
                            icon: Icons.person_outline,
                            keyboardType: TextInputType.name,
                          ),
                          const SizedBox(height: 10),
                          AuthInput(
                            controller: _usernameController,
                            hintText: 'Usuario',
                            icon: Icons.account_circle_outlined,
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(height: 10),
                          AuthInput(
                            controller: _emailController,
                            hintText: 'Correo electrónico',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 10),
                          AuthInput(
                            controller: _phoneNumberController,
                            hintText: 'Teléfono',
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 10),
                          ValueListenableBuilder<bool>(
                            valueListenable: _passwordObscure,
                            builder: (context, value, _) => AuthInput(
                              controller: _passwordController,
                              hintText: 'Contraseña',
                              icon: Icons.lock_outline,
                              obscureText: value,
                              onVisibilityToggle: (v) =>
                                  _passwordObscure.value = v,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ValueListenableBuilder<bool>(
                            valueListenable: _confirmObscure,
                            builder: (context, value, _) => AuthInput(
                              controller: _confirmController,
                              hintText: 'Confirmar contraseña',
                              icon: Icons.lock_outline,
                              obscureText: value,
                              onVisibilityToggle: (v) =>
                                  _confirmObscure.value = v,
                            ),
                          ),
                          const SizedBox(height: 18),
                          state is AuthLoading
                              ? const Center(child: CircularProgressIndicator())
                              : AuthButton(
                                  text: 'Registrarse',
                                  onPressed: () {
                                    context.read<AuthBloc>().add(
                                      RegisterRequested(
                                        RegisterParams(
                                          name: _nameController.text,
                                          surname: _surnameController.text,
                                          username: _usernameController.text,
                                          email: _emailController.text,
                                          phoneNumber: _phoneNumberController.text,
                                          password: _passwordController.text,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Volver a Iniciar Sesión',
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
