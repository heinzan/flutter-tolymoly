import 'package:tolymoly/models/buy_filter_model.dart';
import 'package:tolymoly/repositories/buy_filter_repository.dart';

BuyFilterRepository _buyFilterRepository = new BuyFilterRepository();

class BuyFilterService {
  Future<bool> save(BuyFilterModel model) async {
    await _buyFilterRepository.delete();
    return await _buyFilterRepository.save(model);
  }

  Future<BuyFilterModel> find() async {
    return await _buyFilterRepository.find();
  }
}
