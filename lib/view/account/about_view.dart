import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../../common/color_extension.dart';
import 'dart:convert';
import '../../common/app_constants.dart';

class AboutView extends StatefulWidget {
  const AboutView({super.key});

  @override
  _AboutViewState createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
  String content = '';
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchAboutPage();
  }

  Future<void> _fetchAboutPage() async {
    final url = '${AppConstants.baseUrl}/about-page';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          content = data['data']['content'];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load about page.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: TColor.primaryText),
        ),
        centerTitle: true,
        title: Text(
          "About Us",
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage))
                : SingleChildScrollView(
                    child: content.contains('<') && content.contains('>')
                        ? HtmlWidget(content)
                        : Text(
                            content,
                            style: TextStyle(
                              fontSize: 16,
                              color: TColor.secondaryText,
                              height: 1.5,
                            ),
                          ),
                  ),
      ),
    );
  }
}
