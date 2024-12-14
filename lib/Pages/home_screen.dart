import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_posting/Compoentns/my_drawer.dart';
import 'package:job_posting/Compoentns/my_job_tile.dart';
import 'package:job_posting/Model/job.dart';
import 'package:job_posting/Pages/job_details_page.dart';
import 'package:job_posting/Pages/new_job_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  final auth = FirebaseAuth.instance;
  final jobsCollection = FirebaseFirestore.instance.collection('jobs');

  List<Job> jobs = [];

  Stream<List<Job>> getJobsFromFirebase() {
    try {
      return jobsCollection
          .orderBy('lastDate', descending: false)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => Job.fromJson(doc.data())).toList();
      });
    } catch (e) {
      throw Exception("Error fetching jobs $e");
    }
  }

  @override
  void initState() {
    final jobsStream = getJobsFromFirebase();
    jobsStream.listen((allJobs) {
      setState(() {
        jobs = allJobs;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Jobs'),
        foregroundColor: Theme.of(context).colorScheme.tertiary,
        centerTitle: true,
      ),
      drawer: const MyDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              return MyJobTile(
                job: jobs[index],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JobDetailsPage(
                        job: jobs[index],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).colorScheme.tertiary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewJobPage(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          size: 32,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
