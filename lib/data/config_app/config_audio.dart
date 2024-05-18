import 'dart:math';

import 'package:chatgpt/data/prefs/setting_local.dart';
import 'package:chatgpt/model/language_listen_model.dart';
import 'package:chatgpt/model/language_speak_model.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum StatusAudio { playing, stopped, paused, continued }

class ConfigAudio {
  static final ConfigAudio _instance = ConfigAudio._internal();
  factory ConfigAudio() {
    return _instance;
  }

  Future<void> initAudio() async {
    SettingLocal dataLocal = SettingLocal();
    isAutoReponse = await dataLocal.isAutoChatReponse ?? isAutoReponse;
    currentLanguageListen =
        await dataLocal.languageListen ?? currentLanguageListen;
    await _flutterTts.awaitSpeakCompletion(true);
    currentLanguageSpeak =
        await dataLocal.languageSpeak ?? currentLanguageSpeak;
  }

  ConfigAudio._internal() {
    ///Handle Audio
    _flutterTts = FlutterTts();
    currentLanguageListen = _defaultLanguageListen;
    listLanguageListen = _defaultListLanguageListen;
    statusAudio = StatusAudio.stopped;
    isAutoReponse = true;
    volumn = 0.8;
    pitch = 0.8;
    rate = 0.5;
    listLanguageSpeak = _defaultListLanguageSpeak;
    currentLanguageSpeak = _defaulLanguageSpeak;
  }
  late FlutterTts _flutterTts;

  late StatusAudio statusAudio;

  late bool isAutoReponse;

  Future<void> updateVolumn(double value) async {
    volumn = value;
    await _flutterTts.setVolume(volumn);
  }

  Future<void> updateLanguageListen(LanguageListenModel voice) async {
    //Lưu local
    SettingLocal save = SettingLocal();
    await save.saveLanguageListen(voice);

    //Lưu trạng thái

    currentLanguageListen = voice;
    await _flutterTts.setVoice(voice.toNewData());
  }

  Future<void> updateLanguageSpeak(LanguageSpeakModel speakModel) async {
    //Lưu local
    SettingLocal save = SettingLocal();
    await save.saveLanguageSpeak(speakModel);

    //Lưu trạng thái
    currentLanguageSpeak = speakModel;
  }

  Future<void> updateRate(double value) async {
    rate = value;
    await _flutterTts.setSpeechRate(rate);
  }

  Future<void> updatePitch(double value) async {
    double convertPitch = max(0.5, pitch / 2);
    await _flutterTts.setPitch(convertPitch);
  }

  Future<void> updateAutoReponse(bool value) async {
    //Save local
    SettingLocal save = SettingLocal();
    await save.saveIsAutoChatReponse(value);

    //Save data
    isAutoReponse = value;
  }

  ///Âm lượng
  late double volumn;

  ///Độ cao
  late double pitch;

  ///Tốc độ
  late double rate;

  ///Danh sách nghe ngôn ngữ
  late List<LanguageListenModel> listLanguageListen;

  ///Ngôn ngữ chọn nghe hiện tại
  late LanguageListenModel currentLanguageListen;

  ///Ngôn ngữ nói hiện tại
  late LanguageSpeakModel currentLanguageSpeak;

  ///Danh sách ngữ nói hiện tại
  late List<LanguageSpeakModel> listLanguageSpeak;

  Future<void> speak(String voiceText) async {
    if (statusAudio != StatusAudio.stopped) {
      await stop();
    } else {
      statusAudio = StatusAudio.playing;
      await _flutterTts.speak(voiceText);
    }
  }

  Future<void> stop() async {
    statusAudio = StatusAudio.stopped;
    await _flutterTts.stop();
  }

  Future<void> pause() async {
    statusAudio = StatusAudio.paused;
    await _flutterTts.pause();
  }
}

LanguageListenModel _defaultLanguageListen = _defaultListLanguageListen[3];

List<LanguageListenModel> _defaultListLanguageListen = [
  {
    'name': 'vi-VN-language',
    'locale': 'vi-VN',
    'displayName': 'Tiếng Việt',
  },
  {
    'name': 'en-us-x-tpf-local',
    'locale': 'en-US',
    'displayName': 'Tiếng Mỹ 1',
  },
  {
    'name': 'en-us-x-sfg-network',
    'locale': 'en-US',
    'displayName': 'Tiếng Mỹ 2'
  },
  {
    'name': 'en-us-x-tpd-network',
    'locale': 'en-US',
    'displayName': 'Tiếng Mỹ 3'
  },
  {
    'name': 'en-us-x-tpc-network',
    'locale': 'en-US',
    'displayName': 'Tiếng Mỹ 4'
  },
  {
    'name': 'en-gb-x-gba-local',
    'locale': 'en-GB',
    'displayName': 'Tiếng Anh 1'
  },
  {
    'name': 'en-gb-x-gbb-network',
    'locale': 'en-GB',
    'displayName': 'Tiếng Anh 2'
  },
  {
    'name': 'en-gb-x-rjs-local',
    'locale': 'en-GB',
    'displayName': 'Tiếng Anh 3'
  },
  {
    'name': 'en-gb-x-gbg-local',
    'locale': 'en-GB',
    'displayName': 'Tiếng Anh 4'
  },
].map((e) => LanguageListenModel(e)).toList();

LanguageSpeakModel _defaulLanguageSpeak = _defaultListLanguageSpeak.first;

List<LanguageSpeakModel> _defaultListLanguageSpeak = [
  {
    'locale': 'en_US',
    'name': 'Tiếng Mỹ',
  },
  {
    'locale': 'vi_VN',
    'name': 'Tiếng Việt',
  },
  {
    'locale': 'en_GB',
    'name': 'Tiếng Anh',
  }
].map((e) => LanguageSpeakModel(e)).toList();
