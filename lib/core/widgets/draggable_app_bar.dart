// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:trackify/core/theme/app_colors.dart';
// import 'package:trackify/core/widgets/option_tile.dart';
//
// import '../../feature/map/data/entity/user_vehicle_model.dart';
//
// class DraggableAppBar extends StatefulWidget {
//   final List<UserDevices>? devices;
//   final List<Widget>? actions;
//   final double collapsedHeight;
//   final double expandedHeight;
//   final Color? backgroundColor;
//   final VoidCallback? onAddVehicle;
//   final ValueChanged<UserDevices>? onDeviceTap;
//   final UserDevices? selectedDevice;
//
//   const DraggableAppBar({
//     super.key,
//     this.devices,
//     this.actions,
//     this.collapsedHeight = 160,
//     this.expandedHeight = 340,
//     this.backgroundColor,
//     this.onAddVehicle,
//     this.onDeviceTap,
//     this.selectedDevice,
//   });
//
//   @override
//   State<DraggableAppBar> createState() => _DraggableAppBarBarState();
// }
//
// class _DraggableAppBarBarState extends State<DraggableAppBar>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _controller;
//   late final Animation<double> _heightFactor;
//   late final Animation<double> _overlayOpacity;
//
//   bool _isExpanded = false;
//
//   List<UserDevices> get _devices => widget.devices ?? [];
//
//   UserDevices? get _selectedDevice {
//     if (widget.selectedDevice != null) return widget.selectedDevice;
//     if (_devices.isNotEmpty) return _devices.first;
//     return null;
//   }
//
//   @override
//   void initState() {
//     super.initState();
//
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 260),
//     );
//
//     _heightFactor = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
//
//     _overlayOpacity = Tween<double>(
//       begin: 0,
//       end: 0.45,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
//   }
//
//   void _expand() {
//     setState(() => _isExpanded = true);
//     _controller.forward();
//   }
//
//   void _collapse() {
//     setState(() => _isExpanded = false);
//     _controller.reverse();
//   }
//
//   void _toggle() {
//     if (_isExpanded) {
//       _collapse();
//     } else {
//       _expand();
//     }
//   }
//
//   void _handleVerticalDragUpdate(DragUpdateDetails details) {
//     final delta = details.primaryDelta ?? 0;
//     final dragRange = widget.expandedHeight - widget.collapsedHeight;
//
//     if (dragRange <= 0) return;
//
//     _controller.value = (_controller.value + (delta / dragRange)).clamp(0.0, 1.0);
//   }
//
//   void _handleVerticalDragEnd(DragEndDetails details) {
//     final velocity = details.primaryVelocity ?? 0;
//
//     if (velocity > 250) {
//       _expand();
//       return;
//     }
//
//     if (velocity < -250) {
//       _collapse();
//       return;
//     }
//
//     if (_controller.value >= 0.5) {
//       _expand();
//     } else {
//       _collapse();
//     }
//   }
//
//   // void _handleVerticalDragUpdate(DragUpdateDetails details) {
//   //   final delta = details.primaryDelta ?? 0;
//   //   final dragRange = (widget.expandedHeight - widget.collapsedHeight).clamp(
//   //     1,
//   //     double.infinity,
//   //   );
//   //   _controller.value -= delta / dragRange;
//   // }
//   //
//   // void _handleVerticalDragEnd(DragEndDetails details) {
//   //   if (_controller.value > 0.5) {
//   //     _expand();
//   //   } else {
//   //     _collapse();
//   //   }
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     final topInset = MediaQuery.of(context).padding.top;
//     final selected = _selectedDevice;
//
//     return AnimatedBuilder(
//       animation: _controller,
//       builder: (context, child) {
//         final currentHeight =
//             lerpDouble(
//               widget.collapsedHeight,
//               widget.expandedHeight,
//               _heightFactor.value,
//             ) ??
//             widget.collapsedHeight;
//
//         return Stack(
//           children: [
//             if (_controller.value > 0)
//               Positioned.fill(
//                 top: currentHeight + topInset,
//                 child: GestureDetector(
//                   onTap: _collapse,
//                   child: Container(
//                     color: Colors.black.withOpacity(_overlayOpacity.value),
//                   ),
//                 ),
//               ),
//
//             Material(
//               color: Colors.transparent,
//               child: Align(
//                 alignment: Alignment.topCenter,
//                 child: GestureDetector(
//                   onVerticalDragUpdate: _handleVerticalDragUpdate,
//                   onVerticalDragEnd: _handleVerticalDragEnd,
//                   child: Container(
//                     height: currentHeight + topInset,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: const BorderRadius.only(
//                         bottomLeft: Radius.circular(26),
//                         bottomRight: Radius.circular(26),
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.10),
//                           blurRadius: 18,
//                           offset: const Offset(0, 6),
//                         ),
//                       ],
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.only(top: topInset),
//                       child: Column(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   child: Text(
//                                     "My Garage",
//                                     style: const TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.w700,
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                 ),
//                                 ...(widget.actions ?? []),
//                               ],
//                             ),
//                           ),
//
//                           if (selected != null)
//                             Container(
//                               width: double.infinity,
//                               margin: const EdgeInsets.symmetric(horizontal: 0),
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                                 vertical: 12,
//                               ),
//                               color: const Color(0xFFDDE6EF),
//                               child: Row(
//                                 children: [
//                                   Container(
//                                     width: 44,
//                                     height: 44,
//                                     alignment: Alignment.center,
//                                     child: const Icon(
//                                       Icons.motorcycle,
//                                       size: 34,
//                                       color: AppColors.primaryLight,
//                                     ),
//                                   ),
//                                   const SizedBox(width: 12),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           selected.deviceName?.trim().isNotEmpty == true
//                                               ? selected.deviceName!
//                                               : "Unnamed Device",
//                                           maxLines: 1,
//                                           overflow: TextOverflow.ellipsis,
//                                           style: const TextStyle(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.w700,
//                                             color: Colors.black,
//                                           ),
//                                         ),
//                                         const SizedBox(height: 2),
//                                         Row(
//                                           children: [
//                                             Flexible(
//                                               child: Text(
//                                                 selected.imei ?? "---",
//                                                 maxLines: 1,
//                                                 overflow: TextOverflow.ellipsis,
//                                                 style: const TextStyle(
//                                                   fontSize: 12,
//                                                   color: Color(0xFF5E636A),
//                                                   fontWeight: FontWeight.w500,
//                                                 ),
//                                               ),
//                                             ),
//                                             const SizedBox(width: 8),
//                                             Text(
//                                               "Lite 4G",
//                                               style: const TextStyle(
//                                                 fontSize: 12,
//                                                 color: AppColors.primaryLight,
//                                                 fontWeight: FontWeight.w600,
//                                               ),
//                                             ),
//                                             // if ((selected.deviceType ?? '').isNotEmpty)
//                                             //   Flexible(
//                                             //     child: Text(
//                                             //       selected.deviceType!,
//                                             //       maxLines: 1,
//                                             //       overflow: TextOverflow.ellipsis,
//                                             //       style: const TextStyle(
//                                             //         fontSize: 12,
//                                             //         color: AppColors.primaryLight,
//                                             //         fontWeight: FontWeight.w600,
//                                             //       ),
//                                             //     ),
//                                             //   ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//
//                                   // if ((selected.expiryText ?? '').isNotEmpty)
//                                   //   Text(
//                                   //     selected.expiryText!,
//                                   //     style: const TextStyle(
//                                   //       fontSize: 13,
//                                   //       fontWeight: FontWeight.w700,
//                                   //       color: Colors.green,
//                                   //     ),
//                                   //   ),
//                                 ],
//                               ),
//                             ),
//
//                           ClipRect(
//                             child: Align(
//                               alignment: Alignment.topCenter,
//                               heightFactor: _heightFactor.value,
//                               child: Column(
//                                 children: [
//                                   const SizedBox(height: 10),
//                                   if (_devices.length > 1)
//                                     ListView.separated(
//                                       itemCount: _devices.length,
//                                       shrinkWrap: true,
//                                       physics: const NeverScrollableScrollPhysics(),
//                                       padding: const EdgeInsets.symmetric(horizontal: 12),
//                                       separatorBuilder: (_, __) =>
//                                           const Divider(height: 1),
//                                       itemBuilder: (context, index) {
//                                         final device = _devices[index];
//
//                                         return OptionTile(
//                                           leading: const Icon(
//                                             Icons.motorcycle,
//                                             size: 28,
//                                             color: AppColors.primaryLight,
//                                           ),
//                                           title: device.deviceName ?? "Unnamed Device",
//                                           subtitle: device.imei ?? "---",
//                                           trailing: const SizedBox.shrink(),
//                                           showDivider: false,
//                                           onTap: () {
//                                             widget.onDeviceTap?.call(device);
//                                             _collapse();
//                                           },
//                                         );
//                                       },
//                                     ),
//
//                                   if (widget.onAddVehicle != null)
//                                     InkWell(
//                                       onTap: widget.onAddVehicle,
//                                       child: Padding(
//                                         padding: const EdgeInsets.fromLTRB(
//                                           18,
//                                           14,
//                                           18,
//                                           10,
//                                         ),
//                                         child: Row(
//                                           children: const [
//                                             Icon(
//                                               Icons.add_box_outlined,
//                                               color: AppColors.primaryLight,
//                                               size: 24,
//                                             ),
//                                             SizedBox(width: 10),
//                                             Text(
//                                               "Add New Vehicle",
//                                               style: TextStyle(
//                                                 color: AppColors.primaryLight,
//                                                 fontSize: 16,
//                                                 fontWeight: FontWeight.w700,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                 ],
//                               ),
//                             ),
//                           ),
//
//                           const Spacer(),
//
//                           GestureDetector(
//                             onTap: _toggle,
//                             behavior: HitTestBehavior.opaque,
//                             child: Container(
//                               width: double.infinity,
//                               padding: const EdgeInsets.only(bottom: 14, top: 10),
//                               alignment: Alignment.center,
//                               child: AnimatedRotation(
//                                 turns: _isExpanded ? 0.5 : 0,
//                                 duration: const Duration(milliseconds: 220),
//                                 child: const Icon(
//                                   Icons.keyboard_arrow_down_rounded,
//                                   size: 30,
//                                   color: Colors.black54,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//
//     // GestureDetector(
//     //   onTap: _toggleExpand,
//     //   behavior: HitTestBehavior.translucent,
//     //   child: AnimatedContainer(
//     //     duration: const Duration(milliseconds: 250),
//     //     curve: Curves.easeOut,
//     //     height: height + topInset,
//     //     decoration: BoxDecoration(
//     //       gradient: LinearGradient(
//     //         colors: [
//     //           Colors.white,
//     //           (widget.backgroundColor ??
//     //               Theme
//     //                   .of(context)
//     //                   .colorScheme
//     //                   .secondaryContainer),
//     //         ],
//     //         begin: Alignment.topCenter,
//     //         end: Alignment.bottomCenter,
//     //         stops: const [0.3, 1.0], // 70% white, 30% your theme color
//     //       ),
//     //       borderRadius: const BorderRadius.only(
//     //         bottomLeft: Radius.circular(18),
//     //         bottomRight: Radius.circular(18),
//     //       ),
//     //       boxShadow: [
//     //         BoxShadow(
//     //           color: Colors.black.withOpacity(0.15),
//     //           blurRadius: 6,
//     //           offset: const Offset(0, 3),
//     //         ),
//     //       ],
//     //     ),
//     //
//     //     child: Padding(
//     //       padding: EdgeInsets.only(top: topInset),
//     //       child: Column(
//     //         children: [
//     //           if (devices.isNotEmpty)
//     //             Flexible(
//     //               child: ListView.builder(
//     //                 physics: const NeverScrollableScrollPhysics(),
//     //                 padding: const EdgeInsets.symmetric(horizontal: 12),
//     //                 itemCount: devices.length,
//     //                 itemBuilder: (context, index) {
//     //                   final device = devices[index];
//     //                   return OptionTile(
//     //                     leading: const Icon(
//     //                       Icons.pedal_bike,
//     //                       size: 32,
//     //                       color: Colors.green,
//     //                     ),
//     //                     title: device.deviceName ?? "Unnamed Device",
//     //                     subtitle: device.imei ?? "No IMEI",
//     //                     showDivider: index != devices.length - 1,
//     //                     trailing: SizedBox(),
//     //                     onTap: () {},
//     //                   );
//     //                 },
//     //               ),
//     //             )
//     //           else
//     //             Flexible(
//     //               child: Padding(
//     //                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//     //                 child: Row(
//     //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     //                   children: [
//     //                     Flexible(
//     //                       child: Text(
//     //                         "No Device Found",
//     //                         style: Theme
//     //                             .of(context)
//     //                             .textTheme
//     //                             .headlineSmall
//     //                             ?.copyWith(
//     //                           fontWeight: FontWeight.bold,
//     //                         ),
//     //                       ),
//     //                     ),
//     //                     if (widget.actions != null) Row(children: widget.actions!),
//     //                   ],
//     //                 ),
//     //               ),
//     //             ),
//     //           Container(
//     //             width: 40,
//     //             height: 4,
//     //             margin: const EdgeInsets.only(bottom: 10, top: 6),
//     //             decoration: BoxDecoration(
//     //               color: Theme
//     //                   .of(context)
//     //                   .hintColor
//     //                   .withOpacity(0.7),
//     //               borderRadius: BorderRadius.circular(10),
//     //             ),
//     //           ),
//     //         ],
//     //       ),
//     //     ),
//     //   ),
//     // );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:trackify/core/theme/app_colors.dart';
// import 'package:trackify/core/widgets/option_tile.dart';
//
// import '../../feature/map/data/entity/user_vehicle_model.dart';
//
// class DraggableAppBar extends StatefulWidget {
//   final List<UserDevices>? devices;
//   final List<Widget>? actions;
//   final Color? backgroundColor;
//   final VoidCallback? onAddVehicle;
//   final ValueChanged<UserDevices>? onDeviceTap;
//   final UserDevices? selectedDevice;
//
//   const DraggableAppBar({
//     super.key,
//     this.devices,
//     this.actions,
//     this.backgroundColor,
//     this.onAddVehicle,
//     this.onDeviceTap,
//     this.selectedDevice,
//   });
//
//   @override
//   State<DraggableAppBar> createState() => _DraggableAppBarState();
// }
//
// class _DraggableAppBarState extends State<DraggableAppBar>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _controller;
//   late final Animation<double> _expandFactor;
//   late final Animation<double> _overlayOpacity;
//
//   bool _isExpanded = false;
//
//   List<UserDevices> get _devices => widget.devices ?? [];
//
//   UserDevices? get _selectedDevice {
//     if (widget.selectedDevice != null) return widget.selectedDevice;
//     if (_devices.isNotEmpty) return _devices.first;
//     return null;
//   }
//
//   @override
//   void initState() {
//     super.initState();
//
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 260),
//     );
//
//     _expandFactor = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
//
//     _overlayOpacity = Tween<double>(
//       begin: 0,
//       end: 0.45,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
//   }
//
//   void _expand() {
//     setState(() => _isExpanded = true);
//     _controller.forward();
//   }
//
//   void _collapse() {
//     setState(() => _isExpanded = false);
//     _controller.reverse();
//   }
//
//   void _toggle() {
//     if (_isExpanded) {
//       _collapse();
//     } else {
//       _expand();
//     }
//   }
//
//   void _handleVerticalDragUpdate(DragUpdateDetails details) {
//     final delta = details.primaryDelta ?? 0;
//     final nextValue = _controller.value + (delta / 120);
//     _controller.value = nextValue.clamp(0.0, 1.0);
//   }
//
//   void _handleVerticalDragEnd(DragEndDetails details) {
//     final velocity = details.primaryVelocity ?? 0;
//
//     if (velocity > 150) {
//       _expand();
//       return;
//     }
//
//     if (velocity < -150) {
//       _collapse();
//       return;
//     }
//
//     if (_controller.value >= 0.5) {
//       _expand();
//     } else {
//       _collapse();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final topInset = MediaQuery.of(context).padding.top;
//     final selected = _selectedDevice;
//
//     return AnimatedBuilder(
//       animation: _controller,
//       builder: (context, child) {
//         final showOverlay = _controller.value > 0;
//
//         // approximate visible sheet height so overlay starts below it
//         final visibleHeight = topInset + 142 + (_controller.value * 140);
//
//         return Stack(
//           children: [
//             if (showOverlay)
//               Positioned.fill(
//                 top: visibleHeight,
//                 child: GestureDetector(
//                   onTap: _collapse,
//                   child: Container(
//                     color: Colors.black.withOpacity(_overlayOpacity.value),
//                   ),
//                 ),
//               ),
//
//             Material(
//               color: Colors.transparent,
//               child: Align(
//                 alignment: Alignment.topCenter,
//                 child: AnimatedSize(
//                   duration: const Duration(milliseconds: 260),
//                   curve: Curves.easeOutCubic,
//                   alignment: Alignment.topCenter,
//                   child: Container(
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       color: widget.backgroundColor ?? Colors.white,
//                       borderRadius: const BorderRadius.only(
//                         bottomLeft: Radius.circular(26),
//                         bottomRight: Radius.circular(26),
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.10),
//                           blurRadius: 18,
//                           offset: const Offset(0, 6),
//                         ),
//                       ],
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.only(top: topInset),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           // Padding(
//                           //   padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
//                           //   child: Row(
//                           //     children: [
//                           //       const Expanded(
//                           //         child: Text(
//                           //           'My Garage',
//                           //           style: TextStyle(
//                           //             fontSize: 18,
//                           //             fontWeight: FontWeight.w700,
//                           //             color: Colors.black,
//                           //           ),
//                           //         ),
//                           //       ),
//                           //       ...(widget.actions ?? []),
//                           //     ],
//                           //   ),
//                           // ),
//                           ClipRect(
//                             child: Align(
//                               alignment: Alignment.topCenter,
//                               heightFactor: _expandFactor.value,
//                               child: Padding(
//                                 padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
//                                 child: Row(
//                                   children: [
//                                     const Expanded(
//                                       child: Text(
//                                         'My Garage',
//                                         style: TextStyle(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.w700,
//                                           color: Colors.black,
//                                         ),
//                                       ),
//                                     ),
//                                     ...(widget.actions ?? []),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           if (selected != null)
//                             Container(
//                               width: double.infinity,
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                                 vertical: 12,
//                               ),
//                               color: const Color(0xFFDDE6EF),
//                               child: Row(
//                                 children: [
//                                   Container(
//                                     width: 44,
//                                     height: 44,
//                                     alignment: Alignment.center,
//                                     child: const Icon(
//                                       Icons.motorcycle,
//                                       size: 34,
//                                       color: AppColors.primaryLight,
//                                     ),
//                                   ),
//                                   const SizedBox(width: 12),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           selected.deviceName?.trim().isNotEmpty == true
//                                               ? selected.deviceName!
//                                               : 'Unnamed Device',
//                                           maxLines: 1,
//                                           overflow: TextOverflow.ellipsis,
//                                           style: const TextStyle(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.w700,
//                                             color: Colors.black,
//                                           ),
//                                         ),
//                                         const SizedBox(height: 2),
//                                         Row(
//                                           children: [
//                                             Flexible(
//                                               child: Text(
//                                                 selected.imei ?? '---',
//                                                 maxLines: 1,
//                                                 overflow: TextOverflow.ellipsis,
//                                                 style: const TextStyle(
//                                                   fontSize: 12,
//                                                   color: Color(0xFF5E636A),
//                                                   fontWeight: FontWeight.w500,
//                                                 ),
//                                               ),
//                                             ),
//                                             const SizedBox(width: 8),
//                                             const Text(
//                                               'Lite 4G',
//                                               style: TextStyle(
//                                                 fontSize: 12,
//                                                 color: AppColors.primaryLight,
//                                                 fontWeight: FontWeight.w600,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//
//                           ClipRect(
//                             child: Align(
//                               alignment: Alignment.topCenter,
//                               heightFactor: _expandFactor.value,
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   const SizedBox(height: 8),
//
//                                   if (_devices.length > 1)
//                                     ListView.separated(
//                                       shrinkWrap: true,
//                                       physics: const NeverScrollableScrollPhysics(),
//                                       padding: const EdgeInsets.symmetric(horizontal: 12),
//                                       itemCount: _devices.length,
//                                       separatorBuilder: (_, __) =>
//                                           const Divider(height: 1),
//                                       itemBuilder: (context, index) {
//                                         final device = _devices[index];
//
//                                         return OptionTile(
//                                           leading: const Icon(
//                                             Icons.motorcycle,
//                                             size: 28,
//                                             color: AppColors.primaryLight,
//                                           ),
//                                           title: device.deviceName ?? 'Unnamed Device',
//                                           subtitle: device.imei ?? '---',
//                                           trailing: const SizedBox.shrink(),
//                                           showDivider: false,
//                                           onTap: () {
//                                             widget.onDeviceTap?.call(device);
//                                             _collapse();
//                                           },
//                                         );
//                                       },
//                                     ),
//
//                                   if (widget.onAddVehicle != null)
//                                     InkWell(
//                                       onTap: widget.onAddVehicle,
//                                       child: const Padding(
//                                         padding: EdgeInsets.fromLTRB(18, 14, 18, 10),
//                                         child: Row(
//                                           children: [
//                                             Icon(
//                                               Icons.add_box_outlined,
//                                               color: AppColors.primaryLight,
//                                               size: 24,
//                                             ),
//                                             SizedBox(width: 10),
//                                             Text(
//                                               'Add New Vehicle',
//                                               style: TextStyle(
//                                                 color: AppColors.primaryLight,
//                                                 fontSize: 16,
//                                                 fontWeight: FontWeight.w700,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                 ],
//                               ),
//                             ),
//                           ),
//
//                           GestureDetector(
//                             onTap: _toggle,
//                             onVerticalDragUpdate: _handleVerticalDragUpdate,
//                             onVerticalDragEnd: _handleVerticalDragEnd,
//                             behavior: HitTestBehavior.opaque,
//                             child: Container(
//                               width: double.infinity,
//                               padding: const EdgeInsets.only(top: 10, bottom: 14),
//                               alignment: Alignment.center,
//                               child: AnimatedRotation(
//                                 turns: _isExpanded ? 0.5 : 0,
//                                 duration: const Duration(milliseconds: 220),
//                                 child: const Icon(
//                                   Icons.keyboard_arrow_down_rounded,
//                                   size: 30,
//                                   color: Colors.black54,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:trackify/core/constants/app_images.dart';
// import 'package:trackify/core/theme/app_colors.dart';
// import 'package:trackify/core/widgets/option_tile.dart';
//
// import '../../feature/map/data/entity/user_vehicle_model.dart';
//
// class DraggableAppBar extends StatefulWidget {
//   final List<UserDevices>? devices;
//   final Color? backgroundColor;
//   final VoidCallback? onAddVehicle;
//   final ValueChanged<UserDevices>? onDeviceTap;
//   final UserDevices? selectedDevice;
//
//   /// Shown in collapsed mode on the selected device row
//   final Widget? collapsedTrailing;
//
//   /// Shown in expanded mode in the header row
//   final Widget? expandedTrailing;
//
//   const DraggableAppBar({
//     super.key,
//     this.devices,
//     this.backgroundColor,
//     this.onAddVehicle,
//     this.onDeviceTap,
//     this.selectedDevice,
//     this.collapsedTrailing,
//     this.expandedTrailing,
//   });
//
//   @override
//   State<DraggableAppBar> createState() => _DraggableAppBarState();
// }
//
// class _DraggableAppBarState extends State<DraggableAppBar>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _controller;
//   late final Animation<double> _expandFactor;
//   late final Animation<double> _overlayOpacity;
//
//   List<UserDevices> get _devices => widget.devices ?? [];
//
//   UserDevices? get _selectedDevice {
//     if (widget.selectedDevice != null) return widget.selectedDevice;
//     if (_devices.isNotEmpty) return _devices.first;
//     return null;
//   }
//
//   bool get _isExpanded => _controller.value > 0.5;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 260),
//     );
//
//     _expandFactor = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
//
//     _overlayOpacity = Tween<double>(
//       begin: 0,
//       end: 0.45,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
//   }
//
//   void _expand() {
//     _controller.forward();
//   }
//
//   void _collapse() {
//     _controller.reverse();
//   }
//
//   void _toggle() {
//     if (_isExpanded) {
//       _collapse();
//     } else {
//       _expand();
//     }
//   }
//
//   void _handleVerticalDragUpdate(DragUpdateDetails details) {
//     final delta = details.primaryDelta ?? 0;
//     final nextValue = _controller.value + (delta / 120);
//     _controller.value = nextValue.clamp(0.0, 1.0);
//   }
//
//   void _handleVerticalDragEnd(DragEndDetails details) {
//     final velocity = details.primaryVelocity ?? 0;
//
//     if (velocity > 150) {
//       _expand();
//       return;
//     }
//
//     if (velocity < -150) {
//       _collapse();
//       return;
//     }
//
//     if (_controller.value >= 0.5) {
//       _expand();
//     } else {
//       _collapse();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final topInset = MediaQuery.of(context).padding.top;
//     final selected = _selectedDevice;
//
//     return AnimatedBuilder(
//       animation: _controller,
//       builder: (context, child) {
//         return Stack(
//           children: [
//             /// Full-screen overlay behind the sheet
//             if (_controller.value > 0)
//               Positioned.fill(
//                 child: GestureDetector(
//                   onTap: _collapse,
//                   child: Container(
//                     color: Colors.black.withOpacity(_overlayOpacity.value),
//                   ),
//                 ),
//               ),
//
//             /// Sheet
//             Align(
//               alignment: Alignment.topCenter,
//               child: Material(
//                 color: Colors.transparent,
//                 child: AnimatedSize(
//                   duration: const Duration(milliseconds: 260),
//                   curve: Curves.easeOutCubic,
//                   alignment: Alignment.topCenter,
//                   child: Container(
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       color: widget.backgroundColor ?? Colors.white,
//                       border: Border(
//                         top: BorderSide(color: Colors.grey.shade300, width: 0.8),
//                       ),
//                       borderRadius: const BorderRadius.only(
//                         bottomLeft: Radius.circular(26),
//                         bottomRight: Radius.circular(26),
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.10),
//                           blurRadius: 18,
//                           offset: const Offset(0, 6),
//                         ),
//                       ],
//                     ),
//                     child: ClipRRect(
//                       borderRadius: const BorderRadius.only(
//                         bottomLeft: Radius.circular(26),
//                         bottomRight: Radius.circular(26),
//                       ),
//                       child: Stack(
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.only(top: topInset),
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 ClipRect(
//                                   child: Align(
//                                     alignment: Alignment.topCenter,
//                                     heightFactor: _expandFactor.value,
//                                     child: Padding(
//                                       padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
//                                       child: Row(
//                                         children: [
//                                           const Expanded(
//                                             child: Text(
//                                               'My Garage',
//                                               style: TextStyle(
//                                                 fontSize: 16,
//                                                 fontWeight: FontWeight.w500,
//                                                 color: Colors.black,
//                                               ),
//                                             ),
//                                           ),
//                                           if (widget.expandedTrailing != null)
//                                             widget.expandedTrailing!,
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//
//                                 /// Always visible selected device row
//                                 if (selected != null)
//                                   Container(
//                                     width: double.infinity,
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 16,
//                                       vertical: 8,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: _isExpanded
//                                           ? const Color(0xFFDDE6EF)
//                                           : Colors.transparent,
//                                     ),
//
//                                     child: Row(
//                                       children: [
//                                         Container(
//                                           width: 44,
//                                           height: 44,
//                                           alignment: Alignment.center,
//                                           child: Image.asset(
//                                             AppImages.bikeImage,
//                                             height: 74,
//                                             width: 74,
//                                           ),
//                                         ),
//                                         const SizedBox(width: 12),
//                                         Expanded(
//                                           child: Column(
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 selected.deviceName?.trim().isNotEmpty ==
//                                                         true
//                                                     ? selected.deviceName!
//                                                     : 'Unnamed Device',
//                                                 maxLines: 1,
//                                                 overflow: TextOverflow.ellipsis,
//                                                 style: const TextStyle(
//                                                   fontSize: 16,
//                                                   fontWeight: FontWeight.w700,
//                                                   color: Colors.black,
//                                                 ),
//                                               ),
//                                               // const SizedBox(height: 1),
//                                               Row(
//                                                 children: [
//                                                   Flexible(
//                                                     child: Text(
//                                                       selected.imei ?? '---',
//                                                       maxLines: 1,
//                                                       overflow: TextOverflow.ellipsis,
//                                                       style: const TextStyle(
//                                                         fontSize: 12,
//                                                         color: Color(0xFF5E636A),
//                                                         fontWeight: FontWeight.w500,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   const SizedBox(width: 8),
//                                                   const Text(
//                                                     'Lite 4G',
//                                                     style: TextStyle(
//                                                       fontSize: 10,
//                                                       color: AppColors.primaryLight,
//                                                       fontWeight: FontWeight.w600,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//
//                                         /// Collapsed icon only
//                                         if (!_isExpanded &&
//                                             widget.collapsedTrailing != null)
//                                           widget.collapsedTrailing!,
//                                       ],
//                                     ),
//                                   ),
//
//                                 /// Expanded body only
//                                 ClipRect(
//                                   child: Align(
//                                     alignment: Alignment.topCenter,
//                                     heightFactor: _expandFactor.value,
//                                     child: Column(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         if (widget.onAddVehicle != null)
//                                           InkWell(
//                                             onTap: widget.onAddVehicle,
//                                             child: const Padding(
//                                               padding: EdgeInsets.fromLTRB(18, 4, 18, 0),
//                                               child: Row(
//                                                 children: [
//                                                   Icon(
//                                                     Icons.add_box_outlined,
//                                                     color: AppColors.primaryLight,
//                                                     size: 16,
//                                                   ),
//                                                   SizedBox(width: 4),
//                                                   Text(
//                                                     'Add New Vehicle',
//                                                     style: TextStyle(
//                                                       color: AppColors.primaryLight,
//                                                       fontSize: 12,
//                                                       fontWeight: FontWeight.w700,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//
//                                         if (_devices.length > 1)
//                                           ListView.separated(
//                                             shrinkWrap: true,
//                                             physics: const NeverScrollableScrollPhysics(),
//                                             padding: const EdgeInsets.symmetric(
//                                               horizontal: 12,
//                                             ),
//                                             itemCount: _devices.length,
//                                             separatorBuilder: (_, __) =>
//                                                 const Divider(height: 1),
//                                             itemBuilder: (context, index) {
//                                               final device = _devices[index];
//
//                                               return OptionTile(
//                                                 leading: const Icon(
//                                                   Icons.motorcycle,
//                                                   size: 28,
//                                                   color: AppColors.primaryLight,
//                                                 ),
//                                                 title:
//                                                     device.deviceName ?? 'Unnamed Device',
//                                                 subtitle: device.imei ?? '---',
//                                                 trailing: const SizedBox.shrink(),
//                                                 showDivider: false,
//                                                 onTap: () {
//                                                   widget.onDeviceTap?.call(device);
//                                                   _collapse();
//                                                 },
//                                               );
//                                             },
//                                           ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//
//                                 /// Drag handle
//                                 GestureDetector(
//                                   onTap: _toggle,
//                                   onVerticalDragUpdate: _handleVerticalDragUpdate,
//                                   onVerticalDragEnd: _handleVerticalDragEnd,
//                                   behavior: HitTestBehavior.opaque,
//                                   child: Container(
//                                     width: double.infinity,
//                                     padding: const EdgeInsets.only(top: 0, bottom: 4),
//                                     alignment: Alignment.center,
//                                     decoration: BoxDecoration(
//                                       border: Border(
//                                         bottom: BorderSide(
//                                           color: Colors.grey,
//                                           width: 0.25,
//                                         ),
//                                       ),
//                                     ),
//                                     child: AnimatedSwitcher(
//                                       duration: const Duration(milliseconds: 180),
//                                       transitionBuilder: (child, animation) {
//                                         return FadeTransition(
//                                           opacity: animation,
//                                           child: child,
//                                         );
//                                       },
//                                       child: _isExpanded
//                                           ? Image.asset(
//                                               AppImages.arrowUpIcon,
//                                               height: 60,
//                                               width: 80,
//                                               key: ValueKey('expanded_handle'),
//                                             )
//                                           : Container(
//                                               key: const ValueKey('collapsed_handle'),
//                                               width: 55,
//                                               height: 2.5,
//                                               decoration: BoxDecoration(
//                                                 color: Colors.black,
//                                                 borderRadius: BorderRadius.circular(24),
//                                               ),
//                                             ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//
//                           /// Bottom inner blue gradient effect
//                           Positioned(
//                             left: 0,
//                             right: 0,
//                             bottom: 0,
//                             child: IgnorePointer(
//                               child: Container(
//                                 height: 26,
//                                 decoration: BoxDecoration(
//                                   border: Border(
//                                     bottom: BorderSide(color: Colors.grey, width: 0.15),
//                                   ),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black.withOpacity(0.15),
//                                       blurRadius: 20,
//                                       offset: const Offset(0, 0),
//                                     ),
//                                   ],
//                                   gradient: LinearGradient(
//                                     begin: Alignment.bottomCenter,
//                                     end: Alignment.topCenter,
//                                     colors: [
//                                       AppColors.primaryLightVariant.withOpacity(0.75),
//                                       AppColors.primaryLightVariant.withOpacity(0.05),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';
import 'package:trackify/core/constants/app_images.dart';
import 'package:trackify/core/theme/app_colors.dart';
import 'package:trackify/feature/map/data/entity/user_vehicles.dart';

class DraggableAppBar extends StatefulWidget {
  final List<Vehicles>? vehicles;
  final Color? backgroundColor;
  final VoidCallback? onAddVehicle;
  final ValueChanged<Vehicles>? onDeviceTap;
  final Vehicles? selectedDevice;

  /// Shown in collapsed mode on the selected device row
  final Widget? collapsedTrailing;

  /// Shown in expanded mode in the header row
  final Widget? expandedTrailing;

  const DraggableAppBar({
    super.key,
    this.vehicles,
    this.backgroundColor,
    this.onAddVehicle,
    this.onDeviceTap,
    this.selectedDevice,
    this.collapsedTrailing,
    this.expandedTrailing,
  });

  @override
  State<DraggableAppBar> createState() => _DraggableAppBarState();
}

class _DraggableAppBarState extends State<DraggableAppBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandFactor;
  late final Animation<double> _overlayOpacity;

  List<Vehicles> get _vehicles => widget.vehicles ?? [];

  Vehicles? get _selectedDevice {
    if (widget.selectedDevice != null) return widget.selectedDevice;
    if (_vehicles.isNotEmpty) return _vehicles.first;
    return null;
  }

  bool get _isExpanded => _controller.value > 0.5;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    _expandFactor = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);

    _overlayOpacity = Tween<double>(
      begin: 0,
      end: 0.45,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  void _expand() {
    _controller.forward();
  }

  void _collapse() {
    _controller.reverse();
  }

  void _toggle() {
    if (_isExpanded) {
      _collapse();
    } else {
      _expand();
    }
  }

  void _handleSheetTap() {
    _toggle();
  }

  void _handleVerticalDragUpdate(DragUpdateDetails details) {
    final delta = details.primaryDelta ?? 0;
    final nextValue = _controller.value + (delta / 120);
    _controller.value = nextValue.clamp(0.0, 1.0);
  }

  void _handleVerticalDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;

    if (velocity > 150) {
      _expand();
      return;
    }

    if (velocity < -150) {
      _collapse();
      return;
    }

    if (_controller.value >= 0.5) {
      _expand();
    } else {
      _collapse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    final selected = _selectedDevice;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            if (_controller.value > 0)
              Positioned.fill(
                child: GestureDetector(
                  onTap: _collapse,
                  child: Container(
                    color: Colors.black.withOpacity(_overlayOpacity.value),
                  ),
                ),
              ),

            Align(
              alignment: Alignment.topCenter,
              child: Material(
                color: Colors.transparent,
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: double.infinity,
                    decoration: ShapeDecoration(
                      color: widget.backgroundColor ?? Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(26),
                          bottomRight: Radius.circular(26),
                        ),
                        side: BorderSide(color: Colors.grey.shade300, width: 0.8),
                      ),
                      shadows: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 1,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(26),
                        bottomRight: Radius.circular(26),
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: topInset),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                /// Full tappable sheet area except handle
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: _handleSheetTap,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ClipRect(
                                        child: Align(
                                          alignment: Alignment.topCenter,
                                          heightFactor: _expandFactor.value,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                              16,
                                              10,
                                              4,
                                              8,
                                            ),
                                            child: Row(
                                              children: [
                                                const Expanded(
                                                  child: Text(
                                                    'My Garage',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                if (widget.expandedTrailing != null)
                                                  widget.expandedTrailing!,
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                      if (selected != null)
                                        _buildVehicleRow(
                                          selected,
                                          isHeaderRow: true,
                                          isHighlighted: _isExpanded,
                                        ),

                                      ClipRect(
                                        child: Align(
                                          alignment: Alignment.topCenter,
                                          heightFactor: _expandFactor.value,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (_vehicles.length > 1)
                                                ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  padding: EdgeInsets.zero,
                                                  itemCount: _vehicles.length,
                                                  itemBuilder: (context, index) {
                                                    final device = _vehicles[index];

                                                    if (device.vehicleNumber ==
                                                        selected?.vehicleNumber) {
                                                      return const SizedBox.shrink(); // skip selected as it's at the top
                                                    }

                                                    return _buildVehicleRow(
                                                      device,
                                                      isHeaderRow: false,
                                                      isHighlighted: false,
                                                    );
                                                  },
                                                ),

                                              if (widget.onAddVehicle != null)
                                                InkWell(
                                                  onTap: widget.onAddVehicle,
                                                  child: const Padding(
                                                    padding: EdgeInsets.symmetric(
                                                      horizontal: 18,
                                                      vertical: 16,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.add_box_outlined,
                                                          color: AppColors.primaryLight,
                                                          size: 20,
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          'Add New Vehicle',
                                                          style: TextStyle(
                                                            color: AppColors.primaryLight,
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      GestureDetector(
                                        onTap: _toggle,
                                        onVerticalDragUpdate: _handleVerticalDragUpdate,
                                        onVerticalDragEnd: _handleVerticalDragEnd,
                                        behavior: HitTestBehavior.opaque,
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.only(
                                            top: 0,
                                            bottom: 4,
                                          ),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Colors.grey,
                                                width: 0.25,
                                              ),
                                            ),
                                          ),
                                          child: AnimatedSwitcher(
                                            duration: const Duration(milliseconds: 180),
                                            transitionBuilder: (child, animation) {
                                              return FadeTransition(
                                                opacity: animation,
                                                child: child,
                                              );
                                            },
                                            child: _isExpanded
                                                ? Image.asset(
                                                    AppImages.arrowUpIcon,
                                                    height: 60,
                                                    width: 80,
                                                    key: const ValueKey(
                                                      'expanded_handle',
                                                    ),
                                                  )
                                                : Container(
                                                    key: const ValueKey(
                                                      'collapsed_handle',
                                                    ),
                                                    width: 55,
                                                    height: 2.5,
                                                    decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      borderRadius: BorderRadius.circular(
                                                        24,
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: IgnorePointer(
                              child: Container(
                                height: 26,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey, width: 0.15),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 20,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      AppColors.primaryLightVariant.withOpacity(0.75),
                                      AppColors.primaryLightVariant.withOpacity(0.05),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildVehicleRow(
    Vehicles device, {
    required bool isHeaderRow,
    required bool isHighlighted,
  }) {
    return InkWell(
      onTap: isHeaderRow
          ? null
          : () {
              widget.onDeviceTap?.call(device);
              _collapse();
            },
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        color: isHighlighted ? const Color(0xFFF0F4F8) : Colors.transparent,
        child: Row(
          children: [
            // Image
            Image.asset(AppImages.bikeImage, height: 60, width: 60, fit: BoxFit.contain),
            const SizedBox(width: 6),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${device.vehicleMaker} ${device.vehicleModel}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  // const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        device.vehicleNumber ?? '---',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Tag
                      _buildTag(device),
                    ],
                  ),
                ],
              ),
            ),

            // Right Side info / icon
            if (!_isExpanded && isHeaderRow)
              widget.collapsedTrailing ??
                  const Icon(Icons.notifications_none_outlined, color: Colors.black87)
            else if (_isExpanded && isHeaderRow)
              const Text(
                '321 days left',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.green,
                ),
              )
            else if (_isExpanded && !isHeaderRow)
              Row(
                children: const [
                  Icon(Icons.shield, color: Colors.orange, size: 14),
                  SizedBox(width: 4),
                  Text(
                    'Buy Ajjas Device',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(Vehicles device) {
    return Text(
      "${device.fuelType}", // Default for now
      style: TextStyle(
        fontSize: 11,
        color: AppColors.primaryLight,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
