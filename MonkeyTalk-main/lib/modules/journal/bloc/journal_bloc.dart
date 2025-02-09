import 'package:collection/collection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kraken/config.dart';
import 'package:kraken/modules/journal/model/journal_model.dart';
import 'package:kraken/utils/network/exception_handler.dart';
import 'package:kraken/utils/network/network_requester.dart';
import 'package:rxdart/rxdart.dart';

class JournalBloc {
  JournalBloc._();

  factory JournalBloc() => _instance ??= JournalBloc._();

  static JournalBloc? _instance;

  final BehaviorSubject<List<JournalModel>> _journalSubject =
      BehaviorSubject<List<JournalModel>>();

  Stream<List<JournalModel>> get journalStream => _journalSubject.stream;

  final NetworkRequester _networkRequester = NetworkRequester.instance;

  List<JournalModel> _journalList = [];

  Future<void> loadData() async {
    final result = await hitJournalApi();
    if (result != null) {
      _journalList = result;
    } else {
      _journalList = [];
      for (Map<String, dynamic> e in mockJournalData) {
        _journalList.add(JournalModel.fromJson(e));
      }
    }
    _journalList.sortBy((element) => element.date);
    _journalSubject.sink.add(_journalList.reversed.toList());
  }

  Future<List<JournalModel>?> hitJournalApi() async {
    var response = await _networkRequester.post(path: "/journal", data: {});
    if (response is! APIException) {
      List<JournalModel> journals = [];
      for (Map<String, dynamic> e in (response.data as List)) {
        journals.add(JournalModel.fromJson(e));
      }
      return journals;
    }
    Fluttertoast.showToast(msg: "Error ${response.message}");
    return null;
  }

  Future<bool> hitRecordingContentApi(String content) async {
    var response = await _networkRequester.post(
      path: "/send_content",
      data: {
        "date": DateTime.now().toString().split(" ").first,
        "content": content,
      },
    );
    if (response is APIException) {
      Fluttertoast.showToast(msg: "Error ${response.message}");
    }
    return response is! Exception;
  }

  Future<String?> motivateMeApi() async {
    var response = await _networkRequester.post(
      path: "/motivate_me",
      data: {},
    );
    if (response is APIException) {
      Fluttertoast.showToast(msg: "Error ${response.message}");
      return null;
    }
    return response.data["text"];
  }

  JournalModel? searchJournal(DateTime date) {
    for (var element in _journalList) {
      if (element.date.formattedText == date.formattedText) {
        return element;
      }
    }
    return null;
  }
}

List<Map<String, dynamic>> mockJournalData = [
  {
    "content": "Content: |\nWoke up feeling drained after a fun FIFA night.",
    "date": "2025-02-08",
    "emoji": "🤕",
    "mood": "Sadness",
    "title": "Overwhelmed by Reality"
  },
  {
    "content":
        "Content: | \nGrabbed a quick coffee and a granola bar to fuel my day.",
    "date": "2025-02-08",
    "emoji": "☕️",
    "mood": "Excitement",
    "title": "Coffee Fuelled"
  },
  {
    "content":
        "Content: |\nFelt the panic set in during OS lecture as I tried to absorb past quiz questions.",
    "date": "2025-02-07",
    "emoji": "😳",
    "mood": "Embarrassment",
    "title": "Panic Sets In"
  },
  {
    "content":
        "Content: | \nPlayed FIFA way longer than planned and had no regrets.",
    "date": "2025-02-07",
    "emoji": "😊",
    "mood": "Contentment",
    "title": "FIFA Victory"
  }
];
