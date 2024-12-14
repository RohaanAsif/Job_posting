import 'package:cloud_firestore/cloud_firestore.dart';

class Job {
  final String uid;
  final String title;
  final String description;
  final String salary;
  final Timestamp lastDate;
  final String imageUrl;
  final String applyLink;

  Job({
    required this.uid,
    required this.title,
    required this.description,
    required this.salary,
    required this.lastDate,
    required this.imageUrl,
    required this.applyLink,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      uid: json['uid'],
      title: json['title'],
      description: json['description'],
      salary: json['salary'],
      lastDate: json['lastDate'] as Timestamp,
      imageUrl: json['imageUrl'],
      applyLink: json['applyLink'] ?? '',
    );
  }
}
