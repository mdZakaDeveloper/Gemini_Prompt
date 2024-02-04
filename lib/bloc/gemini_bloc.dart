import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:google_gemini_project/models/prompt_message_model.dart';
import 'package:google_gemini_project/repo/prompt_repo.dart';
import 'package:meta/meta.dart';

part 'gemini_event.dart';
part 'gemini_state.dart';

class GeminiBloc extends Bloc<GeminiEvent, GeminiState> {
  GeminiBloc() : super(PromptSuccessState(promptMessages: [])) {
    on<SendMessageToPromptEvent>(sendMessageToPromptEvent);
  }
  List<PromptMessageModel> promptMessages = [];
  bool generatingPrompt = false;

  FutureOr<void> sendMessageToPromptEvent(
      SendMessageToPromptEvent event, Emitter<GeminiState> emit) async {
    promptMessages.add(PromptMessageModel(
        role: 'user', parts: [PromptPartModel(text: event.inputMessageQuery)]));
    emit(PromptSuccessState(promptMessages: promptMessages));
    generatingPrompt = true;
    String generatedPrompt = await PromptRepo.promptGeneration(promptMessages);
    if (generatedPrompt.isNotEmpty) {
      promptMessages.add(PromptMessageModel(
          role: 'model', parts: [PromptPartModel(text: generatedPrompt)]));
      emit(PromptSuccessState(promptMessages: promptMessages));
    }
    generatingPrompt = false;
  }
}
