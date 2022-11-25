import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/order/new_order.dart';

String tableName = "NewOrders";
String restaurantIdColumnName = "restaurantIdColumnName";
String paymentMethodColumnName = "paymentMethodColumnName";
String latitudeColumnName = "latitudeColumnName";
String longitudeColumnName = "longitudeColumnName";
String addressInformationColumnName = "addressInformationColumnName";
String deliveryPriceColumnName = "deliveryPriceColumnName";
String mealsColumnName = "mealsColumnName";

class NewOrdersProvider {
  static final NewOrdersProvider instance = NewOrdersProvider._internal();

  factory NewOrdersProvider() {
    return instance;
  }

  NewOrdersProvider._internal();

  late Database db;

  Future open(String path) async {
    db = await openDatabase(join(await getDatabasesPath(), 'new_orders.db'),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute('''
create table $tableName ( 
  $restaurantIdColumnName integer not null, 
  $paymentMethodColumnName integer not null, 
  $latitudeColumnName text not null,
  $longitudeColumnName text not null,
  $addressInformationColumnName text not null,
  $deliveryPriceColumnName integer not null,
  $mealsColumnName text not null)
''');
    });
  }

  Future<NewOrder> insert(NewOrder newOrder) async {
    await db.insert(tableName, newOrder.toLocalJson());
    return newOrder;
  }

  Future<NewOrder> getNewOrder(int restaurantId) async {
    List<Map<String, dynamic>> maps = await db.query(tableName,
        where: '$restaurantIdColumnName = ?', whereArgs: [restaurantId]);
    if (maps.length > 0) {
      return NewOrder.fromLocalJson(maps.first);
    } else
      throw ("No order for this restaurant");
  }

  Future<int> delete(int restaurantId) async {
    return await db.delete(tableName,
        where: '$restaurantIdColumnName = ?', whereArgs: [restaurantId]);
  }

  Future<int> update(NewOrder newOrder) async {
    return await db.update(tableName, newOrder.toLocalJson(),
        where: '$restaurantIdColumnName = ?',
        whereArgs: [newOrder.restaurantId]);
  }

  Future close() async => db.close();
}
