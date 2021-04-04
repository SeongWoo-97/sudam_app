import 'package:exam_project_app/Answer/Common/korAnswer.dart';
import 'package:exam_project_app/Answer/Common/engAnswer.dart';
import 'package:exam_project_app/Answer/Common/historyAnswer.dart';
import 'package:exam_project_app/Answer/Common/math1Answer.dart';
import 'package:exam_project_app/Answer/Common/math2Answer.dart';
import 'package:exam_project_app/Answer/Science/chemistry1Answer.dart';
import 'package:exam_project_app/Answer/Science/chemistry2Answer.dart';
import 'package:exam_project_app/Answer/Science/earth1Answer.dart';
import 'package:exam_project_app/Answer/Science/earth2Answer.dart';
import 'package:exam_project_app/Answer/Science/life1Answer.dart';
import 'package:exam_project_app/Answer/Science/life2Answer.dart';
import 'package:exam_project_app/Answer/Science/physics1Answer.dart';
import 'package:exam_project_app/Answer/Science/physics2Answer.dart';
import 'package:exam_project_app/Answer/Social/eastAsiaAnswer.dart';
import 'package:exam_project_app/Answer/Social/ethicsAndLifeAnswer.dart';
import 'package:exam_project_app/Answer/Social/koreanGeographyAnswer.dart';
import 'package:exam_project_app/Answer/Social/politicalAndLawAnswer.dart';
import 'package:exam_project_app/Answer/Social/worldHistoryAnswer.dart';
import 'package:exam_project_app/Answer/Social/economyAnswer.dart';
import 'package:exam_project_app/Answer/Social/ethicsAndthoughtsAnswer.dart';
import 'package:exam_project_app/Answer/Social/socialCultureAnswer.dart';
import 'package:exam_project_app/Answer/Social/worldGeographyAnswer.dart';

class ExamInfo {
  String objectName;
  String folderName;
  String answerName;
  int year;
  int month;
  int answerCount;
  var questionAnswer = [];
  List<String> pickedList;

  ExamInfo(String objectName, {int year, int month}) {
    this.objectName = objectName;
    this.year = year;
    this.month = month;
    switch (objectName) {
      case '국어':
        answerCount = 45;
        pickedList = List.filled(answerCount, " ");
        break;
      case '수학(가)':
        answerCount = 30;
        pickedList = List.filled(answerCount, " ");
        break;
      case '수학(나)':
        answerCount = 30;
        pickedList = List.filled(answerCount, " ");
        break;
      case '영어':
        answerCount = 45;
        pickedList = List.filled(answerCount, " ");
        break;
      default:
        answerCount = 20;
        pickedList = List.filled(answerCount, " ");
        break;
    }
    switch (objectName) {
      case '국어':
        folderName = 'kor';
        questionAnswer = korAnswer['$year년$month월'];
        break;
      case '수학(가)':
        folderName = 'math1';
        questionAnswer = math1Answer['$year년$month월'];
        break;
      case '수학(나)':
        folderName = 'math2';
        questionAnswer = math2Answer['$year년$month월'];
        break;
      case '영어':
        folderName = 'eng';
        questionAnswer = engAnswer['$year년$month월'];
        break;
      case '한국사':
        folderName = 'history';
        questionAnswer = historyAnswer['$year년$month월'];
        break;
      case '물리I':
        folderName = 'physics1';
        questionAnswer = physics1Answer['$year년$month월'];
        break;
      case '화학I':
        folderName = 'chemistry1';
        questionAnswer = chemistry1Answer['$year년$month월'];
        break;
      case '생명과학I':
        folderName = 'life1';
        questionAnswer = life1Answer['$year년$month월'];
        break;
      case '지구과학I':
        folderName = 'earth1';
        questionAnswer = earth1Answer['$year년$month월'];
        break;
      case '물리II':
        folderName = 'physics2';
        questionAnswer = physics2Answer['$year년$month월'];
        break;
      case '화학II':
        folderName = 'chemistry2';
        questionAnswer = chemistry2Answer['$year년$month월'];
        break;
      case '생명과학II':
        folderName = 'life2';
        questionAnswer = life2Answer['$year년$month월'];
        break;
      case '지구과학II':
        folderName = 'earth2';
        questionAnswer = earth2Answer['$year년$month월'];
        break;
      case '경제':
        folderName = 'economy';
        questionAnswer = economyAnswer['$year년$month월'];
        break;
      case '동아시아':
        folderName = 'eastAsia';
        questionAnswer = eastAsiaAnswer['$year년$month월'];
        break;
      case '사회문화':
        folderName = 'socialCulture';
        questionAnswer = socialCultureAnswer['$year년$month월'];
        break;
      case '세계사':
        folderName = 'worldHistory';
        questionAnswer = worldHistoryAnswer['$year년$month월'];
        break;
      case '세계지리':
        folderName = 'worldGeography';
        questionAnswer = worldGeographyAnswer['$year년$month월'];
        break;
      case '윤리와사상':
        folderName = 'ethicsAndthoughts';
        questionAnswer = ethicsAndthoughtsAnswer['$year년$month월'];
        break;
      case '정치와법':
        folderName = 'politicalAndLaw';
        questionAnswer = politicalAndLawAnswer['$year년$month월'];
        break;
      case '한국지리':
        folderName = 'koreanGeography';
        questionAnswer = koreanGeographyAnswer['$year년$month월'];
        break;
      case '생활과윤리':
        folderName = 'ethicsAndLife';
        questionAnswer = ethicsAndLifeAnswer['$year년$month월'];
        break;
    }
  }
}
