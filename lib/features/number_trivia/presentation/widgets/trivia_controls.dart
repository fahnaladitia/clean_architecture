import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/widgets.dart';
import '../bloc/number_trivia_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    super.key,
  });

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  late TextEditingController _triviaController;

  @override
  void initState() {
    super.initState();
    _triviaController = TextEditingController();
  }

  @override
  void dispose() {
    _triviaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // TextField
        TextField(
          controller: _triviaController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Input a number",
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: PrimaryButton(
                onPressed: () {
                  context.read<NumberTriviaBloc>().add(
                        GetTriviaForConcreteNumber(
                          number: _triviaController.text,
                        ),
                      );
                },
                text: 'Search',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SecondaryButton(
                onPressed: () {
                  context
                      .read<NumberTriviaBloc>()
                      .add(GetTriviaForRandomNumber());
                },
                text: 'Get random trivia',
              ),
            ),
          ],
        )
      ],
    );
  }
}
