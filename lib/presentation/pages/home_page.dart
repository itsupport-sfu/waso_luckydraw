import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waso_ticket_system/presentation/bloc/select_bloc.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:waso_ticket_system/presentation/bloc/welcome_bloc.dart';

import '../../data/luck_person_model.dart';
import '../bloc/luck_bloc.dart';
import '../slot/slot_machine.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController animation;
  late Animation<double> _fadeInFadeOut;
  @override
  void initState() {
    ServicesBinding.instance.keyboard.addHandler(_onKey);
    animation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeInFadeOut = Tween<double>(begin: 1, end: 0).animate(animation);

    super.initState();
  }

  //handler key for every key press
  bool _onKey(KeyEvent event) {
    if (event is KeyUpEvent) {
      if (mounted) {
        if (event.logicalKey == LogicalKeyboardKey.keyQ) {
          context.read<WelcomeBloc>().add(ActionWelcomeEvent());
        }
        if (event.logicalKey == LogicalKeyboardKey.keyW) {
          print("1");
          context.read<SelectBloc>().add(SelectLuckDraw(1));
        }
        if (event.logicalKey == LogicalKeyboardKey.keyE) {
          print("2");
          context.read<SelectBloc>().add(SelectLuckDraw(2));
        }
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return BlocListener<WelcomeBloc, WelcomeState>(
      listener: (context, state) {
        if (state is WelcomeOpenState) {
          animation.forward();
        } else {
          animation.reverse();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        extendBody: true,
        body: SizedBox(
          width: deviceWidth,
          height: deviceHeight,
          child: FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(
              width: 1920,
              height: 1080,
              child: Stack(
                children: [
                  Image.asset(
                    "assets/lucky_draw.png",
                    width: 1920,
                    height: 1080,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    width: 1920,
                    height: 1080,
                    child: BlocConsumer<SelectBloc, SelectState>(
                      listener: (context, state) {
                        if (state.status == SelectStatus.loaded) {
                          context
                              .read<LuckBloc>()
                              .add(ShowLuckPeople(LuckPersonModel()));
                        }
                      },
                      builder: (context, sState) {
                        print(sState);
                        if (sState.status == SelectStatus.loading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return BlocConsumer<LuckBloc, LuckState>(
                          listener: (context, state) {},
                          builder: (context, state) {
                            if (state.status == LuckStatus.loading) {
                              return const SizedBox();
                            }
                            return ShowLuckyPerson(
                              selectState: sState.id ?? 0,
                              personList: state.personList ?? [],
                            );
                          },
                        );
                      },
                    ),
                  ),
                  FadeTransition(
                    opacity: _fadeInFadeOut,
                    child: Image.asset(
                      "assets/welcome_image.JPG",
                      width: 1920,
                      height: 1080,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ShowLuckyPerson extends StatefulWidget {
  final List<LuckPersonModel> personList;
  final int selectState;

  const ShowLuckyPerson(
      {super.key, required this.personList, required this.selectState});

  @override
  State<ShowLuckyPerson> createState() => _ShowLuckyPersonState();
}

class _ShowLuckyPersonState extends State<ShowLuckyPerson> {
  late SlotMachineController _controller;
  late ConfettiController _controllerTopCenter;

  List<LuckDrawModel> drawList = [
    LuckDrawModel(
        bottomCenter: "assets/car_lucky_draw.png",
        bottomLeft: "assets/grade.png",
        bottomRight: "assets/spin.png",
        header: "assets/kg_12_select.png"),
    LuckDrawModel(
        bottomCenter: "assets/car_lucky_draw.png",
        bottomLeft: "assets/language.png",
        bottomRight: "assets/spin.png",
        header: "assets/language_select.png"),
    LuckDrawModel(
        bottomCenter: "assets/car_lucky_draw.png",
        bottomLeft: "assets/car.png",
        bottomRight: "assets/spin.png",
        header: "assets/car_select.png"),
  ];

  @override
  void initState() {
    ServicesBinding.instance.keyboard.addHandler(_onKey);
    _controllerTopCenter =
        ConfettiController(duration: const Duration(seconds: 10));

    super.initState();
  }

  @override
  void dispose() {
    _controllerTopCenter.dispose();
    super.dispose();
  }

  bool _onKey(KeyEvent event) {
    if (event is KeyUpEvent) {
      if (mounted) {
        if (event.logicalKey == LogicalKeyboardKey.space) {
          _controller.stop(reelIndex: 0);
        }
        if (event.logicalKey == LogicalKeyboardKey.enter) {
          context.read<LuckBloc>().add(SelectLuckState());
          final index = Random().nextInt(widget.personList.length);
          _controller.start(hitRollItemIndex: index);
        }
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LuckBloc, LuckState>(
      listener: (context, state) {
        if (state.status == LuckStatus.selected) {
          _controllerTopCenter.play();
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Positioned(
              top: 485,
              left: 620,
              height: 90,
              width: 670,
              child: state.status == LuckStatus.selected
                  ? SizedBox(
                      width: 670,
                      height: 90,
                      child: Center(
                        child: Text(
                          state.person?.userCode ?? "",
                          style: const TextStyle(
                            fontSize: 30,
                            letterSpacing: 5,
                            color: Color(0xff6E0E00),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : SlotMachine(
                      width: 670,
                      height: 90,
                      rollItems: widget.personList
                          .asMap()
                          .entries
                          .map((e) => RollItem(
                              index: e.key,
                              child: SizedBox(
                                height: 80,
                                child: Center(
                                  child: Text(
                                    e.value.userCode ?? "",
                                    style: const TextStyle(
                                      fontSize: 30,
                                      letterSpacing: 5,
                                      color: Color(0xff6E0E00),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )))
                          .toList(),
                      multiplyNumberOfSlotItems: 1,
                      onCreated: (controller) {
                        _controller = controller;
                      },
                      onFinished: (resultIndexes) async {
                        await Future.delayed(const Duration(seconds: 2))
                            .whenComplete(() {
                          context.read<LuckBloc>().add(
                              ShowLuckPeople(widget.personList[resultIndexes]));
                        });
                      },
                    ),
            ),
            if (state.status == LuckStatus.selected)
              Positioned(
                top: 690,
                left: 736,
                height: 115,
                width: 345,
                child: Center(
                  child: Text(
                    state.person?.phone != null
                        ? "09XXXXX${state.person!.phone!.substring(
                            state.person!.phone!.length - 4,
                            state.person!.phone!.length,
                          )}"
                        : "",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 30,
                      color: Color(0xff6E0E00),
                    ),
                  ),
                ),
              ),
            if (state.status == LuckStatus.selected)
              Positioned(
                top: 690,
                left: 346,
                height: 115,
                width: 345,
                child: Center(
                  child: Text(
                    state.person?.name ?? "",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xff6E0E00),
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            if (state.status == LuckStatus.selected)
              Positioned(
                top: 690,
                left: 1125,
                height: 115,
                width: 435,
                child: Center(
                  child: Text(
                    state.person?.grade ?? "",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xff6E0E00),
                      fontSize: 30,
                    ),
                  ),
                ),
              ),

            //left bottom
            Positioned(
              left: widget.selectState != 1 ? 0 : -20,
              bottom: widget.selectState != 1 ? 0 : -20,
              child: MirrorAnimationBuilder<double>(
                tween: Tween(begin: 1, end: 0.95),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.linear,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: child,
                  );
                },
                child: Image.asset(
                  drawList[widget.selectState].bottomLeft ?? "",
                  width: 450,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            //header
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: MirrorAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 30),
                  duration: const Duration(milliseconds: 2000),
                  curve: Curves.linear,
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, value),
                      child: child,
                    );
                  },
                  child: Image.asset(
                    drawList[widget.selectState].header ?? "",
                    width: 1410,
                    height: 347,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Image.asset(
                  drawList[widget.selectState].bottomCenter ?? "",
                  width: 400,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Image.asset(
                drawList[widget.selectState].bottomRight ?? "",
                width: 400,
                fit: BoxFit.contain,
              ),
            ),
            // if (state.status == LuckStatus.selected)
            //   Lottie.asset(
            //     "assets/confetti.json",
            //     width: 1920,
            //     height: 1080,
            //     fit: BoxFit.contain,
            //   ),
            // if (state.status == LuckStatus.selected)
            //   Lottie.asset(
            //     "assets/confetti_2.json",
            //     width: 1920,
            //     height: 1080,
            //     fit: BoxFit.contain,
            //   ),
            if (state.status == LuckStatus.selected)
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding: EdgeInsets.only(top: 50),
                  height: double.infinity,
                  child: ConfettiWidget(
                    blastDirection: 2500,
                    confettiController: _controllerTopCenter,
                    blastDirectionality: BlastDirectionality
                        .explosive, // don't specify a direction, blast randomly
                    numberOfParticles: 20,
                    shouldLoop:
                        true, // start again as soon as the animation is finished
                    colors: const [
                      Colors.green,
                      Colors.blue,
                      Colors.pink,
                      Colors.orange,
                      Colors.purple
                    ], // manually specify the colors to be used
                  ),
                ),
              ),
            if (state.status == LuckStatus.selected)
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  padding: const EdgeInsets.only(left: 300.0, top: 50),
                  height: double.infinity,
                  margin: EdgeInsets.only(top: 100.0),
                  child: ConfettiWidget(
                    blastDirection: 1500,
                    numberOfParticles: 20,

                    confettiController: _controllerTopCenter,
                    blastDirectionality: BlastDirectionality
                        .explosive, // don't specify a direction, blast randomly
                    shouldLoop:
                        true, // start again as soon as the animation is finished
                    colors: const [
                      Colors.green,
                      Colors.blue,
                      Colors.pink,
                      Colors.orange,
                      Colors.purple
                    ], // manually specify the colors to be used
                  ),
                ),
              ),
            if (state.status == LuckStatus.selected)
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: const EdgeInsets.only(right: 300.0, top: 50),
                  height: double.infinity,
                  child: ConfettiWidget(
                    blastDirection: 1500,
                    numberOfParticles: 20,

                    confettiController: _controllerTopCenter,
                    blastDirectionality: BlastDirectionality
                        .explosive, // don't specify a direction, blast randomly
                    shouldLoop:
                        true, // start again as soon as the animation is finished
                    colors: const [
                      Colors.green,
                      Colors.blue,
                      Colors.pink,
                      Colors.orange,
                      Colors.purple
                    ], // manually specify the colors to be used
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class LuckDrawModel {
  final String? header, bottomLeft, bottomRight, bottomCenter;

  LuckDrawModel(
      {this.header, this.bottomLeft, this.bottomRight, this.bottomCenter});
}
