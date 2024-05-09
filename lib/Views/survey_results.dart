import 'package:flutter/material.dart';
import 'package:survey_app/ViewModel/survey_view_model.dart';

class SurveyResultsScreen extends StatefulWidget {
  const SurveyResultsScreen({super.key});

  @override
  State<SurveyResultsScreen> createState() => _SurveyResultsState();
}

class _SurveyResultsState extends State<SurveyResultsScreen> {
  final SurveyViewModel _surveyViewModel = SurveyViewModel();
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _fetchSurveyResults();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: _isLoading
          ? SizedBox(
              height: size.height * 0.70,
              child: const Center(
                child: CircularProgressIndicator(), // Show loading indicator
              ),
            )
          : _surveyViewModel.surveyResults.isNotEmpty
              ? _buildSurveyResults(_surveyViewModel.surveyResults)
              : _surveyViewModel.totalSurveys > 0
                  ? _buildSurveyResults(
                      []) // Display the UI with no survey results
                  : SizedBox(
                      height: size.height * 0.70,
                      child: const Center(
                        child: Text('No Surveys Available'),
                      ),
                    ),
    );
  }

  _buildSurveyResults(List<Map<String, dynamic>> surveyResults) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(
            top: 10.0,
            bottom: 10.0,
          ),
          child: Center(
            child: Text(
              "Survey Results",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: size.width * 0.010,
              left: size.width * 0.050,
              right: size.width * 0.050,
              bottom: size.width * 0.010),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(size.width < 600
                  ? "Total number of Surveys:"
                  : "Total number of Surveys:"),
              Text("${_surveyViewModel.totalSurveys}")
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: size.width * 0.010,
              left: size.width * 0.050,
              right: size.width * 0.050,
              bottom: size.width * 0.010),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Average Age:"),
              Text("${_surveyViewModel.averageAge}")
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: size.width * 0.010,
              left: size.width * 0.050,
              right: size.width * 0.050,
              bottom: size.width * 0.010),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(size.width < 600
                  ? "Oldest Person who participated \nin Surveys:"
                  : "Oldest Person who participated in Surveys:"),
              Text("${_surveyViewModel.oldPerson}")
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: size.width * 0.010,
              left: size.width * 0.050,
              right: size.width * 0.050,
              bottom: size.width * 0.010),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(size.width < 600
                  ? "Youngest Person who participated \nin Surveys:"
                  : "Youngest Person who participated in Surveys:"),
              Text("${_surveyViewModel.youngPerson}")
            ],
          ),
        ),
        SizedBox(
          height: size.height * 0.020,
        ),
        Padding(
          padding: EdgeInsets.only(
              top: size.width * 0.010,
              left: size.width * 0.050,
              right: size.width * 0.050,
              bottom: size.width * 0.010),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Percentage of people who like Pizza:"),
              Text("${_surveyViewModel.pizzaPercentage}%")
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: size.width * 0.010,
              left: size.width * 0.050,
              right: size.width * 0.050,
              bottom: size.width * 0.010),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Percentage of people who like Pasta:"),
              Text("${_surveyViewModel.pastaPercentage}%")
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: size.width * 0.010,
              left: size.width * 0.050,
              right: size.width * 0.050,
              bottom: size.width * 0.010),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(size.width < 600
                  ? "Percentage of people who \nlike Pap and Wors:"
                  : "Percentage of people who like Pap and Wors:"),
              Text("${_surveyViewModel.papPercentage}%")
            ],
          ),
        ),
        SizedBox(
          height: size.height * 0.020,
        ),
        Padding(
          padding: EdgeInsets.only(
              top: size.width * 0.010,
              left: size.width * 0.050,
              right: size.width * 0.050,
              bottom: size.width * 0.010),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("People who like to watch movies:"),
              Text("${_surveyViewModel.averageMovies}")
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: size.width * 0.010,
              left: size.width * 0.050,
              right: size.width * 0.050,
              bottom: size.width * 0.010),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("People who like to listen to radio:"),
              Text("${_surveyViewModel.averageRadio}")
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: size.width * 0.010,
              left: size.width * 0.050,
              right: size.width * 0.050,
              bottom: size.width * 0.010),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("People who like to eat out:"),
              Text("${_surveyViewModel.averageEatOut}")
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: size.width * 0.010,
              left: size.width * 0.050,
              right: size.width * 0.050,
              bottom: size.width * 0.010),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("People who like to watch tv:"),
              Text("${_surveyViewModel.averageTv}")
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _fetchSurveyResults() async {
    await _surveyViewModel.fetchSurveyResults(); // Await the fetch operation
    setState(() {
      _isLoading = false; // Update loading state once data is fetched
    });
  }
}
