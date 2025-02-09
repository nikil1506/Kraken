import 'package:extended_markdown_viewer/extended_markdown_viewer.dart';
import 'package:kraken/config.dart';
import 'package:kraken/modules/journal/model/journal_model.dart';

class ContentPage extends StatelessWidget {
  const ContentPage({
    super.key,
    required this.journal,
  });

  final JournalModel journal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(journal.title),
        centerTitle: true,
        backgroundColor: context.colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: ExtendedMarkDownViewer(
          markdownText: journal.content,
          isExpandable: true,
          maxCollapsedLength: null,
        ),
      ),
    );
  }
}
