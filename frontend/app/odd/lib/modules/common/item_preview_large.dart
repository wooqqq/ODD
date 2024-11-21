// 보류

// import 'package:flutter/material.dart';
// import 'package:odd/modules/common/service_type_label.dart';
// import '../../../constants/appcolors.dart';
// import '../../cart/widgets/cart_modal.dart';
// import '../../common/image_card.dart';
//
// class ItemPreviewLarge extends StatelessWidget {
//   final String assetPath;
//   final String platform;
//   final String itemName;
//   final String price;
//   final int rank;
//
//   const ItemPreviewLarge({
//     super.key,
//     required this.rank,
//     required this.assetPath,
//     required this.platform,
//     required this.itemName,
//     required this.price,
//   });
//
//   // 플랫폼에 따른 Primary와 Secondary 색상 선택
//   Map<String, Color> _getPlatformColors() {
//     switch (platform) {
//       case 'GS25':
//         return {
//           'primary': AppColors.gsPrimary,
//           'secondary': AppColors.gsSecondary,
//         };
//       case 'GS더프레시':
//         return {
//           'primary': AppColors.freshPrimary,
//           'secondary': AppColors.freshSecondary,
//         };
//       case 'wine25':
//         return {
//           'primary': AppColors.winePrimary,
//           'secondary': AppColors.wineSecondary,
//         };
//       default:
//         return {
//           'primary': Colors.grey,
//           'secondary': Colors.grey,
//         };
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final colors = _getPlatformColors();
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: IntrinsicHeight(
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 순위 텍스트
//             Center(
//               child: Text(
//                 '$rank',
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.black,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 8),
//
//             // 이미지 카드
//             ImageCard(
//               assetPath: assetPath,
//               length: 120,
//             ),
//             const SizedBox(width: 16),
//
//             // 상품 정보 및 아이콘
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // 상품명
//                 Text(
//                   itemName,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     color: AppColors.grey,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//
//                 Text(
//                   platform,
//                   style: TextStyle(
//                     fontFamily: 'LogoFont',
//                     fontWeight: FontWeight.w700,
//                     color: colors['primary'],
//                     fontSize: 16,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//
//                 // 가격
//                 Text(
//                   price,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     color: AppColors.black,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//
//                 // 태그와 아이콘 정렬
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     ServiceTypeLabel(
//                       backgroundColor: colors['secondary']!,
//                       type: '픽업',
//                     ),
//                     Row(
//                       children: [
//                         // 좋아요 버튼
//                         GestureDetector(
//                           onTap: () {
//                             // 좋아요 기능
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Image.asset(
//                               'assets/icons/heart_icon.png',
//                               width: 20,
//                               height: 20,
//                             ),
//                           ),
//                         ),
//
//                         // 장바구니 담기 버튼
//                         GestureDetector(
//                           onTap: () {
//                             showModalBottomSheet(
//                               context: context,
//                               builder: (BuildContext context) {
//                                 return const CartModal(item: item);
//                               },
//                               shape: const RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.vertical(
//                                   top: Radius.circular(20),
//                                 ),
//                               ),
//                             );
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Image.asset(
//                               'assets/icons/bag_icon.png',
//                               width: 20,
//                               height: 20,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
