part of 'gemini_bloc.dart';

@immutable
sealed class GeminiState {}

final class GeminiInitial extends GeminiState {}

class PromptSuccessState extends GeminiState{
  final List<PromptMessageModel> promptMessages;

  PromptSuccessState({required this.promptMessages});
}

