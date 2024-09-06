import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/api/models/deal_model.dart';
import 'package:to_do_list/data/get_set_data.dart';


void _createNote(int id, String title, String text, details, List<DealModelData>? listOfMyDeals) {

  final object = DealModelData(
    id: 1,
    title: title,
    text: text,
    charts: [],
  );
  listOfMyDeals?.add(object);
  setDataDeals('dealsData', DealModel(deal: listOfMyDeals));
  print(listOfMyDeals);
}


class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  TextEditingController titleController = TextEditingController();
  TextEditingController textController = TextEditingController();
  List<DealModelData>? listOfMyDeals = [];

  @override
  void initState() {
    _getlist();
    super.initState();
  }

  void _getlist() async {
    final responce = await getDataDeals('dealsData');
    print('<${responce?.deal}>- получение данных о делах ');

    setState(() {
      listOfMyDeals = responce?.deal;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('<${listOfMyDeals?[0].text}>- данные о делах');
    return Scaffold(
      body: SafeArea(
        child: _listOfWidgets(context)
      ),
    );
  }


  Widget _listOfWidgets(context) {
    return CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 350,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  _diogramWidget(),
                  _addbutton(context)
                ],
              )
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  color: index.isOdd ? Colors.white : Colors.black12,
                  height: 100.0,
                  child: Center(
                    child: Text('$index',
                        textScaler: const TextScaler.linear(5.0)),
                  ),
                );
              },
              childCount: 20,
            ),
          ),
        ],
      );
  }


  Widget _addbutton(context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              // title: ,
              content: SizedBox(
                width: 400,
                height: 400,
                child: Column(
                  children: [
                    Text('Заголовок'),
                    _textField(titleController, 'Заголовок', 1),
                  
                    Text('Текст'),
                    _textField(textController, '', 8)
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {

                    final chartP = PieChartSectionData(
                      color: Colors.blue
                    );

                    _createNote(
                      1,
                      titleController.text,
                      textController.text,
                      chartP,
                      listOfMyDeals
                    );

                    // Navigator.pop(context, 'Добавить');
                  },
                  child: const Text('Добавить'),
                ),
              ],
            ),
          );
        },
        
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.black,
          elevation: 6,
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Устанавливаем радиус закругления
          ),
        ),
      
        child: Icon(Icons.add, color: Colors.white,)
      ),
    );
  }


  Widget _textField(TextEditingController controller, String text, int size) {
    return Container(
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(10),
      ),
      child: TextField(
        maxLines: size,
        textInputAction: TextInputAction.next,
        style: const TextStyle(),
        controller: controller,
        // decoration: InputDecoration(
        //   hintText: text,
        //   hintStyle: const TextStyle(),
        //   border: OutlineInputBorder(
        //     borderRadius: BorderRadius.all(
        //         Radius.circular(15)),
        //   ),
        //   contentPadding: EdgeInsets.symmetric(horizontal: 15),

        //   suffixIcon: Icon(Icons.abc)
        // ),
      ),
    );
  }


  Widget _diogramWidget () {
    return Container(
      padding: const EdgeInsets.all(16),
      child: PieChart(
        swapAnimationDuration: const Duration(microseconds: 600),
        swapAnimationCurve: Curves.easeInOutQuint,
        PieChartData(
          sections: [
            PieChartSectionData(
              color: Colors.blue
            ),
            PieChartSectionData(
              color: Colors.blue
            )
          ]
        )
      )
    );
  }
}