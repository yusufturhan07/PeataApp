import 'package:flutter/material.dart';
import 'package:mvc_uygun_peata_proje/controllers/profile_controller.dart';
import 'package:mvc_uygun_peata_proje/utils/global.dart';
import 'package:mvc_uygun_peata_proje/views/profile/add_adoption_screen.dart';
import 'package:mvc_uygun_peata_proje/views/profile/profile_myads_detail.dart';
import 'package:provider/provider.dart';
import 'package:loading_animations/loading_animations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ProfileController>(
        builder: (context, controller, child) {
          return Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Text(
                  "Name: ${controller.user.displayName}",
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  "Email: ${controller.user.email}",
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all<Size>(
                              const Size(170, 40)),
                          backgroundColor: MaterialStateProperty.all<Color?>(
                              colorPeataYesili),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddAdoptionPage()),
                          );
                        },
                        child: const Text(
                          'Add Adoption Ad',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all<Size>(
                              const Size(170, 40)),
                          backgroundColor: MaterialStateProperty.all<Color?>(
                              colorPeataYesili),
                        ),
                        onPressed: null,
                        child: const Text(
                          'Add Lost Ad',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'My Ads',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                controller.petList.isEmpty
                    ? Center(
                        child: LoadingBouncingGrid.square(
                          size: 50,
                          backgroundColor: Colors.blue,
                        ),
                      )
                    : Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            await controller.fetchPetList();
                          },
                          child: ListView.builder(
                            itemCount: controller.petList.length,
                            itemBuilder: (context, index) {
                              final pet = controller.petList[index];
                              return ListTile(
                                leading: SizedBox(
                                  width: 150,
                                  height: 200,
                                  child: Image.network(
                                    pet.image,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Text(":("),
                                  ),
                                ),
                                title: Text(pet.name),
                                subtitle: Text(pet.age),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    controller.deleteAd(pet.adId);
                                  },
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfileMyAdsDetail(
                                        name: pet.name,
                                        description: pet.description,
                                        image: pet.image,
                                        ad_id: pet.adId,
                                        userToken: controller.user.userToken,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
