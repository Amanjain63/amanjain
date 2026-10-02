import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Users',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
        fontFamily: 'Roboto',
      ),
      home: const UsersScreen(),
    );
  }
}

// ---------------------------------------------------------------------------
// Models
// ---------------------------------------------------------------------------

enum UserRole { admin, user, moderator }

class AppUser {
  final String name;
  final String email;
  final UserRole role;
  final Color avatarBg;
  final Color avatarFg;

  const AppUser({
    required this.name,
    required this.email,
    required this.role,
    required this.avatarBg,
    required this.avatarFg,
  });

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}

class RoleStyle {
  final String label;
  final Color bg;
  final Color fg;
  const RoleStyle(this.label, this.bg, this.fg);

  static RoleStyle of(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return const RoleStyle('Admin', Color(0xFFE6EEFF), Color(0xFF2F5FD0));
      case UserRole.user:
        return const RoleStyle('User', Color(0xFFE5F6EC), Color(0xFF2E8B57));
      case UserRole.moderator:
        return const RoleStyle(
            'Moderator', Color(0xFFFFF1DE), Color(0xFFC9771A));
    }
  }
}

// Sample data (matches the design)
const List<AppUser> kUsers = [
  AppUser(
    name: 'John Smith',
    email: 'john.smith@example.com',
    role: UserRole.admin,
    avatarBg: Color(0xFFE6EEFF),
    avatarFg: Color(0xFF2F5FD0),
  ),
  AppUser(
    name: 'Sarah Johnson',
    email: 'sarah.j@example.com',
    role: UserRole.user,
    avatarBg: Color(0xFFFDE7EE),
    avatarFg: Color(0xFFD03A6B),
  ),
  AppUser(
    name: 'Michael Brown',
    email: 'michael.b@example.com',
    role: UserRole.user,
    avatarBg: Color(0xFFE5F6EC),
    avatarFg: Color(0xFF2E8B57),
  ),
  AppUser(
    name: 'Emily Wilson',
    email: 'emily.w@example.com',
    role: UserRole.moderator,
    avatarBg: Color(0xFFF1E9FF),
    avatarFg: Color(0xFF8A4FE0),
  ),
  AppUser(
    name: 'David Lee',
    email: 'david.l@example.com',
    role: UserRole.user,
    avatarBg: Color(0xFFFFF1DE),
    avatarFg: Color(0xFFD9822B),
  ),
  AppUser(
    name: 'Olivia Parker',
    email: 'olivia.p@example.com',
    role: UserRole.admin,
    avatarBg: Color(0xFFFDE7EE),
    avatarFg: Color(0xFFC2185B),
  ),
  AppUser(
    name: 'James White',
    email: 'james.w@example.com',
    role: UserRole.user,
    avatarBg: Color(0xFFE0F7F7),
    avatarFg: Color(0xFF1A9A9A),
  ),
  AppUser(
    name: 'Ava Thompson',
    email: 'ava.t@example.com',
    role: UserRole.moderator,
    avatarBg: Color(0xFFF1E9FF),
    avatarFg: Color(0xFF8A4FE0),
  ),
];

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<AppUser> _users = List.of(kUsers);
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<AppUser> get _filtered {
    if (_query.isEmpty) return _users;
    final q = _query.toLowerCase();
    return _users
        .where((u) =>
    u.name.toLowerCase().contains(q) ||
        u.email.toLowerCase().contains(q))
        .toList();
  }

  Future<void> _refresh() async {
    // Replace with your API call.
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() => _users = List.of(kUsers));
  }

  @override
  Widget build(BuildContext context) {
    final users = _filtered;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _Header(onRefresh: _refresh),
              const SizedBox(height: 20),
              _SearchBar(
                controller: _searchController,
                onChanged: (v) => setState(() => _query = v.trim()),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refresh,
                  child: users.isEmpty
                      ? ListView(
                    children: const [
                      SizedBox(height: 80),
                      Center(
                        child: Text(
                          'No users found',
                          style: TextStyle(color: Color(0xFF8A94A6)),
                        ),
                      ),
                    ],
                  )
                      : ListView.separated(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: users.length,
                    separatorBuilder: (_, __) =>
                    const SizedBox(height: 10),
                    itemBuilder: (context, i) => UserTile(
                      user: users[i],
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(users[i].name)),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Widgets
// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  final VoidCallback onRefresh;
  const _Header({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Users',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Manage and browse all users',
                style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
              ),
            ],
          ),
        ),
        Material(
          color: const Color(0xFFE6EEFF),
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onRefresh,
            child: const SizedBox(
              width: 44,
              height: 44,
              child: Icon(Icons.sync_rounded,
                  color: Color(0xFF2F6BEA), size: 24),
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchBar({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 15, color: Color(0xFF111827)),
      decoration: InputDecoration(
        hintText: 'Search by name or email...',
        hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 15),
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: 12, right: 8),
          child: Icon(Icons.search_rounded, color: Color(0xFF374151)),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 44),
        filled: true,
        fillColor: const Color(0xFFEDF0F5),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class UserTile extends StatelessWidget {
  final AppUser user;
  final VoidCallback? onTap;

  const UserTile({super.key, required this.user, this.onTap});

  @override
  Widget build(BuildContext context) {
    final role = RoleStyle.of(user.role);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D101828), // ~5% black
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: user.avatarBg,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    user.initials,
                    style: TextStyle(
                      color: user.avatarFg,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Name + email
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        user.email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Role chip
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: role.bg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    role.label,
                    style: TextStyle(
                      color: role.fg,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.chevron_right_rounded,
                    color: Color(0xFF6B7280)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}