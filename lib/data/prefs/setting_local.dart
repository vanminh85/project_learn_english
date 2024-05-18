import 'dart:convert';

import 'package:chatgpt/model/language_speak_model.dart';
import 'package:chatgpt/model/language_listen_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _keyPrefsVoiceListen = 'voiceListen';
const String _keyPrefsStatusReponse = 'statusReponse';
const String _keyPrefsVoiceSpeak = 'languageVoiceSpeak';

class SettingLocal implements _SettingLocal {
  @override
  Future<bool?> get isAutoChatReponse async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyPrefsStatusReponse);
  }

  @override
  Future<LanguageListenModel?> get languageListen async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_keyPrefsVoiceListen)) {
      String str = prefs.getString(_keyPrefsVoiceListen)!;
      Map<String, Object> data = jsonDecode(str);
      return LanguageListenModel(data);
    }
    return null;
  }

  @override
  Future<void> saveIsAutoChatReponse(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyPrefsStatusReponse, value);
  }

  @override
  Future<void> saveLanguageListen(LanguageListenModel voice) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String listObjectEncode = jsonEncode(voice.data);
    await prefs.setString(_keyPrefsVoiceListen, listObjectEncode);
  }

  @override
  Future<void> saveLanguageSpeak(LanguageSpeakModel voice) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String listObjectEncode = jsonEncode(voice.data);
    await prefs.setString(_keyPrefsVoiceSpeak, listObjectEncode);
  }

  @override
  Future<LanguageSpeakModel?> get languageSpeak async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_keyPrefsVoiceSpeak)) {
      String str = prefs.getString(_keyPrefsVoiceSpeak)!;
      Map<String, Object> data = jsonDecode(str);
      return LanguageSpeakModel(data);
    }
    return null;
  }
}

abstract class _SettingLocal {
  ///Lấy trạng thái
  Future<bool?> get isAutoChatReponse;

  ///Lưu trạng thái phản hồi
  Future<void> saveIsAutoChatReponse(bool value);

  ///Lấy trang Thai isGiongVN
  Future<LanguageSpeakModel?> get languageSpeak;

  ///Lưu trạng thái phản hồi
  Future<void> saveLanguageSpeak(LanguageSpeakModel voice);

  ///Lấy ngôn ngữ
  Future<LanguageListenModel?> get languageListen;

  ///Lưu ngôn ngữ
  Future<void> saveLanguageListen(LanguageListenModel voice);
}
