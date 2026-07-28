import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trackify/core/constants/app_images.dart';
import 'package:trackify/core/utils/active_video_manager.dart';
import 'package:trackify/core/widgets/trackify_loader.dart';
import 'package:trackify/feature/map/data/entity/product_feature_model.dart';
import 'package:trackify/feature/map/presentation/cubit/product_feature_cubit.dart';
import 'package:trackify/feature/map/presentation/cubit/product_feature_state.dart';
import 'package:trackify/feature/my_garage/presentation/view/checkout_screen.dart';
import 'package:trackify/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({super.key});

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  YoutubePlayerController? _topYoutubeController;
  bool _isTopPlaying = false;

  @override
  void dispose() {
    _topYoutubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider(
      create: (_) => ProductFeatureCubit()..fetchProductFeatures(),
      child: Builder(builder: (ctx) => Scaffold(
        appBar: AppBar(
        title: Text(
          l10n?.products ?? "Products", ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPromoCard(ctx),
            const SizedBox(height: 24),
            _buildTrackifyFeatures(ctx),
            const SizedBox(height: 24),
            _buildDeviceComparisonTable(ctx),
            const SizedBox(height: 24),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      builder: (context) => const ProductSelectionBottomSheet(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    l10n?.exploreProducts ?? "Explore Products",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 48),
            Center(
              child: Column(
                children: [
                  Text(
                    l10n?.decideBestProductText ?? "Not able to decide which product is",
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n?.bestForYou ?? "Best for you?",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () async { 
                      final Uri telUri = Uri(scheme: 'tel', path: '07314275761');
                      try {
                        if (await canLaunchUrl(telUri)) {
                          await launchUrl(telUri);
                        } else {
                          await launchUrl(telUri, mode: LaunchMode.externalApplication);
                        }
                      } catch (e) {
                        debugPrint("Could not launch call: $e");
                      }
                    },
                    icon: const Icon(Icons.phone_in_talk, size: 18),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      side: BorderSide(color: Theme.of(context).colorScheme.primary),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    label: Text(
                      l10n?.callUs ?? "Call Us",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            _buildHappyUsersSection(ctx),
            const SizedBox(height: 32),
          ],
        ),
      ),
    ))); // closes Scaffold + Builder + BlocProvider
  }

  Widget _buildHappyUsersSection(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n?.happyTrackifyUsers ?? "Happy Trackify Users",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 260,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildUserTestimonial(
                context,
                name: l10n?.umeshDarwatkar ?? "Umesh Darwatkar",
                duration: l10n?.umeshDarwatkarDuration ?? "Trackify user from past 1 years",
                review:
                    l10n?.umeshDarwatkarReview ?? "I highly recommend Trackify GPS device to anyone looking for a reliable and accurate navigation tool for bikes it has great features like Theft Detection, Accident Alert, Live Ride Sharing, Ride Recording & Fuel Tracking. Its easy to install & it Apps is very easy to use with lots of features.",
                imageAsset: AppImages.profileIcon,
              ),
              const SizedBox(width: 16),
              _buildUserTestimonial(
                context,
                name: l10n?.rohitSharma ?? "Rohit Sharma",
                duration: l10n?.rohitSharmaDuration ?? "Trackify user from past 2 years",
                review:
                    l10n?.rohitSharmaReview ?? "Using the device would like to highlight in movement tracking sharing it with the other people so that my friend can track me is the easiest way. The App is very responsive and useful.",
                imageAsset: AppImages.profileIcon,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPromoCard(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<ProductFeatureCubit, ProductFeatureState>(
      builder: (context, state) {
        String titleText = '35000+ people made their bike smart.\nExperience Smart features of Trackify 🏍️';
        String? promoVideoUrl;

        if (state is ProductFeatureLoaded && state.features.isNotEmpty) {
          final firstFeature = state.features.first;
          if (firstFeature.title.isNotEmpty) {
            titleText = firstFeature.title;
          }
          if (firstFeature.titleVideos.isNotEmpty) {
            promoVideoUrl = firstFeature.titleVideos.first;
          }
        }

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  titleText,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                ),
              ),
              if (promoVideoUrl != null && promoVideoUrl.isNotEmpty)
                _PromoTitleVideoPlayer(
                  videoUrl: promoVideoUrl,
                  title: titleText,
                )
              else
                GestureDetector(
                  onTap: () {
                    if (_topYoutubeController == null) {
                      _topYoutubeController = YoutubePlayerController(
                        initialVideoId: 'l_q_4N59tN8',
                        flags: const YoutubePlayerFlags(
                          autoPlay: true,
                          mute: false,
                        ),
                      );
                    }
                    setState(() {
                      _isTopPlaying = !_isTopPlaying;
                      if (_isTopPlaying) {
                        _topYoutubeController?.play();
                      } else {
                        _topYoutubeController?.pause();
                      }
                    });
                  },
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      child: _isTopPlaying && _topYoutubeController != null
                          ? YoutubePlayer(
                              controller: _topYoutubeController!,
                              showVideoProgressIndicator: true,
                              progressIndicatorColor: Theme.of(context).colorScheme.primary,
                            )
                          : Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  AppImages.bikeInfoImage,
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    width: double.infinity,
                                    height: 200,
                                    color: Colors.grey[300],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.play_arrow,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTrackifyFeatures(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<ProductFeatureCubit, ProductFeatureState>(
      builder: (context, state) {
        // Loading
        if (state is ProductFeatureLoading) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n?.features ?? "Features",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const SizedBox(height: 180, child: Center(child: TrackifyLoader())),
            ],
          );
        }

        // Loaded with data
        if (state is ProductFeatureLoaded && state.features.isNotEmpty) {
          // Flatten all videos across all feature groups
          final List<_FeatureVideoItem> items = [];
          for (final feature in state.features) {
            for (final url in feature.allVideos) {
              items.add(_FeatureVideoItem(title: feature.title, videoUrl: url));
            }
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n?.features ?? "Features",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _FeatureVideoCard(title: item.title, videoUrl: item.videoUrl);
                  },
                ),
              ),
            ],
          );
        }

        // Error or empty — fall back to original dummy cards
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n?.features ?? "Features",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildFeatureItem(context,
                      title: l10n?.accidentAlertCard ?? "Accident alert",
                      imageAsset: AppImages.roadImage, videoId: 'l_q_4N59tN8'),
                  const SizedBox(width: 12),
                  _buildFeatureItem(context,
                      title: l10n?.antiTheftAlertCard ?? "Anti-Theft alert",
                      imageAsset: AppImages.safeParking, videoId: 'dQw4w9WgXcQ'),
                  const SizedBox(width: 12),
                  _buildFeatureItem(context,
                      title: l10n?.liveGpsTrackingCard ?? "Live GPS Tracking",
                      imageAsset: AppImages.exploreApp, videoId: 'l_q_4N59tN8'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFeatureItem(BuildContext context,
      {required String title, required String imageAsset, required String videoId}) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => FeatureVideoScreen(title: title, videoId: videoId)));
      },
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(imageAsset, width: 130, height: 140, fit: BoxFit.cover,
                    errorBuilder: (c, e, s) =>
                        Container(width: 130, height: 140, color: Colors.grey[300])),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration:
                    BoxDecoration(color: Colors.black.withOpacity(0.4), shape: BoxShape.circle),
                child: const Icon(Icons.play_arrow, color: Colors.white, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildDeviceComparisonTable(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n?.chooseDeviceSuitsYou ?? "Choose device which suits you well",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              _buildTableRow(context, [
                l10n?.features ?? "Features",
                l10n?.lite ?? "Lite",
                l10n?.pro ?? "Pro",
                l10n?.go ?? "Go"
              ], isHeader: true),
              _buildTableRow(context, [l10n?.deviceSim ?? "Device + Airtel/Vi SIM", "✓", "✓", "✓"], iconData: Icons.sim_card_outlined),
              _buildTableRow(context, [l10n?.liveTracking ?? "Live Tracking", "✓", "✓", "✓"], iconData: Icons.my_location_outlined),
              _buildTableRow(context, [l10n?.statistics ?? "Statistics", "✓", "✓", "✓"], iconData: Icons.bar_chart_outlined),
              _buildTableRow(context, [l10n?.fuelLogs ?? "Fuel Logs", "✓", "✓", "✓"], iconData: Icons.local_gas_station_outlined),
              _buildTableRow(context, [l10n?.accidentAlert ?? "Accident Alerts", "x", "✓", "x"], iconData: Icons.motorcycle_outlined), // Actually it's a bike falling, close enough
              _buildTableRow(context, [l10n?.ignitionOnOffAlert ?? "Ignition ON/OFF Alert", "✓", "✓", "x"], iconData: Icons.key_outlined),
              _buildTableRow(context, [l10n?.remoteEngineOff ?? "Remote Engine OFF", "✓", "x", "x"], iconData: Icons.power_settings_new_outlined),
              _buildTableRow(context, [l10n?.tamperAlert ?? "Tamper Alert", "x", "✓", "x"], iconData: Icons.vibration_outlined),
              _buildTableRow(context, [l10n?.portable ?? "Portable", "x", "x", "✓"], iconData: Icons.pan_tool_outlined),
              _buildTableRow(context, [l10n?.voiceMonitoring ?? "Voice Monitoring", "x", "x", "✓"], iconData: Icons.mic_none_outlined),
              _buildTableRow(context, [l10n?.overspeedAlert ?? "Overspeed Alert", "✓", "✓", "✓"], iconData: Icons.speed_outlined),
              _buildTableRow(context, [l10n?.geoFenceAlert ?? "Geo Fence Alert", "✓", "✓", "✓"], iconData: Icons.share_location_outlined),
              _buildTableRow(context, [l10n?.replacementWarrantyMonths ?? "Replacement Warranty\n(months)", "12", "12", "12"], iconData: Icons.sync_outlined),
              _buildPricingRow(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTableRow(BuildContext context, List<String> columns,
      {bool isHeader = false, IconData? iconData}) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                if (!isHeader)
                  Icon(
                    iconData ?? Icons.inventory_2_outlined,
                    size: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                if (!isHeader) const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    columns[0],
                    style: TextStyle(
                      fontWeight: isHeader ? FontWeight.bold : FontWeight.w500,
                      fontSize: 11,
                      color: isHeader
                          ? Theme.of(context).colorScheme.onSurface
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildTableCell(context, columns[1],
              color: isHeader ? Colors.purple : null),
          _buildTableCell(context, columns[2],
              color: isHeader ? Colors.blue : null),
          _buildTableCell(context, columns[3],
              color: isHeader ? Colors.orange : null),
        ],
      ),
    );
  }

  Widget _buildTableCell(BuildContext context, String text, {Color? color}) {
    Color getTextColor() {
      if (color != null) return color;
      if (text == "✓") return Colors.green;
      if (text == "x") return Colors.redAccent;
      if (text == "12") return Theme.of(context).colorScheme.onSurface;
      return Theme.of(context).colorScheme.onSurfaceVariant;
    }

    return Expanded(
      flex: 1,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: getTextColor(),
          ),
        ),
      ),
    );
  }

  Widget _buildPricingRow(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.money_outlined,
                  size: 16,
                  color: Colors.black87,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n?.trackifySmartGpsIot ?? "Trackify Smart GPS IoT",
                        style: TextStyle(color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 10,
                          ),
                          children: [
                            TextSpan(text: l10n?.withText ?? "with "),
                            TextSpan(
                                text: l10n?.monthAppSubscription ?? "12 Month App\nSubscription\n\n",
                                style: const TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: l10n?.simActivationCharges ?? "SIM Activation Charges"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildPricingCell(context, "1599", "1519", "699", Colors.purple.withOpacity(0.1)),
          _buildPricingCell(context, "2690", "2556", "699", Colors.blue.withOpacity(0.1)),
          _buildPricingCell(context, "3990", "3791", "699", Colors.orange.withOpacity(0.1)),
        ],
      ),
    );
  }

  Widget _buildPricingCell(BuildContext context, String oldPrice, String newPrice,
      String simCharge, Color bgColor) {
    return Expanded(
      flex: 1,
      child: Container(
        color: bgColor,
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          children: [
            const SizedBox(height: 16), // space for the discount badge top
            Text(
              "â‚¹$oldPrice",
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
                decoration: TextDecoration.lineThrough,
              ),
            ),
            Text(
              "â‚¹$newPrice",
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              "+â‚¹$simCharge",
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildUserTestimonial(BuildContext context,
      {required String name,
      required String duration,
      required String review,
      required String imageAsset}) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage(imageAsset),
                backgroundColor: Colors.grey.shade200,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      duration,
                      style: TextStyle(
                        fontSize: 10,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.play_arrow, color: Colors.green, size: 12),
                        Text(l10n?.googlePlay ?? "Google Play", style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 4),
                        ...List.generate(
                          5,
                          (index) => const Icon(Icons.star, color: Colors.amber, size: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                review,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Helper data class for a single video item shown in the
// horizontal feature list.
// ──────────────────────────────────────────────────────────────
class _FeatureVideoItem {
  final String title;
  final String videoUrl;
  const _FeatureVideoItem({required this.title, required this.videoUrl});
}

// ──────────────────────────────────────────────────────────────
// Horizontal card that plays a direct MP4 video on tap.
// ──────────────────────────────────────────────────────────────
// Top Promo Card Video Player (displays titleVideos MP4)
// ──────────────────────────────────────────────────────────────
class _PromoTitleVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String title;

  const _PromoTitleVideoPlayer({
    Key? key,
    required this.videoUrl,
    required this.title,
  }) : super(key: key);

  @override
  State<_PromoTitleVideoPlayer> createState() => _PromoTitleVideoPlayerState();
}

class _PromoTitleVideoPlayerState extends State<_PromoTitleVideoPlayer> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    try {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      await _controller!.initialize();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint("Error initializing promo video: $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _playFullScreen() {
    if (ActiveVideoManager.currentDispose != null) {
      ActiveVideoManager.currentDispose!();
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _FullScreenVideoPlayerDialog(
          title: widget.title,
          videoUrl: widget.videoUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _playFullScreen,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (_isInitialized && _controller != null && _controller!.value.isInitialized)
                SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    clipBehavior: Clip.hardEdge,
                    child: SizedBox(
                      width: _controller!.value.size.width,
                      height: _controller!.value.size.height,
                      child: VideoPlayer(_controller!),
                    ),
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1A1A2E), Color(0xFF0F3460)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
class _FeatureVideoCard extends StatefulWidget {
  final String title;
  final String videoUrl;
  const _FeatureVideoCard({required this.title, required this.videoUrl});

  @override
  State<_FeatureVideoCard> createState() => _FeatureVideoCardState();
}

class _FeatureVideoCardState extends State<_FeatureVideoCard> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initThumbnail();
  }

  Future<void> _initThumbnail() async {
    try {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      await _controller!.initialize();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint("Error initializing feature video thumbnail: $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _openFullScreenVideo() {
    if (ActiveVideoManager.currentDispose != null) {
      ActiveVideoManager.currentDispose!();
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _FullScreenVideoPlayerDialog(
          title: widget.title,
          videoUrl: widget.videoUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openFullScreenVideo,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  width: 130,
                  height: 155,
                  child: _isInitialized && _controller != null && _controller!.value.isInitialized
                      ? FittedBox(
                          fit: BoxFit.cover,
                          clipBehavior: Clip.hardEdge,
                          child: SizedBox(
                            width: _controller!.value.size.width,
                            height: _controller!.value.size.height,
                            child: VideoPlayer(_controller!),
                          ),
                        )
                      : Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF1A1A2E), Color(0xFF0F3460)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white54,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 28),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 130,
            child: Text(
              widget.title,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// Full Screen Video Player Page/Dialog
// ──────────────────────────────────────────────────────────────
class _FullScreenVideoPlayerDialog extends StatefulWidget {
  final String title;
  final String videoUrl;

  const _FullScreenVideoPlayerDialog({
    required this.title,
    required this.videoUrl,
  });

  @override
  State<_FullScreenVideoPlayerDialog> createState() =>
      __FullScreenVideoPlayerDialogState();
}

class __FullScreenVideoPlayerDialogState
    extends State<_FullScreenVideoPlayerDialog> {
  VideoPlayerController? _controller;
  ChewieController? _chewieController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _disposeControllers() async {
    final chewie = _chewieController;
    final vp = _controller;
    _chewieController = null;
    _controller = null;
    try {
      chewie?.dispose();
    } catch (e) {
      debugPrint("Chewie dispose error: $e");
    }
    try {
      await vp?.dispose();
    } catch (e) {
      debugPrint("VideoPlayer dispose error: $e");
    }
  }

  Future<void> _initPlayer() async {
    try {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      await _controller!.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _controller!,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
        showControls: true,
        aspectRatio: _controller!.value.aspectRatio > 0
            ? _controller!.value.aspectRatio
            : 16 / 9,
      );
      ActiveVideoManager.currentDispose = _disposeControllers;
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error initializing full screen video player: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : _chewieController != null
                ? Chewie(controller: _chewieController!)
                : const Text(
                    "Unable to load video",
                    style: TextStyle(color: Colors.white),
                  ),
      ),
    );
  }
}

class ProductSelectionBottomSheet extends StatefulWidget {
  const ProductSelectionBottomSheet({Key? key}) : super(key: key);

  @override
  State<ProductSelectionBottomSheet> createState() => _ProductSelectionBottomSheetState();
}

class _ProductSelectionBottomSheetState extends State<ProductSelectionBottomSheet> {
  String _selectedProduct = "Trackify Pro";

  final Map<String, Map<String, dynamic>> _productDetails = {
    "Trackify Pro": {
      "isOut": true,
      "price": "2556",
      "oldPrice": "2690"
    },
    "Trackify Go": {
      "isOut": false,
      "price": "3791",
      "oldPrice": "3990"
    },
    "Trackify Lite": {
      "isOut": false,
      "price": "1519",
      "oldPrice": "1599"
    }
  };
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final details = _productDetails[_selectedProduct]!;
    final isOut = details['isOut'] as bool;
    final price = details['price'] as String;
    final oldPrice = details['oldPrice'] as String;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n?.selectProduct ?? "Select Product",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildProductOption("Trackify Pro"),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildProductOption("Trackify Go"),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildProductOption("Trackify Lite"),
              ),
            ],
          ),
          const SizedBox(height: 32),
          if (!isOut) ...[
            Text(
              l10n?.usersBoughtProduct(_selectedProduct) ?? "*31 users bought $_selectedProduct yesterday",
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CheckoutScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(text: l10n?.buyNowForPrice(price) ?? "Buy Now for ₹$price"),
                      const TextSpan(text: "  "),
                      TextSpan(
                        text: "₹$oldPrice",
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ] else ...[
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor: Colors.grey.shade300,
                  disabledForegroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  l10n?.outOfStock ?? "Out of Stock",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildProductOption(String title) {
    final isSelected = _selectedProduct == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedProduct = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),      ),
    );
  }
}

class FeatureVideoScreen extends StatefulWidget {
  final String title;
  final String videoId;

  const FeatureVideoScreen({
    super.key,
    required this.title,
    required this.videoId,
  });

  @override
  State<FeatureVideoScreen> createState() => _FeatureVideoScreenState();
}

class _FeatureVideoScreenState extends State<FeatureVideoScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: theme.colorScheme.primary,
          progressColors: ProgressBarColors(
            playedColor: theme.colorScheme.primary,
            handleColor: theme.colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}

