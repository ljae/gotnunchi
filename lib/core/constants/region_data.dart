/// Region district definitions and utilities
///
/// Contains district mappings for major regions (Seoul, Gyeonggi, etc.)
class RegionData {
  /// Seoul parent region ID
  static const String seoulId = 'KR-11';
  /// Gyeonggi parent region ID
  static const String gyeonggiId = 'KR-41';

  /// "All of Region" suffix
  static const String allSuffix = '-all';

  /// List of all Seoul districts
  static const List<Map<String, String>> seoulDistricts = [
    {'id': 'KR-11-gangnam', 'name': 'Gangnam-gu', 'nameKo': '강남구'},
    {'id': 'KR-11-seocho', 'name': 'Seocho-gu', 'nameKo': '서초구'},
    {'id': 'KR-11-songpa', 'name': 'Songpa-gu', 'nameKo': '송파구'},
    {'id': 'KR-11-gangdong', 'name': 'Gangdong-gu', 'nameKo': '강동구'},
    {'id': 'KR-11-yongsan', 'name': 'Yongsan-gu', 'nameKo': '용산구'},
    {'id': 'KR-11-jongno', 'name': 'Jongno-gu', 'nameKo': '종로구'},
    {'id': 'KR-11-jung', 'name': 'Jung-gu', 'nameKo': '중구'},
    {'id': 'KR-11-seodaemun', 'name': 'Seodaemun-gu', 'nameKo': '서대문구'},
    {'id': 'KR-11-mapo', 'name': 'Mapo-gu', 'nameKo': '마포구'},
    {'id': 'KR-11-eunpyeong', 'name': 'Eunpyeong-gu', 'nameKo': '은평구'},
    {'id': 'KR-11-seongbuk', 'name': 'Seongbuk-gu', 'nameKo': '성북구'},
    {'id': 'KR-11-gangbuk', 'name': 'Gangbuk-gu', 'nameKo': '강북구'},
    {'id': 'KR-11-dobong', 'name': 'Dobong-gu', 'nameKo': '도봉구'},
    {'id': 'KR-11-nowon', 'name': 'Nowon-gu', 'nameKo': '노원구'},
    {'id': 'KR-11-dongdaemun', 'name': 'Dongdaemun-gu', 'nameKo': '동대문구'},
    {'id': 'KR-11-jungnang', 'name': 'Jungnang-gu', 'nameKo': '중랑구'},
    {'id': 'KR-11-seongdong', 'name': 'Seongdong-gu', 'nameKo': '성동구'},
    {'id': 'KR-11-gwangjin', 'name': 'Gwangjin-gu', 'nameKo': '광진구'},
    {'id': 'KR-11-dongjak', 'name': 'Dongjak-gu', 'nameKo': '동작구'},
    {'id': 'KR-11-gwanak', 'name': 'Gwanak-gu', 'nameKo': '관악구'},
    {'id': 'KR-11-geumcheon', 'name': 'Geumcheon-gu', 'nameKo': '금천구'},
    {'id': 'KR-11-guro', 'name': 'Guro-gu', 'nameKo': '구로구'},
    {'id': 'KR-11-gangseo', 'name': 'Gangseo-gu', 'nameKo': '강서구'},
    {'id': 'KR-11-yangcheon', 'name': 'Yangcheon-gu', 'nameKo': '양천구'},
    {'id': 'KR-11-yeongdeungpo', 'name': 'Yeongdeungpo-gu', 'nameKo': '영등포구'},
  ];

