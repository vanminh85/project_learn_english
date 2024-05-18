import 'package:chatgpt/view/resources/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BottomSheetSetting extends StatelessWidget {
  const BottomSheetSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          body(context),
          _buttonClose(context),
        ],
      ),
    );
  }

  Widget _buttonClose(BuildContext context) {
    return Positioned(
      right: 15,
      top: -20,
      child: CircleAvatar(
        backgroundColor: Colors.blue,
        radius: 25,
        child: IconButton(
          icon: const Icon(Icons.close),
          color: Colors.white,
          focusColor: Colors.blue.shade500,
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  Widget body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _text(
              text: 'Nếu thấy hay thì ủng hộ mình nhé 😎',
              colour: Colors.white,
              fontSize: 18),
          const SizedBox(height: 40),
          CircleAvatar(
            radius: 80,
            child: Image.asset(AssetsManager.support),
          ),
          const SizedBox(height: 50),
          rowText(context,
              label: 'Momo', text: '', valueCopy: ''),
          const SizedBox(height: 24),
          rowText(context,
              label: '',
              text: '',
              valueCopy: ''),
        ],
      ),
    );
  }

  Widget rowText(BuildContext context,
      {required String label,
      required String text,
      required String valueCopy}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: valueCopy));
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              SnackBar snackBar = const SnackBar(
                content: Text('Đã coppy vào bộ nhớ'),
                backgroundColor: Colors.black,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.pop(context);
            },
            child: _text(text: text, colour: Colors.white, fontSize: 17))
      ],
    );
  }

  Widget _text(
      {required String text, required Color colour, required double fontSize}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: colour,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
