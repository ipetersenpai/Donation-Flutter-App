import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                'assets/about/1.svg',
                width: MediaQuery.of(context).size.width,
                height: 400.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Caritas Tarlac serves as a vital bridge between generous donors and those in need, leveraging the collective support of various Caritas branches to make a meaningful impact. With a dedicated team led by Director Rev. Fr. Randy Salunga and Coordinator Bro. Crisberto Salvador, Caritas Tarlac continues to address diverse community needs through its comprehensive legacy programs.',
                style: TextStyle(
                  fontSize: 16.0,
                  height: 1.5, // Adjust the height for better readability
                  wordSpacing: 2.0, // Add word spacing
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'THE CARITAS TARLAC HAS SEVEN LEGACY PROGRAMS',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              SvgPicture.asset(
                'assets/about/2.svg',
                width: MediaQuery.of(context).size.width,
                height: 400.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Caritas Tarlac fosters educational growth by providing scholarships and financial assistance to students from seventh grade through college. They support current students with monthly stipends and essential learning tools, ensuring access to quality education and empowering youth to achieve their academic goals.',
                style: TextStyle(
                  fontSize: 16.0,
                  height: 1.5,
                  wordSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 20.0),
              SvgPicture.asset(
                'assets/about/3.svg',
                width: MediaQuery.of(context).size.width,
                height: 400.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20.0),
              const Text(
                'This legacy focuses on enhancing health and well-being by supporting persons with disabilities. Caritas Tarlac distributes necessary medicines sourced from the Department of Health and operates Saklay Cafe, which employs individuals with disabilities. Additionally, they conduct dental missions and bloodletting activities to promote community health',
                style: TextStyle(
                  fontSize: 16.0,
                  height: 1.5,
                  wordSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 20.0),
              SvgPicture.asset(
                'assets/about/4.svg',
                width: MediaQuery.of(context).size.width,
                height: 400.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Caritas Tarlac provides vital disaster relief by coordinating with other Caritas branches and charitable individuals to deliver essential commodities during emergencies. Whether responding to typhoons, fires, or other disasters, they ensure affected communities receive timely and effective assistance.',
                style: TextStyle(
                  fontSize: 16.0,
                  height: 1.5,
                  wordSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 20.0),
              SvgPicture.asset(
                'assets/about/6.svg',
                width: MediaQuery.of(context).size.width,
                height: 400.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Focused on promoting self-sufficiency, this program initiates projects like greenhouses and backyard gardens to create employment opportunities for those in need. Caritas Tarlac emphasizes human dignity by encouraging beneficiaries to contribute through work, fostering a sense of pride and independence.',
                style: TextStyle(
                  fontSize: 16.0,
                  height: 1.5,
                  wordSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 20.0),
              SvgPicture.asset(
                'assets/about/7.svg',
                width: MediaQuery.of(context).size.width,
                height: 400.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Committed to environmental sustainability, Caritas Tarlac organizes tree planting activities and clean-up drives. Participants, including scholars, engage in tree planting seminars and maintain Caritas facilities, promoting a greener and healthier environment for the community.',
                style: TextStyle(
                  fontSize: 16.0,
                  height: 1.5,
                  wordSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 20.0),
              SvgPicture.asset(
                'assets/about/8.svg',
                width: MediaQuery.of(context).size.width,
                height: 400.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20.0),
              const Text(
                'This legacy advocates for justice by supporting individuals and families facing injustices, such as cases of violence or discrimination. Caritas Tarlac provides assistance and solidarity to victims, ensuring that their voices are heard and their rights are upheld within the community.',
                style: TextStyle(
                  fontSize: 16.0,
                  height: 1.5,
                  wordSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 20.0),
              SvgPicture.asset(
                'assets/about/5.svg',
                width: MediaQuery.of(context).size.width,
                height: 400.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Dedicated to capacity building, this legacy offers training and seminars for Caritas Tarlac’s staff and volunteers. By enhancing their skills, including psychosocial support, Caritas ensures that their team is well-equipped to serve the community effectively and compassionately.',
                style: TextStyle(
                  fontSize: 16.0,
                  height: 1.5,
                  wordSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
