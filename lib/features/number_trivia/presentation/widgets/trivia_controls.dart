import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numbers_trivia_app/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:numbers_trivia_app/features/number_trivia/presentation/bloc/number_trivia_event.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key? key,
  }) : super(key: key);

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  final controller = TextEditingController();
  late String inputString;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
            hintText: 'Input a number',
            hintStyle: TextStyle(color: Colors.black54),
          ),
          onChanged: (value) {
            inputString = value;
          },
        ),
        const SizedBox(
          height: 10,
        ),
        _buildNumberTriviaButtons(),
        _buildExtraTriviaButtons(),
      ],
    );
  }

  Row _buildExtraTriviaButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  side: const BorderSide(color: Colors.deepOrange))),
              backgroundColor: MaterialStateProperty.all(Colors.deepOrange),
            ),
            onPressed: dispatchRandomDate,
            child: const Text('Get random date'),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  side: const BorderSide(color: Colors.deepOrange))),
              backgroundColor: MaterialStateProperty.all(Colors.deepOrange),
            ),
            onPressed: dispatchRandomYear,
            child: const Text('Get random year'),
          ),
        ),
      ],
    );
  }

  Row _buildNumberTriviaButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  side: const BorderSide(color: Colors.deepOrange))),
              backgroundColor: MaterialStateProperty.all(Colors.deepOrange),
            ),
            onPressed: dispatchConcrete,
            child: const Text('Search'),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  side: const BorderSide(color: Colors.deepOrange))),
              backgroundColor: MaterialStateProperty.all(Colors.deepOrange),
            ),
            onPressed: dispatchRandom,
            child: const Text('Get random trivia'),
          ),
        ),
      ],
    );
  }

  void dispatchConcrete() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForConcreteNumberEvent(inputString));
  }

  void dispatchRandom() {
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumberEvent());
  }

  void dispatchRandomYear() {
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomYearEvent());
  }

  void dispatchRandomDate() {
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomDateEvent());
  }
}
