import 'package:mkanak/core/models/wallet/transactions.dart';

class Wallet {
  dynamic balance;
  List<Transaction>? transactions;

  Wallet({this.balance, this.transactions});

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
    balance: json["balance"],
    transactions:
        json["transactions"] != null
            ? List<Transaction>.from(
              json["transactions"].map((x) => Transaction.fromJson(x)),
            )
            : [],
  );

  Map<String, dynamic> toJson() => {
    "balance": balance,
    "transactions": List<dynamic>.from(transactions!.map((x) => x.toJson())),
  };
}
