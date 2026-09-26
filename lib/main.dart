import 'dart:typed_data';
import 'package:flutter/foundation.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const SolutionHubApp());

const Color primary = Color(0xFF6046C9);
const Color primaryLight = Color(0xFFF0ECFF);
const Color background = Color(0xFFF7F7FB);
const Color textDark = Color(0xFF202124);
const Color textGrey = Color(0xFF6B7280);
const Color green = Color(0xFF15966B);
const Color red = Color(0xFFD64545);
const Color orange = Color(0xFFD98A16);

// ============================================================
// DATA
// ============================================================

class StakeholderAccount {
  String name;
  String email;
  String password;
  String role;
  String organization;

  StakeholderAccount({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.organization,
  });
}

class UniversityProject {
  final String university;
  String teamName;
  List<String> members;
  String solution;
  Uint8List? solutionPdfBytes;
  String solutionPdfName;
  int progress;
  String industrySupport;
  bool industryAccepted;
  bool governmentCollaborating;
  bool governmentAccepted;
  bool published;
  String prototypeDescription;
  List<Uint8List> prototypeImages;
  List<String> prototypeImageNames;
  Uint8List? prototypeVideoBytes;
  String prototypeVideoName;
  String prototypeVideoPath;
  Uint8List? prototypePdfBytes;
  String prototypePdfName;
  bool prototypeSubmitted;
  bool governmentPrototypeApproved;
  String industryPrototypeDescription;
  List<Uint8List> industryPrototypeImages;
  List<String> industryPrototypeImageNames;
  Uint8List? industryPrototypeVideoBytes;
  String industryPrototypeVideoName;
  String industryPrototypeVideoPath;
  final DateTime createdAt;
  List<String> tasks;

  UniversityProject({
    required this.university,
    this.teamName = '',
    List<String>? members,
    this.solution = '',
    this.solutionPdfBytes,
    this.solutionPdfName = '',
    this.progress = 0,
    this.industrySupport = 'Not selected',
    this.industryAccepted = false,
    this.governmentCollaborating = false,
    this.governmentAccepted = false,
    this.published = false,
    this.prototypeDescription = '',
    List<Uint8List>? prototypeImages,
    List<String>? prototypeImageNames,
    this.prototypeVideoBytes,
    this.prototypeVideoName = '',
    this.prototypeVideoPath = '',
    this.prototypePdfBytes,
    this.prototypePdfName = '',
    this.prototypeSubmitted = false,
    this.governmentPrototypeApproved = false,
    this.industryPrototypeDescription = '',
    List<Uint8List>? industryPrototypeImages,
    List<String>? industryPrototypeImageNames,
    this.industryPrototypeVideoBytes,
    this.industryPrototypeVideoName = '',
    this.industryPrototypeVideoPath = '',
    DateTime? createdAt,
    List<String>? tasks,
  })  : members = members ?? [],
        prototypeImages = prototypeImages ?? [],
        prototypeImageNames = prototypeImageNames ?? [],
        industryPrototypeImages = industryPrototypeImages ?? [],
        industryPrototypeImageNames = industryPrototypeImageNames ?? [],
        createdAt = createdAt ?? DateTime.now(),
        tasks = tasks ?? [
          'Problem selected',
          'Team formed',
          'Solution submitted',
          'Prototype / testing',
          'Industry support',
          'Government review',
          'Public impact',
        ];

  bool get hasSolution => solution.trim().isNotEmpty || solutionPdfBytes != null;
  bool get hasPrototype => prototypeDescription.trim().isNotEmpty || prototypeImages.isNotEmpty || prototypeVideoBytes != null;
  bool get hasIndustryPrototype => industryPrototypeDescription.trim().isNotEmpty || industryPrototypeImages.isNotEmpty || industryPrototypeVideoBytes != null;
  bool get readyForGovernmentApproval => hasSolution && solutionPdfBytes != null && hasPrototype;
  bool get readyForPublication => readyForGovernmentApproval && governmentPrototypeApproved;
}

class Problem {
  final String id;
  final String title;
  final String description;
  final String location;
  final String domain;
  final String priority;
  final int matching;
  final DateTime createdAt;
  final List<UniversityProject> projects;
  final Uint8List? imageBytes;
  final String imageName;
  final List<Uint8List> imageGallery;
  final List<String> imageNames;
  final Uint8List? videoBytes;
  final String videoName;
  final String videoPath;
  bool governmentProblemApproved;

  Problem({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.domain,
    required this.priority,
    required this.matching,
    this.imageBytes,
    this.imageName = '',
    List<Uint8List>? imageGallery,
    List<String>? imageNames,
    this.videoBytes,
    this.videoName = '',
    this.videoPath = '',
    this.governmentProblemApproved = false,
    DateTime? createdAt,
    List<UniversityProject>? projects,
  })  : imageGallery = imageGallery ?? (imageBytes != null ? [imageBytes] : []),
        imageNames = imageNames ?? (imageName.isNotEmpty ? [imageName] : []),
        createdAt = createdAt ?? DateTime.now(),
        projects = projects ?? [];

  bool get isNew => DateTime.now().difference(createdAt).inDays <= 7;

  bool get isPublished => projects.any((p) => p.published);
  bool get hasCitizenEvidence => imageGallery.isNotEmpty || videoBytes != null;

  bool selectedBy(String university) =>
      projects.any((p) => p.university == university);

  UniversityProject? projectFor(String university) {
    for (final project in projects) {
      if (project.university == university) return project;
    }
    return null;
  }

  String get overallStatus {
    if (isPublished) return 'Published';
    if (projects.any((p) => p.governmentAccepted)) return 'Government Accepted';
    if (projects.any((p) => p.governmentCollaborating)) return 'Government Collaboration';
    if (projects.any((p) => p.industryAccepted)) return 'Industry Supported';
    if (projects.isNotEmpty) return 'University Selected';
    return 'Open';
  }
}

