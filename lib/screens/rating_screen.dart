import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:only_vocal/resources/user_provider.dart';
import 'package:provider/provider.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int _rating = 0;
  final TextEditingController _reviewController = TextEditingController();
  bool _isSubmitting = false;

//   void _submitReview() async {
//   if (_rating == 0 || _reviewController.text.trim().isEmpty) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Please provide both rating and review")),
//     );
//     return;
//   }

//   setState(() => _isSubmitting = true);

//   try {
//     final customUser = Provider.of<UserProvider>(context, listen: false).getUser;

//     if (customUser == null) {
//       throw Exception("User data not loaded");
//     }

//     // Update rating and review in the existing user's Firestore document
//     await FirebaseFirestore.instance.collection('users').doc(customUser.uid).update({
//       'rating': _rating.toString(),
//       'review': _reviewController.text.trim(),
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Thank you for your feedback!")),
//     );

//     setState(() {
//       _rating = 0;
//       _reviewController.clear();
//     });

//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Error: ${e.toString()}")),
//     );
//   } finally {
//     setState(() => _isSubmitting = false);
//   }
// }

void _submitReview() async {
  if (_rating == 0 && _reviewController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please provide at least a rating or a review")),
    );
    return;
  }

  setState(() => _isSubmitting = true);

  try {
    final customUser = Provider.of<UserProvider>(context, listen: false).getUser;

    if (customUser == null) {
      throw Exception("User data not loaded");
    }

    // Prepare update map with only non-empty fields
    Map<String, dynamic> updateData = {};
    if (_rating != 0) updateData['rating'] = _rating.toString();
    if (_reviewController.text.trim().isNotEmpty) {
      updateData['review'] = _reviewController.text.trim();
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(customUser.uid)
        .update(updateData);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Thank you for your feedback!")),
    );

    setState(() {
      _rating = 0;
      _reviewController.clear();
    });

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: ${e.toString()}")),
    );
  } finally {
    setState(() => _isSubmitting = false);
  }
}


  Widget _buildStar(int index) {
    return IconButton(
      icon: Icon(
        index <= _rating ? Icons.star : Icons.star_border,
        color: Colors.amber,
        size: 36,
      ),
      onPressed: () {
        setState(() => _rating = index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rate Us"),
          titleTextStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Optional: ensures it's visible on dark backgrounds
          ),
        backgroundColor: const Color(0xFF1A1E3F),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
                          const Text(
                "How was your experience?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height:20),
              const Text(
                'Yor experience helps us grow better. Feel free to leave as many reviews as you want.',
                textAlign: TextAlign.center,
                style:TextStyle(fontSize: 16, fontWeight: FontWeight.w500)
                ),
        
        
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) => _buildStar(index + 1)),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _reviewController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Write your review...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitReview,
                child: _isSubmitting
                    ? const CircularProgressIndicator()
                    : const Text("Submit",
                    style:TextStyle(fontWeight: FontWeight.w800)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
