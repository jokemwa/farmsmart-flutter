import 'package:farmsmart_flutter/data/bloc/ViewModelProvider.dart';
import 'package:farmsmart_flutter/ui/common/SectionListView.dart';
import 'package:farmsmart_flutter/ui/common/headerAndFooterListView.dart';
import 'package:farmsmart_flutter/ui/common/recommendation_card/recommendation_card.dart';
import 'package:farmsmart_flutter/ui/recommendations/viewmodel/RecommendationsListViewModel.dart';
import 'package:flutter/cupertino.dart';

abstract class RecommendedListStyle {
  final TextStyle titleTextStyle;
  final EdgeInsets titleEdgePadding;

  RecommendedListStyle(this.titleTextStyle, this.titleEdgePadding);
  RecommendedListStyle copyWith({
    TextStyle titleTextStyle,
    EdgeInsets titleEdgePadding,
  });
}

class _DefaultStyle implements RecommendedListStyle {
  final TextStyle titleTextStyle;
  final EdgeInsets titleEdgePadding;

  const _DefaultStyle({TextStyle titleTextStyle, EdgeInsets titleEdgePadding})
      : this.titleTextStyle = titleTextStyle ??
            const TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1a1b46)),
        this.titleEdgePadding = titleEdgePadding ??
            const EdgeInsets.only(
              left: 34.0,
              right: 34.0,
              top: 35.0,
              bottom: 30.0,
            );

  @override
  RecommendedListStyle copyWith({
    TextStyle titleTextStyle,
    EdgeInsets titleEdgePadding,
  }) {
    return _DefaultStyle(
        titleTextStyle: titleTextStyle ?? this.titleTextStyle,
        titleEdgePadding: titleEdgePadding ?? this.titleEdgePadding);
  }
}

const RecommendedListStyle _defaultStyle = const _DefaultStyle();

class RecommendationsList extends StatelessWidget implements ListViewSection {
  final RecommendedListStyle _style;
  final ViewModelProvider<RecommendationsListViewModel> _viewModelProvider;

  const RecommendationsList({
    Key key,
    ViewModelProvider<RecommendationsListViewModel> provider,
    RecommendedListStyle style = _defaultStyle,
  })  : this._style = style,
        this._viewModelProvider = provider,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<RecommendationsListViewModel>(
        stream: _viewModelProvider.observe().stream,
        initialData: _viewModelProvider.initial(),
        builder: (
          BuildContext context,
          AsyncSnapshot<RecommendationsListViewModel> snapshot,
        ) {
          return _buildList(viewModel: snapshot.data);
        });
  }

  Widget _buildList({RecommendationsListViewModel viewModel}) {
    final headedList = HeaderAndFooterListView(headers: <Widget>[_buildHeader(viewModel: viewModel)], shrinkWrap: true, physics: ScrollPhysics(), itemBuilder: itemBuilder(), itemCount: length(),);
    return headedList;
  }

  Widget _buildHeader({RecommendationsListViewModel viewModel}) {
    return Container(
      padding: _style.titleEdgePadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[Text(viewModel.title, style: _style.titleTextStyle,)],
      ),
    );
  }

  @override
  itemBuilder() {
    final viewModel = _viewModelProvider.snapshot();
    return (BuildContext context, int index) {
      return RecommendationCard(viewModel: viewModel.items[index],);
    };
  }

  @override
  int length() {
    return _viewModelProvider.snapshot().items.length;
  }
}
