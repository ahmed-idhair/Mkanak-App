class OrderStatistics {
  dynamic assignedOrders;
  dynamic pendingApproval;
  dynamic availableOrders;
  dynamic completedOrders;
  dynamic totalEarnings;


  OrderStatistics({
    this.assignedOrders,
    this.pendingApproval,
    this.availableOrders,
    this.completedOrders,
    this.totalEarnings,
  });

  factory OrderStatistics.fromJson(Map<String, dynamic> json) =>
      OrderStatistics(
        assignedOrders: json["assigned_orders"],
        pendingApproval: json["pending_approval"],
        availableOrders: json["available_orders"],
        completedOrders: json["completed_orders"],
        totalEarnings: json["total_earnings"],
      );

  Map<String, dynamic> toJson() => {
    "assigned_orders": assignedOrders,
    "pending_approval": pendingApproval,
    "available_orders": availableOrders,
    "completed_orders": completedOrders,
    "total_earnings": totalEarnings,
  };
}
