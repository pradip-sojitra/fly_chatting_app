class CallModel {
  CallModel({
    required this.callerId,
    required this.callerName,
    required this.callerPic,
    required this.receiverId,
    required this.receiverName,
    required this.receiverPic,
    required this.channelId,
    this.hasDialled,
  });

  String callerId;
  String callerName;
  String callerPic;
  String receiverId;
  String receiverName;
  String receiverPic;
  String channelId;
  bool? hasDialled;

  factory CallModel.fromJson(Map<String, dynamic> json) => CallModel(
        callerId: json["callerId"],
        callerName: json["callerName"],
        callerPic: json["callerPic"],
        receiverId: json["receiverId"],
        receiverName: json["receiverName"],
        receiverPic: json["receiverPic"],
        channelId: json["channelId"],
        hasDialled: json["hasDialled"],
      );

  Map<String, dynamic> toJson() => {
        "callerId": callerId,
        "callerName": callerName,
        "callerPic": callerPic,
        "receiverId": receiverId,
        "receiverName": receiverName,
        "receiverPic": receiverPic,
        "channelId": channelId,
        "hasDialled": hasDialled,
      };
}
