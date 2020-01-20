import 'package:tolymoly/dto/location_picker_dto.dart';
import 'package:tolymoly/enum/display_language_type_enum.dart';
import 'package:tolymoly/enum/keyboard_type_enum.dart';
import 'package:tolymoly/models/user_preference_model.dart';
import 'package:tolymoly/repositories/user_preference_repository.dart';
import 'package:tolymoly/utils/user_preference_util.dart';

class UserPreferenceService {
  UserPreferenceRepository userPreferenceRepository =
      new UserPreferenceRepository();

  // Future<bool> updateKeyboardType(KeyboardTypeEnum keyboardTypeEnum) async {
  //   UserPreferenceUtil.keyboardTypeEnum = keyboardTypeEnum;
  //   return await userPreferenceRepository.updateKeyboardType(keyboardTypeEnum);
  // }

  // Future<bool> updateDisplayLanguage(
  //     DisplayLanguageTypeEnum displayLanguageTypeEnum) async {
  //   UserPreferenceUtil.displayLanguageTypeEnum = displayLanguageTypeEnum;
  //   return await userPreferenceRepository
  //       .updateDisplayLanguageType(displayLanguageTypeEnum);
  // }

  Future<bool> updateLanguage(DisplayLanguageTypeEnum displayLanguageTypeEnum,
      KeyboardTypeEnum keyboardTypeEnum) async {
    UserPreferenceUtil.displayLanguageTypeEnum = displayLanguageTypeEnum;
    UserPreferenceUtil.keyboardTypeEnum = keyboardTypeEnum;

    return await userPreferenceRepository.updateLanguage(
        displayLanguageTypeEnum, keyboardTypeEnum);
  }

  Future<bool> updateBuyLocation(LocationPickerDto dto) async {
    UserPreferenceUtil.regionId = dto.regionId;
    UserPreferenceUtil.regionName = dto.regionName;
    UserPreferenceUtil.townshipId = dto.townshipId;
    UserPreferenceUtil.townshipName = dto.townshipName;

    return await userPreferenceRepository.updateBuyLocation(
        dto.regionId, dto.regionName, dto.townshipId, dto.townshipName);
  }

  Future<bool> updateSellLocation(LocationPickerDto dto) async {
    UserPreferenceUtil.sellRegionId = dto.townshipId;
    UserPreferenceUtil.sellRegionName = dto.townshipName;
    UserPreferenceUtil.sellTownshipId = dto.townshipId;
    UserPreferenceUtil.sellTownshipName = dto.townshipName;

    return await userPreferenceRepository.updateSellLocation(
        dto.regionId, dto.regionName, dto.townshipId, dto.townshipName);
  }

  Future<UserPreferenceModel> find() async {
    return await userPreferenceRepository.find();
  }

  // Future<bool> isZawgyi() async {
  //   return await userPreferenceRepository.isZawgyi();
  // }
}
