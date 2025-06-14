import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

import 'package:main/student/view_evaluation.dart';

class ViewSubmitGradedScreen extends StatefulWidget {
  final Map<String, dynamic> submission;

  const ViewSubmitGradedScreen({Key? key, required this.submission})
      : super(key: key);

  @override
  _ViewSubmitGradedScreenState createState() => _ViewSubmitGradedScreenState();
}

class _ViewSubmitGradedScreenState extends State<ViewSubmitGradedScreen> {
  late String fileName;

  @override
  void initState() {
    super.initState();
    extractFileName();
  }

  void extractFileName() {
    final content = widget.submission['content'];
    if (content != null && content.startsWith('http')) {
      final uri = Uri.parse(content);
      fileName = uri.pathSegments.last;
    } else {
      fileName = 'No file uploaded';
    }
  }

  void _downloadFile(String? fileData) async {
    // Check if file data is available
    if (fileData != null) {
      try {
        Uint8List bytes = base64Decode(fileData);

        String fileName = 'downloaded_file';

        print('Downloading file: $fileName');

        // Create a new file to save the downloaded data
        // You can use path_provider package to get the appropriate directory for saving files
        // Here, we're just printing the file data
        print('File Data: $bytes');
      } catch (e) {
        // Handle error
        print('Error downloading file: $e');
      }
    } else {
      // Handle case when no file data is available
      print('No file available for download');
    }
  }

  @override
  Widget build(BuildContext context) {
    final submission = widget.submission;
    return Scaffold(
      backgroundColor: const Color(0xFFEDECEC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEDECEC),
        toolbarHeight: 100,
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 150.0),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(10, 0, 33, 12),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Due ${submission['due_date']} ${submission['due_time']}',
                    style: GoogleFonts.getFont(
                      'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: const Color(0xFF383838),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 33, 12),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    submission['title'],
                    style: GoogleFonts.getFont(
                      'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      color: const Color(0xFF0187F1),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(15, 0, 15, 70),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFFFFFFFF),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x40000000),
                      offset: Offset(0, 4),
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 22, 33, 27),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 22),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Instructions:',
                            style: GoogleFonts.getFont(
                              'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: const Color(0xFF383838),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(11, 0, 0, 16),
                        child: Text(
                          widget.submission['description'] ??
                              'No description...',
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.getFont(
                            'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            letterSpacing: -0.2,
                            color: const Color(0xFF000000),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(30.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Work',
                  style: GoogleFonts.getFont(
                    'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    color: const Color(0xFF383838),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EvaluationPage()),
                    );
                  },
                  child: Text(
                    'View Score',
                    style: GoogleFonts.getFont(
                      'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      letterSpacing: -0.3,
                      color: const Color(0xFF000000),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
              child: submission['type'] == 'file'
                  ? const Text('Get_Started_With_Smallpdf.pdf')
                  : Text(submission['content']),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        var response = await http.post(
                          Uri.parse(
                              'http://localhost/college_poc/delete_submission.php'),
                          body: {
                            'task_id': widget.submission['task_id'].toString(),
                          },
                        );

                        if (response.statusCode == 200) {
                          Navigator.of(context).pop();
                        } else {
                          throw Exception('Failed to delete submission');
                        }
                      } catch (e) {
                        print('Error: $e');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      side:
                          const BorderSide(color: Color(0xff0187f1), width: 2),
                      backgroundColor: const Color(0xFFFFFFFF),
                      disabledBackgroundColor: const Color(0xFFFFFFFF),
                      foregroundColor: const Color(0xff0187f1),
                    ),
                    child: const Text('Unsubmit'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }
}
