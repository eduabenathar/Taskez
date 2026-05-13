import 'dart:async';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taskez/Services/platform_ui_config.dart';
import 'package:taskez/l10n/app_localizations.dart';

enum CapturedMediaKind { photo, video }

class CapturedMedia {
  final String path;
  final CapturedMediaKind kind;
  final String? originalName;

  const CapturedMedia({
    required this.path,
    required this.kind,
    this.originalName,
  });
}

enum _CaptureMode { photo, video }

enum _AspectRatio { r4_3, r16_9, r1_1, rFull }

enum _FlashSetting { off, auto, on }

enum _TimerSetting { off, s3, s10 }

enum _VideoResolution { hd, uhd4k }

enum _VideoFps { fps30, fps60 }

enum _VideoProfile { hd30, hd60, uhd30, uhd60 }

class CameraCaptureScreen extends StatefulWidget {
  const CameraCaptureScreen({Key? key}) : super(key: key);

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = const [];
  int _cameraIndex = 0;
  int? _backWideIndex;
  int? _backUltrawideIndex;
  int? _frontIndex;
  Future<void>? _initFuture;
  String? _initError;

  final ValueNotifier<_CaptureMode> _mode = ValueNotifier(_CaptureMode.photo);
  final ValueNotifier<_AspectRatio> _ratio = ValueNotifier(_AspectRatio.rFull);
  final ValueNotifier<bool> _ratioBarVisible = ValueNotifier(false);
  final ValueNotifier<_FlashSetting> _flash = ValueNotifier(_FlashSetting.off);
  final ValueNotifier<_TimerSetting> _timer = ValueNotifier(_TimerSetting.off);
  final ValueNotifier<bool> _grid = ValueNotifier(false);
  final ValueNotifier<bool> _isRecording = ValueNotifier(false);
  final ValueNotifier<Duration> _recordElapsed = ValueNotifier(Duration.zero);
  final ValueNotifier<int?> _countdown = ValueNotifier(null);
  final ValueNotifier<double> _zoom = ValueNotifier(1.0);
  final ValueNotifier<Offset?> _focusPoint = ValueNotifier(null);
  final ValueNotifier<int> _focusPulse = ValueNotifier(0);
  final ValueNotifier<double> _exposureOffset = ValueNotifier(0.0);
  final ValueNotifier<_VideoResolution> _videoResolution = ValueNotifier(
    _VideoResolution.hd,
  );
  final ValueNotifier<_VideoFps> _videoFps = ValueNotifier(_VideoFps.fps30);
  final ValueNotifier<bool> _quickMenuVisible = ValueNotifier(false);

  double _minZoom = 1.0;
  double _maxZoom = 1.0;
  double _minExposure = -2.0;
  double _maxExposure = 2.0;
  double _baseLogicalZoom = 1.0;
  double? _pendingLogicalZoomOnScaleEnd;

  Timer? _recordTicker;
  Timer? _focusHideTimer;
  Timer? _countdownTimer;
  Timer? _zoomBadgeTimer;
  final ValueNotifier<bool> _zoomBadgeVisible = ValueNotifier(false);
  bool _busy = false;