final List<Problem> appProblems = [
  Problem(
    id: 'P001',
    title: 'Waterlogging near village homes',
    description:
        'During rainfall, dirty water collects near houses and causes mosquito problems. The village does not have proper drainage.',
    location: 'Khunti, Jharkhand',
    domain: 'Water & Sanitation',
    priority: 'HIGH',
    matching: 94,
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    projects: [
      UniversityProject(
        university: 'University Research Centre',
        teamName: 'AquaShield Team',
        members: ['Aarav Kumar — Team Lead', 'Priya Singh — IoT', 'Rahul Das — Civil', 'Ananya Rao — AI/ML'],
        solution: 'Low-cost IoT water-level monitoring and drainage alert system.',
        solutionPdfName: 'aquashield_solution.pdf',
        progress: 65,
        industrySupport: 'WaterTech Solutions',
        industryAccepted: true,
        governmentCollaborating: true,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      UniversityProject(
        university: 'Technology Innovation University',
        teamName: 'DrainSmart',
        members: ['Neha Rao — Lead', 'Vikram Das — IoT'],
        solution: 'Smart drainage sensors with a community alert dashboard.',
        progress: 35,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ],
  ),
  Problem(
    id: 'P002',
    title: 'Smart crop monitoring',
    description:
        'Small farmers need an affordable way to monitor crop health, soil conditions and irrigation.',
    location: 'Ranchi, Jharkhand',
    domain: 'Agriculture',
    priority: 'MEDIUM',
    matching: 88,
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
    projects: [
      UniversityProject(
        university: 'Agriculture Innovation University',
        teamName: 'AgriVision',
        members: ['Sneha Patel — Lead', 'Ravi Kumar — Agriculture', 'Meera Shah — AI'],
        solution: 'AI crop monitoring with soil sensors and a mobile advisory system.',
        progress: 42,
        industrySupport: 'AgriTech India',
        industryAccepted: true,
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
    ],
  ),
  Problem(
    id: 'P003',
    title: 'Rural healthcare access',
    description:
        'Residents in remote areas face difficulties accessing basic healthcare information and services.',
    location: 'Hazaribagh, Jharkhand',
    domain: 'Healthcare',
    priority: 'HIGH',
    matching: 91,
    createdAt: DateTime.now().subtract(const Duration(days: 10)),
  ),
  Problem(
    id: 'P004',
    title: 'Waste collection improvement',
    description:
        'Several neighbourhoods do not have reliable waste collection schedules.',
    location: 'Jamshedpur, Jharkhand',
    domain: 'Sanitation',
    priority: 'MEDIUM',
    matching: 79,
    createdAt: DateTime.now().subtract(const Duration(days: 15)),
  ),
];

final List<StakeholderAccount> accounts = [
  StakeholderAccount(name: 'Demo Citizen', email: 'citizen@demo.com', password: '1234', role: 'Citizen', organization: 'Citizen'),
  StakeholderAccount(name: 'Demo University', email: 'university@demo.com', password: '1234', role: 'University', organization: 'University Research Centre'),
  StakeholderAccount(name: 'Demo Industry', email: 'industry@demo.com', password: '1234', role: 'Industry', organization: 'WaterTech Solutions'),
  StakeholderAccount(name: 'Demo Government', email: 'government@demo.com', password: '1234', role: 'Government', organization: 'Government of Jharkhand'),
];

final List<String> universities = [
  'University Research Centre',
  'Agriculture Innovation University',
  'Health Technology University',
  'Technology Innovation University',
];

// ============================================================
// APP
// ============================================================

class SolutionHubApp extends StatelessWidget {
  const SolutionHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SolutionHub',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: background,
        colorScheme: ColorScheme.fromSeed(seedColor: primary),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}

// ============================================================
// WELCOME
// ============================================================

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _openLogin(BuildContext context, String role) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen(role: role)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF4F0FF), Color(0xFFF8FAFF), Color(0xFFF4FFF9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: Column(
                  children: [
                    Container(
                      height: 76,
                      width: 76,
                      decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(23)),
                      child: const Icon(Icons.hub_rounded, color: Colors.white, size: 42),
                    ),
                    const SizedBox(height: 18),
                    const Text('SolutionHub', style: TextStyle(fontSize: 38, fontWeight: FontWeight.w800)),
                    const Text('Turn Problems Into Impact', style: TextStyle(fontSize: 17, color: textGrey)),
                    const SizedBox(height: 32),
                    Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        image: const DecorationImage(
                          image: NetworkImage('https://images.unsplash.com/photo-1531482615713-2afd69097998?w=1000'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: Colors.black.withValues(alpha: .35)),
                        padding: const EdgeInsets.all(25),
                        alignment: Alignment.bottomLeft,
                        child: const Text('One ecosystem.\nReal problems. Real solutions.', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text('Choose your portal', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('Citizen → University → Industry → Government → Impact', textAlign: TextAlign.center, style: TextStyle(color: textGrey)),
                    const SizedBox(height: 22),
                    _PortalCard(icon: Icons.person_rounded, title: 'Citizen', subtitle: 'Post and track community problems', onTap: () => _openLogin(context, 'Citizen')),
                    _PortalCard(icon: Icons.school_rounded, title: 'University', subtitle: 'Select challenges and build solutions', onTap: () => _openLogin(context, 'University')),
                    _PortalCard(icon: Icons.business_rounded, title: 'Industry', subtitle: 'Review solutions and collaborate', onTap: () => _openLogin(context, 'Industry')),
                    _PortalCard(icon: Icons.account_balance_rounded, title: 'Government', subtitle: 'Monitor, collaborate and publish impact', onTap: () => _openLogin(context, 'Government')),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PortalCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _PortalCard({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200)),
          child: Row(
            children: [
              Container(height: 54, width: 54, decoration: BoxDecoration(color: primaryLight, borderRadius: BorderRadius.circular(16)), child: Icon(icon, color: primary, size: 28)),
              const SizedBox(width: 15),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text(subtitle, style: const TextStyle(color: textGrey, fontSize: 13))])),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// LOGIN + SIGNUP
// ============================================================

class LoginScreen extends StatefulWidget {
  final String role;
  const LoginScreen({super.key, required this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool obscure = true;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void login() {
    final e = email.text.trim().toLowerCase();
    final p = password.text;
    if (e.isEmpty || p.isEmpty) {
      _snack(context, 'Please enter your login details.');
      return;
    }

    final matchingAccount = accounts.where((a) => a.email.toLowerCase() == e && a.role == widget.role).toList();
    final account = matchingAccount.isNotEmpty
        ? matchingAccount.first
        : StakeholderAccount(
            name: e.split('@').first,
            email: e,
            password: p,
            role: widget.role,
            organization: widget.role == 'University'
                ? 'Demo University'
                : widget.role == 'Industry'
                    ? 'Demo Industry'
                    : widget.role == 'Government'
                        ? 'Government Portal'
                        : 'Citizen',
          );
    Widget page;
    switch (widget.role) {
      case 'Citizen':
        page = const CitizenDashboard();
        break;
      case 'University':
        page = UniversityDashboard(university: account.organization);
        break;
      case 'Industry':
        page = IndustryDashboard(industry: account.organization);
        break;
      default:
        page = const GovernmentDashboard();
    }

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .06), blurRadius: 25)]),
            child: Column(
              children: [
                Container(height: 65, width: 65, decoration: BoxDecoration(color: primaryLight, borderRadius: BorderRadius.circular(19)), child: Icon(_roleIcon(widget.role), color: primary, size: 33)),
                const SizedBox(height: 18),
                Text('${widget.role} Login', style: const TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(widget.role == 'Citizen' ? 'Share what your community needs.' : 'Secure stakeholder access', textAlign: TextAlign.center, style: const TextStyle(color: textGrey)),
                const SizedBox(height: 25),
                TextField(controller: email, decoration: InputDecoration(labelText: widget.role == 'University' ? 'University ID / Email' : 'Email / ID', prefixIcon: const Icon(Icons.person_outline))),
                const SizedBox(height: 15),
                TextField(controller: password, obscureText: obscure, decoration: InputDecoration(labelText: 'Password', prefixIcon: const Icon(Icons.lock_outline), suffixIcon: IconButton(onPressed: () => setState(() => obscure = !obscure), icon: Icon(obscure ? Icons.visibility_off : Icons.visibility)))),
                const SizedBox(height: 20),
                SizedBox(width: double.infinity, height: 54, child: ElevatedButton(onPressed: login, style: ElevatedButton.styleFrom(backgroundColor: primary, foregroundColor: Colors.white), child: Text('Login as ${widget.role}'))),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// CITIZEN
// ============================================================

class CitizenDashboard extends StatefulWidget {
  const CitizenDashboard({super.key});

  @override
  State<CitizenDashboard> createState() => _CitizenDashboardState();
}

class _CitizenDashboardState extends State<CitizenDashboard> {
  @override
  Widget build(BuildContext context) {
    final latest = [...appProblems]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return _Layout(title: 'Citizen Portal', icon: Icons.person, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _Hero(title: 'Your voice can start a solution.', subtitle: 'Post any genuine community problem and track what universities, industry and government do with it.', button: 'Report a Problem', onTap: () async { await Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportProblemScreen())); setState(() {}); }),
      const SizedBox(height: 24),
      Row(children: [Expanded(child: _Metric(number: '${appProblems.length}', title: 'Problems Posted', icon: Icons.report_problem_outlined)), const SizedBox(width: 12), Expanded(child: _Metric(number: '${appProblems.where((p) => p.projects.isNotEmpty).length}', title: 'Taken Up', icon: Icons.autorenew)), const SizedBox(width: 12), Expanded(child: _Metric(number: '${appProblems.where((p) => p.isPublished).length}', title: 'Published', icon: Icons.public))]),
      const SizedBox(height: 28),
      const Text('Recent Updated Problems', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      ...latest.take(4).map((p) => _ProblemCard(problem: p, showActions: true)),
      const SizedBox(height: 20),
      const Text('Problem History', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      const Text('Previous problems remain available as a reference for future solutions.', style: TextStyle(color: textGrey)),
      const SizedBox(height: 12),
      ...latest.skip(4).map((p) => _ProblemCard(problem: p, compact: true)),
      if (latest.length <= 4) _Empty(text: 'Older problem history will appear here as new problems are submitted.'),
    ]));
  }
}

class ReportProblemScreen extends StatefulWidget {
  const ReportProblemScreen({super.key});

  @override
  State<ReportProblemScreen> createState() => _ReportProblemScreenState();
}

class _ReportProblemScreenState extends State<ReportProblemScreen> {
  final picker = ImagePicker();
  final title = TextEditingController();
  final description = TextEditingController();
  List<Uint8List> imageGallery = [];
  List<String> imageNames = [];
  Uint8List? videoBytes;
  String videoName = '';
  String videoPath = '';
  String location = 'Hyderabad, Telangana, India';

  @override
  void dispose() {
    title.dispose();
    description.dispose();
    super.dispose();
  }

  Future<void> selectImages() async {
    try {
      final selected = await picker.pickMultiImage(imageQuality: 85);
      if (selected.isEmpty) return;
      final bytesList = <Uint8List>[];
      final names = <String>[];
      for (final file in selected) {
        bytesList.add(await file.readAsBytes());
        names.add(file.name);
      }
      if (!mounted) return;
      setState(() {
        imageGallery = [...imageGallery, ...bytesList];
        imageNames = [...imageNames, ...names];
      });
    } catch (_) {
      if (mounted) _snack(context, 'Image selection failed.');
    }
  }

  Future<void> selectVideo() async {
    try {
      final selected = await picker.pickVideo(source: ImageSource.gallery);
      if (selected != null) {
        final bytes = await selected.readAsBytes();
        if (!mounted) return;
        setState(() {
          videoBytes = bytes;
          videoName = selected.name;
          videoPath = selected.path;
        });
      }
    } catch (_) {
      if (mounted) _snack(context, 'Video selection failed.');
    }
  }

  void analyzeAndSubmit() {
    final t = title.text.trim();
    final d = description.text.trim();
    if (t.isEmpty || d.isEmpty) {
      _snack(context, 'Please enter the problem and description.');
      return;
    }

    final text = '$t $d'.toLowerCase();
    String domain = 'Community Infrastructure';
    String priority = 'MEDIUM';
    if (text.contains('water') || text.contains('drain') || text.contains('waste') || text.contains('sanitation')) {
      domain = 'Water & Sanitation'; priority = 'HIGH';
    } else if (text.contains('farm') || text.contains('crop') || text.contains('soil') || text.contains('agriculture')) {
      domain = 'Agriculture'; priority = 'HIGH';
    } else if (text.contains('health') || text.contains('hospital') || text.contains('doctor') || text.contains('medical')) {
      domain = 'Healthcare'; priority = 'HIGH';
    } else if (text.contains('school') || text.contains('education') || text.contains('student')) {
      domain = 'Education'; priority = 'MEDIUM';
    }

    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Row(children: [Icon(Icons.auto_awesome, color: primary), SizedBox(width: 10), Text('AI Problem Analysis')]),
      content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        _AIItem(label: 'Problem', value: t),
        _AIItem(label: 'Domain', value: domain),
        _AIItem(label: 'Priority', value: priority, important: true),
        _AIItem(label: 'Location', value: location),
        _AIItem(label: 'Photos', value: imageGallery.isNotEmpty ? '${imageGallery.length} photo(s) attached' : 'Not attached'),
        _AIItem(label: 'Video', value: videoBytes != null ? 'Attached — $videoName' : 'Not attached'),
        const SizedBox(height: 8),
        const Text('This evidence and location will remain attached to the problem and can be reviewed by citizens, universities, industry and government.', style: TextStyle(color: textGrey, height: 1.4)),
      ])),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(onPressed: () {
          appProblems.insert(0, Problem(
            id: 'P${DateTime.now().millisecondsSinceEpoch}',
            title: t,
            description: d,
            location: location,
            domain: domain,
            priority: priority,
            matching: 80 + (DateTime.now().millisecond % 19),
            imageBytes: imageGallery.isNotEmpty ? imageGallery.first : null,
            imageName: imageNames.isNotEmpty ? imageNames.first : '',
            imageGallery: imageGallery,
            imageNames: imageNames,
            videoBytes: videoBytes,
            videoName: videoName,
            videoPath: videoPath,
          ));
          Navigator.pop(context);
          _snack(context, 'Problem submitted successfully. Evidence is now visible to all stakeholder portals.');
          Navigator.pop(context);
        }, child: const Text('Submit Problem')),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report a Problem', style: TextStyle(fontWeight: FontWeight.bold))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 760), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('What problem are you facing?', style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
          const SizedBox(height: 7),
          const Text('Post any genuine community or societal problem. Add evidence and an India-wide location.', style: TextStyle(color: textGrey)),
          const SizedBox(height: 25),
          const _Label(icon: Icons.title, text: 'Problem'), const SizedBox(height: 8),
          TextField(controller: title, decoration: const InputDecoration(hintText: 'Example: No proper drainage in our village')),
          const SizedBox(height: 20),
          const _Label(icon: Icons.description_outlined, text: 'Description'), const SizedBox(height: 8),
          TextField(controller: description, maxLines: 6, decoration: const InputDecoration(hintText: 'Explain what is happening, who is affected and why it matters...')),
          const SizedBox(height: 20),
          const _Label(icon: Icons.location_on_outlined, text: 'Location — Anywhere in India'), const SizedBox(height: 8),
          _LocationPicker(location: location, onChanged: (v) => setState(() => location = v)),
          const SizedBox(height: 20),
          const _Label(icon: Icons.attach_file, text: 'Photo / Video Evidence'), const SizedBox(height: 10),
          Row(children: [
            Expanded(child: OutlinedButton.icon(onPressed: selectImages, icon: const Icon(Icons.image_outlined), label: const Text('Add Photos'))),
            const SizedBox(width: 12),
            Expanded(child: OutlinedButton.icon(onPressed: selectVideo, icon: const Icon(Icons.videocam_outlined), label: const Text('Add Video'))),
          ]),
          if (imageGallery.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(height: 115, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: imageGallery.length, separatorBuilder: (_, __) => const SizedBox(width: 10), itemBuilder: (context, index) => GestureDetector(onTap: () => showImageViewer(context, imageGallery[index], imageNames.length > index ? imageNames[index] : 'Evidence photo'), child: ClipRRect(borderRadius: BorderRadius.circular(14), child: Image.memory(imageGallery[index], width: 155, fit: BoxFit.cover))))),
            const SizedBox(height: 5),
            Text('${imageGallery.length} photo(s) attached — tap a photo to view it', style: const TextStyle(color: textGrey, fontSize: 12)),
          ],
          if (videoBytes != null) ...[
            const SizedBox(height: 12),
            InkWell(onTap: videoPath.isEmpty ? null : () => openVideo(context, videoPath, videoName), child: Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: primaryLight, borderRadius: BorderRadius.circular(15)), child: Row(children: [const Icon(Icons.video_file_outlined, color: primary, size: 30), const SizedBox(width: 10), Expanded(child: Text(videoName.isEmpty ? 'Video evidence attached' : videoName, style: const TextStyle(fontWeight: FontWeight.w600))), const Icon(Icons.play_circle_fill, color: primary)]))),
          ],
          const SizedBox(height: 25),
          SizedBox(width: double.infinity, height: 54, child: ElevatedButton.icon(onPressed: analyzeAndSubmit, icon: const Icon(Icons.auto_awesome), label: const Text('Analyze & Submit Problem'), style: ElevatedButton.styleFrom(backgroundColor: primary, foregroundColor: Colors.white))),
        ]))),
      ),
    );
  }
}

