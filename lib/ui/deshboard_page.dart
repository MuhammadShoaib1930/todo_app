import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/blocs/bloc/database_bloc.dart';

class DeshboardPage extends StatefulWidget {
  const DeshboardPage({super.key});

  @override
  State<DeshboardPage> createState() => _DeshboardPageState();
}

class _DeshboardPageState extends State<DeshboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("TODO"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: BlocBuilder<DatabaseBloc, DatabaseState>(
          builder: (context, state) {
            if (state is DatabaseLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is DatabaseError) {
              return Center(child: Text(state.message));
            }
            if (state is DatabaseInitial) {
              context.read<DatabaseBloc>().add(FeatchedEvent());
              return Center(child: CircularProgressIndicator());
            }
            if (state is DatabaseEmpty) {
              return Center(child: Text("Empty"));
            }
            if (state is DatabaseLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  double horizontalDrag = 0;
                  return GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      horizontalDrag += details.delta.dx;
                    },
                    onHorizontalDragEnd: (details) {
                      if (horizontalDrag > 100) {
                        context.read<DatabaseBloc>().add(
                          UpdateEvent(
                            state.data[index]['SN'],
                            state.data[index]['Title'],
                            state.data[index]['Description'],
                            (state.data[index]['workDone'] == 1) ? 0 : 1,
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Done"), backgroundColor: Colors.green),
                        );
                      } else if (horizontalDrag < -100) {
                        context.read<DatabaseBloc>().add(DeleteEvent(state.data[index]['SN']));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Deleted"), backgroundColor: Colors.red),
                        );
                      }

                      horizontalDrag = 0; // reset
                    },

                    child: Card(
                      elevation: 20,
                      borderOnForeground: true,
                      margin: EdgeInsets.all(0.8),
                      semanticContainer: true,
                      shape: Border.all(style: BorderStyle.solid),
                      child: ListTile(
                        title: Text(
                          state.data[index]['Title'] ?? "",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,

                            overflow: TextOverflow.fade,
                            decoration: (state.data[index]['workDone'] == 1)
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        subtitle: Text(
                          "${state.data[index]['Description']} ${state.data[index]['dateTime']}",
                          style: TextStyle(
                            fontSize: 18,
                            overflow: TextOverflow.fade,
                            decoration: (state.data[index]['workDone'] == 1)
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: state.data.length,
              );
            }
            return SizedBox();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (context) => _dialogButton());
        },
        child: Text("+"),
      ),
    );
  }

  Widget _dialogButton() {
    String title = "";
    String description = "";
    final formKey = GlobalKey<FormState>();
    return Center(
      child: SizedBox(
        width: 350,
        height: 300,

        child: Card(
          color: Colors.white,

          child: Form(
            key: formKey,
            child: Column(
              children: [
                Divider(),
                Center(
                  child: Text(
                    "Add new task",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsetsGeometry.only(left: 10, right: 10),
                  child: TextFormField(
                    key: ValueKey("title"),
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return "Write title";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (newValue) {
                      title = newValue.toString().trim();
                    },
                    decoration: InputDecoration(
                      hintText: "Title",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsetsGeometry.only(left: 10, right: 10),
                  child: TextFormField(
                    key: ValueKey("description"),
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return "Write title";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (newValue) {
                      description = newValue.toString().trim();
                    },
                    decoration: InputDecoration(
                      hintText: "Description",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Close"),
                    ),
                    SizedBox(width: 10),

                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          context.read<DatabaseBloc>().add(AddEvent(title, description));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Added"), backgroundColor: Colors.green),
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: Text("Ok"),
                    ),
                    SizedBox(width: 20),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
