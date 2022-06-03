import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numbers_trivia_app/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:numbers_trivia_app/features/number_trivia/presentation/bloc/number_trivia_state.dart';
import 'package:numbers_trivia_app/features/number_trivia/presentation/widgets/loading_widget.dart';
import 'package:numbers_trivia_app/features/number_trivia/presentation/widgets/message_display.dart';
import 'package:numbers_trivia_app/features/number_trivia/presentation/widgets/trivia_controls.dart';
import 'package:numbers_trivia_app/features/number_trivia/presentation/widgets/trivia_display.dart';
import 'package:numbers_trivia_app/injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.deepOrange,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
        title: const Text('Number Trivia'),
      ),
      body: BlocProvider(
          create: (_) => serviceLocator<NumberTriviaBloc>(), child: _buildBody(context)),
    );
  }

  Center _buildBody(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
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
            const TriviaControls(),
          ],
        ),
      ),
    );
  }
}
