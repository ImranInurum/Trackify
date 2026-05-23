import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../data/model/time_slot_model.dart';
import '../cubit/time_slot_cubit.dart';
import '../cubit/time_slot_state.dart';

class BookCallSlotScreen extends StatefulWidget {
  const BookCallSlotScreen({super.key});

  @override
  State<BookCallSlotScreen> createState() =>
      _BookCallSlotScreenState();
}

class _BookCallSlotScreenState
    extends State<BookCallSlotScreen> {

  int selectedDayIndex = 0;

  int? selectedSlotIndex;

  @override
  void initState() {
    super.initState();

    context.read<BookingSlotCubit>().getSlots();
  }


  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(

      backgroundColor:
      Theme.of(context).scaffoldBackgroundColor,

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SizedBox(
            height: 58,
            child: ElevatedButton(
              onPressed: selectedSlotIndex == null
                  ? null
                  : () async {

                final state =
                    context
                        .read<BookingSlotCubit>()
                        .state;

                if (state is BookingSlotLoaded) {

                  final selectedDay =
                  state.slotResponse.days[
                  selectedDayIndex];

                  final selectedSlot =
                  selectedDay.slots[
                  selectedSlotIndex!];

                  Navigator.pop(

                    context,

                    selectedSlot.id,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                disabledBackgroundColor:
                colorScheme.onSurface.withOpacity(0.12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              child: Text(
                l10n.bookNow,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [

            /// APP BAR
            Container(
              width: double.infinity,
              color: colorScheme.surface,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [

                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                      ),
                    ),
                  ),

                  Text(
                    "Trackify",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: BlocBuilder<
                  BookingSlotCubit,
                  BookingSlotState>(
                builder: (context, state) {

                  if (state is BookingSlotLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is BookingSlotError) {
                    return Center(
                      child: Text(state.message),
                    );
                  }

                  if (state is BookingSlotLoaded) {

                    final data = state.slotResponse;

                    final days = data.days;

                    if (days.isEmpty) {
                      return const Center(
                        child: Text("No Slots Available"),
                      );
                    }

                    final selectedDay =
                    days[selectedDayIndex];

                    final slots =
                        selectedDay.slots;

                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [

                          /// TITLE
                          Text(
                            data.screenTitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 15),

                          /// IMPORTANT TITLE
                          Text(
                            data.importantTitle,
                            style: TextStyle(
                              fontSize: 19,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),

                          const SizedBox(height: 15),

                          /// IMPORTANT DESCRIPTION
                          Text(
                            data.importantDescription,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17,
                              height: 1.5,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// SELECT DAY
                          Text(
                            l10n.selectDay,
                            style: TextStyle(
                              fontSize: 20,
                              color: colorScheme.onSurface,
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// DAYS
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest,
                              borderRadius:
                              BorderRadius.circular(18),
                            ),
                            child: Row(
                              children: List.generate(
                                days.length,
                                    (index) {

                                  final day = days[index];

                                  final isSelected =
                                      selectedDayIndex == index;

                                  return Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedDayIndex = index;
                                          selectedSlotIndex = null;
                                        });
                                      },
                                      child: Container(
                                        padding:
                                        const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? colorScheme.primary
                                              : Colors.transparent,
                                          borderRadius:
                                          BorderRadius.circular(14),
                                        ),
                                        child: Column(
                                          children: [

                                            Text(
                                              "${day.dayNumber} ${day.monthText}",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight:
                                                FontWeight.bold,
                                                color: isSelected
                                                    ? colorScheme.onPrimary
                                                    : colorScheme.onSurface,
                                              ),
                                            ),

                                            const SizedBox(height: 2),

                                            Text(
                                              day.dayText,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: isSelected
                                                    ? colorScheme.onPrimary
                                                    : colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),

                          /// SELECT SLOT
                          Text(
                            l10n.selectTimeSlot,
                            style: TextStyle(
                              fontSize: 20,
                              color: colorScheme.onSurface,
                            ),
                          ),

                          const SizedBox(height: 30),

                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: slots.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 15,
                            childAspectRatio: 2.6,
                          ),
                            itemBuilder: (context, index) {
                              final slot = slots[index];

                              final now = DateTime.now();
                              final currentMinutes = now.hour * 60 + now.minute;

                              final slotDate = DateTime.tryParse(selectedDay.date);
                              final bool isToday = slotDate != null &&
                                  slotDate.year == now.year &&
                                  slotDate.month == now.month &&
                                  slotDate.day == now.day;

                              int parseTime(String time) {
                                try {
                                  time = time.trim().toUpperCase();

                                  final isPM = time.contains('PM');
                                  final isAM = time.contains('AM');

                                  time = time.replaceAll('AM', '').replaceAll('PM', '').trim();

                                  final parts = time.split(':');
                                  if (parts.length != 2) return -1;

                                  int hour = int.parse(parts[0]);
                                  int minute = int.parse(parts[1]);

                                  if (isPM && hour != 12) hour += 12;
                                  if (isAM && hour == 12) hour = 0;

                                  return hour * 60 + minute;
                                } catch (_) {
                                  return -1;
                                }
                              }

                              // 🔥 IMPORTANT FIX: extract END TIME from label if API is wrong
                              String endTimeRaw;

                              if (slot.endTime != null && slot.endTime.toString().isNotEmpty) {
                                endTimeRaw = slot.endTime;
                              } else {
                                // fallback: extract from label "04:00 - 05:00"
                                final parts = slot.label.split('-');
                                endTimeRaw = parts.length == 2 ? parts[1].trim() : '';
                              }

                              final int endMinutes = parseTime(endTimeRaw);

                              final bool isDisabled = isToday &&
                                  endMinutes != -1 &&
                                  currentMinutes >= endMinutes;

                              final bool isSelected = selectedSlotIndex == index;

                              return GestureDetector(
                                onTap: isDisabled
                                    ? null
                                    : () {
                                  setState(() {
                                    selectedSlotIndex = index;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isDisabled
                                        ? colorScheme.onSurface.withOpacity(0.10)
                                        : (isSelected
                                        ? colorScheme.primary
                                        : colorScheme.surface),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isDisabled
                                          ? Colors.transparent
                                          : colorScheme.outline.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Text(
                                    slot.label,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: isDisabled
                                          ? colorScheme.onSurfaceVariant
                                          : (isSelected
                                          ? colorScheme.onPrimary
                                          : colorScheme.onSurface),
                                    ),
                                  ),
                                ),
                              );
                            }
                        ),
                          const SizedBox(height: 120),
                        ],
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}