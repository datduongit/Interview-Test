import 'package:flutter/material.dart';
import 'package:flutter_mvvm/base/mvvm/view.abs.dart';
import 'package:flutter_mvvm/common/ui_components/app_button.dart';
import 'package:flutter_mvvm/presentation/pages/home/home_page_vm.dart';

class HomePage extends View<HomePageViewModel> {
  const HomePage({required HomePageViewModel viewModel, Key? key})
      : super.model(viewModel, key: key);

  @override
  _HomePageState createState() => _HomePageState(viewModel);
}

class _HomePageState extends ViewState<HomePage, HomePageViewModel> {
  _HomePageState(HomePageViewModel viewModel) : super(viewModel);

  @override
  void initState() {
    super.initState();
    listenToRoutesSpecs(viewModel.routes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'DEMO',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                const SizedBox(height: 32),
                AppButton(
                  onTap: viewModel.cardPageButtonTapped,
                  child: Text(
                    'Go to add card page',
                    style: Theme.of(context)
                        .textTheme
                        .button
                        ?.copyWith(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
