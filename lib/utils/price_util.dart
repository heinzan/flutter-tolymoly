import 'package:intl/intl.dart';
import 'package:tolymoly/enum/price_type_enum.dart';

class PriceUtil {
  static final formatter = new NumberFormat("#,###");

  static String price(double priceValue, int priceType) {
    if (priceValue == null || priceType == null) return '';

    String priceTypeName;
    if (priceType == PriceTypeEnum.Kyat.index) {
      priceTypeName = 'Ks';
    } else if (priceType == PriceTypeEnum.Lakh.index) {
      priceTypeName = 'Lks';
    } else if (priceType == PriceTypeEnum.Usd.index) {
      priceTypeName = 'USD';
    }
    // print('=====');
    // print(priceValue.toString());
    // print(priceTypeName);
    // print(priceValue);
    // print(formatter.format(priceValue));
    // print('$priceTypeName ${formatter.format(priceValue)}');
    // print('=====');

    return '$priceTypeName ${formatter.format(priceValue)}';
  }

  static String value(double priceValue) {
    if (priceValue == null) return '';

    return formatter.format(priceValue);
  }
}
