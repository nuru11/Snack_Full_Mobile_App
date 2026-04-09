import 'package:flutter/material.dart';

import '../core/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          tooltip: 'Back',
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.ios_share_rounded),
            tooltip: 'Share',
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 92,
                      height: 92,
                      decoration: BoxDecoration(
                        color: const Color(0xFF9CA3AF),
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 18,
                            offset: Offset(0, 10),
                            color: AppColors.shadowSoft,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person_rounded,
                          size: 44,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // const SizedBox(height: 14),
                    // Text(
                    //   'Ebenezer Omosuli',
                    //   style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    //         fontWeight: FontWeight.w900,
                    //         color: AppColors.text,
                    //       ),
                    // ),
                    // const SizedBox(height: 6),
                    // const Text(
                    //   '@eben10',
                    //   style: TextStyle(
                    //     color: AppColors.muted,
                    //     fontWeight: FontWeight.w700,
                    //   ),
                    // ),
                    const SizedBox(height: 14),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.text,
                        side: const BorderSide(color: AppColors.softGray),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        'Edit Profile',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 18,
                      offset: Offset(0, 12),
                      color: AppColors.shadowSoft,
                    ),
                  ],
                ),
                child: Column(
                  children: const [
                    _ProfileRow(
                      icon: Icons.verified_user_outlined,
                      title: 'Verification',
                      trailing: _VerifiedTrailing(),
                    ),
                    _DividerLine(),
                    _ProfileRow(
                      icon: Icons.settings_outlined,
                      title: 'Settings',
                      trailing: _ChevronTrailing(),
                    ),
                    _DividerLine(),
                    _ProfileRow(
                      icon: Icons.lock_outline_rounded,
                      title: 'Change password',
                      trailing: _ChevronTrailing(),
                    ),
                    _DividerLine(),
                    _ProfileRow(
                      icon: Icons.card_giftcard_outlined,
                      title: 'Refer friends',
                      trailing: _ChevronTrailing(),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _DividerLine extends StatelessWidget {
  const _DividerLine();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 60),
      child: Divider(height: 1, thickness: 1, color: AppColors.softGray),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.icon,
    required this.title,
    required this.trailing,
  });

  final IconData icon;
  final String title;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.softGray,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AppColors.text, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.text,
                ),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

class _ChevronTrailing extends StatelessWidget {
  const _ChevronTrailing();

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.chevron_right_rounded,
      color: AppColors.muted,
      size: 24,
    );
  }
}

class _VerifiedTrailing extends StatelessWidget {
  const _VerifiedTrailing();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Icon(Icons.check_rounded, color: AppColors.primary, size: 20),
        SizedBox(width: 6),
        Icon(
          Icons.chevron_right_rounded,
          color: AppColors.muted,
          size: 24,
        ),
      ],
    );
  }
}
