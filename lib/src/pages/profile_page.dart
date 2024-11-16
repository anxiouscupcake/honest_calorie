/* Honest Calorie, an open-source nutrition tracker
Copyright (C) 2024 Roman Zubin

Full notice can be found at /lib/main.dart file. */

import 'package:flutter/material.dart';
import 'package:honest_calorie/src/models/profile_model.dart';
import 'package:honest_calorie/src/types/profile.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileModel profileModel;
  late Profile profile;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    profileModel = Provider.of<ProfileModel>(context);
    profile = profileModel.profile;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Container(
              height: 96,
              color: Colors.pink,
              child: const Center(
                child: Text("User photo"),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      profile.username,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    const Icon(
                      Icons.edit,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              trailing: const Icon(Icons.help_outline),
              title: const Text("Body mass index"),
              subtitle: Text(profile.getBMI() != null
                  ? profile.getBMI().toString()
                  : "Unknown"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.monitor_weight_outlined),
              title: const Text("Weight"),
              subtitle: Text(
                  profile.weight != null ? profile.weight.toString() : "Unset"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.height),
              title: const Text("Height"),
              subtitle: Text(
                  profile.height != null ? profile.height.toString() : "Unset"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(profile.getGenderIconData()),
              title: const Text("Gender"),
              subtitle: Text(profile.getGenderName()),
              onTap: () async {
                Gender? selectedGender = await showDialog<Gender>(
                  context: context,
                  builder: (context) => SimpleDialog(
                    title: const Text("Select your gender"),
                    children: [
                      SimpleDialogOption(
                        child: const Text("Female"),
                        onPressed: () {
                          Navigator.pop<Gender>(context, Gender.female);
                        },
                      ),
                      SimpleDialogOption(
                        child: const Text("Male"),
                        onPressed: () {
                          Navigator.pop<Gender>(context, Gender.male);
                        },
                      ),
                      SimpleDialogOption(
                        child: const Text("Rather not say"),
                        onPressed: () {
                          Navigator.pop<Gender>(context, null);
                        },
                      ),
                    ],
                  ),
                );
                setState(() => profile.gender = selectedGender);
              },
            ),
          ],
        ),
      ],
    );
  }
}
