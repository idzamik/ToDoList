import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  String _data = 'Loading...';

  // Асинхронная функция для получения данных
  Future<String> _fetchData() async {
    await Future.delayed(const Duration(seconds: 2)); // Эмуляция задержки
    return 'Данные получены!';
  }

  @override
  void initState() {
    super.initState();

    // Вызываем _fetchData() и ждем завершения
    _fetchData().then((data) {
      // Обновляем состояние после получения данных
      setState(() {
        _data = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Пример ожидания Future')),
      body: Center(child: Text(_data)),
    );
  }
}
