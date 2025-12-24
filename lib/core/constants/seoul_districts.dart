/// Seoul district definitions and utilities
///
/// Contains all 25 Seoul districts (구) with their IDs and names
class SeoulDistricts {
  /// Seoul parent region ID
  static const String seoulId = 'KR-11';

  /// "All of Seoul" option ID
  static const String allSeoulId = 'KR-11-all';

  /// List of all Seoul districts with IDs, English names, and Korean names
  static const List<Map<String, String>> districts = [
    {
      'id': 'KR-11-gangnam',
      'name': 'Gangnam-gu',
      'nameKo': '강남구',
    },
    {
      'id': 'KR-11-seocho',
      'name': 'Seocho-gu',
      'nameKo': '서초구',
    },
    {
      'id': 'KR-11-songpa',
      'name': 'Songpa-gu',
      'nameKo': '송파구',
    },
    {
      'id': 'KR-11-gangdong',
      'name': 'Gangdong-gu',
      'nameKo': '강동구',
    },
    {
      'id': 'KR-11-yongsan',
      'name': 'Yongsan-gu',
      'nameKo': '용산구',
    },
    {
      'id': 'KR-11-jongno',
      'name': 'Jongno-gu',
      'nameKo': '종로구',
    },
    {
      'id': 'KR-11-jung',
      'name': 'Jung-gu',
      'nameKo': '중구',
    },
    {
      'id': 'KR-11-seodaemun',
      'name': 'Seodaemun-gu',
      'nameKo': '서대문구',
    },
    {
      'id': 'KR-11-mapo',
      'name': 'Mapo-gu',
      'nameKo': '마포구',
    },
    {
      'id': 'KR-11-eunpyeong',
      'name': 'Eunpyeong-gu',
      'nameKo': '은평구',
    },
    {
      'id': 'KR-11-seongbuk',
      'name': 'Seongbuk-gu',
      'nameKo': '성북구',
    },
    {
      'id': 'KR-11-gangbuk',
      'name': 'Gangbuk-gu',
      'nameKo': '강북구',
    },
    {
      'id': 'KR-11-dobong',
      'name': 'Dobong-gu',
      'nameKo': '도봉구',
    },
    {
      'id': 'KR-11-nowon',
      'name': 'Nowon-gu',
      'nameKo': '노원구',
    },
    {
      'id': 'KR-11-dongdaemun',
      'name': 'Dongdaemun-gu',
      'nameKo': '동대문구',
    },
    {
      'id': 'KR-11-jungnang',
      'name': 'Jungnang-gu',
      'nameKo': '중랑구',
    },
    {
      'id': 'KR-11-seongdong',
      'name': 'Seongdong-gu',
      'nameKo': '성동구',
    },
    {
      'id': 'KR-11-gwangjin',
      'name': 'Gwangjin-gu',
      'nameKo': '광진구',
    },
    {
      'id': 'KR-11-dongjak',
      'name': 'Dongjak-gu',
      'nameKo': '동작구',
    },
    {
      'id': 'KR-11-gwanak',
      'name': 'Gwanak-gu',
      'nameKo': '관악구',
    },
    {
      'id': 'KR-11-geumcheon',
      'name': 'Geumcheon-gu',
      'nameKo': '금천구',
    },
    {
      'id': 'KR-11-guro',
      'name': 'Guro-gu',
      'nameKo': '구로구',
    },
    {
      'id': 'KR-11-gangseo',
      'name': 'Gangseo-gu',
      'nameKo': '강서구',
    },
    {
      'id': 'KR-11-yangcheon',
      'name': 'Yangcheon-gu',
      'nameKo': '양천구',
    },
    {
      'id': 'KR-11-yeongdeungpo',
      'name': 'Yeongdeungpo-gu',
      'nameKo': '영등포구',
    },
  ];

  /// Check if a region ID is a Seoul district
  static bool isSeoulDistrict(String regionId) {
    return regionId.startsWith('$seoulId-') && regionId != seoulId;
  }

  /// Get parent region ID for a district
  static String getParentRegion(String districtId) {
    if (isSeoulDistrict(districtId) || districtId == allSeoulId) {
      return seoulId;
    }
    return districtId;
  }

  /// Get district name by ID
  static String? getDistrictName(String districtId) {
    if (districtId == allSeoulId) {
      return 'All of Seoul';
    }

    for (var district in districts) {
      if (district['id'] == districtId) {
        return district['name'];
      }
    }
    return null;
  }

  /// Get all district IDs
  static List<String> getAllDistrictIds() {
    return districts.map((d) => d['id'] as String).toList();
  }
}
