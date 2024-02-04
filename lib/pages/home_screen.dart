import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_gemini_project/bloc/gemini_bloc.dart';
import 'package:google_gemini_project/models/prompt_message_model.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController messageQueryController = TextEditingController();
  GeminiBloc geminiBloc = GeminiBloc();

  @override
  void initState() {
    messageQueryController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<GeminiBloc, GeminiState>(
        bloc: geminiBloc,
        listener: (context, state) {},
        builder: (context, state) {
          switch (state.runtimeType) {
            case PromptSuccessState:
              List<PromptMessageModel> messages =
                  (state as PromptSuccessState).promptMessages;
              return Container(
                height: double.maxFinite,
                width: double.maxFinite,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        opacity: 0.5,
                        image: AssetImage("assets/images/space.jpg"),
                        fit: BoxFit.cover)),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      height: 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Gemini Prompt',
                            style: GoogleFonts.robotoMono(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          const Icon(Icons.image_search)
                        ],
                      ),
                    ),
                    Expanded(
                        child: messages.length > 0
                            ? ListView.builder(
                                itemCount: messages.length,
                                itemBuilder: (context, singleItem) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              blurRadius: 10.0,
                                              spreadRadius: 4.0)
                                        ],
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.black.withOpacity(0.3)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          messages[singleItem].role == "user"
                                              ? "You"
                                              : "Gemini AI",
                                          style: GoogleFonts.robotoMono(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  messages[singleItem].role ==
                                                          "user"
                                                      ? Color.fromARGB(
                                                          255, 0, 171, 206)
                                                      : Color.fromARGB(
                                                          255, 209, 0, 98)),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          messages[singleItem].parts.first.text,
                                          style: GoogleFonts.inter(
                                              fontSize: 15,
                                              fontStyle:
                                                  messages[singleItem].role ==
                                                          "user"
                                                      ? FontStyle.italic
                                                      : FontStyle.normal),
                                        ),
                                      ],
                                    ),
                                  );
                                })
                            : Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Text(
                                    'Ask your queries to Gemini!',
                                    style: GoogleFonts.robotoMono(
                                        fontSize: 20,
                                        color: Colors.white.withOpacity(0.7)),
                                  ),
                                ),
                              )),
                    if (geminiBloc.generatingPrompt)
                      Row(
                        children: [
                          Container(
                              height: 100,
                              width: 100,
                              child:
                                  Lottie.asset('assets/loaders/loader.json')),
                          Text(
                            'Loading...',
                            style: GoogleFonts.robotoMono(
                                fontSize: 20,
                                color: Colors.white.withOpacity(0.7)),
                          )
                        ],
                      ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.white.withOpacity(0.4),
                                      blurRadius: 10.0,
                                      spreadRadius: 2.0)
                                ]),
                            child: TextField(
                              controller: messageQueryController,
                              style:
                                  GoogleFonts.robotoMono(color: Colors.white),
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                  hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.4)),
                                  hintText: "Ask Gemini Prompt...",
                                  filled: true,
                                  fillColor:
                                      const Color.fromARGB(255, 23, 23, 23)
                                          .withOpacity(0.4),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40),
                                      borderSide: const BorderSide(
                                          color: Color.fromARGB(
                                              255, 74, 74, 74)))),
                            ),
                          )),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              if (messageQueryController.text.isNotEmpty) {
                                String text = messageQueryController.text;
                                messageQueryController.clear();
                                geminiBloc.add(SendMessageToPromptEvent(
                                    inputMessageQuery: text));
                              }
                            },
                            child: const CircleAvatar(
                              backgroundColor: Colors.white54,
                              radius: 31,
                              child: CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(255, 23, 23, 23),
                                radius: 30,
                                child: Center(
                                  child: Icon(
                                    Icons.start_rounded,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );

            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
