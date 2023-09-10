import 'package:flutter/material.dart';

class PointOfSaleScreen extends StatefulWidget {
  @override
  _PointOfSaleScreenState createState() => _PointOfSaleScreenState();
}

class _PointOfSaleScreenState extends State<PointOfSaleScreen> {
  // Placeholder for products
  final List<Product> products = [
    Product('Product 1', 10.99),
    Product('Product 2', 15.99),
    Product('Product 3', 8.99),
    // Add more products as needed
  ];

  final MOBILE_CONSTRAIN_WIDTH = 500;

  // Placeholder for the shopping cart
  final List<Product> cart = [];

  @override
  void initState() {
    super.initState();

    cart.add(products[1]);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          if (MediaQuery.of(context).size.width > MOBILE_CONSTRAIN_WIDTH)
            productWidget(),
          cartWidget(context),
        ],
      ),
    );
  }

  Expanded productWidget() {
    return Expanded(
      flex: 3,
      child: Column(
        children: <Widget>[
          Text(
            'Products',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (ctx, index) {
                return ListTile(
                  title: Text(products[index].name),
                  subtitle:
                      Text('\$${products[index].price.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: Icon(Icons.add_shopping_cart),
                    onPressed: () {
                      setState(() {
                        cart.add(products[index]);
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Expanded cartWidget(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
        color: Colors.grey[200],
        child: Column(
          children: [
            Expanded(
                flex: 5,
                child: Column(
                  children: [
                    Text(
                      'Cart',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: cart.length,
                        itemBuilder: (ctx, index) {
                          return ListTile(
                            title: Text(cart[index].name),
                            subtitle: Text(
                                '\$${cart[index].price.toStringAsFixed(2)}'),
                            trailing: IconButton(
                              icon: Icon(Icons.remove_shopping_cart),
                              onPressed: () {
                                setState(() {
                                  cart.removeAt(index);
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
            )),
            numPad(context),
          ],
        ),
      ),
    );
  }

  Expanded numPad(BuildContext context) {
    return Expanded(
      flex: 6,
      child: SizedBox(
        child: GridView.builder(
          padding: EdgeInsets.all(8.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              // Mobile childAspectRatio : (width / height)
              // Desktop childAspectRatio : (height / width)
              childAspectRatio:
                  (MediaQuery.of(context).size.width <= MOBILE_CONSTRAIN_WIDTH)
                      ? MediaQuery.of(context).size.height /
                          MediaQuery.of(context).size.width
                      : MediaQuery.of(context).size.width /
                          MediaQuery.of(context).size.height,
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8),
          itemCount: 11, // You can customize the number of buttons
          itemBuilder: (ctx, index) {
            if (index + 1 == 10) return Container();
            if (index + 1 == 11) return NumberButton(0);
            return NumberButton(index + 1);
          },
        ),
      ),
    );
  }
}

class Product {
  final String name;
  final double price;

  Product(this.name, this.price);
}

class NumberButton extends StatelessWidget {
  final int number;

  NumberButton(this.number);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2.0,
      borderRadius: BorderRadius.circular(8),
      // borderOnForeground: true,
      child: InkWell(
        onTap: () {
          // Handle button press, e.g., adding a quantity of the selected product to the cart
          print(number);
        },
        child: Container(
          decoration: BoxDecoration(

          ),
          alignment: Alignment.center,
          child: Text(
            number.toString(),
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