  final ImagePicker _galleryPicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    SystemChrome.setPreferredOrientations(const [
      DeviceOrientation.portraitUp,
    ]);
    _initFuture = _bootstrap();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final c = _controller;
    if (c == null || !c.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      c.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initFuture = _initCamera(_cameras[_cameraIndex]);
      setState(() {});
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    SystemChrome.setPreferredOrientations(const [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _recordTicker?.cancel();
    _focusHideTimer?.cancel();
    _zoomBadgeTimer?.cancel();
    _countdownTimer?.cancel();
    _controller?.dispose();
    _mode.dispose();
    _ratio.dispose();
    _ratioBarVisible.dispose();
    _flash.dispose();
    _timer.dispose();
    _grid.dispose();
    _isRecording.dispose();
    _recordElapsed.dispose();
    _countdown.dispose();
    _zoom.dispose();
    _focusPoint.dispose();
    _focusPulse.dispose();
    _exposureOffset.dispose();
    _videoResolution.dispose();
    _videoFps.dispose();
    _quickMenuVisible.dispose();
    _zoomBadgeVisible.dispose();
    super.dispose();
  }

  void _flashZoomBadge() {
    _zoomBadgeVisible.value = true;
    _zoomBadgeTimer?.cancel();
    _zoomBadgeTimer = Timer(const Duration(milliseconds: 1200), () {
      _zoomBadgeVisible.value = false;
    });
  }

  Future<void> _bootstrap() async {
    try {
      _cameras = await availableCameras();
    } on CameraException catch (e) {
      _initError = e.description ?? e.code;
      return;
    }
    if (_cameras.isEmpty) {
      _initError = AppLocalizations.of(context).cameraNoCameraAvailable;
      return;
    }
    final backIndexes = <int>[];
    for (int i = 0; i < _cameras.length; i++) {
      final cam = _cameras[i];
      final n = cam.name.toLowerCase();
      debugPrint(
        '[Camera] idx=$i name="${cam.name}" lens=${cam.lensDirection.name}',
      );
      if (cam.lensDirection == CameraLensDirection.back) {
        backIndexes.add(i);
        final isUltrawide = _looksUltrawideName(n);
        if (isUltrawide) {
          _backUltrawideIndex ??= i;
        } else {
          _backWideIndex ??= i;
        }
      } else if (cam.lensDirection == CameraLensDirection.front) {
        _frontIndex ??= i;
      }
    }
    _backWideIndex ??= _cameras.indexWhere(
      (c) => c.lensDirection == CameraLensDirection.back,
    );
    if ((_backWideIndex ?? -1) == -1) _backWideIndex = 0;

    // Fallback para dispositivos iOS em que o plugin não descreve "ultrawide"
    // no nome. Priorizamos a última câmera traseira que não pareça telefoto.
    if (_backUltrawideIndex == null && backIndexes.length > 1) {
      int? nonTeleCandidate;
      for (final i in backIndexes.reversed) {
        if (i == _backWideIndex) continue;
        final name = _cameras[i].name.toLowerCase();
        if (!_looksTelephotoName(name)) {
          nonTeleCandidate = i;
          break;
        }
      }
      _backUltrawideIndex = nonTeleCandidate ??
          backIndexes.lastWhere((i) => i != _backWideIndex, orElse: () => -1);
      if (_backUltrawideIndex == -1) _backUltrawideIndex = null;
    }

    debugPrint(
      '[Camera] chosen wide=$_backWideIndex ultrawide=$_backUltrawideIndex front=$_frontIndex',
    );
    _cameraIndex = _backWideIndex!;
    await _initCamera(_cameras[_cameraIndex]);
  }

  bool _looksUltrawideName(String n) {
    return n.contains('ultra') ||
        n.contains('0.5') ||
        n.contains('0,5') ||
        n.contains('wide angle') && n.contains('ultra') ||
        n.contains('ultra-angle') ||
        n.contains('ultra angle') ||
        n.contains('ultra-angular') ||
        n.contains('ultra angular');
  }

  bool _looksTelephotoName(String n) {
    return n.contains('tele') ||
        n.contains('zoom') ||
        n.contains('3x') ||
        n.contains('2x');
  }

  Future<void> _initCamera(CameraDescription description) async {
    await _controller?.dispose();
    CameraController? controller;
    final selected = _composeProfile(_videoResolution.value, _videoFps.value);
    final profilesToTry = _candidateProfilesFor(selected);
    Object? lastError;

    for (final profile in profilesToTry) {
      final attempt = CameraController(
        description,
        _resolutionPresetFor(profile),
        enableAudio: true,
        fps: _fpsFor(profile),
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      try {
        await attempt.initialize();
        controller = attempt;
        _videoResolution.value = _resolutionFromProfile(profile);
        _videoFps.value = _fpsFromProfile(profile);
        break;
      } on CameraException catch (e) {
        lastError = e;
        await attempt.dispose();
      }
    }

    if (controller == null) {
      _initError = (lastError is CameraException)
          ? (lastError.description ?? lastError.code)
          : AppLocalizations.of(context).cameraInitError;
      if (mounted) setState(() {});
      return;
    }

    _controller = controller;
    try {
      _minZoom = await controller.getMinZoomLevel();
      _maxZoom = await controller.getMaxZoomLevel();
      try {
        _minExposure = await controller.getMinExposureOffset();
        _maxExposure = await controller.getMaxExposureOffset();
      } on CameraException catch (_) {
        _minExposure = -2.0;
        _maxExposure = 2.0;
      }
      _exposureOffset.value = 0.0;
      _zoom.value = 1.0;
      await controller.setFlashMode(_flashModeFor(_flash.value, _mode.value));
      _initError = null;
    } on CameraException catch (e) {
      _initError = e.description ?? e.code;
    }
    if (mounted) setState(() {});
  }

  _VideoProfile _composeProfile(_VideoResolution res, _VideoFps fps) {
    if (res == _VideoResolution.uhd4k && fps == _VideoFps.fps60) {
      return _VideoProfile.uhd60;
    }
    if (res == _VideoResolution.uhd4k && fps == _VideoFps.fps30) {
      return _VideoProfile.uhd30;
    }
    if (res == _VideoResolution.hd && fps == _VideoFps.fps60) {
      return _VideoProfile.hd60;
    }
    return _VideoProfile.hd30;
  }

  _VideoResolution _resolutionFromProfile(_VideoProfile profile) {
    switch (profile) {
      case _VideoProfile.hd30:
      case _VideoProfile.hd60:
        return _VideoResolution.hd;
      case _VideoProfile.uhd30:
      case _VideoProfile.uhd60:
        return _VideoResolution.uhd4k;
    }
  }

  _VideoFps _fpsFromProfile(_VideoProfile profile) {
    switch (profile) {
      case _VideoProfile.hd30:
      case _VideoProfile.uhd30:
        return _VideoFps.fps30;
      case _VideoProfile.hd60:
      case _VideoProfile.uhd60:
        return _VideoFps.fps60;
    }
  }

  List<_VideoProfile> _candidateProfilesFor(_VideoProfile target) {
    switch (target) {
      case _VideoProfile.uhd60:
        return const [
          _VideoProfile.uhd60,
          _VideoProfile.uhd30,
          _VideoProfile.hd60,
          _VideoProfile.hd30,
        ];
      case _VideoProfile.uhd30:
        return const [
          _VideoProfile.uhd30,
          _VideoProfile.hd60,
          _VideoProfile.hd30,
        ];
      case _VideoProfile.hd60:
        return const [
          _VideoProfile.hd60,
          _VideoProfile.hd30,
        ];
      case _VideoProfile.hd30:
        return const [_VideoProfile.hd30];
    }
  }

  ResolutionPreset _resolutionPresetFor(_VideoProfile profile) {
    switch (profile) {
      case _VideoProfile.uhd30:
      case _VideoProfile.uhd60:
        return ResolutionPreset.ultraHigh;
      case _VideoProfile.hd30:
      case _VideoProfile.hd60:
        return ResolutionPreset.high;
    }
  }

  int _fpsFor(_VideoProfile profile) {
    switch (profile) {
      case _VideoProfile.hd30:
      case _VideoProfile.uhd30:
        return 30;
      case _VideoProfile.hd60:
      case _VideoProfile.uhd60:
        return 60;
    }
  }

  Future<void> _setVideoResolution(_VideoResolution next) async {
    if (_busy || _isRecording.value) return;
    if (_videoResolution.value == next) return;
    _videoResolution.value = next;
    _initFuture = _initCamera(_cameras[_cameraIndex]);
    setState(() {});
  }

  Future<void> _setVideoFps(_VideoFps next) async {
    if (_busy || _isRecording.value) return;
    if (_videoFps.value == next) return;
    _videoFps.value = next;
    _initFuture = _initCamera(_cameras[_cameraIndex]);
    setState(() {});
  }

  FlashMode _flashModeFor(_FlashSetting setting, _CaptureMode mode) {
    if (mode == _CaptureMode.video) {
      return setting == _FlashSetting.on ? FlashMode.torch : FlashMode.off;
    }
    switch (setting) {
      case _FlashSetting.off:
        return FlashMode.off;
      case _FlashSetting.auto:
        return FlashMode.auto;
      case _FlashSetting.on:
        return FlashMode.always;
    }
  }

  Future<void> _applyFlash() async {
    final c = _controller;
    if (c == null || !c.value.isInitialized) return;
    try {
      await c.setFlashMode(_flashModeFor(_flash.value, _mode.value));
    } on CameraException catch (_) {}
  }

  Future<void> _switchCamera() async {
    if (_busy) return;
    final isBack =
        _cameras[_cameraIndex].lensDirection == CameraLensDirection.back;
    final target =
        isBack ? _frontIndex : (_backWideIndex ?? _backUltrawideIndex);
    if (target == null || target == _cameraIndex) return;
    _cameraIndex = target;
    _initFuture = _initCamera(_cameras[_cameraIndex]);
    setState(() {});
  }

  Future<void> _selectLogicalZoom(double level) async {
    if (_busy) return;
    _flashZoomBadge();
    final wantsUltrawide = level < 1.0;
    final currentIsUltrawide = _cameraIndex == _backUltrawideIndex;
    final canSwitch = _backUltrawideIndex != null && _backWideIndex != null;
    if (wantsUltrawide && canSwitch && !currentIsUltrawide) {
      _cameraIndex = _backUltrawideIndex!;
      _zoom.value = 1.0;
      _initFuture = _initCamera(_cameras[_cameraIndex]);
      setState(() {});
      return;
    }
    if (!wantsUltrawide && currentIsUltrawide) {
      _cameraIndex = _backWideIndex!;
      _zoom.value = level;
      _initFuture = _initCamera(_cameras[_cameraIndex]).then((_) async {
        try {
          await _controller?.setZoomLevel(level.clamp(_minZoom, _maxZoom));
        } on CameraException catch (_) {}
      });
      setState(() {});
      return;
    }
    final clamped = level.clamp(_minZoom, _maxZoom);
    _zoom.value = clamped;
    try {
      await _controller?.setZoomLevel(clamped);
    } on CameraException catch (_) {}
  }

  void _onScaleStart(ScaleStartDetails _) {
    _baseLogicalZoom = _currentLogicalZoom();
  }

  Future<void> _onScaleUpdate(ScaleUpdateDetails details) async {
    final c = _controller;
    if (c == null || !c.value.isInitialized) return;
    final maxLogical = math.max(_maxZoom, 2.0);
    final rawNext = (_baseLogicalZoom * details.scale).clamp(0.5, maxLogical);
    final next = _snapLogicalZoom(rawNext);
    await _applyLogicalZoom(next, allowLensSwitch: false);
  }

  Future<void> _onScaleEnd(ScaleEndDetails _) async {
    final pending = _pendingLogicalZoomOnScaleEnd;
    _pendingLogicalZoomOnScaleEnd = null;
    if (pending == null) return;
    await _applyLogicalZoom(pending, allowLensSwitch: true);
  }

  double _currentLogicalZoom() {
    if (_cameraIndex == _backUltrawideIndex) return 0.5 * _zoom.value;
    return _zoom.value;
  }

  double _snapLogicalZoom(double v) {
    if ((v - 0.5).abs() <= 0.04) return 0.5;
    if ((v - 1.0).abs() <= 0.05) return 1.0;
    return v;
  }

  Future<void> _applyLogicalZoom(
    double logicalZoom, {
    required bool allowLensSwitch,
  }) async {
    final c = _controller;
    if (c == null || !c.value.isInitialized) return;
    final wantsUltrawide = logicalZoom < 1.0;
    final currentIsUltrawide = _cameraIndex == _backUltrawideIndex;
    final canSwitch = _backUltrawideIndex != null && _backWideIndex != null;

    if (wantsUltrawide && canSwitch && !currentIsUltrawide) {
      if (!allowLensSwitch) {
        _pendingLogicalZoomOnScaleEnd = logicalZoom;
        final physical = _minZoom;
        if ((physical - _zoom.value).abs() >= 0.01) {
          _zoom.value = physical;
          _flashZoomBadge();
          try {
            await c.setZoomLevel(physical);
          } on CameraException catch (_) {}
        }
        return;
      }
      _cameraIndex = _backUltrawideIndex!;
      _initFuture = _initCamera(_cameras[_cameraIndex]).then((_) async {
        final physical = (logicalZoom * 2.0).clamp(_minZoom, _maxZoom);
        _zoom.value = physical;
        try {
          await _controller?.setZoomLevel(physical);
        } on CameraException catch (_) {}
      });
      setState(() {});
      _flashZoomBadge();
      return;
    }

    if (!wantsUltrawide && currentIsUltrawide) {
      if (!allowLensSwitch) {
        _pendingLogicalZoomOnScaleEnd = logicalZoom;
        final physical = _maxZoom;
        if ((physical - _zoom.value).abs() >= 0.01) {
          _zoom.value = physical;
          _flashZoomBadge();
          try {
            await c.setZoomLevel(physical);
          } on CameraException catch (_) {}
        }
        return;
      }
      _cameraIndex = _backWideIndex!;
      _initFuture = _initCamera(_cameras[_cameraIndex]).then((_) async {
        final physical = logicalZoom.clamp(_minZoom, _maxZoom);
        _zoom.value = physical;
        try {
          await _controller?.setZoomLevel(physical);
        } on CameraException catch (_) {}
      });
      setState(() {});
      _flashZoomBadge();
      return;
    }

    final physical = currentIsUltrawide
        ? (logicalZoom * 2.0).clamp(_minZoom, _maxZoom)
        : logicalZoom.clamp(_minZoom, _maxZoom);

    if ((physical - _zoom.value).abs() < 0.01) return;
    _zoom.value = physical;
    _flashZoomBadge();
    try {
      await c.setZoomLevel(physical);
    } on CameraException catch (_) {}
  }

  Future<void> _onTapFocus(TapUpDetails details, Size previewSize) async {
    final c = _controller;
    if (c == null || !c.value.isInitialized) return;
    final local = details.localPosition;
    final relative = Offset(
      (local.dx / previewSize.width).clamp(0.0, 1.0),
      (local.dy / previewSize.height).clamp(0.0, 1.0),
    );
    _focusPoint.value = local;
    _focusPulse.value = _focusPulse.value + 1;
    _exposureOffset.value = 0.0;
    _scheduleFocusHide();
    try {
      await c.setFocusPoint(relative);
      await c.setExposurePoint(relative);
      await c.setExposureOffset(0.0);
    } on CameraException catch (_) {}
  }

  void _scheduleFocusHide() {
    _focusHideTimer?.cancel();
    _focusHideTimer = Timer(const Duration(seconds: 3), () {
      _focusPoint.value = null;
    });
  }

  Future<void> _onExposureChanged(double offset) async {
    final c = _controller;
    if (c == null || !c.value.isInitialized) return;
    final clamped = offset.clamp(_minExposure, _maxExposure);
    _exposureOffset.value = clamped;
    _scheduleFocusHide();
    try {
      await c.setExposureOffset(clamped);
    } on CameraException catch (_) {}
  }

  Future<void> _runCountdownIfNeeded() async {
    final seconds = switch (_timer.value) {
      _TimerSetting.off => 0,
      _TimerSetting.s3 => 3,
      _TimerSetting.s10 => 10,
    };
    if (seconds == 0) return;
    for (int i = seconds; i > 0; i--) {
      _countdown.value = i;
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
    }
    _countdown.value = null;
  }

  Future<void> _capturePhoto() async {
    if (_busy) return;
    final c = _controller;
    if (c == null || !c.value.isInitialized) return;
    _busy = true;
    try {
      await _runCountdownIfNeeded();
      final file = await c.takePicture();
      if (!mounted) return;
      final shouldUse = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (_) => _PhotoReviewScreen(
            imagePath: file.path,
            onUseLabel: AppLocalizations.of(context).cameraUse,
            onRetakeLabel: AppLocalizations.of(context).cameraRetake,
          ),
        ),
      );
      if (!mounted || shouldUse != true) return;
      Navigator.of(context).pop(
        CapturedMedia(
          path: file.path,
          kind: CapturedMediaKind.photo,
          originalName: file.name,
        ),
      );
    } on CameraException catch (_) {
      _showSnack(AppLocalizations.of(context).cameraInitError);
    } finally {
      _busy = false;
    }
  }

  Future<void> _toggleVideoRecording() async {
    final c = _controller;
    if (c == null || !c.value.isInitialized) return;
    if (_isRecording.value) {
      _busy = true;
      try {
        final file = await c.stopVideoRecording();
        _recordTicker?.cancel();
        _isRecording.value = false;
        _recordElapsed.value = Duration.zero;
        if (!mounted) return;
        Navigator.of(context).pop(
          CapturedMedia(
            path: file.path,
            kind: CapturedMediaKind.video,
            originalName: file.name,
          ),
        );
      } on CameraException catch (_) {
        _showSnack(AppLocalizations.of(context).cameraInitError);
      } finally {
        _busy = false;
      }
    } else {
      if (_busy) return;
      _busy = true;
      try {
        await _runCountdownIfNeeded();
        await c.startVideoRecording();
        _isRecording.value = true;
        _recordElapsed.value = Duration.zero;
        _recordTicker?.cancel();
        _recordTicker = Timer.periodic(const Duration(seconds: 1), (_) {
          _recordElapsed.value =
              Duration(seconds: _recordElapsed.value.inSeconds + 1);
        });
      } on CameraException catch (_) {
        _showSnack(AppLocalizations.of(context).cameraInitError);
      } finally {
        _busy = false;
      }
    }
  }

  Future<void> _openGalleryShortcut() async {
    if (_isRecording.value) return;
    final isVideo = _mode.value == _CaptureMode.video;
    try {
      final XFile? picked = isVideo
          ? await _galleryPicker.pickVideo(source: ImageSource.gallery)
          : await _galleryPicker.pickImage(source: ImageSource.gallery);
      if (picked == null || !mounted) return;
      Navigator.of(context).pop(
        CapturedMedia(
          path: picked.path,
          kind: isVideo ? CapturedMediaKind.video : CapturedMediaKind.photo,
          originalName: picked.name,
        ),
      );
    } catch (_) {}
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  double _aspectRatioValue(_AspectRatio r) {
    switch (r) {
      case _AspectRatio.r4_3:
        return 3 / 4;
      case _AspectRatio.r16_9:
        return 9 / 16;
      case _AspectRatio.r1_1:
        return 1.0;
      case _AspectRatio.rFull:
        return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: false,
        bottom: false,
        child: FutureBuilder<void>(
          future: _initFuture,
          builder: (context, snapshot) {
            if (_initError != null) {
              return _ErrorView(message: _initError!);
            }
            final c = _controller;
            if (snapshot.connectionState != ConnectionState.done ||
                c == null ||
                !c.value.isInitialized) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }
            return _buildCameraUi(context, c, l);
          },
        ),
      ),
    );
  }

