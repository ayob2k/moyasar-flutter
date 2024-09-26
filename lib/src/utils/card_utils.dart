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
    final List<String> madaRange = [
      '446404',
      '440795',
      '440647',
      '421141',
      '474491',
      '588845',
      '968208',
      '457997',
      '457865',
      '468540',
      '468541',
      '468542',
      '468543',
      '417633',
      '446393',
      '636120',
      '968201',
      '410621',
      '409201',
      '403024',
      '458456',
      '462220',
      '968205',
      '455708',
      '484783',
      '588848',
      '455036',
      '968203',
      '486094',
      '486095',
      '486096',
      '504300',
      '440533',
      '489318',
      '489319',
      '445564',
      '968211',
      '410685',
      '406996',
      '432328',
      '428671',
      '428672',
      '428673',
      '968206',
      '446672',
      '543357',
      '434107',
      '407197',
      '407395',
      '42689700',
      '412565',
      '431361',
      '604906',
      '521076',
      '588850',
      '968202',
      '529415',
      '535825',
      '543085',
      '524130',
      '554180',
      '549760',
      '968209',
      '524514',
      '529741',
      '537767',
      '535989',
      '536023',
      '513213',
      '520058',
      '558563',
      '605141',
      '968204',
      '422817',
      '422818',
      '422819',
      '410834',
      '428331',
      '442463',
      '483010',
      '483011',
      '483012',
      '589206',
      '968207',
      '406136',
      '419593',
      '439954',
      '407520',
      '530060',
      '531196',
      '420132',
      '242030',
      '224020',
      '411111'
    ];

    // Check card type based on regex matching
    if (visaRegExp.hasMatch(cardNumber)) {
      return 'visa';
    } else if (masterCardRegExp.hasMatch(cardNumber)) {
      return 'mastercard';
    } else if (amexRegExp.hasMatch(cardNumber)) {
      return 'amex';
    } else if (madaRange.contains(cardNumber.substring(0, 6))) {
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
