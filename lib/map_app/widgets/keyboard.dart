
import 'package:flutter/material.dart';

class VirtualKeyboardExtended extends StatefulWidget {
  final Function(String) onKeyPress;
  final VoidCallback onBackspace;
  final VoidCallback onEnter;
  final VoidCallback onClose;
  final VoidCallback onSpace;

  const VirtualKeyboardExtended({
    Key? key,
    required this.onKeyPress,
    required this.onBackspace,
    required this.onEnter,
    required this.onClose,
    required this.onSpace,
  }) : super(key: key);

  @override
  State<VirtualKeyboardExtended> createState() => _VirtualKeyboardExtendedState();
}

class _VirtualKeyboardExtendedState extends State<VirtualKeyboardExtended> {
  bool _isUpperCase = false;
  String _buffer = ""; 

  static const Map<String, List<String>> _vowelBase = {
    'a': ['a', 'á', 'à', 'ả', 'ã', 'ạ'],
    'ă': ['ă', 'ắ', 'ằ', 'ẳ', 'ẵ', 'ặ'],
    'â': ['â', 'ấ', 'ầ', 'ẩ', 'ẫ', 'ậ'],
    'e': ['e', 'é', 'è', 'ẻ', 'ẽ', 'ẹ'],
    'ê': ['ê', 'ế', 'ề', 'ể', 'ễ', 'ệ'],
    'i': ['i', 'í', 'ì', 'ỉ', 'ĩ', 'ị'],
    'o': ['o', 'ó', 'ò', 'ỏ', 'õ', 'ọ'],
    'ô': ['ô', 'ố', 'ồ', 'ổ', 'ỗ', 'ộ'],
    'ơ': ['ơ', 'ớ', 'ờ', 'ở', 'ỡ', 'ợ'],
    'u': ['u', 'ú', 'ù', 'ủ', 'ũ', 'ụ'],
    'ư': ['ư', 'ứ', 'ừ', 'ử', 'ữ', 'ự'],
    'y': ['y', 'ý', 'ỳ', 'ỷ', 'ỹ', 'ỵ'],
  };

  static const Map<String, int> _toneMarks = {
    's': 1, // Sắc
    'f': 2, // Huyền
    'r': 3, // Hỏi
    'x': 4, // Ngã
    'j': 5, // Nặng
  };

  void _handleKeyPress(String key) {
    String result = _processTelex(_buffer + key);
    
    if (result != _buffer) {
      // Xóa buffer cũ và thêm kết quả mới
      for (int i = 0; i < _buffer.length; i++) {
        widget.onBackspace();
      }
      _buffer = result;
      for (int i = 0; i < result.length; i++) {
        widget.onKeyPress(result[i]);
      }
    } else {
      // Không có chuyển đổi, thêm key bình thường
      _buffer += key;
      widget.onKeyPress(key);
    }

    setState(() {});
  }

  String _processTelex(String input) {
    if (input.length < 2) return input;

    String lastChar = input[input.length - 1].toLowerCase();
    String beforeLast = input.substring(0, input.length - 1);

    // Xử lý dấu thanh (s, f, r, x, j)
    if (_toneMarks.containsKey(lastChar)) {
      String result = _applyTone(beforeLast, _toneMarks[lastChar]!);
      if (result != beforeLast) return result;
    }

    // Xử lý các tổ hợp
    // aa -> â, aw -> ă
    if (lastChar == 'a' && beforeLast.endsWith('a')) {
      return beforeLast.substring(0, beforeLast.length - 1) + 'â';
    }
    if (lastChar == 'w' && beforeLast.endsWith('a')) {
      return beforeLast.substring(0, beforeLast.length - 1) + 'ă';
    }
    
    // ee -> ê
    if (lastChar == 'e' && beforeLast.endsWith('e')) {
      return beforeLast.substring(0, beforeLast.length - 1) + 'ê';
    }
    
    // oo -> ô, ow -> ơ
    if (lastChar == 'o' && beforeLast.endsWith('o')) {
      return beforeLast.substring(0, beforeLast.length - 1) + 'ô';
    }
    if (lastChar == 'w' && beforeLast.endsWith('o')) {
      return beforeLast.substring(0, beforeLast.length - 1) + 'ơ';
    }
    
    // uw -> ư
    if (lastChar == 'w' && beforeLast.endsWith('u')) {
      return beforeLast.substring(0, beforeLast.length - 1) + 'ư';
    }
    
    // dd -> đ
    if (lastChar == 'd' && beforeLast.endsWith('d')) {
      return beforeLast.substring(0, beforeLast.length - 1) + 'đ';
    }

    return input;
  }

