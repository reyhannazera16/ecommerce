import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:fradel_spies/models/data/user_model.dart';
import 'package:fradel_spies/providers/user_provider.dart';
import 'package:fradel_spies/utilities/common_widget_utility.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _user;
  bool _isEdit = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _onPostFrameInit());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: RefreshIndicator(
        onRefresh: _onPostFrameInit,
        child: ListView(
          children: <Widget>[
            Consumer<UserProvider>(
              builder: (_, UserProvider userProvider, ___) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: !userProvider.isLoading ? 0 : null,
                  child: const LinearProgressIndicator(),
                );
              },
            ),
            ListTile(
              title: const Text('Edit Profile'),
              trailing: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: !_isEdit
                    ? FilledButton.tonal(
                        onPressed: () => setState(() => _isEdit = true),
                        child: const Icon(Icons.edit_outlined),
                      )
                    : FilledButton.tonal(
                        onPressed: () => setState(() => _isEdit = false),
                        child: const Icon(Icons.close_outlined),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Card.filled(
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    InkWell(
                      onTap: () =>
                          _onWantEdit(id: 'name', value: '${_user?.name}'),
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      child: ListTile(
                        leading: const Icon(Icons.person_outlined),
                        title: const Text('Nama'),
                        subtitle: Skeletonizer(
                          enabled: _user == null,
                          child: Text('${_user?.name}'),
                        ),
                      ),
                    ),
                    Divider(
                        height: 1,
                        thickness: 1,
                        color: Theme.of(context).colorScheme.surface),
                    InkWell(
                      onTap: () =>
                          _onWantEdit(id: 'email', value: '${_user?.email}'),
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      child: ListTile(
                        leading: const Icon(Icons.email_outlined),
                        title: const Text('Email'),
                        subtitle: Skeletonizer(
                          enabled: _user == null,
                          child: Text('${_user?.email}'),
                        ),
                      ),
                    ),
                    Divider(
                        height: 1,
                        thickness: 1,
                        color: Theme.of(context).colorScheme.surface),
                    InkWell(
                      onTap: () => _onWantEdit(
                          id: 'password', value: '${_user?.password}'),
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      child: ListTile(
                        leading: const Icon(Icons.password_outlined),
                        title: const Text('Password'),
                        subtitle: Skeletonizer(
                          enabled: _user == null,
                          child: const Text('********'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: !_isEdit ? 0 : null,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: FilledButton.icon(
                  onPressed: () async {
                    if (_user != null) {
                      final userProvider =
                          Provider.of<UserProvider>(context, listen: false);
                      await userProvider.updateUser(_user!);
                    }
                  },
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Save'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _onPostFrameInit() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.fetchUser();
    setState(() {
      _user = userProvider.user;
    });
  }

  void _onWantEdit({required String id, required String value}) async {
    final data =
        await CommonWidgetUtility.showEditDialog<String>(id: id, value: value);
    if (data != null && data != value) {
      setState(() {
        if (id == 'name') {
          _user?.name = data;
        } else if (id == 'email') {
          _user?.email = data;
        } else if (id == 'password') {
          _user?.password = data;
        }
      });
    }
  }
}
