// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:cyberx/CyberX%20ChatBot/BardAIControllerr.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    BardAIController controller = Get.put(BardAIController());
    TextEditingController textField = TextEditingController();
    return Scaffold(
      // backgroundColor: Color(0xfff2f1f9),
      appBar: AppBar(
        centerTitle: true,

        title: const Text(
          "CyberX-ChatBot",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
        ),
        // backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                controller.sendPrompt("Start");
              },
              icon: Icon(Icons.security))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
                child: ListView(
              children: [
                Obx(() => Column(
                      children: controller.historyList
                          .map(
                            (e) => Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              decoration: BoxDecoration(
                                // color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Text(e.system == "user" ? "👨‍💻" : "🤖"),
                                  SizedBox(width: 10),
                                  Flexible(child: Text(e.message)),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ))
              ],
            )),
            Container(
              decoration: BoxDecoration(
                // color: Colors.blueAccent.withOpacity(0.5),
                borderRadius: BorderRadius.circular(30),
              ),
              height: 60,
              child: Row(children: [
                Expanded(
                  child: TextFormField(
                    controller: textField,
                    decoration: InputDecoration(
                        hintText: "Ask to Cyber-X.....",
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30))),
                  ),
                ),
                Obx(
                  () => controller.isLoading.value
                      ? CircularProgressIndicator()
                      : IconButton(
                          onPressed: () {
                            if (textField.text != "") {
                              controller.sendPrompt(textField.text);
                              textField.clear();
                            }
                          },
                          icon: Icon(
                            Icons.send,
                            // color: Colors.black,
                          )),
                ),
                SizedBox(width: 10)
              ]),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
