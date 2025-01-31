// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:tourist_guide/core/colors/colors.dart';
// import 'package:tourist_guide/core/widgets/favorite_button.dart';
// import 'package:tourist_guide/data/models/landmark_model.dart';

// class FavCard extends StatefulWidget {
//   final LandMark place;
//   final VoidCallback refresh;
//   const FavCard({super.key, required this.place, required this.refresh});

//   @override
//   State<FavCard> createState() => _FavCardState();
// }

// class _FavCardState extends State<FavCard> {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Container(
//         width: 0.85.sw,
//         // height: 0.6.sh,
//         decoration: BoxDecoration(
//           color: Colors.white, // Background color

//           borderRadius: BorderRadius.circular(25),
//         ),
//         child: Stack(
//           children: [
//             _cardImg(),
//             Padding(
//               padding: EdgeInsets.all(10.0.r),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   FavoriteButton(
//                       place: widget.place), // refresh: widget.refresh),
//                   const Expanded(child: SizedBox()),
//                   _aboutPlace(
//                     widget.place.name,
//                     widget.place.governorate,
//                     widget.place.rate,
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

// // Displays the image of the place inside a ClipRRect widget with a rounded border.
// // Tapping on the image navigates to the place details page.
//   Widget _cardImg() {
//     return InkWell(
//       onTap: () {
//         Navigator.pushNamed(context, '/details',
//             arguments: {'landMark': widget.place});
//       },
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(20),
//         child: Image(
//           image: widget.place.imgPath[0].image,
//           height: 1.sh,
//           width: 0.85.sw,
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   }

// // Displays the name, governorate, and rating of the place in a card format,
// // with appropriate icons for location and rating.
//   Widget _aboutPlace(String name, String gov, String rate) {
//     return Container(
//       height: 70.h,
//       width: 0.85.sw,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15),
//         color: const Color.fromARGB(218, 255, 255, 255),
//       ),
//       padding: const EdgeInsets.all(8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           Text(
//             name,
//             style: TextStyle(
//               fontSize: 15.sp,
//               fontWeight: FontWeight.bold,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Flexible(
//                 child: Row(
//                   children: [
//                     Icon(
//                       Icons.place_rounded,
//                       color: kLightBlack,
//                       size: 15.sp,
//                     ),
//                     SizedBox(width: 4.w),
//                     Expanded(
//                       child: Text(
//                         gov,
//                         style: TextStyle(
//                           fontSize: 13.sp,
//                           color: kLightBlack,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Row(
//                 children: [
//                   Icon(
//                     Icons.star_rounded,
//                     color: kLightBlack,
//                     size: 17.sp,
//                     // 18,
//                   ),
//                   SizedBox(width: 4.w),
//                   Text(
//                     rate,
//                     style: TextStyle(
//                       fontSize: 13.sp,
//                       color: kLightBlack,
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   BoxDecoration detailsBoxTheme(double borderRadius) {
//     return BoxDecoration(
//       borderRadius: BorderRadius.circular(borderRadius),
//       color: kWhite,
//     );
//   }
// }
