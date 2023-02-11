class CallModel {
  CallModel({
    required this.callerId,
    required this.callerName,
    required this.callerPic,
    required this.receiverId,
    required this.receiverName,
    required this.receiverPic,
    required this.callId,
    required this.hasDialled,
  });

  final String callerId;
  final String callerName;
  final String callerPic;
  final String receiverId;
  final String receiverName;
  final String receiverPic;
  final String callId;
  final bool hasDialled;

  factory CallModel.fromJson(Map<String, dynamic> json) => CallModel(
        callerId: json["callerId"],
        callerName: json["callerName"],
        callerPic: json["callerPic"],
        receiverId: json["receiverId"],
        receiverName: json["receiverName"],
        receiverPic: json["receiverPic"],
        callId: json["callId"],
        hasDialled: json["hasDialled"],
      );

  Map<String, dynamic> toJson() => {
        "callerId": callerId,
        "callerName": callerName,
        "callerPic": callerPic,
        "receiverId": receiverId,
        "receiverName": receiverName,
        "receiverPic": receiverPic,
        "callId": callId,
        "hasDialled": hasDialled,
      };
}
