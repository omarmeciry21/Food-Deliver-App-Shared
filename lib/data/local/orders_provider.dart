import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/order/new_order.dart';

String tableName = "NewOrders";
String restaurantIdColumnName = "restaurantId";
String paymentMethodColumnName = "paymentMethod";
String latitudeColumnName = "latitude";
String longitudeColumnName = "longitude";
String addressInformationColumnName = "addressInformation";
String deliveryPriceColumnName = "deliveryPrice";
String mealsColumnName = "meals";

class OrdersProvider {
  static final OrdersProvider instance = OrdersProvider._internal();

  factory OrdersProvider() {
    return instance;
  }

  OrdersProvider._internal();

  late Database db;

  Future open() async {
    db = await openDatabase(join(await getDatabasesPath(), 'new_orders2.db'),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute('''
create table $tableName ( 
  $restaurantIdColumnName integer ,
  $paymentMethodColumnName integer ,
  $latitudeColumnName text ,
  $longitudeColumnName text ,
  $addressInformationColumnName text ,
  $deliveryPriceColumnName integer ,
  $mealsColumnName text )
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
    // print('|||||||');
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