// ============================================================
// UNIVERSITY
// ============================================================

class UniversityDashboard extends StatefulWidget {
  final String university;
  const UniversityDashboard({super.key, required this.university});

  @override
  State<UniversityDashboard> createState() => _UniversityDashboardState();
}

class _UniversityDashboardState extends State<UniversityDashboard> {
  @override
  Widget build(BuildContext context) {
    final myProjects = appProblems.expand((p) => p.projects.where((x) => x.university == widget.university).map((x) => (p, x))).toList();
    final available = appProblems.where((p) => !p.selectedBy(widget.university)).toList();
    return _Layout(title: widget.university, icon: Icons.school, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _Hero(title: 'University Workspace', subtitle: 'Choose a community problem first. Only after selection can your team, solution, progress and PDF be entered.', button: 'Browse Problem Statements', onTap: () {}),
      const SizedBox(height: 24),
      Row(children: [Expanded(child: _Metric(number: '${appProblems.length}', title: 'Problem Statements', icon: Icons.description_outlined)), const SizedBox(width: 12), Expanded(child: _Metric(number: '${appProblems.isEmpty ? 0 : appProblems.map((p) => p.matching).reduce((a,b)=>a+b) ~/ appProblems.length}%', title: 'Avg AI Match', icon: Icons.percent)), const SizedBox(width: 12), Expanded(child: _Metric(number: '${appProblems.where((p) => p.priority == 'HIGH').length}', title: 'High Priority', icon: Icons.priority_high))]),
      const SizedBox(height: 28),
      const Text('Problem Statements — Select One To Start', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8), const Text('Citizen-submitted problems are visible here. Team and solution details are not created until your university selects one.', style: TextStyle(color: textGrey)),
      const SizedBox(height: 14),
      ...available.map((p) => _UniversityOpenProblemCard(problem: p, university: widget.university, onChanged: () => setState(() {}))),
      const SizedBox(height: 25),
      const Text('Recent Updated Problems', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      ...([...appProblems]..sort((a, b) => b.createdAt.compareTo(a.createdAt))).take(3).map((p) => _ProblemCard(problem: p, compact: true)),
      const SizedBox(height: 25),
      const Text('My Active Projects', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)), const SizedBox(height: 10),
      if (myProjects.isEmpty) const _Empty(text: 'No project selected yet. Choose a problem statement above.'),
      ...myProjects.map((entry) => _MyUniversityProjectCard(problem: entry.$1, project: entry.$2, onChanged: () => setState(() {}))),
    ]));
  }
}

class _UniversityOpenProblemCard extends StatelessWidget {
  final Problem problem;
  final String university;
  final VoidCallback onChanged;
  const _UniversityOpenProblemCard({required this.problem, required this.university, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return _Card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Expanded(child: Text(problem.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))), _Badge(text: problem.priority, color: problem.priority == 'HIGH' ? red : orange)]),
      const SizedBox(height: 8), Text('📍 ${problem.location}  •  ${problem.domain}', style: const TextStyle(color: textGrey, fontSize: 12)),
      const SizedBox(height: 8), Text('${problem.matching}% AI Match', style: const TextStyle(color: green, fontWeight: FontWeight.bold)),
      const SizedBox(height: 10), Text(problem.description, style: const TextStyle(color: textGrey, height: 1.4)),
      const SizedBox(height: 10),
      _ProblemEvidence(problem: problem),
      const SizedBox(height: 14), Text('Already selected by ${problem.projects.length} university${problem.projects.length == 1 ? '' : 'ies'}', style: const TextStyle(fontSize: 12, color: textGrey)),
      const SizedBox(height: 12), SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: () async { await Navigator.push(context, MaterialPageRoute(builder: (_) => UniversityProjectSetupScreen(problem: problem, university: university))); onChanged(); }, icon: const Icon(Icons.playlist_add_check), label: const Text('Select Problem & Create Project'))),
    ]));
  }
}

