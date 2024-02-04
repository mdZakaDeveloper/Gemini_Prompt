part of 'gemini_bloc.dart';

@immutable
sealed class GeminiEvent {}


class SendMessageToPromptEvent extends GeminiEvent{
  final String inputMessageQuery;

  SendMessageToPromptEvent({required this.inputMessageQuery});
}