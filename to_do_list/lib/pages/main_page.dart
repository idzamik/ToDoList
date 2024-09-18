import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/api/models/deal_model.dart';
import 'package:to_do_list/data/get_set_data.dart';


void _createNote(int id, String title, String text, details, List<DealModelData> listOfMyDeals) {

  final DealModelData object = DealModelData(
    id: id,
    title: title,
    text: text,
    charts_is_done: false
  );
  listOfMyDeals.add(object);
  setDataDeals('dealsData', DealModel(deal: listOfMyDeals));
}


Future<void> _deleteNote(int id) async {
  final DealModel responce = await getDataDeals('dealsData');
  for (int i = 0; i < responce.deal.length; i++) {
    if (responce.deal[i].id == id) {
      responce.deal.removeAt(i);
      break;
    }
  }
  setDataDeals('dealsData', DealModel(deal: responce.deal));
}


Future<void> _editCart(id) async {
  print('смена состояние дела');
  DealModel responce = await getDataDeals('dealsData');
  for (int i = 0; i < responce.deal.length; i++) {
    if (responce.deal[i].id == id) {
      responce.deal[i].charts_is_done = (!responce.deal[i].charts_is_done);
      break;
    }
  }
  setDataDeals('dealsData', DealModel(deal: responce.deal));
}


List<DealModelData> sortDeals(List<DealModelData> deals) {
  deals.sort((a, b) {
    if (a.charts_is_done == b.charts_is_done) {
      return a.id.compareTo(b.id);
    }
    return a.charts_is_done ? 1 : -1;
  });

  return deals;
}


List<PieChartSectionData> _sectionsCreation(List<DealModelData> listOfMyDeals) {
  late List<PieChartSectionData> sections = [];
  for (int i = 0; i < listOfMyDeals.length; i++) {
    sections.add(
      PieChartSectionData(
        color: listOfMyDeals[i].charts_is_done ? Colors.blue : Colors.red,
      )
    );
  }
  return sections;
}


class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  TextEditingController titleController = TextEditingController();
  TextEditingController textController = TextEditingController();
  late List<DealModelData> listOfMyDeals = [];

  @override
  void initState() {
    _getlist();
    super.initState();
  }

  void _getlist() async {
    final DealModel responce = await getDataDeals('dealsData');
    setState(() {
      listOfMyDeals = responce.deal;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                _addButton(context),
                _sortButton(),
                _delButton(),
              ],
            )
          ),
        ),
        _listNotes(listOfMyDeals)
      ],
    );
  }


  Widget _addButton(context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              // title: ,
              content: SizedBox(
                width: 400,
                height: 350,
                child: Column(
                  children: [
                    Text('Заголовок'),
                    _textField(titleController, 'Заголовок', 3),

                    SizedBox(height: 50,),
                  
                    Text('Текст'),
                    _textField(textController, '', 6)
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {

                    final chartP = PieChartSectionData(
                      color: Colors.blue
                    );

                    int idRange = await getIdRange('idRange');
                    idRange += 1;
                    setIdRange('idRange', idRange);

                    setState(() {
                      _createNote(
                        idRange,
                        titleController.text,
                        textController.text,
                        chartP,
                        listOfMyDeals
                      );
                      titleController.text = "";
                      textController.text = "";

                    });

                    Navigator.pop(context, 'Добавить');
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


  Widget _sortButton() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.black,
          elevation: 6,
          backgroundColor: Colors.grey,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Устанавливаем радиус закругления
          ),
        ),
        onPressed: () async {
          DealModel responce = await getDataDeals('dealsData');
          final sortedDeals = sortDeals(responce.deal);
          setDataDeals('dealsData', DealModel(deal: sortedDeals));
          _getlist();
        }, 
        child: const Icon(
          color: Colors.black,
          Icons.sort
        )),
      )
    );
  }


  Widget _delButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.black,
          elevation: 6,
          backgroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Устанавливаем радиус закругления
          ),
        ),
        onPressed: () async {
          deleteDataDeals('dealsData');
          setIdRange('idRange', 0);
          _getlist();
        }, 
        child: const Icon(
          color: Colors.white,
          Icons.cleaning_services_rounded
        )),
      )
    );
  }


  Widget _diogramWidget () {
    if (listOfMyDeals == []) {
      return const Center(child: CircularProgressIndicator()); 
    } else {
      return Container(
        padding: const EdgeInsets.all(16),
        child: PieChart(
          swapAnimationDuration: const Duration(milliseconds: 200),
          swapAnimationCurve: Curves.easeInOutQuint,
          PieChartData(
            sections: _sectionsCreation(listOfMyDeals)
          )
        )
      );
    }
  }


  Widget _listNotes(List listOfMyDeals) {
    if (listOfMyDeals == []) {
      return const Center(child: CircularProgressIndicator()); 
    } else {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return GestureDetector(
              onDoubleTap: () async {
                await _editCartNote(
                  listOfMyDeals[index].id,
                  listOfMyDeals[index].title
                );
              },
              onLongPress: () {
                _infoCartNote(
                  listOfMyDeals[index].id,
                  listOfMyDeals[index].title,
                  listOfMyDeals[index].text,
                  );
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
              margin: const EdgeInsets.only(
                top: 15,
                right: 15,
                left: 15,
              ),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: listOfMyDeals[index].charts_is_done ? Colors.blue : Colors.red,
                borderRadius: BorderRadius.circular(20), // Радиус закругления
              ),
              height: 100.0,
              child: Center(
                child: Column(
                  children: [
                    Text(
                      listOfMyDeals[index].title,
                      style: const TextStyle(
                        fontSize: 25,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      listOfMyDeals[index].text,
                      style: const TextStyle(
                        fontSize: 16,
                        overflow: TextOverflow.ellipsis,
                      ),
                      )
                  ],
                ),
              ),
            ));
            
          },
          childCount: listOfMyDeals.length,
        ),
      );
    }
  }


  _editCartNote(int id, String text) async {
    await _editCart(id);
    _getlist();
  }

  
  _infoCartNote(int id, String title, String text) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Center(
          child: Text(title)),
        content: SizedBox(
          width: 400,
          height: 150,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {},
            onLongPress: () async {
              await _deleteNote(id);

              _getlist();

              Navigator.pop(context, 'Удалить');
            },
            child: const Icon(Icons.delete, color: Colors.red), 
          ),
        ],
      ),
    );
  }
}