class _MyUniversityProjectCard extends StatelessWidget {
  final Problem problem;
  final UniversityProject project;
  final VoidCallback onChanged;
  const _MyUniversityProjectCard({required this.problem, required this.project, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return _Card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Expanded(child: Text(problem.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))), _Badge(text: '${project.progress}% Progress', color: primary)]),
      const SizedBox(height: 8), Text('Team: ${project.teamName.isEmpty ? 'Not entered' : project.teamName}', style: const TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: 6), Text('Members: ${project.members.isEmpty ? 'Not entered' : project.members.join(', ')}', style: const TextStyle(color: textGrey)),
      const SizedBox(height: 10), LinearProgressIndicator(value: project.progress / 100, minHeight: 8),
      const SizedBox(height: 10),
      Wrap(spacing: 8, runSpacing: 8, children: [
        _Badge(text: project.industryAccepted ? 'Industry: ${project.industrySupport}' : 'Industry: Waiting', color: project.industryAccepted ? green : orange),
        if (project.governmentCollaborating) const _Badge(text: 'Government Collaboration', color: primary),
        if (project.governmentAccepted) const _Badge(text: 'Government Accepted', color: green),
        if (project.published) const _Badge(text: 'Published', color: green),
      ]),
      const SizedBox(height: 10), Text('Solution PDF: ${project.solutionPdfName.isEmpty ? 'Not uploaded' : project.solutionPdfName}', style: const TextStyle(color: textGrey)),
      const SizedBox(height: 12), Row(children: [Expanded(child: OutlinedButton(onPressed: () async { await Navigator.push(context, MaterialPageRoute(builder: (_) => UniversityProjectSetupScreen(problem: problem, university: project.university, existing: project))); onChanged(); }, child: const Text('Update Project'))), const SizedBox(width: 10), Expanded(child: ElevatedButton(onPressed: () => _showProject(context, problem, project), child: const Text('View Process')))]),
    ]));
  }

  void _showProject(BuildContext context, Problem problem, UniversityProject project) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => ProjectDetailsScreen(problem: problem, project: project, title: 'University Project')));
  }
}

class UniversityProjectSetupScreen extends StatefulWidget {
  final Problem problem;
  final String university;
  final UniversityProject? existing;
  const UniversityProjectSetupScreen({super.key, required this.problem, required this.university, this.existing});

  @override
  State<UniversityProjectSetupScreen> createState() => _UniversityProjectSetupScreenState();
}

class _UniversityProjectSetupScreenState extends State<UniversityProjectSetupScreen> {
  late final TextEditingController team;
  late final TextEditingController members;
  late final TextEditingController solution;
  late double progress;
  Uint8List? pdfBytes;
  String pdfName = '';
  final prototypePicker = ImagePicker();
  final prototypeDescription = TextEditingController();
  List<Uint8List> prototypeImages = [];
  List<String> prototypeImageNames = [];
  Uint8List? prototypeVideoBytes;
  String prototypeVideoName = '';
  String prototypeVideoPath = '';
  Uint8List? prototypePdfBytes;
  String prototypePdfName = '';

  @override
  void initState() {
    super.initState();
    final p = widget.existing;
    team = TextEditingController(text: p?.teamName ?? '');
    members = TextEditingController(text: p?.members.join('\n') ?? '');
    solution = TextEditingController(text: p?.solution ?? '');
    progress = (p?.progress ?? 0).toDouble();
    pdfBytes = p?.solutionPdfBytes;
    pdfName = p?.solutionPdfName ?? '';
    prototypeDescription.text = p?.prototypeDescription ?? '';
    prototypeImages = [...(p?.prototypeImages ?? [])];
    prototypeImageNames = [...(p?.prototypeImageNames ?? [])];
    prototypeVideoBytes = p?.prototypeVideoBytes;
    prototypeVideoName = p?.prototypeVideoName ?? '';
    prototypeVideoPath = p?.prototypeVideoPath ?? '';
    prototypePdfBytes = p?.prototypePdfBytes;
    prototypePdfName = p?.prototypePdfName ?? '';
  }

  @override
  void dispose() { team.dispose(); members.dispose(); solution.dispose(); prototypeDescription.dispose(); super.dispose(); }

  Future<void> pickPdf() async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (file != null) {
      try {
        final bytes = await file.readAsBytes();
        if (!mounted) return;
        setState(() {
          pdfBytes = bytes;
          pdfName = file.name;
        });
      } catch (_) {
        if (mounted) _snack(context, 'Could not read the selected PDF.');
      }
    }
  }

  Future<void> pickPrototypeImages() async {
    final selected = await prototypePicker.pickMultiImage(imageQuality: 85);
    if (selected.isEmpty) return;
    final bytes = <Uint8List>[];
    final names = <String>[];
    for (final file in selected) {
      bytes.add(await file.readAsBytes());
      names.add(file.name);
    }
    if (!mounted) return;
    setState(() { prototypeImages = [...prototypeImages, ...bytes]; prototypeImageNames = [...prototypeImageNames, ...names]; });
  }

  Future<void> pickPrototypeVideo() async {
    final file = await prototypePicker.pickVideo(source: ImageSource.gallery);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    if (!mounted) return;
    setState(() { prototypeVideoBytes = bytes; prototypeVideoName = file.name; prototypeVideoPath = file.path; });
  }

  Future<void> pickPrototypePdf() async {
    final file = await FilePicker.pickFile(type: FileType.custom, allowedExtensions: ['pdf']);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    if (!mounted) return;
    setState(() { prototypePdfBytes = bytes; prototypePdfName = file.name; });
  }

  void saveProject() {
    if (team.text.trim().isEmpty || members.text.trim().isEmpty || solution.text.trim().isEmpty || pdfBytes == null) {
      _snack(context, 'Enter team, solution and upload the solution PDF before saving.'); return;
    }
    if (prototypeDescription.text.trim().isEmpty && prototypeImages.isEmpty && prototypeVideoBytes == null) {
      _snack(context, 'Add a prototype description, image or video before submitting the project.'); return;
    }
    final p = widget.existing ?? UniversityProject(university: widget.university);
    p.teamName = team.text.trim();
    p.members = members.text.split('\n').map((x) => x.trim()).where((x) => x.isNotEmpty).toList();
    p.solution = solution.text.trim();
    p.solutionPdfBytes = pdfBytes;
    p.solutionPdfName = pdfName;
    p.progress = progress.round();
    p.prototypeDescription = prototypeDescription.text.trim();
    p.prototypeImages = prototypeImages;
    p.prototypeImageNames = prototypeImageNames;
    p.prototypeVideoBytes = prototypeVideoBytes;
    p.prototypeVideoName = prototypeVideoName;
    p.prototypeVideoPath = prototypeVideoPath;
    p.prototypePdfBytes = prototypePdfBytes;
    p.prototypePdfName = prototypePdfName;
    p.prototypeSubmitted = true;
    p.governmentPrototypeApproved = false;
    if (widget.existing == null) widget.problem.projects.add(p);
    _snack(context, 'Project details saved. Industry and Government can now review the solution.');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final firstSelection = widget.existing == null;
    return Scaffold(appBar: AppBar(title: Text(firstSelection ? 'Create University Project' : 'Update University Project')), body: ListView(padding: const EdgeInsets.all(20), children: [
      _ProblemHeader(problem: widget.problem, note: firstSelection ? 'Step 1 completed: problem selected by ${widget.university}.' : 'Update your project while it is in progress.'),
      const SizedBox(height: 18),
      _Section(title: 'Team Information', child: Column(children: [TextField(controller: team, decoration: const InputDecoration(labelText: 'Team Name', prefixIcon: Icon(Icons.groups_outlined))), const SizedBox(height: 12), TextField(controller: members, maxLines: 5, decoration: const InputDecoration(labelText: 'Team Members', hintText: 'One member per line\nExample: Hasini — Team Lead'))])),
      _Section(title: 'University Solution', child: Column(children: [TextField(controller: solution, maxLines: 7, decoration: const InputDecoration(labelText: 'Solution Description', hintText: 'Explain the proposed solution, technology and expected impact.')), const SizedBox(height: 14), Row(children: [Expanded(child: OutlinedButton.icon(onPressed: pickPdf, icon: const Icon(Icons.picture_as_pdf), label: const Text('Upload Solution PDF'))), const SizedBox(width: 12), if (pdfName.isNotEmpty) Expanded(child: Text(pdfName, maxLines: 2, overflow: TextOverflow.ellipsis))]), if (pdfBytes != null) Padding(padding: const EdgeInsets.only(top: 10), child: Row(children: [const Icon(Icons.check_circle, color: green), const SizedBox(width: 7), const Text('PDF ready for Industry & Government review')]))])),
      _Section(title: 'Prototype — Required Before Approval', child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TextField(controller: prototypeDescription, maxLines: 5, decoration: const InputDecoration(labelText: 'Prototype Description', hintText: 'Explain what your team has actually built or demonstrated.')),
        const SizedBox(height: 12),
        Row(children: [Expanded(child: OutlinedButton.icon(onPressed: pickPrototypeImages, icon: const Icon(Icons.add_photo_alternate_outlined), label: const Text('Add Prototype Images'))), const SizedBox(width: 10), Expanded(child: OutlinedButton.icon(onPressed: pickPrototypeVideo, icon: const Icon(Icons.video_library_outlined), label: const Text('Add Prototype Video')))]),
        if (prototypeImages.isNotEmpty) ...[const SizedBox(height: 10), SizedBox(height: 105, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: prototypeImages.length, separatorBuilder: (_, __) => const SizedBox(width: 8), itemBuilder: (context, i) => GestureDetector(onTap: () => showImageViewer(context, prototypeImages[i], prototypeImageNames.length > i ? prototypeImageNames[i] : 'Prototype image'), child: ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.memory(prototypeImages[i], width: 145, fit: BoxFit.cover))))), const SizedBox(height: 5), Text('${prototypeImages.length} prototype image(s) attached', style: const TextStyle(color: textGrey, fontSize: 12))],
        if (prototypeVideoBytes != null) Padding(padding: const EdgeInsets.only(top: 10), child: InkWell(onTap: prototypeVideoPath.isEmpty ? null : () => openVideo(context, prototypeVideoPath, prototypeVideoName), child: Row(children: [const Icon(Icons.play_circle_fill, color: primary), const SizedBox(width: 8), Expanded(child: Text(prototypeVideoName, style: const TextStyle(fontWeight: FontWeight.w600))), const Text('View', style: TextStyle(color: primary, fontWeight: FontWeight.bold))]))),
        const SizedBox(height: 10),
        OutlinedButton.icon(onPressed: pickPrototypePdf, icon: const Icon(Icons.picture_as_pdf), label: Text(prototypePdfName.isEmpty ? 'Add Prototype PDF' : 'Prototype PDF: $prototypePdfName')),
        const SizedBox(height: 8),
        const Text('Government must review and approve the problem statement and this prototype before publication.', style: TextStyle(color: textGrey, height: 1.4)),
      ])),
      _Section(title: 'Project Progress', child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('${progress.round()}% complete', style: const TextStyle(fontWeight: FontWeight.bold)), Slider(value: progress, min: 0, max: 100, divisions: 20, label: '${progress.round()}%', onChanged: (v) => setState(() => progress = v)), LinearProgressIndicator(value: progress / 100, minHeight: 9), const SizedBox(height: 8), const Text('Keep this updated so citizens, industry and government can follow the project process.', style: TextStyle(color: textGrey))])),
      const SizedBox(height: 8), SizedBox(height: 54, child: ElevatedButton.icon(onPressed: saveProject, icon: const Icon(Icons.save_outlined), label: Text(firstSelection ? 'Save Project & Submit Solution' : 'Save Updated Progress'), style: ElevatedButton.styleFrom(backgroundColor: primary, foregroundColor: Colors.white))),
    ]));
  }
}

