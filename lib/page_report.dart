import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PageReport extends StatefulWidget {
  const PageReport({Key? key}) : super(key: key);

  @override
  State<PageReport> createState() => _PageReportState();
}

class _PageReportState extends State<PageReport> {
  static final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
  static final DateTime today = DateTime.now();
  static final DateTime yesterday =
      DateTime.now().subtract(const Duration(days: 1));
  static final DateTime mondayOfThisWeek =
      DateTime(today.year, today.month, today.day - today.weekday + 1);
  static final DateTime mondayOfLastWeek =
      mondayOfThisWeek.subtract(const Duration(days: 7));

  late DateTimeRange _selectedDateTimeRange;
  late String _selectedValuePeriod;
  late String _selectedValueContent;
  late String _selectedValueFormat;

  @override
  void initState() {
    super.initState();

    _selectedValuePeriod = 'Last week';
    _selectedDateTimeRange = DateTimeRange(
        start: mondayOfLastWeek,
        end: mondayOfLastWeek.add(const Duration(days: 6)));
    _selectedValueContent = 'Brief';
    _selectedValueFormat = 'Web page';
  }

  _selectedPeriodLastWeek() {
    _selectedDateTimeRange = DateTimeRange(
        start: mondayOfLastWeek,
        end: mondayOfLastWeek.add(const Duration(days: 6)));
  }

  _selectedPeriodThisWeek() {
    _selectedDateTimeRange = DateTimeRange(
        start: mondayOfThisWeek,
        end: mondayOfThisWeek.add(const Duration(days: 6)));
  }

  _selectedPeriodYesterday() {
    _selectedDateTimeRange = DateTimeRange(start: yesterday, end: yesterday);
  }

  _selectedPeriodToday() {
    _selectedDateTimeRange = DateTimeRange(start: today, end: today);
  }

  _showAlertDateRange(BuildContext context) {
    Widget acceptButton = TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text(
        'ACCEPT',
      ),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Incorrect date range'),
          content:
              const Text('The "From" date has to be before the "To" date.\n\n'
                  'Please, select a valid "To" date.'),
          actions: [
            acceptButton,
          ],
        );
      },
    );
  }

  _pickFromDate() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTimeRange.start,
      firstDate: DateTime(today.year - 10),
      lastDate: DateTime(today.year + 10),
    );

    if (selectedDate != null) {
      if (selectedDate.isAfter(_selectedDateTimeRange.end)) {
        setState(() {
          _selectedValuePeriod = 'Other';
          _selectedDateTimeRange = DateTimeRange(
            start: selectedDate,
            end: selectedDate,
          );
        });
      } else {
        setState(() {
          _selectedValuePeriod = 'Other';
          _selectedDateTimeRange = DateTimeRange(
            start: selectedDate,
            end: _selectedDateTimeRange.end,
          );
        });
      }
    }
  }

  _pickToDate() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTimeRange.end,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      if (selectedDate.isAfter(_selectedDateTimeRange.start)) {
        setState(() {
          _selectedValuePeriod = 'Other';
          _selectedDateTimeRange = DateTimeRange(
            start: _selectedDateTimeRange.start,
            end: selectedDate,
          );
        });
      } else {
        if (mounted) {
          _showAlertDateRange(context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Report',
        ),
        leading: GestureDetector(
          onTap: () {
            // Navigate to the previous screen
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_sharp,
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(
            top: 30.0, bottom: 30.0, left: 50.0, right: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 30.0),
                  child: const Text('Period'),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 30.0),
                  child: DropdownButton<String>(
                    underline: Container(
                      height: 1.0,
                    ),
                    value: _selectedValuePeriod,
                    items: [
                      'Last week',
                      'This week',
                      'Yesterday',
                      'Today',
                      'Other',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedValuePeriod = newValue!;
                        switch (_selectedValuePeriod) {
                          case 'Last week':
                            _selectedPeriodLastWeek();
                            break;
                          case 'This week':
                            _selectedPeriodThisWeek();
                            break;
                          case 'Yesterday':
                            _selectedPeriodYesterday();
                            break;
                          case 'Today':
                            _selectedPeriodToday();
                            break;
                          case 'Other':
                            break;
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 30.0),
                  child: const Text('From'),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 25.0),
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 5.0),
                        child: Text(
                            dateFormatter.format(_selectedDateTimeRange.start)),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.calendar_month_sharp,
                        ),
                        onPressed: () {
                          _pickFromDate();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 30.0),
                  child: const Text('To'),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 25.0),
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 5.0),
                        child: Text(
                            dateFormatter.format(_selectedDateTimeRange.end)),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.calendar_month_sharp,
                        ),
                        onPressed: () {
                          _pickToDate();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 30.0),
                  child: const Text('Content'),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 30.0),
                  child: DropdownButton<String>(
                    underline: Container(
                      height: 1.0,
                    ),
                    value: _selectedValueContent,
                    items: [
                      'Brief',
                      'Detailed',
                      'Statistic',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedValueContent = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 30.0),
                  child: const Text('Format'),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 30.0),
                  child: DropdownButton<String>(
                    underline: Container(
                      height: 1.0,
                    ),
                    value: _selectedValueFormat,
                    items: [
                      'Web page',
                      'PDF',
                      'Text',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedValueFormat = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  child: const Text(
                    'Generate',
                    style: TextStyle(
                      color: Color.fromRGBO(30, 30, 30, 1),
                    ),
                  ),
                  onPressed: () {
                    // TODO: Generate the report for the selected date range               } else {
                    // TODO: Show an error message if the user has not selected a date range
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
