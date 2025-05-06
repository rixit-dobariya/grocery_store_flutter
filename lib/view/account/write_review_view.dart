import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import '../../common/color_extension.dart';
import '../../common_widget/round_button.dart';

class WriteReviewView extends StatefulWidget {
  final Future<void> Function(double, String)
      didSubmit; // Make this return Future
  const WriteReviewView({super.key, required this.didSubmit});

  @override
  State<WriteReviewView> createState() => _WriteReviewViewState();
}

class _WriteReviewViewState extends State<WriteReviewView> {
  double ratingVal = 5.0;
  TextEditingController txtMessage = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.3),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(color: Colors.black26, blurRadius: 10),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title and close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40),
                  Text(
                    "Write A Review",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (!isLoading) Navigator.pop(context);
                    },
                    icon: Icon(Icons.cancel, color: TColor.primary, size: 28),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // Rating bar
              RatingBar.builder(
                initialRating: ratingVal,
                minRating: 1,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: context.width * 0.10,
                itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rate) {
                  setState(() {
                    ratingVal = rate;
                  });
                },
              ),
              const SizedBox(height: 15),

              // Review text
              TextField(
                controller: txtMessage,
                maxLines: 5,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  hintText: "Write a review...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16.0),
                ),
                style: TextStyle(color: TColor.primaryText),
              ),
              const SizedBox(height: 20),

              // Submit button or loading indicator
              isLoading
                  ? const CircularProgressIndicator()
                  : RoundButton(
                      title: "Submit",
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });

                        await widget.didSubmit(
                          ratingVal,
                          txtMessage.text.trim(),
                        );

                        if (mounted) {
                          Navigator.pop(context);
                        }
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
