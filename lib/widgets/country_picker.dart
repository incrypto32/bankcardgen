import 'package:bankcardmaker/constants/countries.dart';
import 'package:flutter/material.dart';

//______________COUNTRY CODE CLASS DEFINITION_________________

class Country {
  String name;
  final String flag;
  final String code;
  final String dialCode;

  Country({
    this.name,
    this.flag,
    this.code,
    this.dialCode,
  });

  factory Country.fromCode(String isoCode) {
    final Map<String, String> jsonCode = countries.firstWhere(
      (code) => code['code'] == isoCode,
      orElse: () => null,
    );

    if (jsonCode == null) {
      return null;
    }

    return Country.fromJson(jsonCode);
  }
  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'],
      code: json['code'],
      dialCode: json['dial_code'],
      flag: json['flag'],
    );
  }

  @override
  String toString() => "$dialCode";

  String toLongString() => "$dialCode ${toCountryStringOnly()}";

  String toCountryStringOnly() {
    return '$name';
  }
}











//__________________COUTRY_CODE_PICKER_(WIDGET)________________

class CountryPicker extends StatefulWidget {
  final ValueChanged<Country> onChanged;
  final ValueChanged<Country> onInit;
  final String initialSelection;
  final List<String> favorite;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
  final bool showCountryOnly;
  final InputDecoration searchDecoration;
  final TextStyle searchStyle;
  final TextStyle dialogTextStyle;
  final WidgetBuilder emptySearchBuilder;
  final Function(Country) builder;
  final bool enabled;
  final TextOverflow textOverflow;

  /// the size of the selection dialog
  final Size dialogSize;

  /// used to customize the country list
  final List<String> countryFilter;

  /// shows the name of the country instead of the dialcode
  final bool showOnlyCountryWhenClosed;

  /// aligns the flag and the Text left
  ///
  /// additionally this option also fills the available space of the widget.
  /// this is especially useful in combination with [showOnlyCountryWhenClosed],
  /// because longer country names are displayed in one line
  final bool alignLeft;

  /// shows the flag
  final bool showFlag;

  final bool hideMainText;

  final bool showFlagMain;

  final bool showFlagDialog;

  /// Width of the flag images
  final double flagWidth;

  /// Use this property to change the order of the options
  final Comparator<Country> comparator;

  /// Set to true if you want to hide the search part
  final bool hideSearch;

  CountryPicker({
    this.onChanged,
    this.onInit,
    this.initialSelection,
    this.favorite = const [],
    this.textStyle,
    this.padding = const EdgeInsets.all(0.0),
    this.showCountryOnly = false,
    this.searchDecoration = const InputDecoration(),
    this.searchStyle,
    this.dialogTextStyle,
    this.emptySearchBuilder,
    this.showOnlyCountryWhenClosed = false,
    this.alignLeft = false,
    this.showFlag = true,
    this.showFlagDialog,
    this.hideMainText = false,
    this.showFlagMain,
    this.builder,
    this.flagWidth = 32.0,
    this.enabled = true,
    this.textOverflow = TextOverflow.ellipsis,
    this.comparator,
    this.countryFilter,
    this.hideSearch = false,
    this.dialogSize,
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    List<Map> jsonList = countries;

    List<Country> elements =
        jsonList.map((json) => Country.fromJson(json)).toList();

    if (comparator != null) {
      elements.sort(comparator);
    }

    if (countryFilter != null && countryFilter.isNotEmpty) {
      final uppercaseCustomList =
          countryFilter.map((c) => c.toUpperCase()).toList();
      elements = elements
          .where((c) =>
              uppercaseCustomList.contains(c.code) ||
              uppercaseCustomList.contains(c.name) ||
              uppercaseCustomList.contains(c.dialCode))
          .toList();
    }

    return CountryPickerState(elements);
  }
}

class CountryPickerState extends State<CountryPicker> {
  Country selectedItem;
  List<Country> elements = [];
  List<Country> favoriteElements = [];

  CountryPickerState(this.elements);

  @override
  Widget build(BuildContext context) {
    Widget _widget;
    if (widget.builder != null)
      _widget = InkWell(
        onTap: showCountryCodePickerDialog,
        child: widget.builder(selectedItem),
      );
    else {
      _widget = FlatButton(
        padding: widget.padding,
        onPressed: widget.enabled ? showCountryCodePickerDialog : null,
        child: Flex(
          direction: Axis.horizontal,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (widget.showFlagMain != null
                ? widget.showFlagMain
                : widget.showFlag)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  selectedItem.flag,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            if (!widget.hideMainText)
              Flexible(
                fit: widget.alignLeft ? FlexFit.tight : FlexFit.loose,
                child: Text(
                  widget.showOnlyCountryWhenClosed
                      ? selectedItem.toCountryStringOnly()
                      : selectedItem.toString(),
                  style: widget.textStyle ?? Theme.of(context).textTheme.button,
                  overflow: widget.textOverflow,
                ),
              ),
          ],
        ),
      );
    }
    return _widget;
  }

