import 'package:farmsmart_flutter/utils/RegExInputFormatter.dart';
import 'package:farmsmart_flutter/ui/profitloss/RecordAmount.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class _Constants {
  static final amountValidator = RegExInputFormatter.withRegex(
      '^\$|^(0|([1-9][0-9]{0,3}))(\\.[0-9]{0,2})?\$');
}

class RecordAmountHeaderViewModel {
  String onAmountChanged;
  final Function(String) listener;
  bool isEditable;

  RecordAmountHeaderViewModel({
    this.onAmountChanged,
    this.listener,
    this.isEditable,
  });
}

class RecordAmountHeaderStyle {
  final TextStyle hintTextStyle;
  final TextStyle titleTextStyle;

  final EdgeInsets edgePadding;

  final double height;
  final int maxLines;

  RecordAmountHeaderStyle({
    this.hintTextStyle,
    this.titleTextStyle,
    this.edgePadding,
    this.height,
    this.maxLines,
  });

  RecordAmountHeaderStyle copyWith({
    TextStyle hintTextStyle,
    TextStyle titleTextStyle,
    EdgeInsets edgePadding,
    double height,
    int maxLines,
  }) {
    return RecordAmountHeaderStyle(
      hintTextStyle: hintTextStyle ?? this.hintTextStyle,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
    );
  }

  factory RecordAmountHeaderStyle.defaultCostStyle() {
    return RecordAmountHeaderStyle(
      hintTextStyle: const TextStyle(
        fontSize: 72,
        fontWeight: FontWeight.w500,
        color: Color(0x4cff8d4f),
        letterSpacing: 4.32,
      ),
      titleTextStyle: const TextStyle(
        fontSize: 72,
        fontWeight: FontWeight.w500,
        color: Color(0xFFff8d4f),
        letterSpacing: 4.32,
      ),
    );
  }

  factory RecordAmountHeaderStyle.defaultSaleStyle() {
    return RecordAmountHeaderStyle.defaultCostStyle().copyWith(
      hintTextStyle: const TextStyle(
        fontSize: 72,
        fontWeight: FontWeight.w500,
        color: Color(0x4c24d900),
        letterSpacing: 4.32,
      ),
      titleTextStyle: const TextStyle(
        fontSize: 72,
        fontWeight: FontWeight.w500,
        color: Color(0xFF24d900),
        letterSpacing: 4.32,
      ),
      edgePadding: const EdgeInsets.symmetric(horizontal: 32),
      height: 137.5,
      maxLines: 1,
    );
  }
}

class RecordAmountHeader extends StatefulWidget {
  final RecordAmountHeaderViewModel _viewModel;
  final RecordAmountHeaderStyle _style;

  RecordAmountHeader({
    Key key,
    RecordAmountHeaderViewModel viewModel,
    RecordAmountHeaderStyle style,
  })  : this._viewModel = viewModel,
        this._style = style,
        super(key: key);

  @override
  _RecordAmountHeaderState createState() => _RecordAmountHeaderState();
}

class _RecordAmountHeaderState extends State<RecordAmountHeader> {
  final _textFieldController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(textFieldFocusDidChange);

    if (widget._viewModel.onAmountChanged == null) {
      widget._viewModel.onAmountChanged = "00";
    }
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  void textFieldFocusDidChange() {
    if (_focusNode.hasFocus) {
      // textfield was tapped
    }
  }


  Widget build(BuildContext context) {
    RecordAmountHeaderViewModel viewModel = widget._viewModel;
    RecordAmountHeaderStyle style = widget._style;

    return Container(
      padding: style.edgePadding,
      height: style.height,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                viewModel.isEditable
                    ? TextField(
                        decoration: InputDecoration(
                            hintText: viewModel.onAmountChanged,
                            hintStyle: style.hintTextStyle,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(0),
                            counterText: ""),
                        keyboardType: TextInputType.numberWithOptions(
                            signed: false, decimal: true),
                        textAlign: TextAlign.center,
                        style: style.titleTextStyle,
                        inputFormatters: [_Constants.amountValidator],
                        maxLines: style.maxLines,
                        textInputAction: TextInputAction.next,
                        controller: _textFieldController,
                        onChanged: viewModel.listener,
                        focusNode: _focusNode,
                        onTap: () => cleanField(),
                        onEditingComplete: () => resetHint(),
                      )
                    : Text(viewModel.onAmountChanged,
                        style: style.titleTextStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }

  cleanField() {
    setState(() {
      widget._viewModel.onAmountChanged = "";
      //TODO: Apply this if want to reset amount onTap
      //_textFieldController.text = "";
    });
  }

  resetHint() {
    setState(() {
      if (_textFieldController.text == "") {
        widget._viewModel.onAmountChanged = "00";
      }
      FocusScope.of(context).detach();
    });
  }
}
