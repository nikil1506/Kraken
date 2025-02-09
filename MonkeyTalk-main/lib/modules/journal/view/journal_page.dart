import 'package:auto_animated/auto_animated.dart';
import 'package:kraken/config.dart';
import 'package:kraken/modules/events/view/events_page.dart';
import 'package:kraken/modules/journal/bloc/journal_bloc.dart';
import 'package:kraken/modules/journal/model/journal_model.dart';
import 'package:kraken/modules/journal/view/content_page.dart';
import 'package:kraken/modules/journal/bloc/speech_manager.dart';
import 'package:kraken/utils/network/network_requester.dart';
import 'package:kraken/utils/widgets/alert_dialog.dart';
import 'package:kraken/utils/widgets/image_widget.dart';
import 'package:kraken/utils/widgets/loading_widget.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final JournalBloc _bloc = JournalBloc();
  final speechManager = SpeechToTextManager();

  String? content;

  @override
  void initState() {
    super.initState();
    _bloc.loadData();
  }

  @override
  void dispose() {
    super.dispose();
    speechManager.dispose();
  }

  void stopService() {
    speechManager.stop();
  }

  void startService() {
    content = null;
    setState(() {});
    speechManager.run(
      onResult: (String content) {
        this.content = content;
        setState(() {});
      },
      onFailure: (error) {
        print(error);
      },
      onComplete: () {
        if (content != null && content!.trim().isNotEmpty) {
          _sendContent();
        } else {
          Future.delayed(
            const Duration(seconds: 1),
            () {
              content = null;
              setState(() {});
            },
          );
        }
      },
    );
  }

  void _sendContent() async {
    await _bloc.hitRecordingContentApi(content!);
    await _bloc.loadData();
    content = null;
    setState(() {});
  }

  void _changeUrl() async {
    String? userInput = await showUrlDialog(context);
    if (userInput != null) {
      tempBaseUrl = userInput.trim();
      NetworkRequester.instance.prepareRequest();
    } else {
      tempBaseUrl = null;
      NetworkRequester.instance.prepareRequest();
    }
  }

  bool _motivateLoader = false;

  void _motivateMe() async {
    setState(() => _motivateLoader = true);
    final result = await _bloc.motivateMeApi();
    if (result != null && mounted) {
      showDelightToast(context, result);
    }
    setState(() => _motivateLoader = false);
  }

  @override
  Widget build(BuildContext context) {
    final options = LiveOptions(visibleFraction: 0.05);
    return RefreshIndicator(
      onRefresh: _bloc.loadData,
      child: Scaffold(
        appBar: AppBar(
          title: Text("MonkeyTalk"),
          centerTitle: true,
          backgroundColor: context.colorScheme.primaryContainer,
          leading: IconButton(
            onPressed: _changeUrl,
            icon: Transform.rotate(
              angle: 100,
              child: ImageWidget(
                label: "wizard1.png",
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            if (_motivateLoader) LoadingWidget(),
            Expanded(
              child: Stack(
                children: [
                  StreamBuilder<List<JournalModel>>(
                    stream: _bloc.journalStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [LoadingWidget()],
                        );
                      }
                      return LiveGrid.options(
                        options: options,
                        padding: EdgeInsets.only(
                            top: 10, bottom: 120, right: 10, left: 10),
                        itemCount: snapshot.data!.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                        ),
                        itemBuilder: (context, index, animation) {
                          final journal = snapshot.data![index];
                          return FadeTransition(
                            opacity: Tween<double>(
                              begin: 0,
                              end: 1,
                            ).animate(animation),
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: Offset(0, -0.1),
                                end: Offset.zero,
                              ).animate(animation),
                              child: GestureDetector(
                                onTap: () {
                                  context.push(ContentPage(journal: journal));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: context.colorScheme.surfaceContainer,
                                  ),
                                  child: Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            journal.date.formattedText,
                                            style: context.textTheme.bodySmall!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Text(
                                                journal.title,
                                                textAlign: TextAlign.left,
                                                style: context
                                                    .textTheme.titleLarge!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.normal),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        journal.emote,
                                        style: context.textTheme.displaySmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: FloatingActionButton.small(
                        heroTag: '1',
                        onPressed: () {
                          context.push(EventsPage());
                        },
                        child: ImageWidget(
                          label: "potion.png",
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: FloatingActionButton.small(
                        heroTag: '2',
                        onPressed: _motivateMe,
                        child: ImageWidget(
                          label: "spellbook.png",
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: speechManager.speechState,
                    builder: (context, value, child) {
                      if (!value && content == null) {
                        return SizedBox();
                      }
                      return Container(
                        color:
                            context.colorScheme.surface.withValues(alpha: 0.9),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: LinearProgressIndicator(
                                backgroundColor: Colors.transparent,
                                value: !value && content == null ? 0 : null,
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  content ?? '',
                                  textAlign: TextAlign.center,
                                  style: context.textTheme.titleLarge,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: ValueListenableBuilder<bool>(
          valueListenable: speechManager.speechState,
          builder: (context, value, child) {
            return FloatingActionButton.large(
              heroTag: 'voice',
              backgroundColor: context.colorScheme.tertiaryContainer,
              onPressed: !value ? startService : stopService,
              child: !value
                  ? ImageWidget(label: "crystal.png", size: 50)
                  : Icon(Icons.pause),
            );
          },
        ),
      ),
    );
  }
}
