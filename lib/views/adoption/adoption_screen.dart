// views/home_screen.dart
import 'package:flutter/material.dart';
import 'package:mvc_uygun_peata_proje/controllers/adoption_controller.dart';
import 'package:mvc_uygun_peata_proje/models/adoption_model.dart';
import 'package:mvc_uygun_peata_proje/views/adoption/adoption_detail_screen.dart';
import 'package:provider/provider.dart';

class AdoptionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdoptionController(),
      child: Scaffold(
        body: Consumer<AdoptionController>(
          builder: (context, controller, child) {
            return controller.adoptionItems.isEmpty
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: controller.fetchDataFromAPI,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: DropdownButton<String>(
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black.withOpacity(0.4),
                              ),
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontSize: 18,
                              ),
                              value: controller.selectedCity,
                              items: [...controller.citiesToFilter, 'All']
                                  .map((String city) {
                                return DropdownMenuItem<String>(
                                  value: city,
                                  child: Text(city),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  controller.setSelectedCity(newValue);
                                }
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: controller.adoptionItems.length,
                            itemBuilder: (context, index) {
                              AdoptionItem item =
                                  controller.adoptionItems[index];
                              if (!controller.shouldDisplayCity(item.city)) {
                                return SizedBox();
                              }
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AdoptionDetailPage(
                                        name: item.name,
                                        description: item.description,
                                        image: item.image,
                                      ),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                      child: Column(
                                        children: [
                                          Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: item.image.isNotEmpty
                                                  ? Image(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.2,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                          item.image),
                                                    )
                                                  : const SizedBox(
                                                      width: 200,
                                                      height: 150,
                                                      child: Icon(Icons.photo),
                                                    ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    item.name,
                                                    style: TextStyle(
                                                      fontSize: 19,
                                                      color: Colors.deepOrange,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 3.0),
                                                child: Text(
                                                  "Age: ${item.age}",
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.grey[900],
                                                  ),
                                                  textAlign: TextAlign.right,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              item.neighborhood,
                                              style: TextStyle(
                                                fontSize: 19,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(
                                      thickness: 2,
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }
}
