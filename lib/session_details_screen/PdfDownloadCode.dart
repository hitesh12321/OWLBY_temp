import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:owlby_serene_m_i_n_d_s/record_feature/models/recording_model.dart';
import 'package:intl/intl.dart';

class PdfService {
  static Future<void> generateAndDownloadPdf(RecordingModel recording) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => [
          pw.Header(
            level: 0,
            child: pw.Text("Session Report: ${recording.title}",
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Paragraph(
              text:
                  "Date: ${DateFormat('yyyy-MM-dd').format(recording.createdAt)}"),
          pw.Paragraph(
              text: "Time: ${DateFormat('HH:mm').format(recording.createdAt)}"),
          pw.SizedBox(height: 20),
          pw.Text("Summary",
              style:
                  pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.Divider(),
          pw.Paragraph(text: recording.summary ?? "No summary available."),
          pw.SizedBox(height: 20),
          pw.Text("SOAP Notes",
              style:
                  pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.Divider(),
          pw.Paragraph(text: recording.notes ?? "No notes available."),
          pw.SizedBox(height: 20),
          pw.Text("Tips & Recommendations",
              style:
                  pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.Divider(),
          pw.Paragraph(text: recording.tips ?? "No tips available."),
        ],
      ),
    );

    // This opens the share/save dialog on mobile
    await Printing.sharePdf(
        bytes: await pdf.save(), filename: '${recording.title}_report.pdf');
  }
}
