import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_persistence_form_sample/Core/result.dart';
import 'package:local_persistence_form_sample/Core/sqflite_stack_error.dart';
import 'package:local_persistence_form_sample/Data/DTO/user_model.dart';

class UserForm extends StatefulWidget {
  const UserForm({super.key, this.onSubmit})
    : assert(onSubmit != null, "UserForm requires an onSubmit callback");

  final AsyncResultFunction<UserModel, Error>? onSubmit;

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? alertLabel;

  bool _submitting = false;

  bool get _canSubmit =>
      _userNameController.text.length > 4 && _emailController.text.length > 4;

  @override
  void initState() {
    _userNameController.addListener(_onChange);
    _emailController.addListener(_onChange);
    super.initState();
  }

  @override
  void dispose() {
    _userNameController.removeListener(_onChange);
    _emailController.removeListener(_onChange);
    _userNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _onChange() {
    if (alertLabel == null) return;
    setState(() {
      alertLabel = null;
    });
  }

  void _onSubmit(BuildContext context) async {
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
    }
    setState(() {
      if (_autovalidateMode == AutovalidateMode.disabled) {
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      }
      _submitting = true;
    });
    if ((_formKey.currentState?.validate() ?? false) && _canSubmit) {
      debugPrint("Submit");
      await Future.delayed(Duration(seconds: 2));

      final formFields = {
        UserModel.columnUserName: _userNameController.text,
        UserModel.columnEmail: _emailController.text,
      };
      final result = await widget.onSubmit?.call(formFields);
      if (result is Success<UserModel?, SqfliteStackError>) {
        _userNameController.clear();
        _emailController.clear();
        debugPrint("The user ${result.value} was stored");
      }

      if (result is Failure<UserModel?, SqfliteStackError>) {
        _processError(result.error);
      }
    }
    setState(() {
      _submitting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: _autovalidateMode,
      child: Column(
        children: [
          TextFormField(
            controller: _userNameController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0),
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person_outline),
              hintText: "Username",
            ),
          ),
          SizedBox(height: 8),
          TextFormField(
            controller: _emailController,
            inputFormatters: [
              TextInputFormatter.withFunction((prevValue, nextValue) {
                final newTextValue = TextEditingValue(
                  text: nextValue.text.toLowerCase(),
                );
                return newTextValue;
              }),
            ],
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0),
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email_outlined),
              hintText: "email",
            ),
          ),
          if (alertLabel != null)
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Text(
                alertLabel!,
                style: TextStyle(color: Colors.red.shade500),
              ),
            ),
          SizedBox(height: 40),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                  ),
                  onPressed: _submitting ? null : () => _onSubmit(context),
                  child: Text(_submitting ? "Submitting" : "Submit"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

extension _UserFormErrors on _UserFormState {
  void _processError(SqfliteStackError error) {
    alertLabel = switch (error) {
      AlreadyExists() => "The username or email is already in use.",
      NotFound() => "Not Found",
      CannotStore() => "We cannot store the user at this moment.",
      CannotDelete() => "Cannot Delete",
      Unknown() => "An unknown error occured.",
    };
  }
}
