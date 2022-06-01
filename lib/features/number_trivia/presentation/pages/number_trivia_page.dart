import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numbers_trivia_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:numbers_trivia_app/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:numbers_trivia_app/features/number_trivia/presentation/bloc/number_trivia_state.dart';
import 'package:numbers_trivia_app/injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: BlocProvider(
          create: (_) => serviceLocator<NumberTriviaBloc>(), child: _buildBody(context)),
    );
  }

  Center _buildBody(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
              builder: (BuildContext context, state) {
                if (state is Empty) {
                  return const MessageDisplay(
                    message: 'Start searching!',
                  );
                } else if (state is Loading) {
                  return const LoadingWidget();
                } else if (state is Loaded) {
                  return TriviaDisplay(trivia: state.trivia);
                } else if (state is Error) {
                  return MessageDisplay(
                    message: state.message,
                  );
                }
                return Container();
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Placeholder(
                  fallbackHeight: 40,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Placeholder(
                        fallbackHeight: 30,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Placeholder(
                        fallbackHeight: 30,
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class TriviaDisplay extends StatelessWidget {
  final NumberTrivia trivia;
  const TriviaDisplay({
    Key? key,
    required this.trivia,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: [
          Text(
            trivia.number.toString(),
            style: const TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Text(
                  trivia.text,
                  style: const TextStyle(
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