  /// List of Gyeonggi districts (major cities/counties)
  static const List<Map<String, String>> gyeonggiDistricts = [
    {'id': 'KR-41-suwon', 'name': 'Suwon-si', 'nameKo': '수원시'},
    {'id': 'KR-41-seongnam', 'name': 'Seongnam-si', 'nameKo': '성남시'},
    {'id': 'KR-41-goyang', 'name': 'Goyang-si', 'nameKo': '고양시'},
    {'id': 'KR-41-yongin', 'name': 'Yongin-si', 'nameKo': '용인시'},
    {'id': 'KR-41-bucheon', 'name': 'Bucheon-si', 'nameKo': '부천시'},
    {'id': 'KR-41-ansan', 'name': 'Ansan-si', 'nameKo': '안산시'},
    {'id': 'KR-41-anyang', 'name': 'Anyang-si', 'nameKo': '안양시'},
    {'id': 'KR-41-namyangju', 'name': 'Namyangju-si', 'nameKo': '남양주시'},
    {'id': 'KR-41-hwaseong', 'name': 'Hwaseong-si', 'nameKo': '화성시'},
    {'id': 'KR-41-pyeongtaek', 'name': 'Pyeongtaek-si', 'nameKo': '평택시'},
    {'id': 'KR-41-uijeongbu', 'name': 'Uijeongbu-si', 'nameKo': '의정부시'},
    {'id': 'KR-41-siheung', 'name': 'Siheung-si', 'nameKo': '시흥시'},
    {'id': 'KR-41-paju', 'name': 'Paju-si', 'nameKo': '파주시'},
    {'id': 'KR-41-gimpo', 'name': 'Gimpo-si', 'nameKo': '김포시'},
    {'id': 'KR-41-gwangmyeong', 'name': 'Gwangmyeong-si', 'nameKo': '광명시'},
    {'id': 'KR-41-gwangju', 'name': 'Gwangju-si', 'nameKo': '광주시'},
    {'id': 'KR-41-gunpo', 'name': 'Gunpo-si', 'nameKo': '군포시'},
    {'id': 'KR-41-icheon', 'name': 'Icheon-si', 'nameKo': '이천시'},
    {'id': 'KR-41-yangju', 'name': 'Yangju-si', 'nameKo': '양주시'},
    {'id': 'KR-41-osan', 'name': 'Osan-si', 'nameKo': '오산시'},
    {'id': 'KR-41-guri', 'name': 'Guri-si', 'nameKo': '구리시'},
    {'id': 'KR-41-anseong', 'name': 'Anseong-si', 'nameKo': '안성시'},
    {'id': 'KR-41-pocheon', 'name': 'Pocheon-si', 'nameKo': '포천시'},
    {'id': 'KR-41-uiwang', 'name': 'Uiwang-si', 'nameKo': '의왕시'},
    {'id': 'KR-41-hanam', 'name': 'Hanam-si', 'nameKo': '하남시'},
    {'id': 'KR-41-yeoju', 'name': 'Yeoju-si', 'nameKo': '여주시'},
    {'id': 'KR-41-yangpyeong', 'name': 'Yangpyeong-gun', 'nameKo': '양평군'},
    {'id': 'KR-41-dongducheon', 'name': 'Dongducheon-si', 'nameKo': '동두천시'},
    {'id': 'KR-41-gwacheon', 'name': 'Gwacheon-si', 'nameKo': '과천시'},
    {'id': 'KR-41-gapyeong', 'name': 'Gapyeong-gun', 'nameKo': '가평군'},
    {'id': 'KR-41-yeoncheon', 'name': 'Yeoncheon-gun', 'nameKo': '연천군'},
  ];

  /// Get mapping of Korean Name -> District ID for a given parent region
  static Map<String, String> getNameToIdMap(String parentRegionId) {
    List<Map<String, String>> districts;
    if (parentRegionId == seoulId) {
      districts = seoulDistricts;
    } else if (parentRegionId == gyeonggiId) {
      districts = gyeonggiDistricts;
    } else {
      return {};
    }

    return {
      for (var d in districts) d['nameKo']!: d['id']!,
    };
  }

  /// Get district name by ID
  static String? getDistrictName(String districtId) {
    if (districtId.endsWith(allSuffix)) {
       if (districtId.startsWith(seoulId)) return 'All of Seoul';
       if (districtId.startsWith(gyeonggiId)) return 'All of Gyeonggi-do';
       return 'All';
    }

    final allDistricts = [...seoulDistricts, ...gyeonggiDistricts];
    for (var district in allDistricts) {
      if (district['id'] == districtId) {
        return district['name'];
      }
    }
    return null;
  }

  /// Check if a region ID has a sub-map (Seoul or Gyeonggi)
  static bool hasSubMap(String regionId) {
    return regionId == seoulId || regionId == gyeonggiId;
  }

  /// Get region name (supports both province-level and district-level IDs)
  static String getRegionName(String regionId) {
    // Check if it's a district ID
    final allDistricts = [...seoulDistricts, ...gyeonggiDistricts];
    for (var district in allDistricts) {
      if (district['id'] == regionId) {
        return district['nameKo']!;
      }
    }

    // Map of province-level region IDs to Korean names
    const Map<String, String> provinceNames = {
      'KR-11': '서울',
      'KR-26': '부산',
      'KR-27': '대구',
      'KR-28': '인천',
      'KR-29': '광주',
      'KR-30': '대전',
      'KR-31': '울산',
      'KR-50': '세종',
      'KR-41': '경기',
      'KR-42': '강원',
      'KR-43': '충북',
      'KR-44': '충남',
      'KR-45': '전북',
      'KR-46': '전남',
      'KR-47': '경북',
      'KR-48': '경남',
      'KR-49': '제주',
    };

    return provinceNames[regionId] ?? regionId;
  }
}