// ============================================================
// INDUSTRY
// ============================================================

class IndustryDashboard extends StatelessWidget {
  final String industry;
  const IndustryDashboard({super.key, required this.industry});

  @override
  Widget build(BuildContext context) {
    final projects = appProblems.expand((p) => p.projects.map((x) => (p, x))).toList();
    return _Layout(title: industry, icon: Icons.business, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _Hero(title: 'Industry Innovation Hub', subtitle: 'Review citizen problems and university projects. Solutions become available after a university selects the problem and submits project details.', button: 'Explore Projects', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const IndustryProjectsScreen()))),
      const SizedBox(height: 24),
      Row(children: [Expanded(child: _Metric(number: '${projects.length}', title: 'University Projects', icon: Icons.folder_outlined)), const SizedBox(width: 12), Expanded(child: _Metric(number: '${projects.where((x) => x.$2.industryAccepted).length}', title: 'Supported', icon: Icons.handshake_outlined)), const SizedBox(width: 12), Expanded(child: _Metric(number: '${appProblems.length}', title: 'Citizen Problems', icon: Icons.report_problem_outlined))]),
      const SizedBox(height: 26),
      const Text('Engagement Options', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)), const SizedBox(height: 12),
      _ModeCard(icon: Icons.rocket_launch_outlined, title: 'Independent', description: 'Support a university project for your organization through mentorship, funding, prototyping or field testing.', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const IndustryProjectsScreen()))),
      _ModeCard(icon: Icons.handshake_outlined, title: 'Government Collaboration', description: 'Choose a university solution and propose collaboration with government for public deployment.', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const IndustryProjectsScreen(governmentMode: true)))),
      const SizedBox(height: 18),
      const Text('Recent Citizen Problem Statements', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      ...([...appProblems]..sort((a, b) => b.createdAt.compareTo(a.createdAt))).take(4).map((p) => _ProblemCard(problem: p)),
    ]));
  }
}

class IndustryProjectsScreen extends StatefulWidget {
  final bool governmentMode;
  const IndustryProjectsScreen({super.key, this.governmentMode = false});

  @override
  State<IndustryProjectsScreen> createState() => _IndustryProjectsScreenState();
}

class _IndustryProjectsScreenState extends State<IndustryProjectsScreen> {
  @override
  Widget build(BuildContext context) {
    final entries = appProblems.expand((p) => p.projects.map((x) => (p, x))).toList();
    return Scaffold(appBar: AppBar(title: Text(widget.governmentMode ? 'Projects For Government Collaboration' : 'University Projects For Industry')), body: ListView(padding: const EdgeInsets.all(20), children: [
      const Text('Available project work', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)), const SizedBox(height: 7),
      const Text('Each card shows the citizen problem, university, team, live progress and solution PDF before industry decides to support.', style: TextStyle(color: textGrey, height: 1.5)), const SizedBox(height: 20),
      ...entries.map((entry) => _IndustryProjectCard(problem: entry.$1, project: entry.$2, governmentMode: widget.governmentMode, onChanged: () => setState(() {}))),
      if (entries.isEmpty) const _Empty(text: 'No university has selected a problem yet.'),
    ]));
  }
}

class _IndustryProjectCard extends StatelessWidget {
  final Problem problem;
  final UniversityProject project;
  final bool governmentMode;
  final VoidCallback onChanged;
  const _IndustryProjectCard({required this.problem, required this.project, required this.governmentMode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return _Card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Expanded(child: Text(problem.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))), _Badge(text: '${project.progress}%', color: primary)]),
      const SizedBox(height: 8), Text('University: ${project.university}', style: const TextStyle(fontWeight: FontWeight.w600)),
      Text('Problem: ${problem.location} • ${problem.domain}', style: const TextStyle(color: textGrey, fontSize: 12)),
      const SizedBox(height: 8),
      _ProblemEvidence(problem: problem),
      const SizedBox(height: 12),
      const SizedBox(height: 12), Text('Team: ${project.teamName}', style: const TextStyle(fontWeight: FontWeight.bold)),
      Text('${project.members.length} members', style: const TextStyle(color: textGrey)), const SizedBox(height: 10),
      LinearProgressIndicator(value: project.progress / 100, minHeight: 8), const SizedBox(height: 12),
      const Text('University Solution', style: TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 5), Text(project.solution, style: const TextStyle(color: textGrey, height: 1.4)),
      const SizedBox(height: 12),
      Row(children: [if (project.solutionPdfBytes != null) Expanded(child: OutlinedButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PdfViewerScreen(title: project.solutionPdfName, bytes: project.solutionPdfBytes!))), icon: const Icon(Icons.picture_as_pdf), label: const Text('View Solution PDF'))), if (project.solutionPdfBytes != null) const SizedBox(width: 10), Expanded(child: ElevatedButton.icon(onPressed: () => _support(context), icon: Icon(governmentMode ? Icons.handshake : Icons.support_agent), label: Text(governmentMode ? 'Propose Government Collaboration' : 'Support Project')))]),
      const SizedBox(height: 12),
      _PrototypePreview(project: project),
      const SizedBox(height: 12),
      _Timeline(project: project),
    ]));
  }

  void _support(BuildContext context) {
    showDialog(context: context, builder: (_) => AlertDialog(title: Text(governmentMode ? 'Government Collaboration' : 'Industry Support'), content: const Text('Choose how your organization wants to support this project.'), actions: [TextButton(onPressed: () { project.industrySupport = 'Mentorship'; project.industryAccepted = true; Navigator.pop(context); onChanged(); _snack(context, 'Mentorship support recorded.'); }, child: const Text('Mentorship')), TextButton(onPressed: () { project.industrySupport = 'Funding'; project.industryAccepted = true; Navigator.pop(context); onChanged(); _snack(context, 'Funding support recorded.'); }, child: const Text('Funding')), ElevatedButton(onPressed: () { project.industrySupport = governmentMode ? 'Government Collaboration' : 'Prototype / Pilot'; project.industryAccepted = true; if (governmentMode) project.governmentCollaborating = true; Navigator.pop(context); onChanged(); _snack(context, governmentMode ? 'Government collaboration proposal recorded.' : 'Prototype / pilot support recorded.'); }, child: Text(governmentMode ? 'Collaborate' : 'Prototype / Pilot'))]));
  }
}

// ============================================================
// GOVERNMENT
// ============================================================

class GovernmentDashboard extends StatelessWidget {
  const GovernmentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final projects = appProblems.fold<int>(0, (sum, p) => sum + p.projects.length);
    return _Layout(title: 'Government Portal', icon: Icons.account_balance, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _Hero(title: 'Government Impact Dashboard', subtitle: 'See every citizen problem, universities that selected it, project progress, solution PDFs, industry support and public outcomes.', button: 'Review Problems', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GovernmentProblemsScreen()))),
      const SizedBox(height: 24),
      Row(children: [Expanded(child: _Metric(number: '${appProblems.length}', title: 'Problems', icon: Icons.report_problem_outlined)), const SizedBox(width: 12), Expanded(child: _Metric(number: '$projects', title: 'University Projects', icon: Icons.folder_outlined)), const SizedBox(width: 12), Expanded(child: _Metric(number: '${appProblems.where((p) => p.isPublished).length}', title: 'Published', icon: Icons.public))]),
      const SizedBox(height: 26),
      const Text('Workflow Visibility', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)), const SizedBox(height: 12),
      const _WorkflowCard(),
    ]));
  }
}

