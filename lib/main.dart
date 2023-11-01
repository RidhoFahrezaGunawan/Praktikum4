import 'package:flutter/material.dart';
import 'sqlite_service.dart';
import 'package:sqlite/models/user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sahamku',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'SAHAMIN'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late DatabaseHandler handler;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tickerController = TextEditingController();
  final TextEditingController _openController = TextEditingController();
  final TextEditingController _highController = TextEditingController();
  final TextEditingController _lastController = TextEditingController();
  final TextEditingController _changeController = TextEditingController();

  Future<int> addsahamin() async {
    Sahamku tlkm = Sahamku(ticker: "TLKM", open: 3380, high: 3500, last: 3490, change: "2,05");
    Sahamku ammn = Sahamku(ticker: "AMMN", open: 6750, high: 6750, last: 6500, change: "-3,7");
    Sahamku bren = Sahamku(ticker: "BREN", open: 4500, high: 4610, last: 4580, change: "1,78");
    Sahamku cuan = Sahamku(ticker: "CUAN", open: 5200, high: 5525, last: 5400, change: "3,85");

    List<Sahamku> listOfsahamin = [tlkm, ammn, bren, cuan];

    return await this.handler.insertSahamku(listOfsahamin);
  }

  @override
  void initState() {
    super.initState();

    this.handler = DatabaseHandler();
    this.handler.initializeDB().whenComplete(() async {
      await this.addsahamin();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _tickerController,
                    decoration: InputDecoration(labelText: 'Ticker'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the ticker';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _openController,
                    decoration: InputDecoration(labelText: 'Open'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the open value';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _highController,
                    decoration: InputDecoration(labelText: 'High'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the high value';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _lastController,
                    decoration: InputDecoration(labelText: 'Last'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the last value';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _changeController,
                    decoration: InputDecoration(labelText: 'Change'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the change value';
                      }
                      return null;
                    },
                  ),
                  // Repeat for high, last, and change fields...
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Create new saham object and save to DB
                        Sahamku newSaham = Sahamku(
                          ticker: _tickerController.text,
                          open: int.parse(_openController.text),
                          high: int.parse(_highController.text),
                          last: int.parse(_lastController.text),
                          change: _changeController.text,
                        );
                        await handler.insertSahamku(newSaham);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data saham berhasil disimpan')));
                        setState(() {});
                      }
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Sahamku>>(
              builder: (BuildContext context, AsyncSnapshot<List<Sahamku>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      Sahamku newSaham = snapshot.data![index];
                      return ListTile(
                        title: Text('${newSaham.ticker}'),
                        subtitle: Text('Open: ${newSaham.open}, High: ${newSaham.high}, Last: ${newSaham.last}'),
                        trailing: Text(
                          'Change: ${newSaham.change}',
                          style: TextStyle(
                            color: newSaham.change?.startsWith('-') ?? false ? Colors.red : Colors.green,
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
              future: handler.retrievesahamin(),
            ),
          ),
        ],
      ),
    );
  }
}