import 'package:collection/collection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kraken/modules/events/model/event_model.dart';
import 'package:kraken/utils/network/exception_handler.dart';
import 'package:kraken/utils/network/network_requester.dart';
import 'package:rxdart/rxdart.dart';

class EventBloc {
  // EventBloc._() {
  //   loadData();
  // }
  //
  // factory EventBloc() => _instance ??= EventBloc._();
  //
  // static EventBloc? _instance;

  final BehaviorSubject<List<EventModel>> _eventSubject =
      BehaviorSubject<List<EventModel>>();

  Stream<List<EventModel>> get eventStream => _eventSubject.stream;

  final NetworkRequester _networkRequester = NetworkRequester.instance;

  List<EventModel> _eventList = [];

  Future<void> loadData() async {
    final result = await hitApi();
    if (result != null) {
      _eventList = result;
    } else {
      _eventList = [];
      for (Map<String, dynamic> e in mockEventData) {
        _eventList.add(EventModel.fromJson(e));
      }
    }
    _eventList.sortBy((element) => element.date);
    _eventSubject.sink.add(_eventList.reversed.toList());
  }

  Future<List<EventModel>?> hitApi() async {
    var response = await _networkRequester.post(path: "/events", data: {
      "current_timestamp": "2025-02-02 00:00:00",
    });
    if (response is! APIException) {
      List<EventModel> events = [];
      for (Map<String, dynamic> e in (response.data as List)) {
        events.add(EventModel.fromJson(e));
      }
      return events;
    }
    Fluttertoast.showToast(msg: "Error ${response.message}");
    return null;
  }
}

List<Map<String, dynamic>> mockEventData = [
  {
    "content": "OS exam reminder.",
    "date": "2025-02-07",
  },
  {
    "content": "FIFA night is happening today.",
    "date": "2025-02-07",
  },
  {
    "content": "Group project meeting.",
    "date": "2025-02-08",
  },
  {
    "content": "Networking lecture.",
    "date": "2025-02-08",
  }
];
