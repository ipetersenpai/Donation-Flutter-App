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
            color: Colors.black, // Set text color to contrast with background
          ),
        ),
        elevation: 0, // Remove shadow if needed
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About Us',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus lacinia odio vitae vestibulum. Phasellus consectetur, felis a facilisis vulputate, libero odio condimentum elit, eget laoreet mi eros nec turpis. Cras suscipit, lorem et tempus posuere, justo eros convallis eros, id pharetra sapien purus nec nisl. Fusce ultricies purus et dolor interdum, a pellentesque mauris fermentum.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'Curabitur vitae ante at velit scelerisque dignissim. Aliquam erat volutpat. Nulla facilisi. Donec in tortor ut elit consequat laoreet. Nam id lorem a magna auctor varius. Sed id vestibulum nisi, a aliquet sapien. Mauris vehicula, ligula eget egestas tempor, purus lorem bibendum dui, non gravida tortor dui ut elit.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'Praesent ac sapien vel dolor lacinia accumsan non ac purus. Integer in nisi non nulla suscipit facilisis. Duis eu neque nec felis varius tristique. Ut euismod sapien nec ante bibendum gravida. Donec in felis eu elit venenatis sollicitudin. Integer vulputate gravida massa, eu vehicula purus cursus at.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'Sed dignissim, sapien at viverra cursus, nunc magna pharetra elit, sed accumsan magna quam nec felis. Suspendisse potenti. In varius, lacus id imperdiet pretium, ligula risus elementum sapien, sed pharetra lectus ante a urna. Curabitur ac libero est. Aenean euismod feugiat sem, vitae blandit lacus tincidunt nec.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'Nunc at nisi non lacus varius convallis. Phasellus volutpat sollicitudin magna, id dignissim orci posuere ut. Proin euismod ligula ac fermentum sodales. Duis quis augue sit amet mauris tincidunt accumsan. Maecenas ac enim in ligula venenatis luctus nec a arcu. Integer vitae nisi vel libero viverra bibendum.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'Aliquam erat volutpat. Cras pharetra arcu vitae velit pharetra, ac pharetra magna convallis. Nulla facilisi. Sed nec bibendum lorem. Fusce ac arcu vel urna vestibulum consectetur ut non lacus. Nam laoreet, mauris id dignissim facilisis, tortor felis sagittis eros, eget dignissim magna dolor et lorem.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'Phasellus nec tincidunt odio. Curabitur in velit sed orci efficitur gravida sit amet sed justo. Integer sed dui et lorem aliquet facilisis vel a lorem. Aliquam erat volutpat. Morbi eu elit ut mauris dictum fringilla non non purus. Donec quis sagittis sapien.',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