class GovernmentProblemsScreen extends StatefulWidget {
  const GovernmentProblemsScreen({super.key});
  @override State<GovernmentProblemsScreen> createState() => _GovernmentProblemsScreenState();
}
class _GovernmentProblemsScreenState extends State<GovernmentProblemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('All Problem Statements')), body: ListView(padding: const EdgeInsets.all(20), children: [
      const Text('Citizen Problems & Project History', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)), const SizedBox(height: 7),
      const Text('Government can compare universities working on the same problem and review every stage before accepting, collaborating or publishing.', style: TextStyle(color: textGrey, height: 1.5)), const SizedBox(height: 20),
      ...appProblems.map((p) => _GovernmentProblemCard(problem: p, onChanged: () => setState(() {}))),
    ]));
  }
}

class _GovernmentProblemCard extends StatelessWidget {
  final Problem problem;
  final VoidCallback onChanged;
  const _GovernmentProblemCard({required this.problem, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return _Card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Expanded(child: Text(problem.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))), _Badge(text: problem.overallStatus, color: problem.isPublished ? green : primary)]),
      const SizedBox(height: 7), Text('${problem.location} • ${problem.domain} • ${problem.priority}', style: const TextStyle(color: textGrey, fontSize: 12)), const SizedBox(height: 8), Text(problem.description, style: const TextStyle(color: textGrey)),
      const SizedBox(height: 12), Text('${problem.projects.length} university project${problem.projects.length == 1 ? '' : 's'} selected this problem', style: const TextStyle(fontWeight: FontWeight.w600)), const SizedBox(height: 10),
      SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () async { await Navigator.push(context, MaterialPageRoute(builder: (_) => GovernmentProblemDetail(problem: problem))); onChanged(); }, child: const Text('Open Full Review'))),
    ]));
  }
}

class GovernmentProblemDetail extends StatefulWidget {
  final Problem problem;
  const GovernmentProblemDetail({super.key, required this.problem});
  @override State<GovernmentProblemDetail> createState() => _GovernmentProblemDetailState();
}
class _GovernmentProblemDetailState extends State<GovernmentProblemDetail> {
  @override
  Widget build(BuildContext context) {
    final p = widget.problem;
    return Scaffold(appBar: AppBar(title: const Text('Government Review')), body: ListView(padding: const EdgeInsets.all(20), children: [
      _ProblemHeader(problem: p, note: 'Citizen-submitted problem — ${p.overallStatus}'), const SizedBox(height: 18),
      _ProblemEvidence(problem: p),
      _Section(title: 'Problem Description', child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(p.description, style: const TextStyle(color: textGrey, height: 1.5)), const SizedBox(height: 10), _Badge(text: p.governmentProblemApproved ? 'Problem Statement Approved' : 'Problem Statement Awaiting Approval', color: p.governmentProblemApproved ? green : orange)])),
      _Section(title: 'Universities Working On This Problem (${p.projects.length})', child: p.projects.isEmpty ? const Text('No university has selected this problem yet.', style: TextStyle(color: textGrey)) : Column(children: p.projects.map((project) => _GovernmentProjectCard(problem: p, project: project, onChanged: () => setState(() {}))).toList())),
      if (p.projects.isNotEmpty) _Section(title: 'Public Workflow', child: Column(children: [for (final project in p.projects) _Timeline(project: project)])),
      const SizedBox(height: 10),
      if (p.projects.isNotEmpty) Row(children: [Expanded(child: OutlinedButton.icon(onPressed: () => _negotiate(), icon: const Icon(Icons.handshake_outlined), label: const Text('Collaborate / Negotiate'))), const SizedBox(width: 12), Expanded(child: ElevatedButton.icon(onPressed: () => _acceptOrPublish(), icon: const Icon(Icons.verified_outlined), label: const Text('Review / Publish')))]),
      const SizedBox(height: 20),
    ]));
  }

  void _negotiate() {
    for (final project in widget.problem.projects) project.governmentCollaborating = true;
    setState(() {});
    _snack(context, 'Government collaboration status is now visible in the workflow.');
  }

  void _acceptOrPublish() {
    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('Government Review & Publication'),
      content: const Text('A project can be published only after the problem statement and prototype have both been approved.'),
      actions: [
        TextButton(onPressed: () {
          widget.problem.governmentProblemApproved = true;
          Navigator.pop(context);
          setState(() {});
          _snack(context, 'Problem statement approved.');
        }, child: const Text('Approve Problem Statement')),
        TextButton(onPressed: () {
          for (final project in widget.problem.projects) {
            if (project.readyForGovernmentApproval) project.governmentAccepted = true;
          }
          Navigator.pop(context);
          setState(() {});
          _snack(context, 'Eligible university projects accepted for publication review.');
        }, child: const Text('Accept Projects')),
        TextButton(onPressed: () {
          for (final project in widget.problem.projects) {
            if (project.prototypeSubmitted) project.governmentPrototypeApproved = true;
          }
          Navigator.pop(context);
          setState(() {});
          _snack(context, 'Submitted prototypes approved.');
        }, child: const Text('Approve Prototypes')),
        TextButton(onPressed: () {
          for (final project in widget.problem.projects) project.governmentCollaborating = true;
          Navigator.pop(context);
          setState(() {});
          _snack(context, 'Government collaboration recorded.');
        }, child: const Text('Collaborate')),
        ElevatedButton(onPressed: () {
          final ready = widget.problem.governmentProblemApproved && widget.problem.projects.isNotEmpty && widget.problem.projects.every((project) => project.readyForPublication);
          if (!ready) {
            Navigator.pop(context);
            _snack(context, 'Publication locked: approve the problem statement and every submitted prototype first.');
            return;
          }
          for (final project in widget.problem.projects) project.published = true;
          Navigator.pop(context);
          setState(() {});
          _snack(context, 'Approved solution and prototype published to citizens/world.');
        }, child: const Text('Publish to Citizens / World')),
      ],
    ));
  }
}

class _GovernmentProjectCard extends StatelessWidget {
  final Problem problem;
  final UniversityProject project;
  final VoidCallback onChanged;
  const _GovernmentProjectCard({required this.problem, required this.project, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(16)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Expanded(child: Text(project.university, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17))), _Badge(text: '${project.progress}%', color: primary)]),
      const SizedBox(height: 7), Text('Problem location: ${problem.location}', style: const TextStyle(color: textGrey)),
      const SizedBox(height: 7), Text('Team: ${project.teamName} • ${project.members.length} members', style: const TextStyle(color: textGrey)), const SizedBox(height: 8), Text(project.solution, style: const TextStyle(height: 1.4)), const SizedBox(height: 8),
      LinearProgressIndicator(value: project.progress / 100, minHeight: 8), const SizedBox(height: 10),
      Wrap(spacing: 8, runSpacing: 8, children: [if (project.solutionPdfBytes != null) OutlinedButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PdfViewerScreen(title: project.solutionPdfName, bytes: project.solutionPdfBytes!))), icon: const Icon(Icons.picture_as_pdf), label: const Text('View PDF')), _Badge(text: project.industryAccepted ? 'Industry: ${project.industrySupport}' : 'Industry: Waiting', color: project.industryAccepted ? green : orange), if (project.governmentCollaborating) const _Badge(text: 'Government Collaboration', color: primary), if (project.governmentAccepted) const _Badge(text: 'Government Accepted', color: green), if (project.published) const _Badge(text: 'Published', color: green)]),
      const SizedBox(height: 12),
      _PrototypePreview(project: project),
      const SizedBox(height: 8),
      Wrap(spacing: 8, runSpacing: 8, children: [
        _Badge(text: widgetApprovalText(problem, project), color: project.governmentPrototypeApproved ? green : orange),
        if (problem.governmentProblemApproved) const _Badge(text: 'Problem Approved', color: green),
        if (project.published) const _Badge(text: 'Published to Citizens / World', color: green),
      ]),
      const SizedBox(height: 10),
      Wrap(spacing: 8, runSpacing: 8, children: [
        if (!problem.governmentProblemApproved) OutlinedButton.icon(onPressed: () { problem.governmentProblemApproved = true; onChanged(); _snack(context, 'Problem statement approved.'); }, icon: const Icon(Icons.fact_check_outlined), label: const Text('Approve Problem')),
        if (project.prototypeSubmitted && !project.governmentPrototypeApproved) OutlinedButton.icon(onPressed: () { project.governmentPrototypeApproved = true; onChanged(); _snack(context, 'Prototype approved.'); }, icon: const Icon(Icons.verified_outlined), label: const Text('Approve Prototype')),
        if (!project.published) ElevatedButton.icon(onPressed: project.readyForPublication && problem.governmentProblemApproved ? () { project.governmentAccepted = true; project.published = true; onChanged(); _snack(context, 'Approved prototype and solution published.'); } : null, icon: const Icon(Icons.public), label: const Text('Publish')),
      ]),
      const SizedBox(height: 8),
      Text(project.readyForPublication && problem.governmentProblemApproved ? 'Publication unlocked: problem + prototype approved.' : 'Publication locked until the problem statement and prototype are approved.', style: TextStyle(color: project.readyForPublication && problem.governmentProblemApproved ? green : textGrey, fontSize: 11, fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      Text('Tasks: ${project.tasks.join(' → ')}', style: const TextStyle(color: textGrey, fontSize: 11)),
    ]));
  }
}

