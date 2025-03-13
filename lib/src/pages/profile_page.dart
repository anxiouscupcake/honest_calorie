/* Honest Calorie, an open-source nutrition tracker
Copyright (C) 2025 Nicole Zubina

Full notice can be found at /lib/main.dart file. */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:honest_calorie/src/common/constants.dart';
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
                  ? "Your BMI is ${profile.getBMI()}"
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
              onTap: () async {},
            ),
            ListTile(
              leading: const Icon(Icons.cake_outlined),
              title: const Text("Age"),
              subtitle: Text(profile.getAge() != null
                  ? "${profile.getAge()} years old"
                  : "Unset"),
              onTap: () async {
                DateTime? birthDate = await showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    lastDate: DateTime(3000),
                    currentDate: profile.dateOfBirth,
                    helpText: "Select your birth date");
                if (birthDate != null) {
                  setState(() => profile.dateOfBirth = birthDate);
                }
              },
            ),
            ListTile(
              leading: Icon(profile.getGenderIconData()),
              title: const Text("Gender"),
              subtitle: Text(profile.getGenderName()),
              onTap: () async {
                String? selectedGender = await showDialog<String>(
                  context: context,
                  builder: (context) => SimpleDialog(
                    title: const Text("Select your gender"),
                    children: [
                      SimpleDialogOption(
                        child: const Text("Female"),
                        onPressed: () {
                          Navigator.pop<String>(context, GENDER_FEMALE);
                        },
                      ),
                      SimpleDialogOption(
                        child: const Text("Male"),
                        onPressed: () {
                          Navigator.pop<String>(context, GENDER_MALE);
                        },
                      ),
                      SimpleDialogOption(
                        child: const Text("Rather not say"),
                        onPressed: () {
                          Navigator.pop<String>(context, null);
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
