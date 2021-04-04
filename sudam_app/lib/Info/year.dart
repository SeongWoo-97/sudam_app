class Year {
  String expandedValue;
  String headerValue;
  bool isExpanded;
  int id;

  Year({this.id, this.expandedValue, this.headerValue, this.isExpanded = false});
}

List<Year> generateItems(int numberOfItems) {
  return List.generate(numberOfItems, (int index) {
    return Year(
      id: index,
      headerValue: '${yearList[index]}년',
      //expandedValue: '${monthList[index]}월 국어 모의고사'
    );
  });
}

List<int> yearList = [2021, 2020, 2019, 2018, 2017, 2016]; //6
List<int> monthList = [3, 4, 6, 7, 9, 10, 11]; //7

var objectUrl = {
  '국어': 'https://kr.object.ncloudstorage.com/sudam/Common/kor',
  '수학(가)': 'https://kr.object.ncloudstorage.com/sudam/Common/math1',
  '수학(나)': 'https://kr.object.ncloudstorage.com/sudam/Common/math2',
  '영어': 'https://kr.object.ncloudstorage.com/sudam/Common/eng',
  '한국사': 'https://kr.object.ncloudstorage.com/sudam/Common/history',
  '물리I': 'https://kr.object.ncloudstorage.com/sudam/Science/physics1',
  '화학I': 'https://kr.object.ncloudstorage.com/sudam/Science/chemistry1',
  '생명과학I': 'https://kr.object.ncloudstorage.com/sudam/Science/life1',
  '지구과학I': 'https://kr.object.ncloudstorage.com/sudam/Science/earth1',
  '물리II': 'https://kr.object.ncloudstorage.com/sudam/Science/physics2',
  '화학II': 'https://kr.object.ncloudstorage.com/sudam/Science/chemistry2',
  '생명과학II': 'https://kr.object.ncloudstorage.com/sudam/Science/life2',
  '지구과학II': 'https://kr.object.ncloudstorage.com/sudam/Science/earth2',
  '경제': 'https://kr.object.ncloudstorage.com/sudam/Social/economy',
  '동아시아': 'https://kr.object.ncloudstorage.com/sudam/Social/eastAsia',
  '사회문화': 'https://kr.object.ncloudstorage.com/sudam/Social/socialCulture',
  '세계사': 'https://kr.object.ncloudstorage.com/sudam/Social/worldHistory',
  '세계지리': 'https://kr.object.ncloudstorage.com/sudam/Social/worldGeography',
  '윤리와사상': 'https://kr.object.ncloudstorage.com/sudam/Social/ethicsAndthoughts',
  '정치와법': 'https://kr.object.ncloudstorage.com/sudam/Social/politicalAndLaw',
  '한국지리': 'https://kr.object.ncloudstorage.com/sudam/Social/koreanGeography',
  '생활과윤리': 'https://kr.object.ncloudstorage.com/sudam/Social/ethicsAndLife',
};

var objectAnswerUrl = {
  '국어': 'https://kr.object.ncloudstorage.com/sudam/Common/kor_answer',
  '수학(가)': 'https://kr.object.ncloudstorage.com/sudam/Common/math1_answer',
  '수학(나)': 'https://kr.object.ncloudstorage.com/sudam/Common/math2_answer',
  '영어': 'https://kr.object.ncloudstorage.com/sudam/Common/eng_answer',
  '한국사': 'https://kr.object.ncloudstorage.com/sudam/Common/history_answer',
  '물리I': 'https://kr.object.ncloudstorage.com/sudam/Science/physics1_answer',
  '화학I': 'https://kr.object.ncloudstorage.com/sudam/Science/chemistry1_answer',
  '생명과학I': 'https://kr.object.ncloudstorage.com/sudam/Science/life1_answer',
  '지구과학I': 'https://kr.object.ncloudstorage.com/sudam/Science/earth1_answer',
  '물리II': 'https://kr.object.ncloudstorage.com/sudam/Science/physics2_answer',
  '화학II': 'https://kr.object.ncloudstorage.com/sudam/Science/chemistry2_answer',
  '생명과학II': 'https://kr.object.ncloudstorage.com/sudam/Science/life2_answer',
  '지구과학II': 'https://kr.object.ncloudstorage.com/sudam/Science/earth2_answer',
  '경제': 'https://kr.object.ncloudstorage.com/sudam/Social/economy_answer',
  '동아시아': 'https://kr.object.ncloudstorage.com/sudam/Social/eastAsia_answer',
  '사회문화': 'https://kr.object.ncloudstorage.com/sudam/Social/socialCulture_answer',
  '세계사': 'https://kr.object.ncloudstorage.com/sudam/Social/worldHistory_answer',
  '세계지리': 'https://kr.object.ncloudstorage.com/sudam/Social/worldGeography_answer',
  '윤리와사상': 'https://kr.object.ncloudstorage.com/sudam/Social/ethicsAndthoughts_answer',
  '정치와법': 'https://kr.object.ncloudstorage.com/sudam/Social/politicalAndLaw_answer',
  '한국지리': 'https://kr.object.ncloudstorage.com/sudam/Social/koreanGeography_answer',
  '생활과윤리': 'https://kr.object.ncloudstorage.com/sudam/Social/ethicsAndLife_answer',
};
