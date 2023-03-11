import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../bloc/number_trivia_bloc.dart';
import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return BlocProvider(
      create: (context) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Top half
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is NumberTriviaEmpty) {
                    return const MessageDisplay(message: "Start searching!");
                  }
                  if (state is NumberTriviaError) {
                    return MessageDisplay(message: state.message);
                  }
                  if (state is NumberTriviaLoading) {
                    return const LoadingWidget();
                  }
                  if (state is NumberTriviaLoaded) {
                    return TriviaDisplay(numberTrivia: state.numberTrivia);
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 20),
              // Bottom half
              Column(
                children: [
                  // TextField
                  const Placeholder(fallbackHeight: 40),
                  const SizedBox(height: 10),
                  Row(
                    children: const [
                      Expanded(child: Placeholder(fallbackHeight: 30)),
                      SizedBox(width: 10),
                      Expanded(child: Placeholder(fallbackHeight: 30)),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
