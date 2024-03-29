import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  static final String routeName = 'info_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Info",
        ),
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              Text(
                "Terms and Conditions",
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                '''

By downloading or using the app, these terms will automatically apply to you – you should make sure therefore that you read them carefully before using the app. You’re not allowed to copy, or modify the app, any part of the app, or our trademarks in any way. You’re not allowed to attempt to extract the source code of the app, and you also shouldn’t try to translate the app into other languages, or make derivative versions. The app itself, and all the trade marks, copyright, database rights and other intellectual property rights related to it, still belong to Obey International.

Obey International is committed to ensuring that the app is as useful and efficient as possible. For that reason, we reserve the right to make changes to the app or to charge for its services, at any time and for any reason. We will never charge you for the app or its services without making it very clear to you exactly what you’re paying for.

The app does use third party services that declare their own Terms and Conditions.

Link to Terms and Conditions of third party service providers used by the app

*   [Google Play Services](https://policies.google.com/terms)
*   [Google Analytics for Firebase](https://firebase.google.com/terms/analytics)

You should be aware that there are certain things that Obey International will not take responsibility for. Certain functions of the app will require the app to have an active internet connection. The connection can be Wi-Fi, or provided by your mobile network provider, but Obey International cannot take responsibility for the app not working at full functionality if you don’t have access to Wi-Fi, and you don’t have any of your data allowance left.

If you’re using the app outside of an area with Wi-Fi, you should remember that your terms of the agreement with your mobile network provider will still apply. As a result, you may be charged by your mobile provider for the cost of data for the duration of the connection while accessing the app, or other third party charges. In using the app, you’re accepting responsibility for any such charges, including roaming data charges if you use the app outside of your home territory (i.e. region or country) without turning off data roaming. If you are not the bill payer for the device on which you’re using the app, please be aware that we assume that you have received permission from the bill payer for using the app.

Along the same lines, Obey International cannot always take responsibility for the way you use the app i.e. You need to make sure that your device stays charged – if it runs out of battery and you can’t turn it on to avail the Service, Obey International cannot accept responsibility.

With respect to Obey International’s responsibility for your use of the app, when you’re using the app, it’s important to bear in mind that although we endeavour to ensure that it is updated and correct at all times, we do rely on third parties to provide information to us so that we can make it available to you. Obey International accepts no liability for any loss, direct or indirect, you experience as a result of relying wholly on this functionality of the app.

''',
              ),
              Text(
                "Privacy Policy",
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                '''

The Bcard app does not store and processes personal data that you have provided to us, in order to provide our Service. The personal data that yu provide is entirely stored and proccessed offline in your device itself. It’s your responsibility to keep your phone and access to the app secure. We therefore recommend that you do not jailbreak or root your phone, which is the process of removing software restrictions and limitations imposed by the official operating system of your device. It could make your phone vulnerable to malware/viruses/malicious programs, compromise your phone’s security features and it could mean that the Bcard app won’t work properly or at all.
                
                ''',
              ),
            ],
          )),
    );
  }
}
