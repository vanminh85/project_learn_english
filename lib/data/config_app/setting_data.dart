import 'package:chatgpt/model/models_model.dart';

class SettingData {
  static final SettingData _instance = SettingData._internal();

  factory SettingData() {
    return _instance;
  }

  SettingData._internal() {
    listModelsModel = [];
    currentModel = _defaultModelsModel;

  }

  late List<ModelsModel> listModelsModel;
  late ModelsModel currentModel;
}

ModelsModel _defaultModelsModel = ModelsModel({
  'id': 'gpt-4-0613',
  'created': DateTime.now(),
  'root': 'gpt-4-0613',
});
