import 'package:farmsmart_flutter/model/loading_status.dart';
import 'package:farmsmart_flutter/ui/common/ListDivider.dart';
import 'package:farmsmart_flutter/ui/common/roundedButton.dart';
import 'package:farmsmart_flutter/ui/profitloss/RecordAmountListItem.dart';
import 'package:farmsmart_flutter/ui/profitloss/RecordAmountHeader.dart';
import 'package:farmsmart_flutter/ui/profitloss/RecordAmountListItemStyles.dart';
import 'package:farmsmart_flutter/utils/strings.dart';
import 'package:flutter/material.dart';

enum RecordType {
  cost,
  sale,
}

class RecordAmountViewModel {
  LoadingStatus loadingStatus;
  List<RecordAmountListItemViewModel> actions;
  String amount;
  String buttonTitle;
  bool isFilled;
  Function onTap;
  RecordType type;
  bool isEditable;
  String description;

  RecordAmountViewModel({
    this.loadingStatus,
    this.actions,
    this.amount: "00",
    this.buttonTitle,
    this.isFilled: false,
    this.onTap,
    this.type,
    this.isEditable: true,
  });
}

class RecordAmountStyle {
  final EdgeInsets buttonEdgePadding;

  final EdgeInsets appBarLeftMargin;
  final EdgeInsets appBarRightMargin;

  final double headerLineSpace;
  final double appBarElevation;
  final double appBarIconHeight;
  final double appBarIconWidth;

  const RecordAmountStyle({
    this.buttonEdgePadding,
    this.appBarLeftMargin,
    this.appBarRightMargin,
    this.headerLineSpace,
    this.appBarElevation,
    this.appBarIconHeight,
    this.appBarIconWidth,
  });

  RecordAmountStyle copyWith({
    EdgeInsets buttonEdgePadding,
    EdgeInsets appBarLeftMargin,
    EdgeInsets appBarRightMargin,
    double headerLineSpace,
    double appBarElevation,
    double appBarIconHeight,
    double appBarIconWidth,
  }) {
    return RecordAmountStyle(
      buttonEdgePadding: buttonEdgePadding ?? this.buttonEdgePadding,
      appBarLeftMargin: appBarLeftMargin ?? this.appBarLeftMargin,
      appBarRightMargin: appBarRightMargin ?? this.appBarRightMargin,
      headerLineSpace: headerLineSpace ?? this.headerLineSpace,
      appBarElevation: appBarElevation ?? this.appBarElevation,
      appBarIconHeight: appBarIconHeight ?? this.appBarIconHeight,
      appBarIconWidth: appBarIconWidth ?? this.appBarIconWidth,
    );
  }
}

class _DefaultStyle extends RecordAmountStyle {
  final EdgeInsets buttonEdgePadding = const EdgeInsets.all(32.0);

  final EdgeInsets appBarLeftMargin = const EdgeInsets.only(left: 31);
  final EdgeInsets appBarRightMargin = const EdgeInsets.only(right: 0);

  final double headerLineSpace = 12.5;

  final double appBarElevation = 0;
  final double appBarIconHeight = 20;
  final double appBarIconWidth = 20.5;

  const _DefaultStyle({
    EdgeInsets buttonEdgePadding,
    EdgeInsets appBarLeftMargin,
    EdgeInsets appBarRightMargin,
    double headerLineSpace,
    double appBarElevation,
    double appBarIconHeight,
    double appBarIconWidth,
  });
}

const RecordAmountStyle _defaultStyle = const _DefaultStyle();

class RecordAmount extends StatefulWidget {
  final RecordAmountViewModel _viewModel;
  final RecordAmountStyle _style;

  RecordAmount({
    Key key,
    RecordAmountViewModel viewModel,
    RecordAmountStyle style = _defaultStyle,
  })  : this._viewModel = viewModel,
        this._style = style,
        super(key: key);

  @override
  RecordAmountState createState() => RecordAmountState();
}

class RecordAmountState extends State<RecordAmount> {
  String selectedCrop;
  bool amoundIsFilled = false;
  bool cropIsFilled = false;
  final int firstListItem = 0;
  final int secondListItem = 1;
  final int thirdListItem = 2;

  @override
  void initState() {
    super.initState();
    setState(() {
      widget._viewModel.isFilled = false;
    });
  }

  Widget build(BuildContext context) {
    switch (widget._viewModel.loadingStatus) {
      case LoadingStatus.LOADING:
        return Container(
          child: CircularProgressIndicator(),
          alignment: Alignment.center,
        );
      case LoadingStatus.SUCCESS:
        return _buildPage(
          context,
          widget._viewModel,
          widget._style,
        );
      case LoadingStatus.ERROR:
        return Text(Strings.errorString);
    }
  }

