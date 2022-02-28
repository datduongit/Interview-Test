import 'package:flutter/material.dart';
import 'package:flutter_mvvm/base/mvvm/view.abs.dart';
import 'package:flutter_mvvm/common/ui_components/app_button.dart';
import 'package:flutter_mvvm/presentation/pages/card/add_card_vm.dart';
import 'package:flutter_mvvm/presentation/pages/card/card_model.dart';

class AddCardPage extends View<AddCardPageViewModel> {
  const AddCardPage({required AddCardPageViewModel viewModel, Key? key})
      : super.model(viewModel, key: key);

  @override
  _AddCardPageState createState() => _AddCardPageState(viewModel);
}

class _AddCardPageState extends ViewState<AddCardPage, AddCardPageViewModel> {
  _AddCardPageState(AddCardPageViewModel viewModel) : super(viewModel);

  @override
  void initState() {
    super.initState();
    listenToRoutesSpecs(viewModel.routes);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AddCardPageState>(
      stream: viewModel.stateStream,
      builder:
          (BuildContext context, AsyncSnapshot<AddCardPageState> snapshot) {
        if (!snapshot.hasData) return Container();
        final AddCardPageState state = snapshot.data!;
        return Scaffold(
          body: Stack(
            children: <Widget>[_buildBody(state), _buildBack()],
          ),
        );
      },
    );
  }

  Widget _buildBody(AddCardPageState state) {
    return StreamBuilder<Product>(
        stream: viewModel.productStream,
        builder: (BuildContext context, AsyncSnapshot<Product> snapshot) {
          if (!snapshot.hasData) return Container();
          final Product product = snapshot.data!;
          return Column(
            children: <Widget>[
              Image.asset(
                product.urlPath,
                width: double.infinity,
                height: 250,
                fit: BoxFit.fill,
              ),
              const SizedBox(height: 16),
              Text(
                product.name,
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 8),
              Text(product.des),
              const SizedBox(height: 5),
              const Divider(),
              _buildNumberProductRow(product, state),
              _buildTitle(
                'MILK OPTION (REQUIRED)',
                const TextStyle(fontWeight: FontWeight.w500),
                Colors.black12,
              ),
              _buildTitle(
                'Please select 1 item',
                const TextStyle(fontWeight: FontWeight.bold),
                Colors.black26,
              ),
              const SizedBox(height: 8),
              Flexible(child: _buildList(product)),
              _buildAddCard(),
              const SizedBox(height: 32),
            ],
          );
        });
  }

  Widget _buildBack() {
    return Positioned(
      top: 50,
      left: 16,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: AppButton(
          onTap: viewModel.popButtonTapped,
          child: const Icon(
            Icons.arrow_back,
            size: 35,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildNumberProductRow(Product product, AddCardPageState state) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${product.price} USD',
            style: Theme.of(context).textTheme.headline6,
          ),
          const Spacer(),
          AppButton(
            isEnabled: state.isMinusEnabled,
            onTap: viewModel.minusButtonTapped,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
              child: const Icon(
                Icons.remove,
                size: 15,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '${state.count}',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          AppButton(
            isEnabled: state.isPlusEnabled,
            onTap: viewModel.plusButtonTapped,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
              child: const Icon(
                Icons.add,
                size: 15,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(String title, TextStyle style, Color bgColor) {
    return Container(
      width: double.infinity,
      color: bgColor,
      padding: const EdgeInsets.all(16),
      child: Text(
        title,
        style: style,
      ),
    );
  }

  Widget _buildList(Product product) {
    return Container(
      padding: const EdgeInsets.only(left: 16),
      color: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: product.items.map(_buildSelectItem).toList(),
      ),
    );
  }

  Widget _buildSelectItem(Item item) {
    final String title =
        item.subPrice > 0 ? item.title + ' (${item.subPrice} USD)' : item.title;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headline6,
            ),
            const Spacer(),
            Checkbox(
              value: item.isCheck,
              onChanged: (isCheck) {
                Item _item = item;
                _item.isCheck = !item.isCheck;
                viewModel.itemSelectedSink.add(_item);
              },
            )
          ],
        ),
        const Divider()
      ],
    );
  }

  Widget _buildAddCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(left: 20, right: 20),
      color: Colors.green,
      width: double.infinity,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(
            Icons.store_sharp,
            size: 20,
            color: Colors.white,
          ),
          const Text('ADD 1 TO CARD',
              style: TextStyle(fontWeight: FontWeight.w500)),
          StreamBuilder<int>(
              stream: viewModel.totalStream,
              builder: (context, snapshot) {
                final int total = snapshot.hasData ? snapshot.data! : 0;
                return Text('$total',
                    style: const TextStyle(fontWeight: FontWeight.w500));
              }),
        ],
      ),
    );
  }
}