  Widget _buildCameraUi(
    BuildContext context,
    CameraController c,
    AppLocalizations l,
  ) {
    final platformUi = PlatformUiConfig.current;
    final ratioBarBottom = platformUi.cameraRatioBarBottom;
    final controlsBottomLift = platformUi.cameraControlsBottomLift;

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(child: Container(color: Colors.black)),
        _PreviewArea(
          controller: c,
          ratioListenable: _ratio,
          gridListenable: _grid,
          focusListenable: _focusPoint,
          focusPulseListenable: _focusPulse,
          exposureListenable: _exposureOffset,
          minExposure: _minExposure,
          maxExposure: _maxExposure,
          onTapFocus: _onTapFocus,
          onExposureChanged: _onExposureChanged,
          onScaleStart: _onScaleStart,
          onScaleUpdate: _onScaleUpdate,
          onScaleEnd: _onScaleEnd,
          ratioOf: _aspectRatioValue,
        ),
        SafeArea(
          child: Column(
            children: [
              _TopBar(
                flash: _flash,
                timer: _timer,
                grid: _grid,
                ratioBarVisible: _ratioBarVisible,
                recording: _isRecording,
                recordElapsed: _recordElapsed,
                quickMenuVisible: _quickMenuVisible,
                videoResolution: _videoResolution,
                videoFps: _videoFps,
                onSetVideoResolution: _setVideoResolution,
                onSetVideoFps: _setVideoFps,
                onFlashChanged: _applyFlash,
              ),
              const Spacer(),
              _ZoomBadge(
                zoom: _zoom,
                visible: _zoomBadgeVisible,
                ultrawideActive: _cameraIndex == _backUltrawideIndex,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: controlsBottomLift),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ZoomChips(
                      zoom: _zoom,
                      onUltrawideAvailable: _backUltrawideIndex != null,
                      maxZoom: _maxZoom,
                      isUltrawideActive: _cameraIndex == _backUltrawideIndex,
                      onSelect: _selectLogicalZoom,
                    ),
                    _ModeSelector(mode: _mode, onChanged: _applyFlash),
                    _BottomBar(
                      mode: _mode,
                      recording: _isRecording,
                      onShutter: () {
                        if (_mode.value == _CaptureMode.photo) {
                          _capturePhoto();
                        } else {
                          _toggleVideoRecording();
                        }
                      },
                      onGallery: _openGalleryShortcut,
                      onSwitch: _cameras.length > 1 ? _switchCamera : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: Center(
              child: ValueListenableBuilder<int?>(
                valueListenable: _countdown,
                builder: (_, count, __) {
                  if (count == null) return const SizedBox.shrink();
                  return Text(
                    '$count',
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 96,
                      fontWeight: FontWeight.w900,
                      shadows: const [
                        Shadow(blurRadius: 24, color: Colors.black54),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: ratioBarBottom,
          child: SafeArea(
            top: false,
            child: ValueListenableBuilder<bool>(
              valueListenable: _ratioBarVisible,
              builder: (_, visible, __) {
                return ValueListenableBuilder<_CaptureMode>(
                  valueListenable: _mode,
                  builder: (_, mode, __) {
                    final show = visible && mode == _CaptureMode.photo;
                    return AnimatedSlide(
                      duration: const Duration(milliseconds: 240),
                      curve: Curves.easeOutCubic,
                      offset: show ? Offset.zero : const Offset(0, 0.2),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutCubic,
                        opacity: show ? 1.0 : 0.0,
                        child: IgnorePointer(
                          ignoring: !show,
                          child: Center(child: _RatioSelector(ratio: _ratio)),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _PreviewArea extends StatelessWidget {
  final CameraController controller;
  final ValueListenable<_AspectRatio> ratioListenable;
  final ValueListenable<bool> gridListenable;
  final ValueListenable<Offset?> focusListenable;
  final ValueListenable<int> focusPulseListenable;
  final ValueListenable<double> exposureListenable;
  final double minExposure;
  final double maxExposure;
  final void Function(TapUpDetails details, Size previewSize) onTapFocus;
  final Future<void> Function(double) onExposureChanged;
  final void Function(ScaleStartDetails) onScaleStart;
  final Future<void> Function(ScaleUpdateDetails) onScaleUpdate;
  final Future<void> Function(ScaleEndDetails) onScaleEnd;
  final double Function(_AspectRatio) ratioOf;

  const _PreviewArea({
    required this.controller,
    required this.ratioListenable,
    required this.gridListenable,
    required this.focusListenable,
    required this.focusPulseListenable,
    required this.exposureListenable,
    required this.minExposure,
    required this.maxExposure,
    required this.onTapFocus,
    required this.onExposureChanged,
    required this.onScaleStart,
    required this.onScaleUpdate,
    required this.onScaleEnd,
    required this.ratioOf,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<_AspectRatio>(
      valueListenable: ratioListenable,
      builder: (context, ratio, _) {
        final target = ratioOf(ratio);
        return LayoutBuilder(
          builder: (context, constraints) {
            final maxW = constraints.maxWidth;
            final maxH = constraints.maxHeight;
            double width;
            double height;
            if (target == 0.0) {
              width = maxW;
              height = maxH;
            } else {
              width = maxW;
              height = width / target;
              if (height > maxH) {
                height = maxH;
                width = height * target;
              }
            }
            return TweenAnimationBuilder<Size?>(
              tween: SizeTween(end: Size(width, height)),
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              builder: (context, animatedSize, _) {
                final aw = animatedSize?.width ?? width;
                final ah = animatedSize?.height ?? height;
                return Center(
                  child: SizedBox(
                    width: aw,
                    height: ah,
                    child: ClipRect(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onScaleStart: onScaleStart,
                        onScaleUpdate: (d) => onScaleUpdate(d),
                        onScaleEnd: (d) => onScaleEnd(d),
                        onTapUp: (d) => onTapFocus(d, Size(aw, ah)),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            FittedBox(
                              fit: BoxFit.cover,
                              child: SizedBox(
                                width:
                                    controller.value.previewSize?.height ?? aw,
                                height:
                                    controller.value.previewSize?.width ?? ah,
                                child: CameraPreview(controller),
                              ),
                            ),
                            ValueListenableBuilder<bool>(
                              valueListenable: gridListenable,
                              builder: (_, show, __) => IgnorePointer(
                                child: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 180),
                                  opacity: show ? 1.0 : 0.0,
                                  child: const _GridOverlay(),
                                ),
                              ),
                            ),
                            ValueListenableBuilder<Offset?>(
                              valueListenable: focusListenable,
                              builder: (_, point, __) {
                                return ValueListenableBuilder<int>(
                                  valueListenable: focusPulseListenable,
                                  builder: (_, pulse, __) {
                                    return _FocusExposureOverlay(
                                      point: point,
                                      pulse: pulse,
                                      areaSize: Size(aw, ah),
                                      exposureListenable: exposureListenable,
                                      minExposure: minExposure,
                                      maxExposure: maxExposure,
                                      onExposureChanged: onExposureChanged,
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class _FocusExposureOverlay extends StatefulWidget {
  final Offset? point;
  final int pulse;
  final Size areaSize;
  final ValueListenable<double> exposureListenable;
  final double minExposure;
  final double maxExposure;
  final Future<void> Function(double) onExposureChanged;

  const _FocusExposureOverlay({
    required this.point,
    required this.pulse,
    required this.areaSize,
    required this.exposureListenable,
    required this.minExposure,
    required this.maxExposure,
    required this.onExposureChanged,
  });

  @override
  State<_FocusExposureOverlay> createState() => _FocusExposureOverlayState();
}

class _FocusExposureOverlayState extends State<_FocusExposureOverlay> {
  static const double _boxSize = 80;
  static const double _sliderHeight = 140;
  double _dragStartOffset = 0.0;
  double _dragStartValue = 0.0;

  @override
  Widget build(BuildContext context) {
    final point = widget.point;
    if (point == null) return const SizedBox.shrink();
    final span = (widget.maxExposure - widget.minExposure).abs();
    final showSlider = span > 0.01;

    final preferRightSlider =
        point.dx + _boxSize / 2 + 56 < widget.areaSize.width;
    final left =
        (point.dx - _boxSize / 2).clamp(0.0, widget.areaSize.width - _boxSize);
    final top =
        (point.dy - _boxSize / 2).clamp(0.0, widget.areaSize.height - _boxSize);

    return Positioned(
      left: left,
      top: top,
      child: SizedBox(
        width: _boxSize + 56,
        height: _boxSize,
        child: Row(
          textDirection:
              preferRightSlider ? TextDirection.ltr : TextDirection.rtl,
          children: [
            TweenAnimationBuilder<double>(
              key: ValueKey(widget.pulse),
              tween: Tween<double>(begin: 1.4, end: 1.0),
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOut,
              builder: (_, scale, child) => Transform.scale(
                scale: scale,
                child: child,
              ),
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _FocusBoxPainter(),
                  size: const Size(_boxSize, _boxSize),
                ),
              ),
            ),
            if (showSlider) ...[
              const SizedBox(width: 6),
              ValueListenableBuilder<double>(
                valueListenable: widget.exposureListenable,
                builder: (_, value, __) {
                  final span = (widget.maxExposure - widget.minExposure).abs();
                  final t = span == 0
                      ? 0.5
                      : ((value - widget.minExposure) / span).clamp(0.0, 1.0);
                  return SizedBox(
                    width: 28,
                    height: _sliderHeight,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onVerticalDragStart: (d) {
                        _dragStartOffset = d.localPosition.dy;
                        _dragStartValue = value;
                      },
                      onVerticalDragUpdate: (d) {
                        final delta = d.localPosition.dy - _dragStartOffset;
                        final ratio = delta / _sliderHeight;
                        final newValue = (_dragStartValue -
                                ratio *
                                    (widget.maxExposure - widget.minExposure))
                            .clamp(widget.minExposure, widget.maxExposure);
                        widget.onExposureChanged(newValue);
                      },
                      child: CustomPaint(
                        painter: _ExposureSliderPainter(t: t),
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ExposureSliderPainter extends CustomPainter {
  final double t;

  _ExposureSliderPainter({required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final trackPaint = Paint()
      ..color = Colors.amberAccent.withValues(alpha: 0.55)
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(centerX, 12),
      Offset(centerX, size.height - 12),
      trackPaint,
    );

    final sunY =
        (12 + (1.0 - t) * (size.height - 24)).clamp(12.0, size.height - 12.0);
    final sunPaint = Paint()..color = Colors.amberAccent;
    canvas.drawCircle(Offset(centerX, sunY), 5, sunPaint);
    final rayPaint = Paint()
      ..color = Colors.amberAccent
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;
    const rayLength = 4.0;
    const rayInner = 7.0;
    for (int i = 0; i < 8; i++) {
      final angle = (i * 3.14159) / 4;
      final dx = centerX + (rayInner) * math.cos(angle);
      final dy = sunY + (rayInner) * math.sin(angle);
      final dx2 = centerX + (rayInner + rayLength) * math.cos(angle);
      final dy2 = sunY + (rayInner + rayLength) * math.sin(angle);
      canvas.drawLine(Offset(dx, dy), Offset(dx2, dy2), rayPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ExposureSliderPainter oldDelegate) {
    return oldDelegate.t != t;
  }
}

class _FocusBoxPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.amberAccent
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    final rect = Rect.fromLTWH(0.5, 0.5, size.width - 1.0, size.height - 1.0);
    canvas.drawRect(rect, linePaint);

    const tickLength = 10.0;
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Top tick
    canvas.drawLine(Offset(cx, 0), Offset(cx, tickLength), linePaint);
    // Bottom tick
    canvas.drawLine(
      Offset(cx, size.height - tickLength),
      Offset(cx, size.height),
      linePaint,
    );
    // Left tick
    canvas.drawLine(Offset(0, cy), Offset(tickLength, cy), linePaint);
    // Right tick
    canvas.drawLine(
      Offset(size.width - tickLength, cy),
      Offset(size.width, cy),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _FocusBoxPainter oldDelegate) => false;
}

class _GridOverlay extends StatelessWidget {
  const _GridOverlay();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _GridPainter());
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.24)
      ..strokeWidth = 0.45;
    for (int i = 1; i < 3; i++) {
      final dx = size.width * i / 3;
      final dy = size.height * i / 3;
      canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), paint);
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TopBar extends StatelessWidget {
  final ValueNotifier<_FlashSetting> flash;
  final ValueNotifier<_TimerSetting> timer;
  final ValueNotifier<bool> grid;
  final ValueNotifier<bool> ratioBarVisible;
  final ValueNotifier<bool> recording;
  final ValueNotifier<Duration> recordElapsed;
  final ValueNotifier<bool> quickMenuVisible;
  final ValueNotifier<_VideoResolution> videoResolution;
  final ValueNotifier<_VideoFps> videoFps;
  final Future<void> Function(_VideoResolution) onSetVideoResolution;
  final Future<void> Function(_VideoFps) onSetVideoFps;
  final Future<void> Function() onFlashChanged;

  const _TopBar({
    required this.flash,
    required this.timer,
    required this.grid,
    required this.ratioBarVisible,
    required this.recording,
    required this.recordElapsed,
    required this.quickMenuVisible,
    required this.videoResolution,
    required this.videoFps,
    required this.onSetVideoResolution,
    required this.onSetVideoFps,
    required this.onFlashChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.45),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ),
              const SizedBox(width: 10),
              ValueListenableBuilder<bool>(
                valueListenable: recording,
                builder: (_, isRec, __) {
                  if (!isRec) return const SizedBox.shrink();
                  return ValueListenableBuilder<Duration>(
                    valueListenable: recordElapsed,
                    builder: (_, d, __) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _formatDuration(d),
                            style: GoogleFonts.lato(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ValueListenableBuilder<_FlashSetting>(
                      valueListenable: flash,
                      builder: (_, value, __) => _PillIconButton(
                        icon: _flashIcon(value),
                        label: _flashLabel(value),
                        active: value != _FlashSetting.off,
                        onTap: () {
                          flash.value = _FlashSetting.values[
                              (value.index + 1) % _FlashSetting.values.length];
                          onFlashChanged();
                        },
                      ),
                    ),
                    ValueListenableBuilder<_TimerSetting>(
                      valueListenable: timer,
                      builder: (_, value, __) => _PillIconButton(
                        icon: Icons.timer_outlined,
                        label: _timerLabel(value),
                        active: value != _TimerSetting.off,
                        onTap: () => timer.value = _TimerSetting.values[
                            (value.index + 1) % _TimerSetting.values.length],
                      ),
                    ),
                    ValueListenableBuilder<bool>(
                      valueListenable: quickMenuVisible,
                      builder: (_, opened, __) => _DotGridButton(
                        active: opened,
                        onTap: () => quickMenuVisible.value = !opened,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          ValueListenableBuilder<bool>(
            valueListenable: quickMenuVisible,
            builder: (_, opened, __) => AnimatedSize(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topRight,
              child: opened
                  ? AnimatedOpacity(
                      duration: const Duration(milliseconds: 180),
                      opacity: opened ? 1.0 : 0.0,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.55),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.12),
                            ),
                          ),
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              ValueListenableBuilder<bool>(
                                valueListenable: grid,
                                builder: (_, value, __) => _QuickOptionChip(
                                  icon: Icons.grid_on_outlined,
                                  label: 'Grade',
                                  active: value,
                                  onTap: () => grid.value = !value,
                                ),
                              ),
                              ValueListenableBuilder<bool>(
                                valueListenable: ratioBarVisible,
                                builder: (_, value, __) => _QuickOptionChip(
                                  icon: Icons.aspect_ratio_outlined,
                                  label: 'Proporcao',
                                  active: value,
                                  onTap: () => ratioBarVisible.value = !value,
                                ),
                              ),
                              ValueListenableBuilder<_VideoResolution>(
                                valueListenable: videoResolution,
                                builder: (_, value, __) => _QuickOptionChip(
                                  icon: Icons.hd_outlined,
                                  label: value == _VideoResolution.hd
                                      ? 'HD'
                                      : '4K',
                                  active: false,
                                  onTap: () => onSetVideoResolution(
                                    value == _VideoResolution.hd
                                        ? _VideoResolution.uhd4k
                                        : _VideoResolution.hd,
                                  ),
                                ),
                              ),
                              ValueListenableBuilder<_VideoFps>(
                                valueListenable: videoFps,
                                builder: (_, value, __) => _QuickOptionChip(
                                  icon: Icons.speed_outlined,
                                  label: value == _VideoFps.fps30
                                      ? '30 FPS'
                                      : '60 FPS',
                                  active: false,
                                  onTap: () => onSetVideoFps(
                                    value == _VideoFps.fps30
                                        ? _VideoFps.fps60
                                        : _VideoFps.fps30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  static String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  IconData _flashIcon(_FlashSetting s) {
    switch (s) {
      case _FlashSetting.off:
        return Icons.flash_off;
      case _FlashSetting.auto:
        return Icons.flash_auto;
      case _FlashSetting.on:
        return Icons.flash_on;
    }
  }

  String? _flashLabel(_FlashSetting s) {
    switch (s) {
      case _FlashSetting.off:
        return null;
      case _FlashSetting.auto:
        return 'A';
      case _FlashSetting.on:
        return null;
    }
  }

  String? _timerLabel(_TimerSetting s) {
    switch (s) {
      case _TimerSetting.off:
        return null;
      case _TimerSetting.s3:
        return '3';
      case _TimerSetting.s10:
        return '10';
    }
  }
}

class _DotGridButton extends StatelessWidget {
  final bool active;
  final VoidCallback onTap;

  const _DotGridButton({required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final dotColor = active ? Colors.amberAccent : Colors.white;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 38,
        height: 38,
        child: Center(
          child: SizedBox(
            width: 16,
            height: 12,
            child: Wrap(
              spacing: 2,
              runSpacing: 2,
              children: List.generate(
                6,
                (_) => Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickOptionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _QuickOptionChip({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? Colors.amberAccent : Colors.white;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: active ? 0.55 : 0.4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.lato(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PillIconButton extends StatelessWidget {
  final IconData icon;
  final String? label;
  final bool active;
  final VoidCallback onTap;

  const _PillIconButton({
    required this.icon,
    required this.onTap,
    this.label,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? Colors.amberAccent : Colors.white;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 38,
        height: 38,
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, color: color, size: 19),
            if (label != null)
              Positioned(
                right: 2,
                bottom: 2,
                child: Text(
                  label!,
                  style: GoogleFonts.lato(
                    color: color,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ZoomBadge extends StatelessWidget {
  final ValueListenable<double> zoom;
  final ValueListenable<bool> visible;
  final bool ultrawideActive;

  const _ZoomBadge({
    required this.zoom,
    required this.visible,
    required this.ultrawideActive,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: visible,
      builder: (_, show, __) => AnimatedOpacity(
        duration: const Duration(milliseconds: 220),
        opacity: show ? 1.0 : 0.0,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: ValueListenableBuilder<double>(
            valueListenable: zoom,
            builder: (_, value, __) {
              final display = ultrawideActive ? 0.5 * value : value;
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${_formatZoom(display)}×',
                  style: GoogleFonts.lato(
                    color: Colors.amberAccent,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  static String _formatZoom(double v) {
    final s = v.toStringAsFixed(1);
    return s.replaceAll('.', ',');
  }
}

class _ZoomChips extends StatelessWidget {
  final ValueNotifier<double> zoom;
  final bool onUltrawideAvailable;
  final bool isUltrawideActive;
  final double maxZoom;
  final Future<void> Function(double) onSelect;

  const _ZoomChips({
    required this.zoom,
    required this.onUltrawideAvailable,
    required this.isUltrawideActive,
    required this.maxZoom,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: zoom,
      builder: (_, current, __) {
        final levels = <double>[
          if (onUltrawideAvailable) 0.5,
          1.0,
          if (maxZoom >= 2.0) 2.0,
        ];
        if (levels.length < 2) return const SizedBox(height: 8);
        bool isSelected(double level) {
          if (level < 1.0) return isUltrawideActive;
          if (isUltrawideActive) return false;
          return (current - level).abs() < 0.15;
        }

        return Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final level in levels)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: GestureDetector(
                    onTap: () => onSelect(level),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      width: isSelected(level) ? 38 : 30,
                      height: isSelected(level) ? 38 : 30,
                      decoration: BoxDecoration(
                        color: isSelected(level)
                            ? Colors.black.withValues(alpha: 0.65)
                            : Colors.black.withValues(alpha: 0.45),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        isSelected(level)
                            ? '${_formatLevel(level)}×'
                            : _formatLevel(level),
                        style: GoogleFonts.lato(
                          color: isSelected(level)
                              ? Colors.amberAccent
                              : Colors.white,
                          fontSize: isSelected(level) ? 12 : 11,
                          fontWeight: FontWeight.w800,
                        ),
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

  String _formatLevel(double level) {
    if (level == level.roundToDouble()) return level.toInt().toString();
    return level.toStringAsFixed(1).replaceAll('.', ',');
  }
}

class _RatioSelector extends StatelessWidget {
  final ValueNotifier<_AspectRatio> ratio;

  const _RatioSelector({required this.ratio});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final entries = <(_AspectRatio, String)>[
      (_AspectRatio.r4_3, l.cameraRatio4to3),
      (_AspectRatio.r16_9, l.cameraRatio16to9),
      (_AspectRatio.r1_1, l.cameraRatio1to1),
      (_AspectRatio.rFull, l.cameraRatioFull),
    ];
    const double chipWidth = 60;
    const double chipHeight = 26;
    const double chipGap = 4;
    return ValueListenableBuilder<_AspectRatio>(
      valueListenable: ratio,
      builder: (_, current, __) {
        final selectedIndex = entries
            .indexWhere((e) => e.$1 == current)
            .clamp(0, entries.length - 1);
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(18),
            ),
            child: SizedBox(
              width:
                  chipWidth * entries.length + chipGap * (entries.length - 1),
              height: chipHeight,
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeOutCubic,
                    left: selectedIndex * (chipWidth + chipGap),
                    top: 0,
                    width: chipWidth,
                    height: chipHeight,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.amberAccent,
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      for (int i = 0; i < entries.length; i++) ...[
                        if (i > 0) const SizedBox(width: chipGap),
                        GestureDetector(
                          onTap: () => ratio.value = entries[i].$1,
                          behavior: HitTestBehavior.opaque,
                          child: SizedBox(
                            width: chipWidth,
                            height: chipHeight,
                            child: Center(
                              child: AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 260),
                                curve: Curves.easeOutCubic,
                                style: GoogleFonts.lato(
                                  color: selectedIndex == i
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                                child: Text(entries[i].$2),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ModeSelector extends StatelessWidget {
  final ValueNotifier<_CaptureMode> mode;
  final Future<void> Function() onChanged;

  const _ModeSelector({required this.mode, required this.onChanged});

  Future<void> _set(_CaptureMode next) async {
    if (mode.value == next) return;
    mode.value = next;
    await onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final entries = <(_CaptureMode, String)>[
      (_CaptureMode.video, l.cameraModeVideo),
      (_CaptureMode.photo, l.cameraModePhoto),
    ];
    const double chipWidth = 86;
    const double chipHeight = 30;
    return ValueListenableBuilder<_CaptureMode>(
      valueListenable: mode,
      builder: (_, current, __) {
        final selectedIndex =
            entries.indexWhere((e) => e.$1 == current).clamp(0, 1);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragEnd: (details) {
              final v = details.primaryVelocity ?? 0;
              if (v < -200) {
                _set(_CaptureMode.photo);
              } else if (v > 200) {
                _set(_CaptureMode.video);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(22),
              ),
              child: SizedBox(
                width: chipWidth * 2 + 4,
                height: chipHeight,
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOut,
                      left: selectedIndex * (chipWidth + 4),
                      top: 0,
                      width: chipWidth,
                      height: chipHeight,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        for (int i = 0; i < entries.length; i++) ...[
                          if (i > 0) const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () => _set(entries[i].$1),
                            behavior: HitTestBehavior.opaque,
                            child: SizedBox(
                              width: chipWidth,
                              height: chipHeight,
                              child: Center(
                                child: AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 220),
                                  style: GoogleFonts.lato(
                                    color: selectedIndex == i
                                        ? Colors.amberAccent
                                        : Colors.white70,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.4,
                                  ),
                                  child: Text(entries[i].$2.toUpperCase()),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BottomBar extends StatelessWidget {
  final ValueNotifier<_CaptureMode> mode;
  final ValueNotifier<bool> recording;
  final VoidCallback onShutter;
  final VoidCallback onGallery;
  final VoidCallback? onSwitch;

  const _BottomBar({
    required this.mode,
    required this.recording,
    required this.onShutter,
    required this.onGallery,
    required this.onSwitch,
  });

  @override
  Widget build(BuildContext context) {
    const ring = Color(0xFFD9C9A3);
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 8, 28, 40),
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: onGallery,
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.25),
                    ),
                  ),
                  child: const Icon(
                    Icons.photo_library_outlined,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
          ValueListenableBuilder<_CaptureMode>(
            valueListenable: mode,
            builder: (_, modeValue, __) {
              return ValueListenableBuilder<bool>(
                valueListenable: recording,
                builder: (_, isRec, __) {
                  final isVideo = modeValue == _CaptureMode.video;
                  return GestureDetector(
                    onTap: onShutter,
                    child: SizedBox(
                      width: 82,
                      height: 82,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: ring, width: 4),
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            curve: Curves.easeOut,
                            width: isVideo ? (isRec ? 32 : 62) : 64,
                            height: isVideo ? (isRec ? 32 : 62) : 64,
                            decoration: BoxDecoration(
                              color: isVideo ? Colors.red : Colors.white,
                              borderRadius: BorderRadius.circular(
                                isVideo && isRec ? 6 : 60,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: onSwitch == null
                  ? const SizedBox(width: 46, height: 46)
                  : GestureDetector(
                      onTap: onSwitch,
                      child: Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.cached_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.videocam_off_outlined,
                color: Colors.white70, size: 56),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.of(context).maybePop(),
              child: Text(
                AppLocalizations.of(context).cameraClose,
                style: GoogleFonts.lato(
                  color: Colors.amberAccent,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoReviewScreen extends StatefulWidget {
  final String imagePath;
  final String onUseLabel;
  final String onRetakeLabel;

  const _PhotoReviewScreen({
    required this.imagePath,
    required this.onUseLabel,
    required this.onRetakeLabel,
  });

  @override
  State<_PhotoReviewScreen> createState() => _PhotoReviewScreenState();
}

class _PhotoReviewScreenState extends State<_PhotoReviewScreen> {
  late final Future<Uint8List> _bytesFuture;

  @override
  void initState() {
    super.initState();
    _bytesFuture = XFile(widget.imagePath).readAsBytes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          FutureBuilder<Uint8List>(
            future: _bytesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }
              if (!snapshot.hasData) {
                return const Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: Colors.white70,
                    size: 52,
                  ),
                );
              }
              return InteractiveViewer(
                minScale: 1.0,
                maxScale: 3.0,
                child: Center(
                  child: Image.memory(
                    snapshot.data!,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              );
            },
          ),
          IgnorePointer(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x8A000000),
                    Color(0x00000000),
                    Color(0xB8000000),
                  ],
                  stops: [0, 0.45, 1],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(false),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.42),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.25),
                          ),
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.18),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(
                                color: Colors.white.withValues(alpha: 0.45),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              textStyle: GoogleFonts.lato(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                            child: Text(widget.onRetakeLabel),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2868FF),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              textStyle: GoogleFonts.lato(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                            child: Text(widget.onUseLabel),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