  Widget _buildPage(BuildContext context, RecordAmountViewModel viewModel,
      RecordAmountStyle style) {
    return Scaffold(
      appBar: viewModel.isEditable
          ? _buildSimpleAppBar(style, context)
          : _buildEditAppBar(style, context),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          checkIfFilled();
        },
        child: ListView(
          children: _buildContent(
            viewModel,
            style,
          ),
        ),
      ),
    );
  }

  AppBar _buildSimpleAppBar(RecordAmountStyle style, BuildContext context) {
    return AppBar(
      elevation: style.appBarElevation,
      leading: FlatButton(
        onPressed: () => Navigator.pop(context, false),
        padding: style.appBarLeftMargin,
        child: Image.asset(
          'assets/icons/nav_icon_cancel.png',
          height: style.appBarIconHeight,
          width: style.appBarIconWidth,
        ),
      ),
    );
  }

  AppBar _buildEditAppBar(RecordAmountStyle style, BuildContext context) {
    return AppBar(
      elevation: style.appBarElevation,
      leading: FlatButton(
        onPressed: () => Navigator.of(context).pop(false),
        padding: style.appBarLeftMargin,
        child: Image.asset(
          'assets/icons/nav_icon_back.png',
          height: style.appBarIconHeight,
          width: style.appBarIconWidth,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () => null,
          padding: style.appBarRightMargin,
          child: Image.asset(
            'assets/icons/nav_icon_options.png',
            height: style.appBarIconHeight,
            width: style.appBarIconWidth,
          ),
        )
      ],
    );
  }

  List<Widget> _buildContent(
      RecordAmountViewModel viewModel, RecordAmountStyle style) {
    List<Widget> listBuilder = [];

    listBuilder.add(
      RecordAmountHeader(
        viewModel: RecordAmountHeaderViewModel(
          isEditable: viewModel.isEditable,
          amount: viewModel.amount,
          listener: (amount) {
            amoundIsFilled = true;
            checkIfFilled();
          },
        ),
        style: viewModel.type == RecordType.sale
            ? RecordAmountHeaderStyle.defaultSaleStyle()
            : RecordAmountHeaderStyle.defaultCostStyle(),
      ),
    );

    listBuilder.add(SizedBox(height: style.headerLineSpace));

    listBuilder.add(
      RecordAmountListItem(
        viewModel: RecordAmountListItemViewModel(
          isEditable: viewModel.isEditable,
          icon: viewModel.actions[firstListItem].icon,
          hint: viewModel.actions[firstListItem].hint,
          arrow: viewModel.actions[firstListItem].arrow,
          title: viewModel.actions[firstListItem].title,
          selectedDate: viewModel.actions[firstListItem].selectedDate,
        ),
        parent: this,
      ),
    );

    listBuilder.add(ListDivider.build());

    listBuilder.add(
      RecordAmountListItem(
        viewModel: RecordAmountListItemViewModel(
          isEditable: viewModel.isEditable,
          icon: viewModel.actions[secondListItem].icon,
          hint: viewModel.actions[secondListItem].hint,
          selectedItem: viewModel.isEditable
              ? selectedCrop
              : viewModel.actions[secondListItem].selectedItem,
          arrow: viewModel.actions[secondListItem].arrow,
          title: viewModel.actions[secondListItem].title,
          listOfCrops: viewModel.actions[secondListItem].listOfCrops,
          listener: (crop) {
            cropIsFilled = true;
            checkIfFilled();
          },
        ),
        parent: this,
      ),
    );

    listBuilder.add(ListDivider.build());

    listBuilder.add(
      RecordAmountListItem(
        viewModel: RecordAmountListItemViewModel(
            isEditable: viewModel.isEditable,
            icon: viewModel.actions[thirdListItem].icon,
            hint: viewModel.actions[thirdListItem].hint,
            description: viewModel.actions[thirdListItem].description,
            arrow: viewModel.actions[thirdListItem].arrow),
        style: RecordAmountListItemStyles.biggerStyle,
        parent: this,
      ),
    );

    if (viewModel.isEditable) {
      listBuilder.add(_buildFooter(viewModel, style));
    }
    return listBuilder;
  }

  Padding _buildFooter(
      RecordAmountViewModel viewModel, RecordAmountStyle style) {
    return Padding(
      padding: style.buttonEdgePadding,
      child: Row(
        children: <Widget>[
          Expanded(
            child: !widget._viewModel.isFilled
                ? RoundedButton(
                    viewModel: RoundedButtonViewModel(
                        title: viewModel.buttonTitle, onTap: null),
                    style: RoundedButtonStyle.largeRoundedButtonStyle()
                        .copyWith(backgroundColor: Color(0xFFe9eaf2)),
                  )
                : RoundedButton(
                    viewModel: RoundedButtonViewModel(
                        title: viewModel.buttonTitle,
                        onTap: widget._viewModel.onTap),
                    style: viewModel.type == RecordType.sale
                        ? RoundedButtonStyle.largeRoundedButtonStyle()
                            .copyWith(backgroundColor: Color(0xFF24d900))
                        : RoundedButtonStyle.largeRoundedButtonStyle()
                            .copyWith(backgroundColor: Color(0xFFff8d4f)),
                  ),
          ),
        ],
      ),
    );
  }

  checkIfFilled() {
    setState(() {
      if (amoundIsFilled && cropIsFilled) {
        widget._viewModel.isFilled = true;
      } else {
        widget._viewModel.isFilled = false;
      }
    });
  }
}