  String _applyTone(String text, int toneIndex) {
    if (text.isEmpty) return text;

    // Tìm nguyên âm cuối cùng để đặt dấu
    int vowelPos = -1;
    String vowelChar = '';
    String baseVowel = '';

    for (int i = text.length - 1; i >= 0; i--) {
      String char = text[i].toLowerCase();
      
      // Tìm nguyên âm
      for (String base in _vowelBase.keys) {
        if (_vowelBase[base]!.contains(char) || char == base) {
          vowelPos = i;
          vowelChar = char;
          baseVowel = base;
          break;
        }
      }
      if (vowelPos != -1) break;
    }

    if (vowelPos == -1) return text;

    // Lấy nguyên âm có dấu
    String newVowel = _vowelBase[baseVowel]![toneIndex];
    
    // Giữ nguyên chữ hoa nếu cần
    if (text[vowelPos] == text[vowelPos].toUpperCase()) {
      newVowel = newVowel.toUpperCase();
    }

    // Thay thế nguyên âm
    return text.substring(0, vowelPos) + newVowel + text.substring(vowelPos + 1);
  }

  void _handleBackspace() {
    if (_buffer.isNotEmpty) {
      _buffer = _buffer.substring(0, _buffer.length - 1);
    }
    widget.onBackspace();
  }

  void _handleSpace() {
    _buffer = "";
    widget.onSpace();
  }

  void _handleEnter() {
    _buffer = "";
    widget.onEnter();
  }

  void _handleClose() {
    _buffer = "";
    widget.onClose();
  }

  Widget _buildKey(String label, {double flex = 1.0, VoidCallback? onTap}) {
    return Expanded(
      flex: (flex * 10).toInt(),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Material(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: onTap ?? () => _handleKeyPress(_isUpperCase ? label.toUpperCase() : label.toLowerCase()),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 48,
              alignment: Alignment.center,
              child: Text(
                _isUpperCase ? label.toUpperCase() : label.toLowerCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialKey(IconData icon, VoidCallback onTap, {double flex = 1.0, Color? color}) {
    return Expanded(
      flex: (flex * 10).toInt(),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Material(
          color: color ?? Colors.grey[700],
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 48,
              alignment: Alignment.center,
              child: Icon(icon, color: Colors.white, size: 20),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
            Row(
              children: [
                _buildKey('1'),
                _buildKey('2'),
                _buildKey('3'),
                _buildKey('4'),
                _buildKey('5'),
                _buildKey('6'),
                _buildKey('7'),
                _buildKey('8'),
                _buildKey('9'),
                _buildKey('0'),
            ],
          ),
          // Row 1: Q W E R T Y U I O P
          Row(
            children: [
              _buildKey('q'),
              _buildKey('w'),
              _buildKey('e'),
              _buildKey('r'),
              _buildKey('t'),
              _buildKey('y'),
              _buildKey('u'),
              _buildKey('i'),
              _buildKey('o'),
              _buildKey('p'),
            ],
          ),
          // Row 2: A S D F G H J K L
          Row(
            children: [
              const Spacer(flex: 5),
              _buildKey('a'),
              _buildKey('s'),
              _buildKey('d'),
              _buildKey('f'),
              _buildKey('g'),
              _buildKey('h'),
              _buildKey('j'),
              _buildKey('k'),
              _buildKey('l'),
              const Spacer(flex: 5),
            ],
          ),
          // Row 3: Shift Z X C V B N M Backspace
          Row(
            children: [
              _buildSpecialKey(
                _isUpperCase ? Icons.arrow_upward : Icons.arrow_downward,
                () {
                  setState(() {
                    _isUpperCase = !_isUpperCase;
                  });
                },
                flex: 1.5,
              ),
              _buildKey('z'),
              _buildKey('x'),
              _buildKey('c'),
              _buildKey('v'),
              _buildKey('b'),
              _buildKey('n'),
              _buildKey('m'),
              _buildSpecialKey(Icons.backspace, _handleBackspace, flex: 1.5),
            ],
          ),
          // Row 4: Close, Space, Enter
          Row(
            children: [
              _buildSpecialKey(Icons.keyboard_hide, _handleClose, flex: 1.5),
              _buildSpecialKey(Icons.space_bar, _handleSpace, flex: 5.0),
              _buildSpecialKey(Icons.search, _handleEnter, flex: 1.5, color: Colors.blue[700]),
            ],
          ),
          
        ],
      ),
    );
  }
}