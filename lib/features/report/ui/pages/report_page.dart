import 'package:monthly_expenses/common/widgets/action_fab.dart';
import 'package:monthly_expenses/common/widgets/expandable_fab.dart';
import 'package:monthly_expenses/extensions/dart_time_extensions.dart';
import 'package:monthly_expenses/features/report/helpers/report_helper.dart';
import 'package:monthly_expenses/features/report/models/report.dart';
import 'package:monthly_expenses/features/report/models/transaction.dart';
import 'package:monthly_expenses/features/report/services/local_report_service.dart';
import 'package:monthly_expenses/features/report/ui/components/report_add_transaction_form_dialog.dart';
import 'package:monthly_expenses/features/report/ui/components/report_transaction_selection.dart';
import 'package:monthly_expenses/features/report/ui/components/report_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:monthly_expenses/features/settings/ui/pages/settings_page.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final _currentDate = DateTime.now();
  final _reportService = LocalReportService();
  var _report = Report.empty();
  var _transactionType = TransactionType.Expenses;
  var _transactionOccurence = TransactionOccurence.Repeating;

  @override
  void initState() {
    super.initState();

    _reportService.getReport(_currentDate).then((value) {
      setState(() {
        _report = value;
      });
    });
  }

  Future<void> getNextReport() async {
    _reportService.saveReport(_report);
    var nextReport = await _reportService.getNextReport(_report);

    setState(() {
      _report = nextReport;
    });
  }

  Future<void> getPreviousReport() async {
    _reportService.saveReport(_report);
    var previousReport = await _reportService.getPreviousReport(_report);

    setState(() {
      _report = previousReport;
    });
  }

  bool isCurrentDate() =>
      (_report.year != 0) &&
      (_report.month != 0) &&
      ReportHelper.getDateTime(_report).isSameYearMonth(_currentDate);

  void _showAddTransactionDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return ReportAddTransactionFormDialog(
            occurence: _transactionOccurence,
            onTransactionAdded: (transaction) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: Duration(milliseconds: 500),
                  content:
                      Text(AppLocalizations.of(context)!.transactionAdded)));
              setState(() {
                ReportHelper.addTransaction(_report, transaction,
                    _transactionType, _transactionOccurence);
                _reportService.saveReport(_report);
              });
            },
          );
        });
  }

  void _copyPreviousMonth() async {
    var previousReport = await _reportService.getPreviousReport(_report);

    setState(() {
      _report.fixedExpenses
          .addAll(new List<Transaction>.from(previousReport.fixedExpenses));
      _report.fixedIncomes
          .addAll(new List<Transaction>.from(previousReport.fixedIncomes));
      _reportService.saveReport(_report);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_left),
            onPressed: isCurrentDate()
                ? null
                : () {
                    getNextReport();
                  },
          ),
          title: Text(ReportHelper.getName(_report)),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.arrow_right),
              onPressed: () {
                getPreviousReport();
              },
            )
          ]),
      // body: ,
      body: ReportWidget(
          report: _report,
          type: _transactionType,
          occurence: _transactionOccurence,
          onStartOfMonthChanged: (value) {
            setState(() {
              _report.startOfMonth = value;
            });
            _reportService.saveReport(_report);
          },
          onTransactionsChanged: () {
            _reportService.saveReport(_report);
          }),
      bottomNavigationBar: ReportTransactionSelection(
        onTransactionOccurenceSelected: (occurence) {
          setState(() {
            _transactionOccurence = occurence;
          });
        },
        onTransactionTypeSelected: (type) {
          setState(() {
            _transactionType = type;
          });
        },
      ),
      floatingActionButton: ExpandableFab(
        distance: 80.0,
        openIcon: Icon(Icons.menu),
        closeIcon: Icon(
          Icons.close,
          color: Theme.of(context).primaryColor,
        ),
        children: [
          ActionFab(
              onPressed: _showAddTransactionDialog,
              icon: const Icon(Icons.add)),
          ActionFab(
            onPressed: _copyPreviousMonth,
            icon: const Icon(Icons.copy),
          ),
          ActionFab(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
              icon: const Icon(Icons.settings)),
        ],
      ),
    );
  }
}
