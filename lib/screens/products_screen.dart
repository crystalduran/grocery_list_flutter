import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/database_helper.dart';
import '../widgets/product_widget.dart';
import 'product_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Compra'),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ProductScreen()));
          setState(() {
          });
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Product>?>(
        future: DatabaseHelper.getAllProduct(),
        builder: (context, AsyncSnapshot<List<Product>?> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.hasData){
            return ListView.builder(
                itemBuilder: (context, index) => ProductWidget(
                    product: snapshot.data![index],
                    onTap: () async{
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductScreen(
                                product: snapshot.data![index],
                              )));
                      setState(() {});
                    },
                    onLongPress: () async {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                '¿Estás seguro de eliminar este producto?'),
                              actions: [
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      Colors.red)),
                                    onPressed: () async {
                                    await DatabaseHelper.deleteProduct(
                                      snapshot.data![index]);
                                    Navigator.pop(context);
                                    setState(() {

                                    });
                                    },
                                    child: const Text('Sí'),
                                ),
                                ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('No'),
                                ),
                              ],
                            );
                          });
                    },
                ),
              itemCount: snapshot.data!.length,
            );
          }
          return const Center(
            child: Text('Aún no hay productos'),
          );
        }
      ),
    );
  }
}