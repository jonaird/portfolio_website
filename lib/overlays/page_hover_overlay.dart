// import '../main.dart';

// class PageHoverOverlay extends StatelessWidget {
//   const PageHoverOverlay({super.key});

//   void onPress(Destination destination, BuildContext context) {
//     context.read<AppViewModel>()!.destination.value = destination;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(children: [
//           GestureDetector(
//             onTap: () => onPress(Destinations.aboutMe, context),
//             child: const PageHoverDetail(text: "About Me"),
//           ),
//           GestureDetector(
//             onTap: () => onPress(Destinations.experience, context),
//             child: const PageHoverDetail(text: "Experience"),
//           ),
//         ]),
//         Row(children: [
//           GestureDetector(
//             onTap: () => onPress(Destinations.projects, context),
//             child: const PageHoverDetail(text: "Projects"),
//           ),
//           GestureDetector(
//             onTap: () => onPress(Destinations.philosophy, context),
//             child: const PageHoverDetail(text: "Development Philosophy"),
//           ),
//         ])
//       ],
//     );
//   }
// }

// class PageHoverDetail extends StatefulWidget {
//   const PageHoverDetail({required this.text, super.key});
//   final String text;

//   @override
//   State<PageHoverDetail> createState() => _PageHoverDetailState();
// }

// class _PageHoverDetailState extends State<PageHoverDetail> {
//   var hover = false;
//   @override
//   Widget build(BuildContext context) {
//     return MouseRegion(
//         onEnter: (_) => setState((() => hover = true)),
//         onExit: (_) => setState((() => hover = false)),
//         child: AnimatedOpacity(
//           opacity: hover ? 1 : 0,
//           duration: const Duration(milliseconds: 400),
//           curve: Curves.easeInOut,
//           child: Container(
//               color: Colors.black38,
//               width: MediaQuery.of(context).size.width / 2,
//               height: MediaQuery.of(context).size.height / 2,
//               child: Center(
//                 child: Text(
//                   widget.text,
//                   style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 30,
//                       decoration: TextDecoration.none),
//                 ),
//               )),
//         ));
//   }
// }
