import 'package:flutter/material.dart';
import 'package:local_persistence_form_sample/Core/result.dart';
import 'package:local_persistence_form_sample/Core/sqflite_stack_error.dart';
import 'package:local_persistence_form_sample/Core/user_repository_abstract.dart';
import 'package:local_persistence_form_sample/Data/DTO/user_model.dart';
import 'package:local_persistence_form_sample/Widgets/user_form.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key, required this.repository});

  final SqfliteUserRepository repository;

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  Future<Result<UserModel, SqfliteStackError>> _onSubmit(
    Map<String, Object?> formFields,
  ) async {
    final result = await widget.repository.save(formFields);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.only(left: 16, right: 16),
        child: Column(
          children: [
            SizedBox(height: 20),
            Center(child: Text("Local Persistence Form Sample")),
            SizedBox(height: 20),
            UserForm(onSubmit: _onSubmit),
          ],
        ),
      ),
    );
  }
}
