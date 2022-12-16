import 'package:flutter/material.dart';
import 'package:zap_player/controller/song_controller.dart';
import 'package:zap_player/db/functions/playlist_db.dart';

class Settings extends StatelessWidget {
  Settings({super.key});
  final List<String> names = ['About', 'Privacy Policy', 'Reset'];

  final List<String> leading = [
    'assets/images/about_us_logo.png',
    'assets/images/privacy_policy_logo (2).png',
    'assets/images/reset_app_logo.png'
  ];

  @override
  Widget build(BuildContext context) {
    List<void Function()> function = [
      () {
        showDialog(
          context: context,
          builder: ((BuildContext context) {
            return const AlertDialog(
              backgroundColor: Colors.lightBlue,
              title: Text(
                'Zap Player',
                style: TextStyle(color: Colors.white),
              ),
              content: Text(
                '''
Welcome to Zap Player, 
your number one source for all Music. We're dedicated to provide you the best of Music, with a focus on dependability and customer service.
We're working to turn our passion for music into a booming Music Player. We hope you enjoy our Music as much as we enjoy offering them to you.
Sincerely,
Shijin Thottyil
email:shijinthottiyil@gmail.com
''',
                style: TextStyle(color: Colors.white),
              ),
            );
          }),
        );
      },
      () {
        showDialog(
            context: context,
            builder: ((context) {
              return const SingleChildScrollView(
                child: AlertDialog(
                  backgroundColor: Colors.lightBlue,
                  title: Text(
                    'Privacy Policy',
                    style: TextStyle(color: Colors.white),
                  ),
                  content: Text(
                    '''Welcome to Zap Player!
These terms and conditions outline the rules and regulations for the use of Zap Player.By using this app we assume you accept these terms and conditions. Do not continue to use Zap Player if you do not agree to take all of the terms and conditions stated on this page.The following terminology applies to these Terms and Conditions, Privacy Statement and Disclaimer Notice and all Agreements: "Client", "You" and "Your" refers to you, the person log on this website and compliant to the Company’s terms and conditions. "The Company", "Ourselves", "We", "Our" and "Us", refers to our Company. "Party", "Parties", or "Us", refers to both the Client and ourselves. All terms refer to the offer, acceptance and consideration of payment necessary to undertake the process of our assistance to the Client in the most appropriate manner for the express purpose of meeting the Client’s needs in respect of provision of the Company’s stated services, in accordance with and subject to, prevailing law of Netherlands. Any use of the above terminology or other words in the singular, plural, capitalization and/or he/she or they, are taken as interchangeable and therefore as referring to same. Our Terms and Conditions were created with the help of the App Terms and Conditions Generator from App-Privacy-Policy.comLicenseUnless otherwise stated, Zap Player and/or its licensors own the intellectual property rights for all material on Zap Player. All intellectual property rights are reserved. You may access this from Zap Player for your own personal use subjected to restrictions set in these terms and conditions.

You must not:
•Republish material from Zap PlayerSell
•Rent or sub-license material from Zap Player
•Reproduce, duplicate or copy material from Zap PlayerRedistribute content from Zap Player''',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            }));
      },
      () {
        showDialog(
          context: context,
          builder: ((context) {
            return AlertDialog(
              title: const Text(
                '!',
                style: TextStyle(color: Colors.red),
              ),
              content: const Text(
                'Do you really want to Reset App?',
                style: TextStyle(color: Colors.white),
              ),
              actionsAlignment: MainAxisAlignment.spaceAround,
              actions: [
                IconButton(
                  onPressed: (() {
                    Navigator.pop(context);
                  }),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: (() {
                    PlayListDB.resetAPP(context);
                    GetSongs.player.stop();
                  }),
                  icon: const Icon(
                    Icons.done,
                    color: Colors.white,
                  ),
                )
              ],
              backgroundColor: Colors.lightBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.05),
              ),
            );
          }),
        );
      }
    ];
    return SafeArea(
      child: Scaffold(
        body: ListView.separated(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: Image.asset(
                leading[index],
                height: MediaQuery.of(context).size.height * 0.05,
                color: Colors.white,
              ),
              title: Text(
                names[index],
                style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width * 0.035),
              ),
              onTap: function[index],
            );
          },
          itemCount: names.length,
          separatorBuilder: (context, index) {
            return const Divider(
              color: Colors.white,
            );
          },
        ),
        bottomNavigationBar: Text(
          'V 1.0.0',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.width * 0.025),
        ),
      ),
    );
  }
}
