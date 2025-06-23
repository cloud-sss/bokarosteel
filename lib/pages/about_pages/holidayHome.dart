// ignore_for_file: file_names

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bseccs/models/masterModel.dart';
import 'package:bseccs/models/sharedPrefModel.dart';

class HolidayHomeList extends StatefulWidget {
  @override
  State<HolidayHomeList> createState() => _HolidayHomeListState();
}

class _HolidayHomeListState extends State<HolidayHomeList> {
  final List<HolidayHome> holidayHomes = [];
  String bankId = sharedPrefModel.getUserData('bank_id');

  final baseUrl = MasterModel.BaseUrl;

  // @override
  // void initState() {
  //   super.initState();
  //   getHolidayHomeList();
  // }

  getHolidayHomeList() async {
    var map = <String, dynamic>{};
    map['bank_id'] = bankId;
    var resDt =
        await MasterModel.globalApiCall(1, '/get_holiday_home_list', map);
    // print(resDt);
    resDt = jsonDecode(resDt.body);
    if (resDt['suc'] > 0) {
      for (final dt in resDt['msg']) {
        holidayHomes.add(HolidayHome(
          name: dt['HOME_NAME'],
          location: dt['LOCATION'],
          price: '\u{20B9} ${dt["PRICE"]}',
          rating: dt['RATING'],
          imageUrl: '$baseUrl/${dt['HOME_IMG']}',
          description: dt['DESCRIPTION'],
          propertyDetails: PropertyDetails(
            beds: dt['NO_OF_BED'],
            baths: dt['NO_OF_BATH'],
            area: dt['ROOM_SIZE'],
            floor: dt['NO_OF_FLOORS'],
          ),
        ));
      }
      // data = resDt['msg'];
    }
  }

  // final List<HolidayHome> holidayHomes = [
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Trending Stays'),
        ),
        body: FutureBuilder(
            future: getHolidayHomeList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // dialogModel.showLoading();
                return const Column();
              } else {
                if (holidayHomes.isNotEmpty) {
                  return ListView.builder(
                    itemCount: holidayHomes.length,
                    itemBuilder: (context, index) {
                      return HolidayHomeCard(
                          holidayHome: holidayHomes[index],
                          index: index,
                          holidayHomes: holidayHomes);
                    },
                  );
                } else {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'No data found.',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  );
                }
              }
            }));
  }
}

class HolidayHome {
  final String name;
  final String location;
  final String price;
  final double rating;
  final String imageUrl;
  final String description;
  final PropertyDetails propertyDetails;

  HolidayHome({
    required this.name,
    required this.location,
    required this.price,
    required this.rating,
    required this.imageUrl,
    required this.description,
    required this.propertyDetails,
  });
}

class PropertyDetails {
  final int beds;
  final int baths;
  final int area;
  final int floor;

  PropertyDetails({
    required this.beds,
    required this.baths,
    required this.area,
    required this.floor,
  });
}

class HolidayHomeCard extends StatelessWidget {
  final HolidayHome holidayHome;
  final int index;
  final List<HolidayHome> holidayHomes;

  HolidayHomeCard(
      {required this.holidayHome,
      required this.index,
      required this.holidayHomes});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HolidayHomeDetailsPage(
              holidayHomes: holidayHomes,
              initialIndex: index,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: holidayHome.imageUrl,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    holidayHome.name,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(holidayHome.location),
                  const SizedBox(height: 4.0),
                  Text(holidayHome.price),
                  const SizedBox(height: 4.0),
                  Row(
                    children: <Widget>[
                      const Icon(Icons.star, color: Colors.yellow, size: 16.0),
                      const SizedBox(width: 4.0),
                      Text(holidayHome.rating.toString()),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HolidayHomeDetailsPage extends StatelessWidget {
  final List<HolidayHome> holidayHomes;
  final int initialIndex;

  HolidayHomeDetailsPage(
      {required this.holidayHomes, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: PageController(initialPage: initialIndex),
        itemCount: holidayHomes.length,
        itemBuilder: (context, index) {
          return HolidayHomeDetailView(holidayHome: holidayHomes[index]);
        },
      ),
    );
  }
}

class HolidayHomeDetailView extends StatelessWidget {
  final HolidayHome holidayHome;

  HolidayHomeDetailView({required this.holidayHome});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: [
              CachedNetworkImage(
                imageUrl: holidayHome.imageUrl,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 40,
                left: 20,
                child: CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  holidayHome.name,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  '${holidayHome.location} - ${holidayHome.price}',
                  style: const TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  holidayHome.description,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Property Details',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    PropertyDetailItem(
                      icon: Icons.king_bed,
                      label: '${holidayHome.propertyDetails.beds} beds',
                    ),
                    PropertyDetailItem(
                      icon: Icons.bathtub,
                      label: '${holidayHome.propertyDetails.baths} bath',
                    ),
                    PropertyDetailItem(
                      icon: Icons.square_foot,
                      label: '${holidayHome.propertyDetails.area} m²',
                    ),
                    PropertyDetailItem(
                      icon: Icons.layers,
                      label: '${holidayHome.propertyDetails.floor} Floor',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PropertyDetailItem extends StatelessWidget {
  final IconData icon;
  final String label;

  PropertyDetailItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Icon(icon, size: 30.0),
        const SizedBox(height: 4.0),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }
}
