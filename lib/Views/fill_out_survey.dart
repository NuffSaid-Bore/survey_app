import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:survey_app/ViewModel/survey_view_model.dart';
import 'package:survey_app/Views/survey_results.dart';
import 'package:survey_app/components/widgets/text_form_field.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key});

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage>
    with SingleTickerProviderStateMixin {
  final SurveyViewModel _surveyViewModel = SurveyViewModel();
  late final TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dateofBirthController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  bool firstValue = false;
  bool secondValue = false;
  bool thirdValue = false;
  bool fourthValue = false;

  int movies = 0;
  int radio = 0;
  int out = 0;
  int tv = 0;

  final List<Tab> _tabs = [
    const Tab(
      text: "Fill Out Survey",
    ),
    const Tab(
      text: "View Survey Results",
    )
  ];

  String? validateAllFields() {
    !_formKey.currentState!.validate();
    if (!validateCheckbox()) {
      return 'At least one option must be selected';
    }
    return null;
  }

  bool validateCheckbox() {
    return firstValue || secondValue || thirdValue || fourthValue;
  }

  String? errorMessage;

  bool allUnchecked = false; // Flag to indicate if all checkboxes are unchecked
  bool? radioButtonSelected;

  bool? radioButtonRadioSelected;
  bool? radioButtonEatOutSelected;
  bool? radioButtonTvSelected;

  bool _isLoading = false;

  void _submitForm() {
    String? validationResult = validateAllFields();
    setState(() {
      errorMessage = validationResult;
      allUnchecked = firstValue == false &&
          secondValue == false &&
          thirdValue == false &&
          fourthValue == false;
    });
    if (radioButtonSelected == null) {
      setState(() {
        radioButtonSelected =
            false; // Set to false only after submit button is clicked
      });
    }
    //
    if (radioButtonRadioSelected == null) {
      setState(() {
        radioButtonRadioSelected =
            false; // Set to false only after submit button is clicked
      });
    }
    if (radioButtonEatOutSelected == null) {
      setState(() {
        radioButtonEatOutSelected =
            false; // Set to false only after submit button is clicked
      });
    }
    if (radioButtonTvSelected == null) {
      setState(() {
        radioButtonTvSelected =
            false; // Set to false only after submit button is clicked
      });
    }
    //
    if (validationResult == null &&
        !allUnchecked &&
        radioButtonSelected == true &&
        radioButtonRadioSelected == true &&
        radioButtonEatOutSelected == true &&
        radioButtonTvSelected == true &&
        _fullNameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _dateofBirthController.text.isNotEmpty &&
        _contactController.text.isNotEmpty &&
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
            .hasMatch(_emailController.text)) {
      _submitValidForm();
    }
  }

  void _submitValidForm() async {
    String selectedCheckboxes = '';
    String selectedMovieRadioButtons = '';
    String selectedRadioRadioButtons = '';
    String selectedEatOutRadioButtons = '';
    String selectedTvRadioButtons = '';
    //Radio Buttons

    if (movies == 1) {
      selectedMovieRadioButtons += 'Strongly Agree';
    }
    if (movies == 2) {
      selectedMovieRadioButtons += 'Agree';
    }
    if (movies == 3) {
      selectedMovieRadioButtons += 'Neutral';
    }
    if (movies == 4) {
      selectedMovieRadioButtons += 'Disagree';
    }
    if (movies == 5) {
      selectedMovieRadioButtons += 'Strongly Disagree';
    }
    if (radio == 1) {
      selectedRadioRadioButtons += 'Strongly Agree';
    }
    if (radio == 2) {
      selectedRadioRadioButtons += 'Agree';
    }
    if (radio == 3) {
      selectedRadioRadioButtons += 'Neutral';
    }
    if (radio == 4) {
      selectedRadioRadioButtons += 'Disagree';
    }
    if (radio == 5) {
      selectedRadioRadioButtons += 'Strongly Disagree';
    }
    if (out == 1) {
      selectedEatOutRadioButtons += 'Strongly Agree';
    }
    if (out == 2) {
      selectedEatOutRadioButtons += 'Agree';
    }
    if (out == 3) {
      selectedEatOutRadioButtons += 'Neutral';
    }
    if (out == 4) {
      selectedEatOutRadioButtons += 'Disagree';
    }
    if (out == 5) {
      selectedEatOutRadioButtons += 'Strongly Disagree';
    }
    if (tv == 1) {
      selectedTvRadioButtons += 'Strongly Agree';
    }
    if (tv == 2) {
      selectedTvRadioButtons += 'Agree';
    }
    if (tv == 3) {
      selectedTvRadioButtons += 'Neutral';
    }
    if (tv == 4) {
      selectedTvRadioButtons += 'Disagree';
    }
    if (tv == 5) {
      selectedTvRadioButtons += 'Strongly Disagree';
    }

    if (firstValue) {
      selectedCheckboxes += ' Pizza, ';
    }

    if (secondValue) {
      selectedCheckboxes += 'Pasta, ';
    }

    if (thirdValue) {
      selectedCheckboxes += 'Pap and Wors, ';
    }

    if (fourthValue) {
      selectedCheckboxes += 'Other, ';
    }

    selectedCheckboxes = selectedCheckboxes.isNotEmpty
        ? selectedCheckboxes.substring(0, selectedCheckboxes.length - 2)
        : selectedCheckboxes;

    setState(() {
      _isLoading = true;
    });
    _surveyViewModel.saveSurvey(
      fullName: _fullNameController.text,
      emailAddress: _emailController.text,
      dateOfBirth: _dateofBirthController.text,
      contact: _contactController.text,
      favoriteFoods: selectedCheckboxes,
      moviesPreference: selectedMovieRadioButtons,
      radioPreference: selectedRadioRadioButtons,
      eatOutPreference: selectedEatOutRadioButtons,
      tvPreference: selectedTvRadioButtons,
    );

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          duration: const Duration(seconds: 2),
          content: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                height: 90,
                decoration: BoxDecoration(
                    color: Colors.deepPurple.shade400,
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: const Row(
                  children: [
                    SizedBox(
                      width: 48,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Congrats!',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          Spacer(),
                          Text(
                            'Survey entry successfully captured!',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.only(bottomLeft: Radius.circular(20)),
                  child: SvgPicture.asset(
                    'assets/icons.bubbles.svg',
                    height: 48,
                    width: 40,
                    // ignore: deprecated_member_use
                    color: Colors.deepPurple.shade600,
                  ),
                ),
              ),
              Positioned(
                top: -20,
                bottom: 0,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/fail.svg',
                      height: 40,
                    ),
                    Positioned(
                      top: 10,
                      child: SvgPicture.asset(
                        'assets/icons/close.svg',
                        height: 16,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    _resetDataFields();
  }

  void _resetDataFields() {
    _formKey.currentState!.reset();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fullNameController;
    _emailController;
    _dateofBirthController;
    _contactController;
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _dateofBirthController.dispose();
    _contactController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(242, 236, 255, 1.0),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(242, 236, 255, 1.0),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.008),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: size.width < 600
                              ? size.width * 0.30
                              : size.width * 0.60,
                          child: Text(
                            '_Surveys',
                            style: TextStyle(
                              fontSize: size.width < 600 ? 12.0 : 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              double tabTextSize =
                                  size.width < 600 ? 10.0 : 16.0;
                              return TabBar(
                                labelColor: Colors.blue.shade300,
                                indicatorColor: Colors.transparent,
                                dividerColor: Colors.transparent,
                                controller: _tabController,
                                tabs: _tabs.map((tab) {
                                  return Tab(
                                    child: SizedBox(
                                      width:
                                          constraints.maxWidth / _tabs.length,
                                      child: Text(
                                        tab.text!,
                                        style: TextStyle(
                                          fontSize: tabTextSize,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 7,
                child: Container(
                  height: size.height * 0.7,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    color: const Color.fromRGBO(242, 236, 255, 1.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: size.width * 0.030),
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      const Text(
                                        "Personal Details:",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.height * 0.03,
                                      ),
                                      MyInputText.buildCustomizedTextField(
                                          controller: _fullNameController,
                                          keyboardType: TextInputType.text,
                                          labelText: "Full Name",
                                          labelError: "Full Name is required"),
                                      SizedBox(
                                        height: size.height * 0.02,
                                      ),
                                      MyInputText.buildCustomizedTextField(
                                        controller: _emailController,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        labelText: "Email",
                                        labelError: "Email is required",
                                        validateEmail: true,
                                      ),
                                      SizedBox(
                                        height: size.height * 0.02,
                                      ),
                                      MyInputText.buildCustomizedTextField(
                                          controller: _dateofBirthController,
                                          keyboardType: TextInputType.datetime,
                                          labelText: "Date Of Birth",
                                          labelError:
                                              "Date of Birth is required",
                                          onTap: () {
                                            _selectedDate();
                                          }),
                                      SizedBox(
                                        height: size.height * 0.02,
                                      ),
                                      MyInputText.buildCustomizedTextField(
                                          controller: _contactController,
                                          keyboardType: TextInputType.number,
                                          labelText: "Contact Number",
                                          labelError:
                                              "Contact Number is required"),
                                      SizedBox(
                                        height: size.height * 0.04,
                                      ),
                                      const Text(
                                        "What is your favourite food?",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.height * 0.02,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Checkbox(
                                                value: firstValue,
                                                onChanged: (value) {
                                                  setState(() {
                                                    firstValue = value!;
                                                    allUnchecked =
                                                        !firstValue &&
                                                            !secondValue &&
                                                            !thirdValue &&
                                                            !fourthValue;
                                                    // If at least one checkbox is checked, remove the error message
                                                    if (!allUnchecked) {
                                                      errorMessage = null;
                                                    }
                                                  });
                                                },
                                                activeColor: allUnchecked
                                                    ? Colors.red
                                                    : null,
                                              ),
                                              Text(
                                                "Pizza",
                                                style: TextStyle(
                                                  color: allUnchecked
                                                      ? Colors.red
                                                      : Colors.black,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Checkbox(
                                                value: secondValue,
                                                onChanged: (value) {
                                                  setState(() {
                                                    secondValue = value!;
                                                    allUnchecked =
                                                        !firstValue &&
                                                            !secondValue &&
                                                            !thirdValue &&
                                                            !fourthValue;
                                                    // If at least one checkbox is checked, remove the error message
                                                    if (!allUnchecked) {
                                                      errorMessage = null;
                                                    }
                                                  });
                                                },
                                                activeColor: allUnchecked
                                                    ? Colors.red
                                                    : null,
                                              ),
                                              Text(
                                                "Pasta",
                                                style: TextStyle(
                                                  color: allUnchecked
                                                      ? Colors.red
                                                      : Colors.black,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Checkbox(
                                                value: thirdValue,
                                                onChanged: (value) {
                                                  setState(() {
                                                    thirdValue = value!;
                                                    allUnchecked =
                                                        !firstValue &&
                                                            !secondValue &&
                                                            !thirdValue &&
                                                            !fourthValue;
                                                    // If at least one checkbox is checked, remove the error message
                                                    if (!allUnchecked) {
                                                      errorMessage = null;
                                                    }
                                                  });
                                                },
                                                activeColor: allUnchecked
                                                    ? Colors.red
                                                    : null,
                                              ),
                                              Text(
                                                "Pap & Wors",
                                                style: TextStyle(
                                                  color: allUnchecked
                                                      ? Colors.red
                                                      : Colors.black,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Checkbox(
                                                value: fourthValue,
                                                onChanged: (value) {
                                                  setState(() {
                                                    fourthValue = value!;
                                                    allUnchecked =
                                                        !firstValue &&
                                                            !secondValue &&
                                                            !thirdValue &&
                                                            !fourthValue;
                                                    // If at least one checkbox is checked, remove the error message
                                                    if (!allUnchecked) {
                                                      errorMessage = null;
                                                    }
                                                  });
                                                },
                                                activeColor: allUnchecked
                                                    ? Colors.red
                                                    : null,
                                              ),
                                              Text(
                                                "Other",
                                                style: TextStyle(
                                                  color: allUnchecked
                                                      ? Colors.red
                                                      : Colors.black,
                                                  fontSize: 12,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      if (errorMessage != null)
                                        Text(
                                          errorMessage!,
                                          style: const TextStyle(
                                              color: Colors.red),
                                        ),
                                      SizedBox(
                                        height: size.height * 0.02,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: size.width * 0.025,
                                          right: size.width * 0.025,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                left: size.width * 0.010,
                                                bottom: size.width * 0.010,
                                              ),
                                              child: const Text(
                                                "I like to watch movies",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Radio(
                                                    value: 1,
                                                    groupValue: movies,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        movies = value!;
                                                        radioButtonSelected =
                                                            true;
                                                      });
                                                    }),
                                                SizedBox(
                                                  width: size.width * 0.01,
                                                ),
                                                Text(
                                                  "Strongly Agree",
                                                  style: TextStyle(
                                                      color:
                                                          radioButtonSelected ==
                                                                  false
                                                              ? Colors.red
                                                              : Colors.black),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Radio(
                                                    value: 2,
                                                    groupValue: movies,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        movies = value!;
                                                        radioButtonSelected =
                                                            true;
                                                      });
                                                    }),
                                                SizedBox(
                                                  width: size.width * 0.01,
                                                ),
                                                Text(
                                                  "Agree",
                                                  style: TextStyle(
                                                      color:
                                                          radioButtonSelected ==
                                                                  false
                                                              ? Colors.red
                                                              : Colors.black),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Radio(
                                                    value: 3,
                                                    groupValue: movies,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        movies = value!;
                                                        radioButtonSelected =
                                                            true;
                                                      });
                                                    }),
                                                SizedBox(
                                                  width: size.width * 0.01,
                                                ),
                                                Text(
                                                  "Neutral",
                                                  style: TextStyle(
                                                      color:
                                                          radioButtonSelected ==
                                                                  false
                                                              ? Colors.red
                                                              : Colors.black),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Radio(
                                                    value: 4,
                                                    groupValue: movies,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        movies = value!;
                                                        radioButtonSelected =
                                                            true;
                                                      });
                                                    }),
                                                SizedBox(
                                                  width: size.width * 0.01,
                                                ),
                                                Text(
                                                  "Disagree",
                                                  style: TextStyle(
                                                      color:
                                                          radioButtonSelected ==
                                                                  false
                                                              ? Colors.red
                                                              : Colors.black),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Radio(
                                                    value: 5,
                                                    groupValue: movies,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        movies = value!;
                                                        radioButtonSelected =
                                                            true;
                                                      });
                                                    }),
                                                SizedBox(
                                                  width: size.width * 0.01,
                                                ),
                                                Text(
                                                  "Strongly Disagree",
                                                  style: TextStyle(
                                                    color:
                                                        radioButtonSelected ==
                                                                false
                                                            ? Colors.red
                                                            : Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (radioButtonSelected == false)
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: size.width * 0.025),
                                                child: const Text(
                                                  "Please select an option",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.height * 0.02,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: size.width * 0.025,
                                          right: size.width * 0.025,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                left: size.width * 0.010,
                                                bottom: size.width * 0.010,
                                              ),
                                              child: const Text(
                                                "I like to listen to radio",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Radio(
                                                    value: 1,
                                                    groupValue: radio,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        radio = value!;
                                                        radioButtonRadioSelected =
                                                            true;
                                                      });
                                                    }),
                                                SizedBox(
                                                  width: size.width * 0.01,
                                                ),
                                                Text(
                                                  "Strongly Agree",
                                                  style: TextStyle(
                                                      color:
                                                          radioButtonRadioSelected ==
                                                                  false
                                                              ? Colors.red
                                                              : Colors.black),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Radio(
                                                    value: 2,
                                                    groupValue: radio,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        radio = value!;
                                                        radioButtonRadioSelected =
                                                            true;
                                                      });
                                                    }),
                                                SizedBox(
                                                  width: size.width * 0.01,
                                                ),
                                                Text(
                                                  "Agree",
                                                  style: TextStyle(
                                                      color:
                                                          radioButtonRadioSelected ==
                                                                  false
                                                              ? Colors.red
                                                              : Colors.black),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Radio(
                                                    value: 3,
                                                    groupValue: radio,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        radio = value!;
                                                        radioButtonRadioSelected =
                                                            true;
                                                      });
                                                    }),
                                                SizedBox(
                                                  width: size.width * 0.01,
                                                ),
                                                Text(
                                                  "Neutral",
                                                  style: TextStyle(
                                                      color:
                                                          radioButtonRadioSelected ==
                                                                  false
                                                              ? Colors.red
                                                              : Colors.black),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Radio(
                                                    value: 4,
                                                    groupValue: radio,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        radio = value!;
                                                        radioButtonRadioSelected =
                                                            true;
                                                      });
                                                    }),
                                                SizedBox(
                                                  width: size.width * 0.01,
                                                ),
                                                Text(
                                                  "Disagree",
                                                  style: TextStyle(
                                                      color:
                                                          radioButtonRadioSelected ==
                                                                  false
                                                              ? Colors.red
                                                              : Colors.black),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Radio(
                                                    value: 5,
                                                    groupValue: radio,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        radio = value!;
                                                        radioButtonRadioSelected =
                                                            true;
                                                      });
                                                    }),
                                                SizedBox(
                                                  width: size.width * 0.01,
                                                ),
                                                Text(
                                                  "Strongly Disagree",
                                                  style: TextStyle(
                                                      color:
                                                          radioButtonRadioSelected ==
                                                                  false
                                                              ? Colors.red
                                                              : Colors.black),
                                                ),
                                              ],
                                            ),
                                            if (radioButtonRadioSelected ==
                                                false)
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: size.width * 0.025),
                                                child: const Text(
                                                  "Please select an option",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.height * 0.02,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: size.width * 0.025,
                                          right: size.width * 0.025,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                left: size.width * 0.010,
                                                bottom: size.width * 0.010,
                                              ),
                                              child: const Text(
                                                "I like to eat out",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Radio(
                                                    value: 1,
                                                    groupValue: out,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        out = value!;
                                                        radioButtonEatOutSelected =
                                                            true;
                                                      });
                                                    }),
                                                SizedBox(
                                                  width: size.width * 0.01,
                                                ),
                                                Text(
                                                  "Strongly Agree",
                                                  style: TextStyle(
                                                      color:
                                                          radioButtonEatOutSelected ==
                                                                  false
                                                              ? Colors.red
                                                              : Colors.black),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Radio(
                                                    value: 2,
                                                    groupValue: out,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        out = value!;
                                                        radioButtonEatOutSelected =
                                                            true;
                                                      });
                                                    }),
                                                SizedBox(
                                                  width: size.width * 0.01,
                                                ),
                                                Text(
                                                  "Agree",
                                                  style: TextStyle(
                                                      color:
                                                          radioButtonEatOutSelected ==
                                                                  false
                                                              ? Colors.red
                                                              : Colors.black),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Radio(
                                                    value: 3,
                                                    groupValue: out,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        out = value!;
                                                        radioButtonEatOutSelected =
                                                            true;
                                                      });
                                                    }),
                                                SizedBox(
                                                  width: size.width * 0.01,
                                                ),
                                                Text(
                                                  "Neutral",
                                                  style: TextStyle(
                                                      color:
                                                          radioButtonEatOutSelected ==
                                                                  false
                                                              ? Colors.red
                                                              : Colors.black),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Radio(
                                                    value: 4,
                                                    groupValue: out,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        out = value!;
                                                        radioButtonEatOutSelected =
                                                            true;
                                                      });
                                                    }),
                                                SizedBox(
                                                  width: size.width * 0.01,
                                                ),
                                                Text(
                                                  "Disagree",
                                                  style: TextStyle(
                                                      color:
                                                          radioButtonEatOutSelected ==
                                                                  false
                                                              ? Colors.red
                                                              : Colors.black),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Radio(
                                                    value: 5,
                                                    groupValue: out,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        out = value!;
                                                        radioButtonEatOutSelected =
                                                            true;
                                                      });
                                                    }),
                                                SizedBox(
                                                  width: size.width * 0.01,
                                                ),
                                                Text(
                                                  "Strongly Disagree",
                                                  style: TextStyle(
                                                      color:
                                                          radioButtonEatOutSelected ==
                                                                  false
                                                              ? Colors.red
                                                              : Colors.black),
                                                ),
                                              ],
                                            ),
                                            if (radioButtonEatOutSelected ==
                                                false)
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: size.width * 0.025),
                                                child: const Text(
                                                  "Please select an option",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.height * 0.02,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: size.width * 0.025,
                                          right: size.width * 0.025,
                                          bottom: size.width * 0.025,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                left: size.width * 0.010,
                                                bottom: size.width * 0.010,
                                              ),
                                              child: const Text(
                                                "I like to watch tv",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Radio(
                                                    value: 1,
                                                    groupValue: tv,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        tv = value!;
                                                        radioButtonTvSelected =
                                                            true;
                                                      });
                                                    }),
                                                SizedBox(
                                                  width: size.width * 0.01,
                                                ),
                                                Text(
                                                  "Strongly Agree",
                                                  style: TextStyle(
                                                      color:
                                                          radioButtonTvSelected ==
                                                                  false
                                                              ? Colors.red
                                                              : Colors.black),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Radio(
                                                    value: 2,
                                                    groupValue: tv,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        tv = value!;
                                                        radioButtonTvSelected =
                                                            true;
                                                      });
                                                    }),
                                                SizedBox(
                                                  width: size.width * 0.01,
                                                ),
                                                Text(
                                                  "Agree",
                                                  style: TextStyle(
                                                      color:
                                                          radioButtonTvSelected ==
                                                                  false
                                                              ? Colors.red
                                                              : Colors.black),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Radio(
                                                    value: 3,
                                                    groupValue: tv,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        tv = value!;
                                                        radioButtonTvSelected =
                                                            true;
                                                      });
                                                    }),
                                                SizedBox(
                                                  width: size.width * 0.01,
                                                ),
                                                Text(
                                                  "Neutral",
                                                  style: TextStyle(
                                                      color:
                                                          radioButtonTvSelected ==
                                                                  false
                                                              ? Colors.red
                                                              : Colors.black),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Radio(
                                                    value: 4,
                                                    groupValue: tv,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        tv = value!;
                                                        radioButtonTvSelected =
                                                            true;
                                                      });
                                                    }),
                                                SizedBox(
                                                  width: size.width * 0.01,
                                                ),
                                                Text(
                                                  "Disagree",
                                                  style: TextStyle(
                                                      color:
                                                          radioButtonTvSelected ==
                                                                  false
                                                              ? Colors.red
                                                              : Colors.black),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Radio(
                                                    value: 5,
                                                    groupValue: tv,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        tv = value!;
                                                        radioButtonTvSelected =
                                                            true;
                                                      });
                                                    }),
                                                SizedBox(
                                                  width: size.width * 0.01,
                                                ),
                                                Text(
                                                  "Strongly Disagree",
                                                  style: TextStyle(
                                                      color:
                                                          radioButtonTvSelected ==
                                                                  false
                                                              ? Colors.red
                                                              : Colors.black),
                                                ),
                                              ],
                                            ),
                                            if (radioButtonTvSelected == false)
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: size.width * 0.025),
                                                child: const Text(
                                                  "Please select an option",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: size.height * 0.05),
                                        child: ElevatedButton(
                                          onPressed:
                                              _isLoading ? null : _submitForm,
                                          // () {

                                          //   _submitForm();
                                          // },
                                          style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: size.width * 0.15,
                                                  vertical:
                                                      size.height * 0.032),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                              ),
                                              backgroundColor:
                                                  Colors.deepPurple.shade300),
                                          child: _isLoading
                                              ? SizedBox(
                                                  width: size.width * 0.15,
                                                  height: size.height * 0.032,
                                                  child: Row(
                                                    children: [
                                                      const Expanded(
                                                        child: Text(
                                                          'Saving Entry',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            size.width * 0.008,
                                                      ),
                                                      SizedBox(
                                                        height:
                                                            size.height * 0.035,
                                                        width:
                                                            size.width * 0.035,
                                                        child:
                                                            const CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : const Text(
                                                  'Submit',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        242, 236, 255, 1.0),
                                                  ),
                                                ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: size.width * 0.05,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SurveyResultsScreen(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectedDate() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1600),
        lastDate: DateTime(2100));

    if (pickedDate != null) {
      setState(() {
        _dateofBirthController.text = pickedDate.toString().split(" ")[0];
      });
    }
  }
}