  @override
  void didUpdateWidget(CountryPicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialSelection != widget.initialSelection) {
      if (widget.initialSelection != null) {
        selectedItem = elements.firstWhere(
            (e) =>
                (e.code.toUpperCase() ==
                    widget.initialSelection.toUpperCase()) ||
                (e.dialCode == widget.initialSelection) ||
                (e.name.toUpperCase() == widget.initialSelection.toUpperCase()),
            orElse: () => elements[0]);
      } else {
        selectedItem = elements[0];
      }
      _onInit(selectedItem);
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.initialSelection != null) {
      selectedItem = elements.firstWhere(
          (e) =>
              (e.code.toUpperCase() == widget.initialSelection.toUpperCase()) ||
              (e.dialCode == widget.initialSelection) ||
              (e.name.toUpperCase() == widget.initialSelection.toUpperCase()),
          orElse: () => elements[0]);
    } else {
      selectedItem = elements[0];
    }

    favoriteElements = elements
        .where((e) =>
            widget.favorite.firstWhere(
                (f) =>
                    e.code.toUpperCase() == f.toUpperCase() ||
                    e.dialCode == f ||
                    e.name.toUpperCase() == f.toUpperCase(),
                orElse: () => null) !=
            null)
        .toList();
  }

  void showCountryCodePickerDialog() {
    showDialog(
      context: context,
      builder: (_) => SelectionDialog(
        elements,
        favoriteElements,
        showCountryOnly: widget.showCountryOnly,
        emptySearchBuilder: widget.emptySearchBuilder,
        searchDecoration: widget.searchDecoration,
        searchStyle: widget.searchStyle,
        textStyle: widget.dialogTextStyle,
        showFlag: widget.showFlagDialog != null
            ? widget.showFlagDialog
            : widget.showFlag,
        flagWidth: widget.flagWidth,
        size: widget.dialogSize,
        hideSearch: widget.hideSearch,
      ),
    ).then((e) {
      if (e != null) {
        setState(() {
          selectedItem = e;
        });

        _publishSelection(e);
      }
    });
  }

  void _publishSelection(Country e) {
    if (widget.onChanged != null) {
      widget.onChanged(e);
    }
  }

  void _onInit(Country e) {
    if (widget.onInit != null) {
      widget.onInit(e);
    }
  }
}









// ____________________SELECTION DIALOG__________________


class SelectionDialog extends StatefulWidget {
  final List<Country> elements;
  final bool showCountryOnly;
  final InputDecoration searchDecoration;
  final TextStyle searchStyle;
  final TextStyle textStyle;
  final WidgetBuilder emptySearchBuilder;
  final bool showFlag;
  final double flagWidth;
  final Size size;
  final bool hideSearch;
  final List<Country> favoriteElements;

  SelectionDialog(
    this.elements,
    this.favoriteElements, {
    Key key,
    this.showCountryOnly,
    this.emptySearchBuilder,
    InputDecoration searchDecoration = const InputDecoration(),
    this.searchStyle,
    this.textStyle,
    this.showFlag,
    this.flagWidth = 32,
    this.size,
    this.hideSearch = false,
  })  : assert(searchDecoration != null, 'searchDecoration must not be null!'),
        this.searchDecoration =
            searchDecoration.copyWith(prefixIcon: Icon(Icons.search)),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _SelectionDialogState();
}

class _SelectionDialogState extends State<SelectionDialog> {
  List<Country> filteredElements;

  @override
  Widget build(BuildContext context) => SimpleDialog(
        titlePadding: const EdgeInsets.all(0),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            IconButton(
              padding: const EdgeInsets.all(0),
              iconSize: 20,
              icon: Icon(
                Icons.close,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            if (!widget.hideSearch)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: TextField(
                  style: widget.searchStyle,
                  decoration: widget.searchDecoration,
                  onChanged: _filterElements,
                ),
              ),
          ],
        ),
        children: [
          Container(
            width: widget.size?.width ?? MediaQuery.of(context).size.width,
            height:
                widget.size?.height ?? MediaQuery.of(context).size.height * 0.7,
            child: ListView(
              children: [
                widget.favoriteElements.isEmpty
                    ? const DecoratedBox(decoration: BoxDecoration())
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...widget.favoriteElements.map(
                            (f) => SimpleDialogOption(
                              child: _buildOption(f),
                              onPressed: () {
                                _selectItem(f);
                              },
                            ),
                          ),
                          const Divider(),
                        ],
                      ),
                if (filteredElements.isEmpty)
                  _buildEmptySearchWidget(context)
                else
                  ...filteredElements.map(
                    (e) => SimpleDialogOption(
                      key: Key(e.toLongString()),
                      child: _buildOption(e),
                      onPressed: () {
                        _selectItem(e);
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      );

  Widget _buildOption(Country e) {
    return Container(
      width: 400,
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          if (widget.showFlag)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                e.flag, style: TextStyle(fontSize: 20),
              ),
            ),
          Expanded(
            flex: 4,
            child: Text(
              widget.showCountryOnly
                  ? e.toCountryStringOnly()
                  : e.toLongString(),
              overflow: TextOverflow.fade,
              style: widget.textStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySearchWidget(BuildContext context) {
    if (widget.emptySearchBuilder != null) {
      return widget.emptySearchBuilder(context);
    }

    return Center(
      child: Text('No country found'),
    );
  }

  @override
  void initState() {
    filteredElements = widget.elements;
    super.initState();
  }

  void _filterElements(String s) {
    s = s.toUpperCase();
    setState(() {
      filteredElements = widget.elements
          .where((e) =>
              e.code.contains(s) ||
              e.dialCode.contains(s) ||
              e.name.toUpperCase().contains(s))
          .toList();
    });
  }

  void _selectItem(Country e) {
    Navigator.pop(context, e);
  }
}
