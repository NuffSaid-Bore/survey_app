import 'package:flutter/foundation.dart';
import 'package:survey_app/repositories/survey_repo.dart';

class SurveyViewModel extends ChangeNotifier {
  final SurveyRepository _surveyRepository = SurveyRepository();
  List<Map<String, dynamic>> surveyResults = [];
  int totalSurveys = 0;
  int averageAge = 0;
  int? oldPerson = 0;
  int? youngPerson = 0;

  double pizzaPercentage = 0.0;
  double pastaPercentage = 0.0;
  double papPercentage = 0.0;

  double averageMovies = 0.0;
  double averageRadio = 0.0;
  double averageEatOut = 0.0;
  double averageTv = 0.0;

  Future<void> fetchSurveyResults() async {
    try {
      surveyResults = await _surveyRepository.getSurveyResults();
      totalSurveys = await _surveyRepository.getTotalSurveyCount();
      averageAge = await _surveyRepository.calculateAverageAge();
      oldPerson = await _surveyRepository.calculateOldestAge();
      youngPerson = await _surveyRepository.calculateYoungestAge();
      pizzaPercentage = await _surveyRepository.countPizzaLovers();
      pastaPercentage = await _surveyRepository.countPastaLovers();
      papPercentage = await _surveyRepository.countPapLovers();
      averageMovies =
          await _surveyRepository.calculateMoviesPreferenceAverage();
      averageRadio = await _surveyRepository.calculateRadioPreferenceAverage();
      averageEatOut =
          await _surveyRepository.calculateEatOutPreferenceAverage();
      averageTv = await _surveyRepository.calculateTvPreferenceAverage();

      notifyListeners();
    } catch (e) {
      // Handle any errors that occur during the retrieval process
      // This could include logging the error or displaying an error message to the user

      // ignore: avoid_print
      print('Error fetching survey results: $e');
      notifyListeners();
    }
  }

  Future<void> saveSurvey({
    required String fullName,
    required String emailAddress,
    required String dateOfBirth,
    required String contact,
    required String favoriteFoods,
    required String moviesPreference,
    required String radioPreference,
    required String eatOutPreference,
    required String tvPreference,
  }) async {
    try {
      // Call UserRepository's saveUser method to save the user data
      await _surveyRepository.saveSurvey(
        fullName: fullName,
        emailAddress: emailAddress,
        dateOfBirth: dateOfBirth,
        contact: contact,
        favoriteFoods: favoriteFoods,
        moviesPreference: moviesPreference,
        radioPreference: radioPreference,
        eatOutPreference: eatOutPreference,
        tvPreference: tvPreference,
      );
      notifyListeners();
    } catch (e) {
      // Handle any errors that occur during the save process
      // This could include logging the error or displaying an error message to the user
      // ignore: avoid_print
      print('Error saving user data: $e');
    }
  }
}
