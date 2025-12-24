class AppConstants {
  static const String appName = 'Got Nunchi';

  // This map matches the IDs from countries_world_map to readable names
  // Includes provinces and Seoul districts
  static const Map<String, String> regionNames = {
    // Provinces
    'KR-11': 'Seoul',
    'KR-26': 'Busan',
    'KR-27': 'Daegu',
    'KR-28': 'Incheon',
    'KR-29': 'Gwangju',
    'KR-30': 'Daejeon',
    'KR-31': 'Ulsan',
    'KR-50': 'Sejong',
    'KR-41': 'Gyeonggi',
    'KR-42': 'Gangwon',
    'KR-43': 'Chungbuk',
    'KR-44': 'Chungnam',
    'KR-45': 'Jeonbuk',
    'KR-46': 'Jeonnam',
    'KR-47': 'Gyeongbuk',
    'KR-48': 'Gyeongnam',
    'KR-49': 'Jeju',

    // Seoul Districts (25 districts + "All of Seoul" option)
    'KR-11-all': 'All of Seoul',
    'KR-11-gangnam': 'Gangnam-gu',
    'KR-11-seocho': 'Seocho-gu',
    'KR-11-songpa': 'Songpa-gu',
    'KR-11-gangdong': 'Gangdong-gu',
    'KR-11-yongsan': 'Yongsan-gu',
    'KR-11-jongno': 'Jongno-gu',
    'KR-11-jung': 'Jung-gu',
    'KR-11-seodaemun': 'Seodaemun-gu',
    'KR-11-mapo': 'Mapo-gu',
    'KR-11-eunpyeong': 'Eunpyeong-gu',
    'KR-11-seongbuk': 'Seongbuk-gu',
    'KR-11-gangbuk': 'Gangbuk-gu',
    'KR-11-dobong': 'Dobong-gu',
    'KR-11-nowon': 'Nowon-gu',
    'KR-11-dongdaemun': 'Dongdaemun-gu',
    'KR-11-jungnang': 'Jungnang-gu',
    'KR-11-seongdong': 'Seongdong-gu',
    'KR-11-gwangjin': 'Gwangjin-gu',
    'KR-11-dongjak': 'Dongjak-gu',
    'KR-11-gwanak': 'Gwanak-gu',
    'KR-11-geumcheon': 'Geumcheon-gu',
    'KR-11-guro': 'Guro-gu',
    'KR-11-gangseo': 'Gangseo-gu',
    'KR-11-yangcheon': 'Yangcheon-gu',
    'KR-11-yeongdeungpo': 'Yeongdeungpo-gu',
  };

  /// Check if a region ID is a Seoul district
  static bool isSeoulDistrict(String regionId) {
    return regionId.startsWith('KR-11-') && regionId != 'KR-11';
  }
}
