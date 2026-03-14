import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideUp;
  late final ScrollController _scrollController;
  final _featuresKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  // Use app colors for consistency
  static const _bg = AppColors.background;
  static const _surface = AppColors.surface;
  static const _primary = AppColors.primary;
  static const _accent = AppColors.accent;
  static const _muted = AppColors.textSecondary;
  static const _success = AppColors.success;
  static const _warning = AppColors.warning;

  final _features = const [
    _FeatureData(
      icon: Icons.checklist_rounded,
      color: _primary,
      title: 'Exam & Topic Organization',
      desc:
          'Create, edit or delete exams. Break your syllabus into topics and set Not Started / In Progress / Completed status.',
    ),
    _FeatureData(
      icon: Icons.timer_rounded,
      color: _accent,
      title: 'Rhythmic Study Timer',
      desc:
          'Built-in focus timer per topic. Start & stop to log every session and build consistent, timed study habits.',
    ),
    _FeatureData(
      icon: Icons.bar_chart_rounded,
      color: _success,
      title: 'Progress Dashboard',
      desc:
          'Visual progress bars and completion percentages per exam. See your readiness grow in real time.',
    ),
    _FeatureData(
      icon: Icons.history_rounded,
      color: _warning,
      title: 'Study History Log',
      desc:
          'Review all past study sessions. Understand your habits and improve how you prepare for every exam.',
    ),
  ];

  final _steps = const [
    _StepData(
      '1',
      'Open Dashboard',
      'See all upcoming exams and their readiness at a glance.',
    ),
    _StepData(
      '2',
      'Add an Exam',
      'Enter exam name, subject, and date to register it.',
    ),
    _StepData(
      '3',
      'Add Topics',
      'Break your exam into chapters or skill areas.',
    ),
    _StepData(
      '4',
      'Start Timer',
      'Select a topic, study, then stop — your session is logged.',
    ),
    _StepData(
      '5',
      'Track Progress',
      'See your updated progress bar and completed topics.',
    ),
    _StepData(
      '6',
      'Repeat & Win',
      'Work through all exams and walk in truly ready.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 700;

    return Scaffold(
      backgroundColor: _bg,
      body: FadeTransition(
        opacity: _fadeIn,
        child: SlideTransition(
          position: _slideUp,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildNav(context),
                _buildHero(context, isMobile),
                _buildStatsStrip(isMobile),
                _buildProblemSection(isMobile),
                Container(
                  key: _featuresKey,
                  child: _buildFeaturesSection(isMobile),
                ),
                _buildHowItWorks(isMobile),
                _buildCTA(context),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── NAV ──────────────────────────────────────────────────────────────────
  Widget _buildNav(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      decoration: BoxDecoration(
        color: _bg.withOpacity(0.95),
        border: Border(
          bottom: BorderSide(color: _primary.withOpacity(0.1), width: 1),
        ),
      ),
      child: Row(
        children: [
          _gradientText(
            '📚 StudyBeat',
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
          const Spacer(),
          _NavButton(label: 'Open App', onTap: () => context.go('/welcome')),
        ],
      ),
    );
  }

  // ── HERO ─────────────────────────────────────────────────────────────────
  Widget _buildHero(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 60,
        vertical: isMobile ? 60 : 90,
      ),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0, -0.5),
          radius: 1.2,
          colors: [_accent.withOpacity(0.12), _bg],
        ),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _heroBadge(),
                const SizedBox(height: 20),
                _heroHeading(isMobile),
                const SizedBox(height: 16),
                _heroSubtitle(),
                const SizedBox(height: 36),
                _heroButtons(context, isMobile),
                const SizedBox(height: 50),
                _phoneMockup(),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _heroBadge(),
                      const SizedBox(height: 20),
                      _heroHeading(isMobile),
                      const SizedBox(height: 16),
                      _heroSubtitle(),
                      const SizedBox(height: 36),
                      _heroButtons(context, isMobile),
                    ],
                  ),
                ),
                const SizedBox(width: 48),
                _phoneMockup(),
              ],
            ),
    );
  }

  Widget _heroBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: _primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: _primary.withOpacity(0.2)),
      ),
      child: Text(
        '🎓  Education App',
        style: TextStyle(
          color: _primary,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _heroHeading(bool isMobile) {
    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          'Study Smarter.',
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: isMobile ? 34 : 48,
            fontWeight: FontWeight.w800,
            letterSpacing: -1.5,
            height: 1.15,
          ),
        ),
        ShaderMask(
          shaderCallback: (bounds) =>
              LinearGradient(colors: [_primary, _accent]).createShader(bounds),
          child: Text(
            'Beat Every Exam.',
            textAlign: isMobile ? TextAlign.center : TextAlign.left,
            style: TextStyle(
              color: _primary,
              fontSize: isMobile ? 34 : 48,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.5,
              height: 1.15,
            ),
          ),
        ),
      ],
    );
  }

  Widget _heroSubtitle() {
    return Text(
      'A personal exam preparation tracker that helps you organize your syllabus, log focused study sessions, and see your readiness grow — all in one place.',
      style: TextStyle(color: _muted, fontSize: 15, height: 1.7),
    );
  }

  Widget _heroButtons(BuildContext context, bool isMobile) {
    final cta = _PrimaryButton(
      label: '🚀  Open StudyBeat',
      onTap: () => context.go('/welcome'),
    );
    final secondary = _SecondaryButton(
      label: '✨  See Features',
      onTap: () {
        Scrollable.ensureVisible(
          _featuresKey.currentContext!,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      },
    );
    if (isMobile) {
      return Column(
        children: [
          SizedBox(width: double.infinity, child: cta),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: secondary),
        ],
      );
    }
    return Row(children: [cta, const SizedBox(width: 14), secondary]);
  }

  // ── PHONE MOCKUP ──────────────────────────────────────────────────────────
  Widget _phoneMockup() {
    return Container(
      width: 240,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(36),
        border: Border.all(color: _primary.withOpacity(0.15), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: _primary.withOpacity(0.12),
            blurRadius: 50,
            spreadRadius: -10,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 8,
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: _muted.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          _mockExamCard('📐 Mathematics Final', 0.72, _primary),
          const SizedBox(height: 8),
          _mockExamCard('⚛ Physics Midterm', 0.45, _accent),
          const SizedBox(height: 8),
          _mockTimerCard(),
          const SizedBox(height: 8),
          _mockTopicItem(
            Icons.check_circle,
            _success,
            'Integration Basics',
            'Done',
          ),
          const SizedBox(height: 4),
          _mockTopicItem(
            Icons.timelapse,
            _warning,
            'Differentiation',
            'In Progress',
          ),
          const SizedBox(height: 4),
          _mockTopicItem(
            Icons.circle_outlined,
            _muted,
            'Series & Sequences',
            'Not Started',
          ),
        ],
      ),
    );
  }

  Widget _mockExamCard(String name, double progress, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border(left: BorderSide(color: color, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: _primary.withOpacity(0.12),
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${(progress * 100).round()}% ready',
            style: const TextStyle(color: _muted, fontSize: 9),
          ),
        ],
      ),
    );
  }

  Widget _mockTimerCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_primary.withOpacity(0.08), _accent.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _primary.withOpacity(0.15)),
      ),
      child: Column(
        children: [
          Text(
            '⏱  FOCUS SESSION',
            style: TextStyle(color: _muted, fontSize: 9, letterSpacing: 0.8),
          ),
          const SizedBox(height: 4),
          Text(
            '24:37',
            style: TextStyle(
              color: _primary,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Calculus – Chapter 5',
            style: TextStyle(color: _muted, fontSize: 9),
          ),
        ],
      ),
    );
  }

  Widget _mockTopicItem(
    IconData icon,
    Color color,
    String label,
    String status,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 12),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 10),
          ),
        ),
        Text(status, style: const TextStyle(color: _muted, fontSize: 9)),
      ],
    );
  }

  // ── STATS ─────────────────────────────────────────────────────────────────
  Widget _buildStatsStrip(bool isMobile) {
    const stats = [
      ['4', 'Core Features'],
      ['75%', 'Target Completion'],
      ['0', 'More Cramming'],
      ['∞', 'Sessions Logged'],
    ];
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 60,
        vertical: 36,
      ),
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(color: _primary.withOpacity(0.08)),
        ),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        runSpacing: 24,
        children: stats
            .map(
              (s) => SizedBox(
                width: isMobile ? 140 : 160,
                child: Column(
                  children: [
                    ShaderMask(
                      shaderCallback: (b) => LinearGradient(
                        colors: [_primary, _accent],
                      ).createShader(b),
                      child: Text(
                        s[0],
                        style: const TextStyle(
                          color: _primary,
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      s[1],
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: _muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  // ── PROBLEM ───────────────────────────────────────────────────────────────
  Widget _buildProblemSection(bool isMobile) {
    const pains = [
      [
        '📅',
        'Calendar apps only show dates',
        'They tell you when — not what to study or how prepared you are.',
      ],
      [
        '⏱',
        'Generic timers disconnect topics',
        "Your timer doesn't know you're on Chapter 4. Time is lost, not tracked.",
      ],
      [
        '📝',
        'Note apps lack progress tracking',
        "No way to confirm you've covered all topics you need to.",
      ],
      [
        '✅',
        'To-do lists are too simple',
        'Complex exam prep needs structure, not just a flat checklist.',
      ],
    ];
    final w = MediaQuery.of(context).size.width;
    return _SectionWrapper(
      isMobile: isMobile,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTag('The Problem'),
          const SizedBox(height: 10),
          _sectionTitle('Exam prep is ', 'fragmented & stressful'),
          const SizedBox(height: 12),
          Text(
            'Students juggle calendars, notebooks, timers, and mental notes — all disconnected. This leads to inefficient studying, last-minute cramming, and unnecessary stress.',
            style: TextStyle(color: _muted, fontSize: 14, height: 1.7),
          ),
          const SizedBox(height: 36),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: pains
                .map(
                  (p) => SizedBox(
                    width: isMobile ? double.infinity : (w / 2) - 80,
                    child: _PainCard(emoji: p[0], title: p[1], desc: p[2]),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  // ── FEATURES ──────────────────────────────────────────────────────────────
  Widget _buildFeaturesSection(bool isMobile) {
    final w = MediaQuery.of(context).size.width;
    return Container(
      color: _accent.withOpacity(0.06),
      child: _SectionWrapper(
        isMobile: isMobile,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTag('Core Features'),
            const SizedBox(height: 10),
            _sectionTitle('Everything to ', 'crush your exams'),
            const SizedBox(height: 12),
            Text(
              'StudyBeat brings all your exam prep tools into one focused, beautifully simple app.',
              style: TextStyle(color: _muted, fontSize: 14, height: 1.7),
            ),
            const SizedBox(height: 36),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: _features
                  .map(
                    (f) => SizedBox(
                      width: isMobile ? double.infinity : (w / 2) - 80,
                      child: _FeatureCard(data: f),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  // ── HOW IT WORKS ──────────────────────────────────────────────────────────
  Widget _buildHowItWorks(bool isMobile) {
    final w = MediaQuery.of(context).size.width;
    return _SectionWrapper(
      isMobile: isMobile,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTag('How It Works'),
          const SizedBox(height: 10),
          _sectionTitle('From zero to ', 'exam ready'),
          const SizedBox(height: 12),
          Text(
            'Six simple steps that turn overwhelming exam prep into a calm, structured rhythm.',
            style: TextStyle(color: _muted, fontSize: 14, height: 1.7),
          ),
          const SizedBox(height: 36),
          Wrap(
            spacing: 16,
            runSpacing: 24,
            children: _steps
                .map(
                  (s) => SizedBox(
                    width: isMobile ? double.infinity : (w / 3) - 56,
                    child: _StepCard(step: s),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  // ── CTA ───────────────────────────────────────────────────────────────────
  Widget _buildCTA(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 80),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.0,
          colors: [_accent.withOpacity(0.1), _bg],
        ),
      ),
      child: Column(
        children: [
          _sectionTag('Get Started'),
          const SizedBox(height: 14),
          ShaderMask(
            shaderCallback: (b) =>
                LinearGradient(colors: [_primary, _accent]).createShader(b),
            child: Text(
              'Your next exam.\nFully prepared.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _primary,
                fontSize: 38,
                fontWeight: FontWeight.w800,
                letterSpacing: -1.2,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Stop cramming. Start tracking.\nStudyBeat helps you study with purpose — one topic, one session, one exam at a time.',
            textAlign: TextAlign.center,
            style: TextStyle(color: _muted, fontSize: 14, height: 1.7),
          ),
          const SizedBox(height: 40),
          _PrimaryButton(
            label: '🚀  Open StudyBeat Now',
            onTap: () => context.go('/welcome'),
            large: true,
          ),
        ],
      ),
    );
  }

  // ── FOOTER ────────────────────────────────────────────────────────────────
  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: _primary.withOpacity(0.1))),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        runSpacing: 12,
        children: [
          _gradientText(
            '📚 StudyBeat',
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
          Text(
            'Built by Kay Khine Myat Ko · 2026',
            style: TextStyle(color: _muted, fontSize: 12),
          ),
          Text(
            '© 2026 StudyBeat',
            style: TextStyle(color: _muted, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // ── HELPERS ───────────────────────────────────────────────────────────────
  Widget _gradientText(
    String text, {
    required double fontSize,
    required FontWeight fontWeight,
  }) {
    return ShaderMask(
      shaderCallback: (b) =>
          LinearGradient(colors: [_primary, _accent]).createShader(b),
      child: Text(
        text,
        style: TextStyle(
          color: _primary,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
    );
  }

  Widget _sectionTag(String label) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        color: _primary,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _sectionTitle(String plain, String highlight) {
    return Wrap(
      children: [
        Text(
          plain,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
            height: 1.2,
          ),
        ),
        ShaderMask(
          shaderCallback: (b) =>
              LinearGradient(colors: [_primary, _accent]).createShader(b),
          child: Text(
            highlight,
            style: TextStyle(
              color: _primary,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }
}

// ── SHARED WIDGETS ────────────────────────────────────────────────────────────

class _SectionWrapper extends StatelessWidget {
  final Widget child;
  final bool isMobile;
  const _SectionWrapper({required this.child, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 60,
        vertical: 72,
      ),
      child: child,
    );
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _NavButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Text(
          'Open App',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool large;
  const _PrimaryButton({
    required this.label,
    required this.onTap,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: large ? 44 : 28,
          vertical: large ? 18 : 14,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primary.withOpacity(0.85)],
          ),
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.25),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: large ? 16 : 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _SecondaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.primary.withOpacity(0.3),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _PainCard extends StatelessWidget {
  final String emoji, title, desc;
  const _PainCard({
    required this.emoji,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 26)),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureData {
  final IconData icon;
  final Color color;
  final String title, desc;
  const _FeatureData({
    required this.icon,
    required this.color,
    required this.title,
    required this.desc,
  });
}

class _FeatureCard extends StatelessWidget {
  final _FeatureData data;
  const _FeatureCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: data.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(data.icon, color: data.color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            data.title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data.desc,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12.5,
              height: 1.65,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepData {
  final String number, title, desc;
  const _StepData(this.number, this.title, this.desc);
}

class _StepCard extends StatelessWidget {
  final _StepData step;
  const _StepCard({required this.step});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.25),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              step.number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          step.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          step.desc,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
