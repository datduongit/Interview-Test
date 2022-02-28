import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_mvvm/base/mvvm/app_routes.dart';
import 'package:flutter_mvvm/base/mvvm/view_model.abs.dart';
import 'package:flutter_mvvm/presentation/pages/card/card_model.dart';
import 'package:rxdart/rxdart.dart';

class AddCardPageState {
  final int count;
  final bool isMinusEnabled;
  final bool isPlusEnabled;

  AddCardPageState({
    this.isMinusEnabled = false,
    this.isPlusEnabled = true,
    this.count = 0,
  });

  AddCardPageState copyWith({
    bool? isMinusEnabled,
    bool? isPlusEnabled,
    int? count,
  }) {
    return AddCardPageState(
      isMinusEnabled: isMinusEnabled ?? this.isMinusEnabled,
      isPlusEnabled: isPlusEnabled ?? this.isPlusEnabled,
      count: count ?? this.count,
    );
  }
}

class AddCardPageViewModel extends ViewModel {
  final BehaviorSubject<AddCardPageState> _stateSubject =
      BehaviorSubject<AddCardPageState>.seeded(AddCardPageState());
  Stream<AddCardPageState> get stateStream => _stateSubject;

  final BehaviorSubject<Product> _product = BehaviorSubject<Product>();
  Stream<Product> get productStream => _product.stream;

  final BehaviorSubject<int> _total = BehaviorSubject<int>();
  Stream<int> get totalStream => _total.stream;

  final BehaviorSubject<Item> _itemSelected = BehaviorSubject<Item>();
  Sink<Item> get itemSelectedSink => _itemSelected.sink;
  Stream<Item> get itemSelectedStream => _itemSelected.stream;

  final PublishSubject<AppRouteSpec> _routesSubject =
      PublishSubject<AppRouteSpec>();
  Stream<AppRouteSpec> get routes => _routesSubject;

  @override
  void init() {
    readJson();
    bind();
    super.init();
  }

  void bind() {
    Rx.combineLatest3(productStream, stateStream, itemSelectedStream,
        (Product product, AddCardPageState state, Item item) {
      if (item.isCheck) {
        return (product.price + item.subPrice) * state.count;
      } else {
        return product.price * state.count;
      }
    }).listen((total) {
      _total.sink.add(total);
    });

    itemSelectedStream.listen((item) {
      Product productChange = _product.value;
      List<Item> itemChange = [];
      for (var i in productChange.items) {
        if (i.title == item.title) {
          i.isCheck = item.isCheck;
        } else {
          i.isCheck = false;
        }
        itemChange.add(i);
      }
      productChange.items = itemChange;
      _product.sink.add(productChange);
    });
  }

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/json/data.json');
    final dynamic data = await json.decode(response);
    final Product product = Product.fromJson(data['product']);
    _product.sink.add(product);
    _itemSelected.sink.add(product.items.first);
  }

  void plusButtonTapped() {
    _updateState(_stateSubject.value.count + 1);
  }

  void minusButtonTapped() {
    _updateState(_stateSubject.value.count - 1);
  }

  void popButtonTapped() {
    _routesSubject.add(
      const AppRouteSpec.pop(),
    );
  }

  void _updateState(int newCount) {
    final AddCardPageState state = _stateSubject.value;
    _stateSubject.add(
      state.copyWith(
        count: newCount,
        isPlusEnabled: newCount < 5,
        isMinusEnabled: newCount > 0,
      ),
    );
  }

  @override
  void dispose() {
    _stateSubject.close();
    _routesSubject.close();
    _product.close();
    _total.close();
    _itemSelected.close();
  }
}