String widgetApprovalText(Problem problem, UniversityProject project) => project.governmentPrototypeApproved ? 'Prototype Approved' : (project.prototypeSubmitted ? 'Prototype Awaiting Approval' : 'Prototype Not Submitted');

class _PrototypePreview extends StatelessWidget {
  final UniversityProject project;
  const _PrototypePreview({required this.project});
  @override
  Widget build(BuildContext context) {
    if (!project.hasPrototype && !project.hasIndustryPrototype) {
      return const Text('No prototype evidence submitted yet.', style: TextStyle(color: textGrey));
    }
    return _Section(title: 'Prototype Evidence', child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (project.prototypeDescription.isNotEmpty) Text(project.prototypeDescription, style: const TextStyle(color: textGrey, height: 1.4)),
      if (project.prototypeImages.isNotEmpty) ...[
        const SizedBox(height: 10),
        SizedBox(height: 110, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: project.prototypeImages.length, separatorBuilder: (_, __) => const SizedBox(width: 8), itemBuilder: (context, i) => GestureDetector(onTap: () => showImageViewer(context, project.prototypeImages[i], project.prototypeImageNames.length > i ? project.prototypeImageNames[i] : 'Prototype image'), child: ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.memory(project.prototypeImages[i], width: 150, fit: BoxFit.cover))))),
      ],
      if (project.prototypeVideoBytes != null) Padding(padding: const EdgeInsets.only(top: 10), child: InkWell(onTap: project.prototypeVideoPath.isEmpty ? null : () => openVideo(context, project.prototypeVideoPath, project.prototypeVideoName), child: Row(children: [const Icon(Icons.play_circle_fill, color: primary), const SizedBox(width: 8), Expanded(child: Text(project.prototypeVideoName.isEmpty ? 'Prototype video' : project.prototypeVideoName)), const Text('View', style: TextStyle(color: primary, fontWeight: FontWeight.bold))]))),
      if (project.prototypePdfBytes != null) Padding(padding: const EdgeInsets.only(top: 10), child: OutlinedButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PdfViewerScreen(title: project.prototypePdfName, bytes: project.prototypePdfBytes!))), icon: const Icon(Icons.picture_as_pdf), label: const Text('View Prototype PDF'))),
    ]));
  }
}

class PdfViewerScreen extends StatelessWidget {
  final String title;
  final Uint8List bytes;
  const PdfViewerScreen({super.key, required this.title, required this.bytes});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text(title)), body: SfPdfViewer.memory(bytes));
}

// ============================================================
// SHARED UI
// ============================================================

class _Layout extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  const _Layout({required this.title, required this.icon, required this.child});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Row(children: [Icon(icon, color: primary), const SizedBox(width: 10), Flexible(child: Text(title, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)))]), actions: [IconButton(onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const WelcomeScreen()), (_) => false), icon: const Icon(Icons.logout))]), body: SingleChildScrollView(padding: const EdgeInsets.all(22), child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 1000), child: child))));
}

class _Hero extends StatelessWidget {
  final String title, subtitle, button;
  final VoidCallback onTap;
  const _Hero({required this.title, required this.subtitle, required this.button, required this.onTap});
  @override
  Widget build(BuildContext context) => Container(width: double.infinity, padding: const EdgeInsets.all(24), decoration: BoxDecoration(gradient: const LinearGradient(colors: [primary, Color(0xFF8066D9)]), borderRadius: BorderRadius.circular(24)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)), const SizedBox(height: 8), Text(subtitle, style: const TextStyle(color: Colors.white70, height: 1.5)), const SizedBox(height: 18), ElevatedButton(onPressed: onTap, style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: primary), child: Text(button))]));
}

class _Metric extends StatelessWidget {
  final String number, title; final IconData icon;
  const _Metric({required this.number, required this.title, required this.icon});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: primary), const SizedBox(height: 9), Text(number, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), Text(title, style: const TextStyle(color: textGrey, fontSize: 12))]));
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});
  @override
  Widget build(BuildContext context) => Container(margin: const EdgeInsets.only(bottom: 14), padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(19), border: Border.all(color: Colors.grey.shade200)), child: child);
}

class _ProblemCard extends StatelessWidget {
  final Problem problem; final bool compact, showActions;
  const _ProblemCard({required this.problem, this.compact = false, this.showActions = false});
  @override
  Widget build(BuildContext context) => _Card(child: InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CitizenProblemDetail(problem: problem))), child: Row(children: [Container(height: 48, width: 48, decoration: BoxDecoration(color: primaryLight, borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.report_problem_outlined, color: primary)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(problem.title, style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 5), Text('${problem.location} • ${problem.domain}', style: const TextStyle(color: textGrey, fontSize: 12)), if (!compact) ...[const SizedBox(height: 5), Text('${problem.projects.length} university project(s) • ${problem.overallStatus}', style: const TextStyle(color: textGrey, fontSize: 11))]])), _Badge(text: problem.overallStatus, color: problem.isPublished ? green : orange)])));
}

class CitizenProblemDetail extends StatelessWidget {
  final Problem problem;
  const CitizenProblemDetail({super.key, required this.problem});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Problem Journey')), body: ListView(padding: const EdgeInsets.all(20), children: [_ProblemHeader(problem: problem, note: 'Visible to citizens, universities, industry and government'), _ProblemEvidence(problem: problem), _Section(title: 'Problem', child: Text(problem.description, style: const TextStyle(color: textGrey, height: 1.5))), _Section(title: 'Universities Selected (${problem.projects.length})', child: problem.projects.isEmpty ? const Text('No university has selected this problem yet.', style: TextStyle(color: textGrey)) : Column(children: problem.projects.map((p) => _Timeline(project: p)).toList())), if (problem.isPublished) Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFFEAF8F1), borderRadius: BorderRadius.circular(16)), child: const Text('Government has published a solution for citizens.', style: TextStyle(fontWeight: FontWeight.bold, color: green))) ]));
}

class _ProblemHeader extends StatelessWidget {
  final Problem problem; final String note;
  const _ProblemHeader({required this.problem, required this.note});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(gradient: const LinearGradient(colors: [primary, Color(0xFF8066D9)]), borderRadius: BorderRadius.circular(22)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(problem.title, style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold)), const SizedBox(height: 8), Text('${problem.location} • ${problem.domain}', style: const TextStyle(color: Colors.white70)), const SizedBox(height: 12), Text(note, style: const TextStyle(color: Colors.white70, height: 1.4)), const SizedBox(height: 12), Row(children: [Expanded(child: Text('${problem.matching}% AI Match', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))), _Badge(text: problem.priority, color: Colors.white)])]));
}

class _Section extends StatelessWidget { final String title; final Widget child; const _Section({required this.title, required this.child}); @override Widget build(BuildContext context) => Container(margin: const EdgeInsets.only(bottom: 14), padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)), const SizedBox(height: 10), child])); }

class _Timeline extends StatelessWidget {
  final UniversityProject project;
  const _Timeline({required this.project});

