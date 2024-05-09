import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
class SurveyRepository {
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
      // Save the user data to the database (e.g., Firestore)
      // Example code to save data to Firestore:
      await FirebaseFirestore.instance.collection('surveys').add({
        'full_Name': fullName,
        'email_Address': emailAddress,
        'date_OfBirth': dateOfBirth,
        'contact': contact,
        'favorite_Foods': favoriteFoods,
        'movies_Preference': moviesPreference,
        'radio_Preference': radioPreference,
        'eat_OutPreference': eatOutPreference,
        'tv_Preference': tvPreference,
      });

      //navigate to the next page
    } catch (e) {
      // Handle any errors that occur during the save process
      // This could include logging the error or rethrowing it

      // ignore: avoid_print
      print(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getSurveyResults() async {
    try {
      // Retrieve survey results from Firestore
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('surveys').get();

      // Convert QuerySnapshot to a list of maps
      List<Map<String, dynamic>> results = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      return results;
    } catch (e) {
      // Handle any errors that occur during the retrieval process
      // This could include logging the error or rethrowing it
      rethrow;
    }
  }

  Future<int> getTotalSurveyCount() async {
    try {
      // Retrieve total count of surveys from Firestore
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('surveys').get();
      return querySnapshot.size;
    } catch (e) {
      // Handle any errors that occur during the retrieval process
      rethrow;
    }
  }

Future<List<String>> getDateOfBirthStrings() async {
  try {
    // Query Firestore to retrieve survey response documents
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('surveys').get();

    // Extract date of birth strings from documents
    List<String> dateOfBirthStrings = querySnapshot.docs.map((doc) {
      // Explicitly cast doc.data() to Map<String, dynamic> to resolve the error
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      // Use null-aware operator ?. to safely access the field
      // Assuming 'dateOfBirth' is the field in your document containing the date of birth as a string
      // Adjust this according to your actual Firestore document structure
      return data?['date_OfBirth'] as String;
    }).toList();

    // Filter out null values
    // dateOfBirthStrings.removeWhere((element) => element == null);

    return dateOfBirthStrings;
  } catch (e) {
    // Handle any errors
    // ignore: avoid_print
    print('Error retrieving date of birth strings: $e');
    return [];
  }
}

Future<int> calculateAverageAge() async {
  // Retrieve date of birth strings
  List<String> dateOfBirthStrings = await getDateOfBirthStrings();

  // Parse date of birth strings into DateTime objects
  List<DateTime> dateOfBirthDates = dateOfBirthStrings.map((dobString) {
    // Parse the date string into a DateTime object
    return DateFormat('yyyy-MM-dd').parse(dobString); // Adjust date format if necessary
  }).toList();

  // Calculate ages based on the current date
  DateTime currentDate = DateTime.now();
  List<int> ages = dateOfBirthDates.map((dob) {
    int age = currentDate.year - dob.year;
    if (currentDate.month < dob.month ||
        (currentDate.month == dob.month && currentDate.day < dob.day)) {
      age--; // Adjust age if the current date has not passed the birth month and day yet
    }
    return age;
  }).toList();

  // Calculate the average age
  if (ages.isNotEmpty) {
    double averageAge = ages.reduce((a, b) => a + b) / ages.length;
    return averageAge.round(); // Round the average age to the nearest whole number
  } else {
    // Handle the case where there are no dates of birth
    return 0; // or return a default value
  }
}


Future<int?> calculateOldestAge() async {
  try {
    List<String> dateOfBirthStrings = await getDateOfBirthStrings();

    // Parse each date of birth string into a DateTime object
    List<DateTime> dateOfBirths = dateOfBirthStrings.map((dobString) {
      return DateFormat('yyyy-MM-dd').parse(dobString);
    }).toList();

    // Calculate age for each person based on their date of birth
    List<int> ages = dateOfBirths.map((dob) {
      final now = DateTime.now();
      final age = now.year - dob.year - (now.month > dob.month || (now.month == dob.month && now.day >= dob.day) ? 0 : 1);
      return age;
    }).toList();

    // Find the maximum age
    int? oldestAge = ages.isNotEmpty ? ages.reduce((curr, next) => curr > next ? curr : next) : null;

    return oldestAge;
  } catch (e) {
    // Handle any errors
    // ignore: avoid_print
    print('Error calculating oldest age: $e');
    return null;
  }
}

Future<int?> calculateYoungestAge() async {
  try {
    List<String> dateOfBirthStrings = await getDateOfBirthStrings();

    // Parse each date of birth string into a DateTime object
    List<DateTime> dateOfBirths = dateOfBirthStrings.map((dobString) {
      return DateFormat('yyyy-MM-dd').parse(dobString);
    }).toList();

    // Calculate age for each person based on their date of birth
    List<int> ages = dateOfBirths.map((dob) {
      final now = DateTime.now();
      final age = now.year - dob.year - (now.month > dob.month || (now.month == dob.month && now.day >= dob.day) ? 0 : 1);
      return age;
    }).toList();

    // Find the minimum age
    int? youngestAge = ages.isNotEmpty ? ages.reduce((curr, next) => curr < next ? curr : next) : null;

    return youngestAge;
  } catch (e) {
    // Handle any errors
    // ignore: avoid_print
    print('Error calculating youngest age: $e');
    return null;
  }
}

Future<double> countPizzaLovers() async {
  try {
    // Retrieve survey results
    List<Map<String, dynamic>> surveyResults = await getSurveyResults();

    // Initialize counter
    int pizzaLoversCount = 0;

    // Loop through survey results
    for (var result in surveyResults) {
      // Check if favorite foods contain "Pizza"
      if (result['favorite_Foods'] != null && result['favorite_Foods'].contains('Pizza')) {
        pizzaLoversCount++;
      }
    }
    int totalSurveys = surveyResults.length;
    double percentage = (pizzaLoversCount / totalSurveys) * 100;
    percentage = double.parse(percentage.toStringAsFixed(1));

    return percentage;
  } catch (e) {
    // Handle any errors
    // ignore: avoid_print
    print('Error calculating pizza preference percentage: $e');
    return 0;
  }
}

Future<double> countPastaLovers() async {
  try {
    // Retrieve survey results
    List<Map<String, dynamic>> surveyResults = await getSurveyResults();

    // Initialize counter
    int pastaLoversCount = 0;

    // Loop through survey results
    for (var result in surveyResults) {
      // Check if favorite foods contain "Pasta"
      if (result['favorite_Foods'] != null && result['favorite_Foods'].contains('Pasta')) {
        pastaLoversCount++;
      }
    }
    int totalSurveys = surveyResults.length;
    double percentage = (pastaLoversCount / totalSurveys) * 100;
    percentage = double.parse(percentage.toStringAsFixed(1));

    return percentage;
  } catch (e) {
    // Handle any errors
    // ignore: avoid_print
    print('Error calculating pasta preference percentage: $e');
    return 0;
  }
}

Future<double> countPapLovers() async {
  try {
    // Retrieve survey results
    List<Map<String, dynamic>> surveyResults = await getSurveyResults();

    // Initialize counter
    int papLoversCount = 0;

    // Loop through survey results
    for (var result in surveyResults) {
      // Check if favorite foods contain "Pasta"
      if (result['favorite_Foods'] != null && result['favorite_Foods'].contains('Pap and Wors')) {
        papLoversCount++;
      }
    }
    int totalSurveys = surveyResults.length;
    double percentage = (papLoversCount / totalSurveys) * 100;
    percentage = double.parse(percentage.toStringAsFixed(1));

    return percentage;
  } catch (e) {
    // Handle any errors
    // ignore: avoid_print
    print('Error calculating pap and wors preference percentage: $e');
    return 0;
  }
}

Future<double> calculateEatOutPreferenceAverage() async {
  try {
    // Retrieve survey results
    List<Map<String, dynamic>> surveyResults = await getSurveyResults();

    // Initialize variables for total rating and count
    int totalRating = 0;
    int count = 0;

    // Loop through survey results
    // Loop through survey results
for (var result in surveyResults) {
  try {
    // Extract eat out preference rating and convert to numeric value
    String eatOutPreference = result['eat_OutPreference'];

    int eatRating = convertPreferenceToNumericValue(eatOutPreference);

    // Add rating to total and increment count
    totalRating += eatRating;
    count++;
  } catch (e) {
    // Handle any errors
    // ignore: avoid_print
    print('Error processing survey result: $e');
  }
}


    // Calculate average rating
    double averageRating = totalRating / count;

    // Round off to 1 decimal place
    return double.parse(averageRating.toStringAsFixed(1));
  } catch (e) {
    // Handle any errors
    // ignore: avoid_print
    print('Error calculating eat out preference average: $e');
    return 0.0;
  }
}

Future<double> calculateRadioPreferenceAverage() async {
  try {
    // Retrieve survey results
    List<Map<String, dynamic>> surveyResults = await getSurveyResults();

    // Initialize variables for total rating and count
    int totalRating = 0;
    int count = 0;

    // Loop through survey results
    for (var result in surveyResults) {
      // Extract eat out preference rating and convert to numeric value
      String radioPreference = result['radio_Preference'];

      int radioRating = convertPreferenceToNumericValue(radioPreference);

      // Add rating to total and increment count
      totalRating += radioRating;
      count++;
    }

    // Calculate average rating
    double averageRating = totalRating / count;

    // Round off to 1 decimal place
    return double.parse(averageRating.toStringAsFixed(1));
  } catch (e) {
    // Handle any errors
    // ignore: avoid_print
    print('Error calculating radio preference average: $e');
    return 0.0;
  }
}

Future<double> calculateMoviesPreferenceAverage() async {
  try {
    // Retrieve survey results
    List<Map<String, dynamic>> surveyResults = await getSurveyResults();

    // Initialize variables for total rating and count
    int totalRating = 0;
    int count = 0;

    // Loop through survey results
    for (var result in surveyResults) {
      // Extract eat out preference rating and convert to numeric value
      String moviePreference = result['movies_Preference'];

      int moviesRating = convertPreferenceToNumericValue(moviePreference);

      // Add rating to total and increment count
      totalRating += moviesRating;
      count++;
    }

    // Calculate average rating
    double averageRating = totalRating / count;

    // Round off to 1 decimal place
    return double.parse(averageRating.toStringAsFixed(1));
  } catch (e) {
    // Handle any errors
    // ignore: avoid_print
    print('Error calculating movies preference average: $e');
    return 0.0;
  }
}

Future<double> calculateTvPreferenceAverage() async {
  try {
    // Retrieve survey results
    List<Map<String, dynamic>> surveyResults = await getSurveyResults();

    // Initialize variables for total rating and count
    int totalRating = 0;
    int count = 0;

    // Loop through survey results
    for (var result in surveyResults) {
      // Extract eat out preference rating and convert to numeric value
      String tvPreference = result['tv_Preference'];

      int tvRating = convertPreferenceToNumericValue(tvPreference);

      // Add rating to total and increment count
      totalRating += tvRating;
      count++;
    }

    // Calculate average rating
    double averageRating = totalRating / count;

    // Round off to 1 decimal place
    return double.parse(averageRating.toStringAsFixed(1));
  } catch (e) {
    // Handle any errors
    // ignore: avoid_print
    print('Error calculating tv preference average: $e');
    return 0.0;
  }
}

// Function to convert preference string to numeric value
int convertPreferenceToNumericValue(String preference) {
  switch (preference) {
    case 'Strongly Agree':
      return 1;
    case 'Agree':
      return 2;
    case 'Neutral':
      return 3;
    case 'Disagree':
      return 4;
    case 'Strongly Disagree':
      return 5;
    default:
      return 0; // Handle unrecognized preferences
  }
}


}
