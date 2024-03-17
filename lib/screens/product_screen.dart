import 'package:flutter/material.dart';
import 'package:crystal_tarea_siete/models/product.dart';
import 'package:crystal_tarea_siete/services/database_helper.dart';

class ProductScreen extends StatelessWidget {
  final Product? product;
  const ProductScreen({Key? key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final amountController = TextEditingController();

    if(product != null) {
      nameController.text = product!.name;
      amountController.text = product!.amount.toString();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          product == null ? 'Añadir producto' : 'Editar producto'
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 40.0),
              child: Center(
                child: Text(
                  '¿Qué deseas comprar?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: TextFormField(
                controller: nameController,
                maxLines: 1,
                decoration: const InputDecoration(
                  hintText: 'Nombre',
                  labelText: 'Producto nombre',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white
                    ),
                  ),
                ),
              ),
            ),
            TextFormField(
              controller: amountController,
              decoration: const InputDecoration(
                hintText: 'Cantidad',
                labelText: 'Cantidad del producto',
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white
                  ),
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: SizedBox(
                height: 45,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () async {
                    final name = nameController.value.text;
                    final amount = int.tryParse(amountController.value.text) ??
                        0;

                    if(name.isEmpty || amount <= 0){
                      return;
                    }

                    final Product model = Product(name: name, amount: amount, id: product?.id);
                    if(product == null) {
                      await DatabaseHelper.insertProduct(model);
                    } else {
                      await DatabaseHelper.updateProduct(model);
                    }

                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      const RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.white,
                          width: 0.75,
                        ),
                        borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  child: Text(
                    product == null ? 'Añadir' : 'Editar',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}