  @override
  Widget build(BuildContext context) {
    final steps = <(String, bool)>[
      ('Problem selected', true),
      ('Team formed', project.teamName.isNotEmpty && project.members.isNotEmpty),
      ('Solution + PDF submitted', project.hasSolution && project.solutionPdfBytes != null),
      ('Prototype submitted', project.prototypeSubmitted),
      ('Prototype approved', project.governmentPrototypeApproved),
      ('Project in progress — ${project.progress}%', project.progress > 0),
      ('Industry: ${project.industryAccepted ? project.industrySupport : 'Awaiting support'}', project.industryAccepted),
      ('Government: ${project.published ? 'Published' : project.governmentAccepted ? 'Accepted' : project.governmentCollaborating ? 'Collaborating' : 'Review pending'}', project.governmentAccepted || project.governmentCollaborating || project.published),
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(project.university, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...steps.map(
            (step) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Icon(
                    step.$2 ? Icons.check_circle : Icons.radio_button_unchecked,
                    size: 18,
                    color: step.$2 ? green : Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      step.$1,
                      style: TextStyle(
                        color: step.$2 ? textDark : textGrey,
                        fontWeight: step.$2 ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProblemEvidence extends StatelessWidget {
  final Problem problem;
  const _ProblemEvidence({required this.problem});

  @override
  Widget build(BuildContext context) {
    return _Section(title: 'Citizen Evidence & Location', child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [const Icon(Icons.location_on, color: primary), const SizedBox(width: 8), Expanded(child: Text(problem.location, style: const TextStyle(fontWeight: FontWeight.w600)))]),
      const SizedBox(height: 12),
      if (problem.imageGallery.isNotEmpty) ...[
        const Text('Photos — tap any photo to view full size', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SizedBox(height: 145, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: problem.imageGallery.length, separatorBuilder: (_, __) => const SizedBox(width: 10), itemBuilder: (context, index) => GestureDetector(onTap: () => showImageViewer(context, problem.imageGallery[index], problem.imageNames.length > index ? problem.imageNames[index] : 'Citizen evidence'), child: ClipRRect(borderRadius: BorderRadius.circular(14), child: Image.memory(problem.imageGallery[index], width: 190, fit: BoxFit.cover))))),
      ],
      if (problem.videoBytes != null) Padding(padding: const EdgeInsets.only(top: 14), child: InkWell(onTap: problem.videoPath.isEmpty ? null : () => openVideo(context, problem.videoPath, problem.videoName), child: Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: primaryLight, borderRadius: BorderRadius.circular(14)), child: Row(children: [const Icon(Icons.play_circle_fill, color: primary, size: 32), const SizedBox(width: 10), Expanded(child: Text(problem.videoName.isEmpty ? 'Citizen video evidence' : problem.videoName, style: const TextStyle(fontWeight: FontWeight.w600))), const Text('View video', style: TextStyle(color: primary, fontWeight: FontWeight.bold))])))),
      if (!problem.hasCitizenEvidence) const Text('No photo or video evidence was attached.', style: TextStyle(color: textGrey)),
      const SizedBox(height: 10),
      const Text('This evidence is available to Citizen, University, Industry and Government portals.', style: TextStyle(color: textGrey, height: 1.4, fontSize: 12)),
    ]));
  }
}

class ProjectDetailsScreen extends StatelessWidget {
  final Problem problem; final UniversityProject project; final String title;
  const ProjectDetailsScreen({super.key, required this.problem, required this.project, required this.title});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text(title)), body: ListView(padding: const EdgeInsets.all(20), children: [
    _ProblemHeader(problem: problem, note: 'University: ${project.university} • Team: ${project.teamName}'),
    _ProblemEvidence(problem: problem),
    _Section(title: 'Team Members', child: Column(children: project.members.map((m) => ListTile(contentPadding: EdgeInsets.zero, leading: const CircleAvatar(backgroundColor: primaryLight, child: Icon(Icons.person, color: primary)), title: Text(m))).toList())),
    _Section(title: 'Solution', child: Text(project.solution, style: const TextStyle(color: textGrey, height: 1.5))),
    _Section(title: 'Progress', child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [LinearProgressIndicator(value: project.progress / 100, minHeight: 10), const SizedBox(height: 8), Text('${project.progress}% complete')])),
    if (project.solutionPdfBytes != null) SizedBox(height: 52, child: ElevatedButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PdfViewerScreen(title: project.solutionPdfName, bytes: project.solutionPdfBytes!))), icon: const Icon(Icons.picture_as_pdf), label: const Text('View Solution PDF'))),
    const SizedBox(height: 12),
    _PrototypePreview(project: project),
    _Timeline(project: project),
  ]));
}

class ProjectJourneyCard extends StatelessWidget {
  final Problem problem; final UniversityProject project;
  const ProjectJourneyCard({super.key, required this.problem, required this.project});
  @override
  Widget build(BuildContext context) => _Card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(project.university, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    const SizedBox(height: 6), Text('Team: ${project.teamName}', style: const TextStyle(color: textGrey)),
    const SizedBox(height: 10), LinearProgressIndicator(value: project.progress / 100, minHeight: 8),
    const SizedBox(height: 10), Text(project.solution, style: const TextStyle(color: textGrey, height: 1.4)),
    const SizedBox(height: 10),
    Wrap(spacing: 8, runSpacing: 8, children: [
      if (project.solutionPdfBytes != null) OutlinedButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PdfViewerScreen(title: project.solutionPdfName, bytes: project.solutionPdfBytes!))), icon: const Icon(Icons.picture_as_pdf), label: const Text('View Solution PDF')),
      if (project.governmentPrototypeApproved) const _Badge(text: 'Prototype Approved', color: green),
      if (project.published) const _Badge(text: 'Published', color: green),
    ]),
    const SizedBox(height: 8),
    _PrototypePreview(project: project),
  ]));
}

class _StatusBanner extends StatelessWidget {
  final String text; final Color color;
  const _StatusBanner({required this.text, required this.color});
  @override
  Widget build(BuildContext context) => Container(margin: const EdgeInsets.only(bottom: 14), padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: color.withValues(alpha: .10), borderRadius: BorderRadius.circular(14)), child: Row(children: [Icon(Icons.verified, color: color), const SizedBox(width: 8), Expanded(child: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold)))]));
}

class _WorkflowCard extends StatelessWidget {
  const _WorkflowCard();
  @override
  Widget build(BuildContext context) => _Card(child: const Wrap(alignment: WrapAlignment.center, spacing: 10, runSpacing: 10, children: [Chip(label: Text('Citizen Problem')), Icon(Icons.arrow_forward), Chip(label: Text('University Selection')), Icon(Icons.arrow_forward), Chip(label: Text('Team + Solution PDF')), Icon(Icons.arrow_forward), Chip(label: Text('Industry Review')), Icon(Icons.arrow_forward), Chip(label: Text('Government Review')), Icon(Icons.arrow_forward), Chip(label: Text('Approve Problem')), Icon(Icons.arrow_forward), Chip(label: Text('Approve Prototype')), Icon(Icons.arrow_forward), Chip(label: Text('Publish / Impact'))]));
}

class _ModeCard extends StatelessWidget { final IconData icon; final String title, description; final VoidCallback onTap; const _ModeCard({required this.icon, required this.title, required this.description, required this.onTap}); @override Widget build(BuildContext context) => _Card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: primary, size: 30), const SizedBox(height: 10), Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 5), Text(description, style: const TextStyle(color: textGrey, height: 1.4)), const SizedBox(height: 12), ElevatedButton(onPressed: onTap, child: const Text('Explore'))])); }

class _LocationPicker extends StatelessWidget {
  final String location;
  final ValueChanged<String> onChanged;

  const _LocationPicker({required this.location, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final controller = TextEditingController(text: location);
        showDialog(context: context, builder: (_) => AlertDialog(
          title: const Text('Select Problem Location'),
          content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Enter any city, village, district or address in India.', style: TextStyle(color: textGrey)),
            const SizedBox(height: 14),
            TextField(controller: controller, autofocus: true, decoration: const InputDecoration(labelText: 'Location', prefixIcon: Icon(Icons.location_on_outlined), hintText: 'Example: Hyderabad, Telangana, India')),
            const SizedBox(height: 12),
            const Text('Examples', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 7),
            Wrap(spacing: 6, runSpacing: 6, children: [
              for (final v in ['Hyderabad, Telangana, India', 'Bengaluru, Karnataka, India', 'Mumbai, Maharashtra, India', 'Delhi, India', 'Ranchi, Jharkhand, India', 'Chennai, Tamil Nadu, India'])
                ActionChip(label: Text(v, style: const TextStyle(fontSize: 11)), onPressed: () => controller.text = v),
            ]),
          ]),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(onPressed: () { final value = controller.text.trim(); if (value.isNotEmpty) { onChanged(value); Navigator.pop(context); } }, child: const Text('Use Location')),
          ],
        ));
      },
      child: Container(width: double.infinity, padding: const EdgeInsets.all(17), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)), child: Row(children: [const Icon(Icons.location_on, color: primary), const SizedBox(width: 10), Expanded(child: Text(location, style: const TextStyle(fontWeight: FontWeight.w600))), const Icon(Icons.edit_location_alt_outlined)])),
    );
  }
}

Future<void> openVideo(BuildContext context, String path, String name) async {
  if (path.isEmpty) { _snack(context, 'Video preview is not available for this file.'); return; }
  final uri = kIsWeb ? Uri.parse(path) : Uri.file(path);
  final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!ok && context.mounted) _snack(context, 'Could not open $name');
}

void showImageViewer(BuildContext context, Uint8List bytes, String title) {
  showDialog(context: context, builder: (_) => Dialog(
    child: SizedBox(width: 850, height: 650, child: Column(children: [
      AppBar(title: Text(title), automaticallyImplyLeading: false, actions: [IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close))]),
      Expanded(child: InteractiveViewer(child: Center(child: Image.memory(bytes, fit: BoxFit.contain)))),
    ]))),
  );
}

class _AIItem extends StatelessWidget { final String label, value; final bool important; const _AIItem({required this.label, required this.value, this.important = false}); @override Widget build(BuildContext context) => Container(margin: const EdgeInsets.only(bottom: 7), padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: important ? const Color(0xFFFFF4E5) : Colors.grey.shade50, borderRadius: BorderRadius.circular(10)), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [SizedBox(width: 90, child: Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: important ? orange : textDark))), Expanded(child: Text(value, style: const TextStyle(color: textGrey))) ])); }

class _Label extends StatelessWidget { final IconData icon; final String text; const _Label({required this.icon, required this.text}); @override Widget build(BuildContext context) => Row(children: [Icon(icon, color: primary, size: 20), const SizedBox(width: 8), Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))]); }

class _Badge extends StatelessWidget { final String text; final Color color; const _Badge({required this.text, required this.color}); @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5), decoration: BoxDecoration(color: color.withValues(alpha: .10), borderRadius: BorderRadius.circular(20)), child: Text(text, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold))); }

class _Empty extends StatelessWidget { final String text; const _Empty({required this.text}); @override Widget build(BuildContext context) => Container(width: double.infinity, padding: const EdgeInsets.all(25), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)), child: Column(children: [const Icon(Icons.folder_open_outlined, size: 45, color: textGrey), const SizedBox(height: 10), Text(text, textAlign: TextAlign.center, style: const TextStyle(color: textGrey))])); }

void _snack(BuildContext context, String message) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
IconData _roleIcon(String role) => role == 'Citizen' ? Icons.person : role == 'University' ? Icons.school : role == 'Industry' ? Icons.business : Icons.account_balance;
