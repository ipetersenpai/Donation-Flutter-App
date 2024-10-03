import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ABOUT',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Caritas Tarlac',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                '          Caritas Tarlac has been active since 2018, and it is a social action form of the Diocese of Tarlac. It was originally called Caritas San Sebastian because it is based in San Sebastian Tarlac, but it was later renamed Caritas Tarlac because the director and bishop saw that it was good to make its own identity in every diocese, so they called it Caritas Tarlac.',
                style: TextStyle(
                  fontSize: 16.0,
                  height: 1.5, // Adjust the height for better readability
                  wordSpacing: 2.0, // Add word spacing
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'The Church has three activities: formation, prayer, and service, and Caritas Tarlac falls within the category of service, which is why it is the Diocese\'s social action form. Caritas in the Philippines is not limited to just one; there is Caritas Manila, Caritas Pampanga, and others. The different Caritas support each other whenever they need help. The primary source of finances for these social action forms is the generosity of individuals, various parishes, and a coin bank located in various locations. Caritas Manila, Caritas Tarlac, etc. is the bridge between generous people and those in need.',
                style: TextStyle(
                  fontSize: 16.0,
                  height: 1.5,
                  wordSpacing: 2.0,
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'The Caritas Tarlac has seven legacy programs:',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                '1. Alay Kapwa para sa Karunungan (Wisdom)\n'
                '2. Alay Kapwa para sa Kalusugan (Health)\n'
                '3. Alay Kapwa para sa Kalamidad (Calamity)\n'
                '4. Alay kapwa para sa Kasanayan (Skills)\n'
                '5. Alay kapwa para sa Kabuhayan (Livelihood)\n'
                '6. Alay kapwa para sa Kalikasan (Nature)\n'
                '7. Alay kapwa para sa Katarungan (Justice)',
                style: TextStyle(
                  fontSize: 16.0,
                  height: 1.5,
                  wordSpacing: 2.0,
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                '          According to the Coordinator, Caritas does not have large money; instead, they rely on kind people and other Caritas to aid; they serve as a bridge, finding beneficiaries for the generous people.',
                style: TextStyle(
                  fontSize: 16.0,
                  height: 1.5,
                  wordSpacing: 2.0,
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'Other Caritas Pampanga has a staff of fifty, Caritas Manila has a staff of 300, and Caritas Tarlac has only 6 staff, including the Director, Rev. Fr. Randy Salunga. The Coordinator is Bro. Crisberto Salvador. Other Caritas have different coordinators for different legacies, but Caritas Tarlac only has one Coordinator for Seven Legacy. Thus, based on their stories and experience, they definitely need a system, and it will be useful to them in terms of report creation and receipt. This system will help its staffing shortage and make it easier for them to handle the 7 Legacy, as well as generate awareness that there is an existing social action form in which you may be one of its contributors or one of the generous individuals.',
                style: TextStyle(
                  fontSize: 16.0,
                  height: 1.5,
                  wordSpacing: 2.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
