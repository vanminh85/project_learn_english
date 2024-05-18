import 'package:chatgpt/data/methods.dart';
import 'package:chatgpt/model/base_model.dart.dart';

class ChatModel extends BaseModel {
  ChatModel(super.data);

  String get msg => Methods.getString(data, 'msg');
  ///Check user chat 
  bool get isUserChat => Methods.getInt(data, 'chatIndex')==0?true:false;
  String get root => Methods.getString(data, 'root');

  @override
  String toString() {
    return 'msg: $msg - chatIndex: $isUserChat';
  }
}
