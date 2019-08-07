import 'package:flutter/material.dart';
import 'package:farmsmart_flutter/chat/bloc/transformer/implementation/SelectableOptionsViewModelTransformer.dart';
import 'package:farmsmart_flutter/chat/model/form/input_request_entity.dart';
import 'package:farmsmart_flutter/chat/ui/viewmodel/SelectableOptionViewModel.dart';
import 'package:farmsmart_flutter/chat/ui/viewmodel/SelectableOptionsViewModel.dart';
import 'package:farmsmart_flutter/chat/ui/widgets/selectable_options.dart';
import 'package:farmsmart_flutter/chat/ui/widgets/text_input.dart';
import 'package:intl/intl.dart';
import '../InteractiveMessageHandler.dart';

class _LocalisedStrings {
  static String sendText() => Intl.message('Send');

  static String messageNotEmpty() =>
      Intl.message('Message should not be empty');

  static String inputHint() => Intl.message('Type a message');

  static String notValidString() => Intl.message('Provided TEXT is not valid');

  static String notValidEmail() => Intl.message("Provided EMAIL is not valid");

  static String notValidPhone() => Intl.message('Provided PHONE is not valid');
}

class InteractiveMessageHandlerImpl implements InteractiveMessageHandler {
  @override
  Widget buildInputTextWidget({
    InputRequestEntity inputRequestEntity,
    TextEditingController textEditingController,
    Function onSendPressed,
    Function(String) onValidationPassed,
    InteractiveMessageType type,
    bool isFocusedOnBuild,
  }) =>
      _buildTextInputWidget(
        onSendPressed: onSendPressed,
        onValidationPassed: onValidationPassed,
        textEditingController: textEditingController,
        type: type,
        inputRequestEntity: inputRequestEntity,
        isFocusedOnBuild: isFocusedOnBuild,
      );

  @override
  Widget buildSelectableOptionsWidget({
    InputRequestEntity inputRequestEntity,
    Function(SelectableOptionViewModel) onTap,
  }) =>
      _buildSelectableOptionsWidget(
        onTap: onTap,
        inputRequestEntity: inputRequestEntity,
      );

  _buildTextInputWidget({
    InputRequestEntity inputRequestEntity,
    TextEditingController textEditingController,
    Function onSendPressed,
    Function(String) onValidationPassed,
    InteractiveMessageType type,
    bool isFocusedOnBuild,
  }) =>
      TextInput(
        buttonText: _LocalisedStrings.sendText(),
        formFieldValidatorFunction: _getValidationFunction(
          regex: inputRequestEntity.validationRegex,
          type: type,
          onValidationPassed: onValidationPassed,
        ),
        onSendPressed: onSendPressed,
        controller: textEditingController,
        decoration: _getInputDecoration(),
        isFocusedOnBuild: isFocusedOnBuild,
      );

  _buildSelectableOptionsWidget({
    InputRequestEntity inputRequestEntity,
    Function(SelectableOptionViewModel) onTap,
  }) =>
      SelectableOptions(
        viewModel: _getSelectableOptionsViewModel(
          inputRequestEntity: inputRequestEntity,
        ),
        onTap: onTap,
      );

  SelectableOptionsViewModel _getSelectableOptionsViewModel({
    InputRequestEntity inputRequestEntity,
  }) =>
      SelectableOptionsViewModelTransformer()
          .transform(from: inputRequestEntity);

  String Function(String) _getValidationFunction({
    String regex,
    InteractiveMessageType type,
    Function(String) onValidationPassed,
  }) {
    return (value) {
      return _getFormFieldValidatorValue(
        value: value,
        regex: regex,
        type: type,
        onValidationPassed: onValidationPassed,
      );
    };
  }

  InputDecoration _getInputDecoration() =>
      InputDecoration(hintText: _LocalisedStrings.inputHint());

  String _getFormFieldValidatorValue({
    String value,
    String regex,
    InteractiveMessageType type,
    Function(String) onValidationPassed,
  }) {
    if (value.isEmpty) {
      return _LocalisedStrings.messageNotEmpty();
    } else if (_isRegexProvided(regex: regex) &&
        !_isRegexValidationPassed(value: value, regex: regex)) {
      return _getErrorMessageByType(type: type);
    }
    onValidationPassed(value);
    return null;
  }

  String _getErrorMessageByType({InteractiveMessageType type}) {
    switch (type) {
      case InteractiveMessageType.inputString:
        return _LocalisedStrings.notValidString();
      case InteractiveMessageType.inputEmail:
        return _LocalisedStrings.notValidEmail();
      case InteractiveMessageType.inputPhoneNumber:
        return _LocalisedStrings.notValidPhone();
      case InteractiveMessageType.inputImage:
        return null;
      case InteractiveMessageType.multiChoice:
        return null;
      default:
        return null;
    }
  }

  bool _isRegexValidationPassed({
    String value,
    String regex,
  }) =>
      RegExp(
        regex,
        caseSensitive: false,
        multiLine: false,
      ).hasMatch(value);

  bool _isRegexProvided({
    String regex,
  }) {
    return regex != null && regex.isNotEmpty;
  }
}