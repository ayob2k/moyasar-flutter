import 'package:moyasar/moyasar.dart';

class CardUtils {
  static String? validateName(String? value, Localization locale) {
    if (value == null || value.isEmpty) return locale.nameRequired;

    var fullName = value.split(RegExp(r' ')).where((el) => el != '');
    if (fullName.length < 2) {
      return locale.bothNamesRequired;
    }

    return null;
  }

  static String? validateCardNum(String? input, Localization locale) {
    if (input == null || input.isEmpty) return locale.cardNumberRequired;

    String cardNumber = getCleanedNumber(input);

    if (input.length < 8 || !isValidLuhn(cardNumber)) {
      return locale.invalidCardNumber;
    }

    return null;
  }

  static String? validateDate(String? value, Localization locale) {
    if (value == null || value.isEmpty) return locale.expiryRequired;

    if (!value.contains(RegExp(r'(/)'))) return locale.invalidExpiry;

    var split = value.split(RegExp(r'(/)'));

    int month = int.parse(split[0]);
    int year = int.parse(split[1]);

    if ((month < 1) || (month > 12)) return locale.invalidExpiry;

    final expiryDate = DateTime(convertYearTo4Digits(year), month);
    final now = DateTime.now();

    if (expiryDate.isBefore(now)) return locale.expiredCard;

    return null;
  }

  static String? validateCVC(String? value, Localization locale) {
    if (value == null || value.isEmpty) return locale.cvcRequired;

    if (value.length < 3 || value.length > 4) return locale.invalidCvc;

    return null;
  }

  static int convertYearTo4Digits(int year) {
    if (year < 100 && year >= 0) {
      var now = DateTime.now();
      String currentYear = now.year.toString();
      String prefix = currentYear.substring(0, currentYear.length - 2);
      year = int.parse('$prefix${year.toString().padLeft(2, '0')}');
    }
    return year;
  }

  static List<String> getExpiryDate(String value) {
    var split = value.split(RegExp(r'(/)'));
    return [split[0].trim(), split[1].trim()];
  }

  static String getCleanedNumber(String text) {
    RegExp regExp = RegExp(r'[^0-9]');
    return text.replaceAll(regExp, '');
  }

  static CardCompany getCardCompanyFromNumber(String input) {
    if (input.startsWith(RegExp(
        r'((5[1-5])|(222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720))'))) {
      return CardCompany.master;
    } else if (input.startsWith(RegExp(r'((34)|(37))'))) {
      return CardCompany.amex;
    } else if (input.startsWith(RegExp(r'[4]'))) {
      return CardCompany.visa;
    }
    return CardCompany.visa;
  }

  static String getCardType(String cardNumber) {
    // Remove all spaces and hyphens
    cardNumber = cardNumber.replaceAll(RegExp(r'[\s-]+'), '');

    // Regular expressions for card types
    final RegExp visaRegExp = RegExp(r'^4[0-9]{12}(?:[0-9]{3})?$');
    final RegExp masterCardRegExp = RegExp(r'^(?:5[1-5][0-9]{14})$');
    final RegExp amexRegExp = RegExp(r'^3[47][0-9]{13}$');
    final RegExp madaRegExp = RegExp(
        r'^4(0(0861|1757|7(197|395)|9201)|1(0685|7633|9593)|2(281(7|8|9)|8(331|67(1|2|3)))|3(1361|2328|4107|9954)|4(0(533|647|795)|5564|6(393|404|672))|5(5(036|708)|7865|8456)|6(2220|854(0|1|2|3))|8(301(0|1|2)|4783|609(4|5|6)|931(7|8|9))|93428)|5(0(4300|8160)|13213|2(1076|4(130|514)|9(415|741))|3(0906|1095|2013|5(825|989)|6023|7767|9931)|4(3(085|357)|9760)|5(4180|7606|8848)|8(5265|8(8(4(5|6|7|8|9)|5(0|1))|98(2|3))|9(005|206)))|6(0(4906|5141)|36120)|9682(0(1|2|3|4|5|6|7|8|9)|1(0|1))');

    // Check card type based on regex matching
    if (visaRegExp.hasMatch(cardNumber)) {
      return 'visa';
    } else if (masterCardRegExp.hasMatch(cardNumber)) {
      return 'mastercard';
    } else if (amexRegExp.hasMatch(cardNumber)) {
      return 'amex';
    } else if (madaRegExp.hasMatch(cardNumber)) {
      return 'mada';
    } else {
      return 'unknown';
    }
  }
}

bool isValidLuhn(String cardNumber) {
  int sum = 0;
  int length = cardNumber.length;
  for (var i = 0; i < length; i++) {
    int digit = int.parse(cardNumber[length - i - 1]);

    if (i % 2 == 1) {
      digit *= 2;
    }
    sum += digit > 9 ? (digit - 9) : digit;
  }

  if (sum % 10 == 0) {
    return true;
  }

  return false;
}
