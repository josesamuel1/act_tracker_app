import 'package:act_tracker/core/core.dart';
import 'package:act_tracker/features/auth/presentation/presentation.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class _AuthForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const _AuthForm({required this.formKey});

  String _titleByMode(AuthMode mode) {
    switch (mode) {
      case AuthMode.login:
        return AuthStrings.loginTitle;
      case AuthMode.register:
        return AuthStrings.registerTitle;
    }
  }

  String _buttonTextByMode(AuthMode mode) {
    switch (mode) {
      case AuthMode.login:
        return AuthStrings.loginElevatedButton;
      case AuthMode.register:
        return AuthStrings.registerElevatedButton;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthPageCubit, AuthPageState>(
      builder: (context, state) {
        final cubit = context.read<AuthPageCubit>();

        return Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title Page
              Text(
                _titleByMode(state.mode),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 32.0),
              // Username Form Field
              TextFormField(
                decoration: InputDecoration(labelText: AuthStrings.usernameLabel),
                onChanged: cubit.onUsernameChanged,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AuthStrings.usernameValidator;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              // Password Form Field
              TextFormField(
                obscureText: state.obscurePassword,
                decoration: InputDecoration(
                  labelText: AuthStrings.passwordLabel,
                  suffixIcon: IconButton(
                    onPressed: cubit.togglePasswordVisibility,
                    icon: state.obscurePassword
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                  ),
                ),
                onChanged: cubit.onPasswordChanged,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AuthStrings.passwordValidator;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32.0),
              // Submit Button
              ElevatedButton(
                onPressed: state.status == AuthStatus.loading
                    ? null
                    : () {
                        if (formKey.currentState!.validate()) {
                          cubit.submit();
                        }
                      },
                child: state.status == AuthStatus.loading
                    ? const SizedBox(width: 20.0, height: 20.0, child: CircularProgressIndicator())
                    : Text(_buttonTextByMode(state.mode)),
              ),
              const SizedBox(height: 16.0),
              // Register/Login Text Button
              if (state.isLogin) ...[
                TextButton(
                  onPressed: cubit.switchToRegister,
                  child: Text(AuthStrings.registerTextButton, style: TextStyle(fontSize: 10.0)),
                ),
              ],
              if (state.isRegister) ...[
                TextButton(
                  onPressed: cubit.switchToLogin,
                  child: Text(AuthStrings.loginTextButton, style: TextStyle(fontSize: 10.0)),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

@RoutePage()
class AuthPage extends StatelessWidget {
  AuthPage({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AppLayoutContainer(
        child: BlocListener<AuthPageCubit, AuthPageState>(
          listenWhen: (prev, curr) => prev.status != curr.status,
          listener: (context, state) {
            if (state.status == AuthStatus.error) {
              debugPrint('${CoreStrings.error}: ${state.errorMessage}');
            }

            if (state.status == AuthStatus.success) {
              context.router.replace(const HomeRoute());
            }
          },
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.0),
              child: _AuthForm(formKey: _formKey),
            ),
          ),
        ),
      ),
    );
  }
}
