import 'package:flutter/material.dart';

import 'package:twic_app/style/style.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class AutoCompleteElement {
  int id;
  String name;
  String logo;
  dynamic data;

  AutoCompleteElement({this.id, this.name, this.logo, this.data});
}

class Autocomplete<T extends AutoCompleteElement> extends StatelessWidget {
  final String placeholder;
  final IconData icon;
  final double iconSize;
  final bool obscureText;
  final Function onSaved;
  final Function validator;
  final Function itemBuilder;
  final Function itemSubmitted;
  final Function itemSorter;
  final Function itemFilter;
  final Function textChanged;
  final List<T> suggestions;
  final int minLength;
  final int suggestionsAmount;
  final double size;
  final GlobalKey<AutoCompleteTextFieldState<T>> fieldKey;

  final String initialValue;

  static GlobalKey<AutoCompleteTextFieldState<AutoCompleteElement>> getKey() {
    return GlobalKey<AutoCompleteTextFieldState<AutoCompleteElement>>();
  }

  Autocomplete(
      {this.placeholder,
      this.icon,
      this.obscureText,
      this.onSaved,
      this.itemBuilder,
      this.itemSubmitted,
      this.itemFilter,
      this.itemSorter,
      this.textChanged,
      this.suggestions,
      this.initialValue,
      this.validator,
      this.fieldKey,
      this.suggestionsAmount,
      this.minLength,
      this.size,
      this.iconSize});

  @override
  Widget build(BuildContext context) {
    final Size mediaSize = MediaQuery.of(context).size;
    AutoCompleteTextField<T> autocomplete = AutoCompleteTextField<T>(
      clearOnSubmit: true,
      itemBuilder: itemBuilder ??
          (BuildContext context, T item) => Container(
              height: 50.0,
              child: OverflowBox(
                  alignment: Alignment(0.0, 0.0),
                  minWidth: size ?? mediaSize.width - 40.0,
                  maxWidth: size ?? mediaSize.width - 40.0,
                  child: Container(
                      color: Colors.white,
                      child: ListTile(
                        leading: item.logo != null
                            ? Image.asset(
                                item.logo,
                                width: 20.0,
                                height: 20.0,
                              )
                            : null,
                        title: Text(
                          item.name,
                          style: Style.largeText,
                        ),
                      )))),
      itemSorter: itemSorter ??
          (T a, T b) {
            return a.name.compareTo(b.name);
          },
      itemFilter: itemFilter ??
          (T item, String query) {
            return query.length == 0 ||
                item.name.toLowerCase().startsWith(query.toLowerCase());
          },
      itemSubmitted: itemSubmitted,
      textChanged: textChanged,
      keyboardType: TextInputType.text,
      key: fieldKey,
      suggestions: suggestions,
      controller: null != initialValue
          ? TextEditingController(text: initialValue)
          : null,
      suggestionsAmount: this.suggestions.length,
      onFocusChanged: (bool focused) {},
      minLength: this.minLength,
      decoration: InputDecoration(
          icon: icon != null
              ? Icon(
                  icon,
                  size: iconSize,
                  color: Style.lightGrey,
                )
              : null,
          border: InputBorder.none,
          fillColor: Style.grey,
          hintText: this.placeholder),
    );
    if (null != this.initialValue && null != fieldKey.currentState) {
      autocomplete.textField.controller.text = this.initialValue;
    }

    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Style.shadow,
              offset: Offset(10.0, 10.0),
              blurRadius: 30.0)
        ],
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: autocomplete,
    );
  }
}
