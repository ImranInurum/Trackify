import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/config/theme_manager.dart';
import '../cubit/upgrade_to_plus_cubit.dart';
import '../state/upgrade_to_plus_state.dart';
import '../../domain/entity/plus_membership_entity.dart';
import '../../data/data_source/plus_membership_remote_data_source.dart';
import '../../data/repository/plus_membership_repository_impl.dart';
import '../../domain/usecase/get_plus_membership_details.dart';
import 'package:trackify/core/widgets/trackify_loader.dart';

class UpgradeToPlusScreen extends StatefulWidget {
  const UpgradeToPlusScreen({super.key});

  @override
  State<UpgradeToPlusScreen> createState() => _UpgradeToPlusScreenState();
}

class _UpgradeToPlusScreenState extends State<UpgradeToPlusScreen> {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _showStickyButton = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _showAppBarTitle = ValueNotifier<bool>(false);

  final GlobalKey _topButtonKey = GlobalKey();
  final GlobalKey _bottomButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) return;

    double offset = _scrollController.offset;
    final screenHeight = MediaQuery.of(context).size.height;

    bool isTopButtonHidden = false;
    final RenderObject? topRender = _topButtonKey.currentContext
        ?.findRenderObject();
    if (topRender is RenderBox) {
      final position = topRender.localToGlobal(Offset.zero);
      isTopButtonHidden = position.dy + topRender.size.height < 100;
    } else {
      isTopButtonHidden = offset > 450;
    }

    bool isBottomButtonVisible = false;
    final RenderObject? bottomRender = _bottomButtonKey.currentContext
        ?.findRenderObject();
    if (bottomRender is RenderBox) {
      final position = bottomRender.localToGlobal(Offset.zero);
      isBottomButtonVisible = position.dy < screenHeight - 20;
    } else {
      isBottomButtonVisible =
          offset > _scrollController.position.maxScrollExtent - 250;
    }

    _showStickyButton.value = isTopButtonHidden && !isBottomButtonVisible;
    _showAppBarTitle.value = offset > screenHeight * 0.15;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _showStickyButton.dispose();
    _showAppBarTitle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Theme(
      data: ThemeManager.darkTheme,
      child: BlocBuilder<UpgradeToPlusCubit, UpgradeToPlusState>(
        builder: (context, state) {
          final l10n = AppLocalizations.of(context)!;
          const bool isDark = true;

          if (state is UpgradeToPlusLoading || state is UpgradeToPlusInitial) {
            return Scaffold(
              backgroundColor: AppColors.backgroundDark,
              body: const Center(child: TrackifyLoader()),
            );
          }

          if (state is UpgradeToPlusFailure) {
            return Scaffold(
              backgroundColor: AppColors.backgroundDark,
              body: Center(
                child: Text(
                  "Error: ${state.message}",
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          if (state is UpgradeToPlusSuccess) {
            final details = state.details;
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      AppImages.upgradeBackground,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.85),
                            AppColors.backgroundDark.withValues(alpha: 0.95),
                          ],
                        ),
                      ),
                    ),
                  ),
                  CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      ValueListenableBuilder<bool>(
                        valueListenable: _showAppBarTitle,
                        builder: (context, show, child) {
                          return SliverAppBar(
                            backgroundColor: show
                                ? AppColors.backgroundDark.withValues(alpha: 0.9)
                                : Colors.transparent,
                            elevation: 0,
                            pinned: true,
                            leading: IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios_new,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                            centerTitle: false,
                            title: AnimatedOpacity(
                              opacity: show ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 200),
                              child: Text(
                                l10n.plusMembershipTitle,
                                style: const TextStyle(
                                  color: AppColors.goldStart,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05,
                          ),
                          child: Column(
                            children: [
                              Image.asset(
                                AppImages.appLogo,
                                height: screenHeight * 0.15,
                                color: AppColors.goldStart,
                              ),
                              _buildTitleSection(
                                isDark,
                                screenWidth,
                                screenHeight,
                                l10n,
                              ),
                              SizedBox(height: screenHeight * 0.04),
                              _buildPricingCard(
                                isDark,
                                context,
                                details,
                                screenWidth,
                                screenHeight,
                                l10n,
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              Text(
                                details.usersCountMessage,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.06),
                              _buildSectionHeader(l10n.premiumBenefits, isDark),
                              SizedBox(height: screenHeight * 0.04),
                              ...details.premiumBenefits.map(
                                (benefit) => _buildBenefitTile(
                                  icon: _getIconForType(benefit.iconType),
                                  title: benefit.title,
                                  subtitle: benefit.subtitle,
                                  isDark: isDark,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.05),
                              _buildSectionHeader(l10n.otherBenefits, isDark),
                              SizedBox(height: screenHeight * 0.025),
                              _buildBenefitsTable(
                                isDark,
                                details.otherBenefits,
                              ),
                              SizedBox(height: screenHeight * 0.06),
                              _buildSectionHeader(
                                l10n.trackifyPlusReviews,
                                isDark,
                              ),
                              SizedBox(height: screenHeight * 0.04),
                              ...details.reviews.map(
                                (review) => _buildReviewTile(
                                  name: review.name,
                                  duration: review.duration,
                                  review: review.review,
                                  isDark: isDark,
                                ),
                              ),
                              _buildViewMoreButton(l10n),
                              SizedBox(height: screenHeight * 0.025),
                              _buildPremiumButton(
                                key: _bottomButtonKey,
                                text: l10n.upgradeNowAtJust(
                                    details.currentPrice.toInt().toString()),
                                onPressed: () => context
                                    .read<UpgradeToPlusCubit>()
                                    .upgradeToPlus(),
                                height: screenHeight * 0.07,
                              ),
                              SizedBox(height: screenHeight * 0.06),
                              _buildFooter(isDark, screenWidth, screenHeight),
                              SizedBox(height: screenHeight * 0.12),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  _buildStickyButton(
                    context,
                    details,
                    screenWidth,
                    screenHeight,
                    l10n,
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'speed':
        return Icons.speed;
      case 'car':
        return Icons.car_repair;
      case 'parking':
        return Icons.local_parking;
      case 'stats':
        return Icons.bar_chart;
      default:
        return Icons.star;
    }
  }

  Widget _buildBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.goldStart, AppColors.goldEnd],
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        AppLocalizations.of(context)!.speciallyForYou,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildViewMoreButton(AppLocalizations l10n) {
    return TextButton(
      onPressed: () {},
      child: Text(
        l10n.viewMoreReviews,
        style: const TextStyle(
          color: AppColors.goldStart,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStickyButton(
    BuildContext context,
    PlusMembershipEntity details,
    double screenWidth,
    double screenHeight,
    AppLocalizations l10n,
  ) {
    return ValueListenableBuilder<bool>(
      valueListenable: _showStickyButton,
      builder: (context, show, child) {
        return AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          bottom: show ? 20 : -100,
          left: screenWidth * 0.05,
          right: screenWidth * 0.05,
          child: _buildPremiumButton(
            text: l10n.upgradeNowAtJust(
                details.currentPrice.toInt().toString()),
            onPressed: () => context.read<UpgradeToPlusCubit>().upgradeToPlus(),
            isSticky: true,
            height: screenHeight * 0.07,
          ),
        );
      },
    );
  }

  Widget _buildFooter(bool isDark, double screenWidth, double screenHeight) {
    return Column(
      children: [
        Opacity(
          opacity:
              0.2, // Slightly increased opacity for better visibility now that it's not overlapping
          child: Image.asset(
            AppImages.bikeUpgrade,
            height: screenHeight * 0.2,
            width: double.infinity,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: screenHeight * 0.03),
        Image.asset(
          AppImages.appLogo,
          height: screenHeight * 0.12,
          color: AppColors.goldStart,
        ),
        const SizedBox(height: 15),
        Text(
          AppLocalizations.of(context)!.footerMotto,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 13,
            height: 1.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTitleSection(
    bool isDark,
    double screenWidth,
    double screenHeight,
    AppLocalizations l10n,
  ) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -screenHeight * 0.01,
              right: -screenWidth * 0.05,
              child: const _AnimatedSparkle(size: 20, delay: 0),
            ),
            Positioned(
              bottom: screenHeight * 0.05,
              left: -screenWidth * 0.07,
              child: const _AnimatedSparkle(size: 14, delay: 500),
            ),
            Positioned(
              bottom: -screenHeight * 0.01,
              right: screenWidth * 0.02,
              child: const _AnimatedSparkle(size: 16, delay: 1000),
            ),

            Image.asset(
              AppImages.plusImg,
              height: screenWidth * 0.25,
              fit: BoxFit.contain,
            ),
            // Positioned(
            //   top: -10,
            //   left: 0,
            //   child: Transform.rotate(
            //     angle: -0.3,
            //     child: Image.asset(
            //       AppImages.kingIcon,
            //       height: screenHeight * 0.045,
            //       color: AppColors.goldStart,
            //     ),
            //   ),
            // ),
          ],
        ),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [AppColors.goldStart, Color(0xFFFFF3D6), AppColors.goldEnd],
          ).createShader(bounds),
          child: Text(
            l10n.membership,
            style: TextStyle(
              fontSize: screenWidth * 0.065,
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPricingCard(
    bool isDark,
    BuildContext context,
    PlusMembershipEntity details,
    double screenWidth,
    double screenHeight,
    AppLocalizations l10n,
  ) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 15),
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "₹",
                          style: TextStyle(
                            fontSize: screenWidth * 0.08,
                            fontWeight: FontWeight.bold,
                            color: AppColors.goldStart,
                          ),
                        ),
                        TextSpan(
                          text: "${details.currentPrice.toInt()}",
                          style: TextStyle(
                            fontSize: screenWidth * 0.12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.goldStart,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "₹${details.originalPrice.toInt()}",
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: Colors.white.withValues(alpha: 0.6),
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      Text(
                        details.duration,
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              _buildPremiumButton(
                key: _topButtonKey,
                text: l10n.upgradeToPlus,
                onPressed: () =>
                    context.read<UpgradeToPlusCubit>().upgradeToPlus(),
                height: screenHeight * 0.07,
              ),
            ],
          ),
        ),
        Positioned(top: 0, child: _buildBadge()),
      ],
    );
  }

  Widget _buildPremiumButton({
    Key? key,
    required String text,
    required VoidCallback onPressed,
    bool isSticky = false,
    double? height,
  }) {
    return Container(
      key: key,
      width: double.infinity,
      height: height ?? 58,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.goldStart,
            AppColors.warrantyButtonEnd,
            AppColors.warrantyButtonEnd,
            AppColors.warrantyButtonEnd,
            AppColors.goldStart,
          ],
          stops: [0.0, 0.45, 0.5, 0.55, 1.0],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: isSticky
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(25),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontSize: 16.5,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.goldStart.withValues(alpha: 0.5),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                AppColors.goldStart,
                Color(0xFFFFF3D6),
                AppColors.goldStart,
              ],
            ).createShader(bounds),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 14,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.goldStart.withValues(alpha: 0.5),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              color: Colors.black,
            ),
            child: Icon(icon, color: AppColors.goldStart, size: 22),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      AppColors.goldStart,
                      Color(0xFFFFF3D6),
                      AppColors.goldStart,
                    ],
                  ).createShader(bounds),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsTable(bool isDark, List<OtherBenefitEntity> benefits) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        color: Colors.white.withValues(alpha: 0.02),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    AppLocalizations.of(context)!.offerings,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    AppLocalizations.of(context)!.regular,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    AppLocalizations.of(context)!.plus,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.goldStart,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...benefits.map(
            (benefit) => _buildTableRow(
              benefit.title,
              benefit.description,
              benefit.regularValue,
              benefit.plusValue,
              isDark,
              isLast: benefits.last == benefit,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(
    String title,
    String description,
    String regular,
    String plus,
    bool isDark, {
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.1))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    description,
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(child: _buildTableValue(regular, false)),
          ),
          Expanded(flex: 1, child: Center(child: _buildTableValue(plus, true))),
        ],
      ),
    );
  }

  Widget _buildTableValue(String value, bool isPlus) {
    if (value == "Check")
      return Icon(Icons.check, color: Colors.grey.withValues(alpha: 0.5), size: 22);
    if (value == "CheckGold")
      return const Icon(Icons.check, color: AppColors.goldStart, size: 22);
    return Text(
      value,
      style: TextStyle(
        color: isPlus ? AppColors.goldStart : Colors.grey,
        fontWeight: isPlus ? FontWeight.bold : FontWeight.normal,
        fontSize: 13,
      ),
    );
  }

  Widget _buildReviewTile({
    required String name,
    required String duration,
    required String review,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.grey.withValues(alpha: 0.2),
                child: const Icon(Icons.person, color: Colors.white54),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: AppColors.goldStart,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    duration,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontStyle: FontStyle.italic,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedSparkle extends StatefulWidget {
  final double size;
  final int delay;

  const _AnimatedSparkle({required this.size, required this.delay});

  @override
  State<_AnimatedSparkle> createState() => _AnimatedSparkleState();
}

class _AnimatedSparkleState extends State<_AnimatedSparkle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 1.2,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.2,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 20,
      ),
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 40),
    ]).animate(_controller);

    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 20),
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 40),
    ]).animate(_controller);

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.repeat();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Icon(
              Icons.auto_awesome,
              color: AppColors.goldStart,
              size: widget.size,
            ),
          ),
        );
      },
    );
  }
}
